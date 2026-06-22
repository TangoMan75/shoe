#!/usr/bin/env python3
"""Tests for shoeshine.py shoedoc detection.

Run from the repository root: python3 tests/python/test_shoeshine.py
"""

import json
import pathlib
import subprocess
import sys
import tempfile
import unittest

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent.parent))

import shoeshine


class CaptureAnnotationTest(unittest.TestCase):
    def test_annotation_run_captured_before_function(self):
        content = (
            "## Run following code before each execution\n"
            "##\n"
            "## {\n"
            "##   \"namespace\": \"ns\"\n"
            "## }\n"
            "foo() {\n"
        )
        records = shoeshine.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(
            records,
            [shoeshine.AnnotationRecord(
                5,
                "foo",
                [0, 1, 2, 3, 4],
                ["## Run following code before each execution", "##",
                 "## {", "##   \"namespace\": \"ns\"", "## }"],
            )],
        )

    def test_annotation_after_blank_gap_is_still_captured(self):
        content = (
            "## {\n"
            "##   \"namespace\": \"ns\"\n"
            "## }\n"
            "\n"
            "foo() {\n"
        )
        records = shoeshine.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        self.assertEqual(
            (records[0].function_line_index, records[0].function_name,
             records[0].line_indexes),
            (4, "foo", [0, 1, 2]),
        )

    def test_run_terminated_by_code_line(self):
        content = (
            "x=1\n"
            "## {\n"
            "##   \"namespace\": \"ns\"\n"
            "foo() {\n"
        )
        records = shoeshine.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        _, _, run_indexes, lines = records[0]
        self.assertEqual(run_indexes, [1, 2])
        self.assertEqual(len(lines), 2)

    def test_crlf_annotations(self):
        content = "## {\r\n##   \"namespace\": \"ns\"\r\n## }\r\nfoo() {\r\n"
        records = shoeshine.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        self.assertEqual(len(records[0].lines), 3)


class StripAndParseTest(unittest.TestCase):
    def test_prefixes_are_stripped_before_parsing(self):
        stripped = shoeshine.strip_shoedoc_prefixes(
            ["## {", "##   \"namespace\": \"ns\"", "## }"]
        )
        self.assertEqual(stripped, ["{", "  \"namespace\": \"ns\"", "}"])
        first_open, last_close = shoeshine.locate_envelope(stripped)
        parsed = shoeshine.parse_shoedoc(shoeshine.envelope_json_text(
            stripped, first_open, last_close
        ))
        self.assertEqual(parsed, {"namespace": "ns"})

    def test_bare_strip(self):
        self.assertEqual(shoeshine.strip_shoedoc_prefix("##"), "")
        self.assertEqual(shoeshine.strip_shoedoc_prefix("## Bare summary"),
                         "Bare summary")

    def test_summary_lines_outside_envelope(self):
        stripped = shoeshine.strip_shoedoc_prefixes(
            ["## Summary", "##", "## {", "##   \"k\": 1", "## }"]
        )
        self.assertEqual(
            stripped,
            ["Summary", "", "{", "  \"k\": 1", "}"],
        )
        first_open, last_close = shoeshine.locate_envelope(stripped)
        self.assertEqual((first_open, last_close), (2, 4))
        self.assertEqual(
            shoeshine.parse_shoedoc(shoeshine.envelope_json_text(
                stripped, first_open, last_close
            )),
            {"k": 1},
        )

    def test_state_unclosed(self):
        stripped = shoeshine.strip_shoedoc_prefixes(
            ["## {", "##   \"namespace\": \"ns\""]
        )
        self.assertEqual(shoeshine.envelope_state(stripped), "unclosed")

    def test_state_bare(self):
        stripped = shoeshine.strip_shoedoc_prefixes(["## Bare summary"])
        self.assertEqual(shoeshine.envelope_state(stripped), "bare")

    def test_state_envelope(self):
        stripped = shoeshine.strip_shoedoc_prefixes(
            ["## {", "##   \"k\": 1", "## }"]
        )
        self.assertEqual(shoeshine.envelope_state(stripped), "envelope")

    def test_second_open_rescopes_run_to_unclosed(self):
        content = (
            "## {\n"
            "##   \"namespace\": \"a\"\n"
            "## {\n"
            "##   \"summary\": \"b\"\n"
            "foo() {\n"
        )
        records = shoeshine.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        _, _, _, lines = records[0]
        self.assertEqual(
            shoeshine.envelope_state(shoeshine.strip_shoedoc_prefixes(lines)),
            "unclosed",
        )


class FixPipelineTest(unittest.TestCase):
    def test_dangling_commas_removed(self):
        fixes = []
        cleaned = shoeshine.remove_dangling_commas(
            ['  "requires": [', '    "awk",', '  ],', "}"], fixes
        )
        self.assertEqual(
            cleaned, ['  "requires": [', '    "awk"', '  ]', "}"]
        )
        self.assertEqual(
            fixes, ["removed dangling comma", "removed dangling comma"])

    def test_commas_inside_values_are_not_touched(self):
        fixes = []
        cleaned = shoeshine.remove_dangling_commas(
            ['  "description": "a, b"'], fixes
        )
        self.assertEqual(cleaned, ['  "description": "a, b"'])
        self.assertEqual(fixes, [])

    def test_orphan_depends_merged(self):
        fixes = []
        cleaned = shoeshine.merge_orphan_depends_lines(
            ["{", '  "depends": [],', '    "src/x/_h",', '  ],', "}"], fixes
        )
        self.assertEqual(
            shoeshine.parse_shoedoc("\n".join(cleaned)),
            {"depends": ["src/x/_h"]},
        )
        self.assertIn("merged orphan depends array lines", fixes)

    def test_stray_depends_terminators_removed(self):
        fixes = []
        cleaned = shoeshine.merge_orphan_depends_lines(
            ["{", '  "depends": [],', "  ],", "  ],", "}"], fixes
        )
        self.assertEqual(
            shoeshine.parse_shoedoc("\n".join(cleaned)), {"depends": []}
        )
        self.assertIn("removed stray depends array terminator", fixes)

    def test_orphan_repairs_in_main_pipeline_order(self):
        fixes = []
        envelope = ["{", '  "depends": [],', '    "src/x/_h",', "  ],", "}"]
        repaired = shoeshine.remove_dangling_commas(envelope, fixes)
        repaired = shoeshine.merge_orphan_depends_lines(repaired, fixes)
        repaired = shoeshine.remove_dangling_commas(repaired, fixes)
        self.assertEqual(
            shoeshine.parse_shoedoc("\n".join(repaired)),
            {"depends": ["src/x/_h"]},
        )

    def test_entries_sorted_deduplicated_and_unused_dropped(self):
        cleaned, fixes = shoeshine.fix_string_array_entries(
            ["sed", "awk", "awk"], "requires", body="awk 1"
        )
        self.assertEqual(cleaned, ["awk"])
        self.assertIn("removed duplicated 'requires' entries", fixes)
        self.assertIn("removed unused 'requires' entries", fixes)

    def test_missing_depends_added(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns", "depends": ["src/x/_other"]},
            body="_other _helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["depends"], ["src/x/_helper", "src/x/_other"])
        self.assertIn("added missing 'depends' entries", fixes)

    def test_depends_property_created_when_missing(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns", "requires": ["awk"]},
            body="awk _helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(list(fixed), ["namespace", "requires", "depends"])
        self.assertEqual(fixed["depends"], ["src/x/_helper"])
        self.assertIn("added missing 'depends' entries", fixes)

    def test_unused_depends_removed_before_adding(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns", "depends": ["src/x/_gone"]},
            body="_helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["depends"], ["src/x/_helper"])
        self.assertIn("removed unused 'depends' entries", fixes)
        self.assertIn("added missing 'depends' entries", fixes)

    def test_requires_property_created_when_missing(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns"},
            body="awk helper", adds={"requires": {"awk", "sed"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["requires"], ["awk", "sed"])
        self.assertIn("added missing 'requires' entries", fixes)

    def test_missing_requires_merged_into_existing(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns", "requires": ["sed"]},
            body="awk sed helper", adds={"requires": {"awk"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["requires"], ["awk", "sed"])
        self.assertIn("added missing 'requires' entries", fixes)

    def test_external_commands_detected(self):
        self.assertEqual(
            shoeshine.find_external_commands(
                "    awk 'x' && sed -n 'y'",
                defined=set(), registry={},
            ),
            {"awk", "sed"},
        )
        self.assertEqual(
            shoeshine.find_external_commands(
                "    for file in x; do :; done",
                defined=set(), registry={},
            ),
            set(),
        )

    def test_wrong_namespace_value_repaired(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "nowhere/nothing"},
            body="", adds=None, namespace_value=None,
            wrong_namespace="ns",
        )
        self.assertEqual(fixed["namespace"], "ns")
        self.assertIn("repaired 'namespace' folder", fixes)

    def test_missing_namespace_inserted_first(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"summary": "s"},
            body="x", adds=None, namespace_value="ns",
            wrong_namespace=None,
        )
        self.assertEqual(list(fixed), ["namespace", "summary"])
        self.assertIn("inserted missing namespace", fixes)

    def test_empty_arrays_and_parameters_removed(self):
        fixed, fixes = shoeshine.fix_dictionary(
            {"namespace": "ns", "requires": [], "parameters": []},
            body="", adds=None, namespace_value=None,
            wrong_namespace=None,
        )
        self.assertEqual(fixed, {"namespace": "ns"})
        self.assertIn("removed empty 'requires' array", fixes)
        self.assertIn("removed empty 'parameters' property", fixes)

    def test_envelope_lines_match_repo_style(self):
        lines = shoeshine.shoedoc_envelope_lines({"namespace": "ns"})
        self.assertEqual(
            lines, ["## {\n", '##   "namespace": "ns"\n', "## }\n"])


class MissingShoedocBlocksTest(unittest.TestCase):
    def function_line(self, name):
        return f"{name}() {{\n"

    def test_bare_summary_is_flagged(self):
        lines = [
            "#!/bin/sh\n",
            "\n",
            "## Install local SSL certificates\n",
            "certificates() {\n",
            "    echo ok\n",
            "}\n",
        ]
        missing = shoeshine.missing_shoedoc_blocks(lines)
        self.assertEqual(missing, [(3, "certificates", 2)])

    def test_proper_block_with_blank_gap_is_not_flagged(self):
        lines = [
            "#!/bin/sh\n",
            "\n",
            "## Run following code before each execution\n",
            "##\n",
            "## {\n",
            "##   \"namespace\": \"ns\"\n",
            "## }\n",
            "\n",
            "_before() {\n",
            "}\n",
        ]
        self.assertEqual(shoeshine.missing_shoedoc_blocks(lines), [])

    def test_stray_open_after_proper_block_is_flagged(self):
        lines = [
            "## {\n",
            "##   \"namespace\": \"ns\"\n",
            "## }\n",
            "## {\n",
            "##   \"summary\": \"s\"\n",
            "foo() {\n",
        ]
        missing = shoeshine.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (5, "foo"))

    def test_double_open_single_close_is_flagged(self):
        lines = [
            "## {\n",
            "## {\n",
            "## }\n",
            "bar() {\n",
        ]
        missing = shoeshine.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (3, "bar"))

    def test_orphan_close_above_open_is_flagged(self):
        lines = [
            "## }\n",
            "## {\n",
            "##   \"summary\": \"s\"\n",
            "baz() {\n",
        ]
        missing = shoeshine.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (3, "baz"))

    def test_unannotated_function_is_not_flagged(self):
        lines = [
            "function() {\n",
            "    echo ok\n",
            "}\n",
        ]
        self.assertEqual(shoeshine.missing_shoedoc_blocks(lines), [])

    def test_crlf_annotation_lines(self):
        lines = [
            "## summary\r\n",
            "function() {\r\n",
        ]
        missing = shoeshine.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (1, "function"))


class SanitizeTest(unittest.TestCase):
    def test_deep_nesting_terminates(self):
        text = "$(echo " * 1000 + "ok" + ")" * 1000
        try:
            sanitized, _ = shoeshine.sanitize(text)
        except RecursionError:
            self.fail("sanitize raised RecursionError on deep nesting")
        self.assertEqual(len(sanitized), len(text))

    def test_string_content_is_blanked(self):
        sanitized, _ = shoeshine.sanitize('x "abc" \'def\'')
        self.assertNotIn("abc", sanitized)
        self.assertNotIn("def", sanitized)

    def test_substitution_content_is_preserved(self):
        sanitized, _ = shoeshine.sanitize('x "$(cmd1)"')
        self.assertIn("cmd1", sanitized)


class EndToEndTest(unittest.TestCase):
    def setUp(self):
        self._temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self._temporary_directory.cleanup)
        self.root = pathlib.Path(self._temporary_directory.name)
        (self.root / "ns").mkdir()
        repository = pathlib.Path(shoeshine.__file__).resolve().parent

        valid = (
            "#!/bin/sh\n"
            "\n"
            "## Valid function\n"
            "##\n"
            "## {\n"
            "##   \"namespace\": \"ns\"\n"
            "## }\n"
            "valid() {\n"
            "    echo \"$1\"\n"
            "}\n"
        )
        bare = (
            "#!/bin/sh\n"
            "\n"
            "## Bare summary\n"
            "bare() {\n"
            "    echo bare\n"
            "}\n"
        )
        malformed = (
            "#!/bin/sh\n"
            "\n"
            "## Malformed\n"
            "##\n"
            "## {\n"
            "##   \"namespace\": \"ns\"\n"
            "malformed() {\n"
            "    echo \"$1\"\n"
            "}\n"
        )
        (self.root / "ns" / "valid.sh").write_text(valid)
        (self.root / "ns" / "bare.sh").write_text(bare)
        (self.root / "ns" / "malformed.sh").write_text(malformed)
        self._repository = repository

    def run_shoeshine(self, arguments):
        return subprocess.run(
            [sys.executable, str(self._repository / "shoeshine.py"),
             str(self.root), *arguments],
            cwd=self.root, capture_output=True, text=True)

    def test_valid_file_completes_without_error(self):
        result = self.run_shoeshine([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_bare_summary_is_warned(self):
        result = self.run_shoeshine([])
        self.assertIn(
            "invalid shoedoc: no '## {' ... '## }' JSON block around "
            "the annotation lines of function 'bare'", result.stdout)

    def test_malformed_block_is_warned_once(self):
        result = self.run_shoeshine([])
        self.assertIn(
            "malformed shoedoc: '## {' without matching '## }'",
            result.stdout)
        malformed_path = self.root / "ns" / "malformed.sh"
        warnings = [
            line for line in result.stdout.splitlines()
            if str(malformed_path) in line
        ]
        self.assertEqual(len(warnings), 1)


class FixGenerationTest(unittest.TestCase):
    def setUp(self):
        self._temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self._temporary_directory.cleanup)
        self.root = pathlib.Path(self._temporary_directory.name)
        (self.root / "ns").mkdir()
        (self.root / "src" / "x").mkdir(parents=True)
        repository = pathlib.Path(shoeshine.__file__).resolve().parent
        self._repository = repository

        (self.root / "src" / "x" / "_helper.sh").write_text(
            "_helper() {\n"
            "    echo helper\n"
            "}\n"
        )
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        )

    def run_shoeshine(self, arguments, folder=None):
        return subprocess.run(
            [sys.executable, str(self._repository / "shoeshine.py"),
             str(folder or self.root), *arguments],
            cwd=self.root, capture_output=True, text=True)

    def test_bare_summary_is_warned_without_fix(self):
        result = self.run_shoeshine([])
        self.assertIn(
            "invalid shoedoc: no '## {' ... '## }' JSON block around "
            "the annotation lines of function 'bare'", result.stdout)

    def test_fix_generates_namespace_and_depends(self):
        result = self.run_shoeshine(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run helper",\n'
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        ))

    def test_fixed_file_is_clean_on_re_run(self):
        self.run_shoeshine(["--fix"])
        result = self.run_shoeshine([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)
        self.assertNotIn("warning:", result.stdout)

    def test_fix_without_calls_generates_namespace_only(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Stand alone\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        )
        result = self.run_shoeshine(["--fix"])
        self.assertIn("generated JSON block", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Stand alone"\n'
            "## }\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        ))

    def test_fix_replaces_summary_and_separator_lines(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Example summary\n"
            "##\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        )
        result = self.run_shoeshine(["--fix"])
        self.assertIn("generated JSON block", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Example summary"\n'
            "## }\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        ))

    def test_fix_replaces_bare_lines_across_blank_lines(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Example summary\n"
            "\n"
            "##\n"
            "## Run helper\n"
            "## Another line\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        )
        result = self.run_shoeshine(["--fix"])
        self.assertIn("generated JSON block", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Example summary\\nRun helper\\n'
            'Another line"\n'
            "## }\n"
            "bare() {\n"
            "    :\n"
            "}\n"
        ))
        missing = shoeshine.missing_shoedoc_blocks(content.splitlines(True))
        self.assertEqual(missing, [])

    def test_fix_folds_leading_lines_into_envelope_summary(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run following code before each execution\n"
            "##\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        )
        result = self.run_shoeshine(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn(
            "folded summary lines into 'summary'", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run following code before each execution",\n'
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        ))
        missing = shoeshine.missing_shoedoc_blocks(content.splitlines(True))
        self.assertEqual(missing, [])

    def test_fix_keeps_leading_lines_when_summary_set(self):
        content = (
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "##\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run helper",\n'
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        )
        (self.root / "ns" / "bare.sh").write_text(content)
        result = self.run_shoeshine(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertEqual(
            (self.root / "ns" / "bare.sh").read_text(), content)

    def test_fix_generates_requires_from_external_commands(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "bare() {\n"
            "    _helper\n"
            "    awk -F \"=\" '{print $NF}'\n"
            "    for file in x; do :; done\n"
            "}\n"
        )
        result = self.run_shoeshine(["--fix"])
        self.assertIn("generated JSON block", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run helper",\n'
            '##   "requires": [\n'
            '##     "awk"\n'
            "##   ],\n"
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    _helper\n"
            "    awk -F \"=\" '{print $NF}'\n"
            "    for file in x; do :; done\n"
            "}\n"
        ))

    def test_subfolder_scan_still_resolves_src_depends(self):
        result = self.run_shoeshine(
            ["--fix"], folder=self.root / "ns"
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertIn('"depends": [', content)
        self.assertIn('"src/x/_helper"', content)


if __name__ == "__main__":
    unittest.main()
