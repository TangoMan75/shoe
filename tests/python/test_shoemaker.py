#!/usr/bin/env python3
"""Tests for shoemaker.py Shoedoc linting and conversion.

Run from the repository root: python3 tests/python/test_shoemaker.py
"""

import json
import os
import pathlib
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent.parent))

import shoemaker
from shoemaker import ShoedocConverter


def convert_content(content, direction):
    """Run the converter through its public class API."""
    return ShoedocConverter().convert_content(content, direction)


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
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(
            records,
            [shoemaker.AnnotationRecord(
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
        records = shoemaker.ShoedocParser.capture_function_annotations(
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
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        _, _, run_indexes, lines = records[0]
        self.assertEqual(run_indexes, [1, 2])
        self.assertEqual(len(lines), 2)

    def test_crlf_annotations(self):
        content = "## {\r\n##   \"namespace\": \"ns\"\r\n## }\r\nfoo() {\r\n"
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        self.assertEqual(len(records[0].lines), 3)


class StripAndParseTest(unittest.TestCase):
    def test_prefixes_are_stripped_before_parsing(self):
        stripped = shoemaker.ShoedocParser.strip_shoedoc_prefixes(
            ["## {", "##   \"namespace\": \"ns\"", "## }"]
        )
        self.assertEqual(stripped, ["{", "  \"namespace\": \"ns\"", "}"])
        first_open, last_close = shoemaker.ShoedocParser.locate_envelope(stripped)
        parsed = shoemaker.ShoedocParser.parse_json(shoemaker.ShoedocParser.envelope_json_text(
            stripped, first_open, last_close
        ))
        self.assertEqual(parsed, {"namespace": "ns"})

    def test_bare_strip(self):
        self.assertEqual(shoemaker.ShoedocParser.strip_shoedoc_prefix("##"), "")
        self.assertEqual(shoemaker.ShoedocParser.strip_shoedoc_prefix("## Bare summary"),
                         "Bare summary")

    def test_summary_lines_outside_envelope(self):
        stripped = shoemaker.ShoedocParser.strip_shoedoc_prefixes(
            ["## Summary", "##", "## {", "##   \"k\": 1", "## }"]
        )
        self.assertEqual(
            stripped,
            ["Summary", "", "{", "  \"k\": 1", "}"],
        )
        first_open, last_close = shoemaker.ShoedocParser.locate_envelope(stripped)
        self.assertEqual((first_open, last_close), (2, 4))
        self.assertEqual(
            shoemaker.ShoedocParser.parse_json(shoemaker.ShoedocParser.envelope_json_text(
                stripped, first_open, last_close
            )),
            {"k": 1},
        )

    def test_state_unclosed(self):
        stripped = shoemaker.ShoedocParser.strip_shoedoc_prefixes(
            ["## {", "##   \"namespace\": \"ns\""]
        )
        self.assertEqual(shoemaker.ShoedocParser.envelope_state(stripped), "unclosed")

    def test_state_bare(self):
        stripped = shoemaker.ShoedocParser.strip_shoedoc_prefixes(["## Bare summary"])
        self.assertEqual(shoemaker.ShoedocParser.envelope_state(stripped), "bare")

    def test_state_envelope(self):
        stripped = shoemaker.ShoedocParser.strip_shoedoc_prefixes(
            ["## {", "##   \"k\": 1", "## }"]
        )
        self.assertEqual(shoemaker.ShoedocParser.envelope_state(stripped), "envelope")

    def test_second_open_rescopes_run_to_unclosed(self):
        content = (
            "## {\n"
            "##   \"namespace\": \"a\"\n"
            "## {\n"
            "##   \"summary\": \"b\"\n"
            "foo() {\n"
        )
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        _, _, _, lines = records[0]
        self.assertEqual(
            shoemaker.ShoedocParser.envelope_state(shoemaker.ShoedocParser.strip_shoedoc_prefixes(lines)),
            "unclosed",
        )


class FixPipelineTest(unittest.TestCase):
    def test_dangling_commas_removed(self):
        fixes = []
        cleaned = shoemaker.ShoedocFixer.remove_dangling_commas(
            ['  "requires": [', '    "awk",', '  ],', "}"], fixes
        )
        self.assertEqual(
            cleaned, ['  "requires": [', '    "awk"', '  ]', "}"]
        )
        self.assertEqual(
            fixes, ["removed dangling comma", "removed dangling comma"])

    def test_commas_inside_values_are_not_touched(self):
        fixes = []
        cleaned = shoemaker.ShoedocFixer.remove_dangling_commas(
            ['  "description": "a, b"'], fixes
        )
        self.assertEqual(cleaned, ['  "description": "a, b"'])
        self.assertEqual(fixes, [])

    def test_orphan_depends_merged(self):
        fixes = []
        cleaned = shoemaker.ShoedocFixer.merge_orphan_depends_lines(
            ["{", '  "depends": [],', '    "src/x/_h",', '  ],', "}"], fixes
        )
        self.assertEqual(
            shoemaker.ShoedocParser.parse_json("\n".join(cleaned)),
            {"depends": ["src/x/_h"]},
        )
        self.assertIn("merged orphan depends array lines", fixes)

    def test_stray_depends_terminators_removed(self):
        fixes = []
        cleaned = shoemaker.ShoedocFixer.merge_orphan_depends_lines(
            ["{", '  "depends": [],', "  ],", "  ],", "}"], fixes
        )
        self.assertEqual(
            shoemaker.ShoedocParser.parse_json("\n".join(cleaned)), {"depends": []}
        )
        self.assertIn("removed stray depends array terminator", fixes)

    def test_orphan_repairs_in_main_pipeline_order(self):
        fixes = []
        envelope = ["{", '  "depends": [],', '    "src/x/_h",', "  ],", "}"]
        repaired = shoemaker.ShoedocFixer.remove_dangling_commas(envelope, fixes)
        repaired = shoemaker.ShoedocFixer.merge_orphan_depends_lines(repaired, fixes)
        repaired = shoemaker.ShoedocFixer.remove_dangling_commas(repaired, fixes)
        self.assertEqual(
            shoemaker.ShoedocParser.parse_json("\n".join(repaired)),
            {"depends": ["src/x/_h"]},
        )

    def test_required_entry_default_removed(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {
                "namespace": "ns",
                "params": [{
                    "position": 1,
                    "name": "who",
                    "default": "World",
                    "required": True,
                }],
            },
            body="", adds=None, namespace_value=None,
            wrong_namespace=None,
        )
        self.assertEqual(fixed["params"], [{
            "position": 1,
            "name": "who",
            "required": True,
        }])
        self.assertIn("removed 'default' from required 'params' entries", fixes)
        errors, _warnings = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_entries_sorted_deduplicated_and_unused_dropped(self):
        cleaned, fixes = shoemaker.ShoedocFixer().fix_string_array_entries(
            ["sed", "awk", "awk"], "requires", body="awk 1"
        )
        self.assertEqual(cleaned, ["awk"])
        self.assertIn("removed duplicated 'requires' entries", fixes)
        self.assertIn("removed unused 'requires' entries", fixes)

    def test_missing_depends_added(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns", "depends": ["src/x/_other"]},
            body="_other _helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["depends"], ["src/x/_helper", "src/x/_other"])
        self.assertIn("added missing 'depends' entries", fixes)

    def test_depends_property_created_when_missing(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns", "requires": ["awk"]},
            body="awk _helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(list(fixed), ["namespace", "requires", "depends"])
        self.assertEqual(fixed["depends"], ["src/x/_helper"])
        self.assertIn("added missing 'depends' entries", fixes)

    def test_unused_depends_removed_before_adding(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns", "depends": ["src/x/_gone"]},
            body="_helper", adds={"depends": {"src/x/_helper"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["depends"], ["src/x/_helper"])
        self.assertIn("removed unused 'depends' entries", fixes)
        self.assertIn("added missing 'depends' entries", fixes)

    def test_requires_property_created_when_missing(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns"},
            body="awk helper", adds={"requires": {"awk", "sed"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["requires"], ["awk", "sed"])
        self.assertIn("added missing 'requires' entries", fixes)

    def test_missing_requires_merged_into_existing(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns", "requires": ["sed"]},
            body="awk sed helper", adds={"requires": {"awk"}},
            namespace_value=None, wrong_namespace=None,
        )
        self.assertEqual(fixed["requires"], ["awk", "sed"])
        self.assertIn("added missing 'requires' entries", fixes)

    def test_external_commands_detected(self):
        self.assertEqual(
            shoemaker.StaticAnalyzer(registry={}).find_external_commands(
                "    awk 'x' && sed -n 'y'",
                defined=set(),
            ),
            {"awk", "sed"},
        )
        self.assertEqual(
            shoemaker.StaticAnalyzer(registry={}).find_external_commands(
                "    for file in x; do :; done",
                defined=set(),
            ),
            set(),
        )

    def test_hyphenated_external_command_detected(self):
        with tempfile.TemporaryDirectory() as directory:
            command = pathlib.Path(directory) / "ssh-add"
            command.write_text("#!/bin/sh\n")
            command.chmod(0o755)
            with mock.patch.dict(os.environ, {"PATH": directory}):
                self.assertEqual(
                    shoemaker.StaticAnalyzer(
                        registry={}
                    ).find_external_commands(
                        '    SSH_AUTH_SOCK="$1" ssh-add -l',
                        defined=set(),
                    ),
                    {"ssh-add"},
                )

    def test_hyphenated_function_call_detected(self):
        analyzer = shoemaker.StaticAnalyzer(
            registry={"my-helper": "src/x/my-helper"}
        )
        self.assertEqual(
            analyzer.find_calls("    my-helper arg", defined=set()),
            {"my-helper"},
        )

    def test_function_call_in_command_substitution_detected(self):
        analyzer = shoemaker.StaticAnalyzer(
            registry={"_pwd": "src/x/_pwd"}
        )
        self.assertEqual(
            analyzer.find_calls(
                '    set -- "$(_pwd)/backups"', defined=set()
            ),
            {"_pwd"},
        )

    def test_case_label_is_not_a_command(self):
        analyzer = shoemaker.StaticAnalyzer(registry={"w": "src/x/w"})
        self.assertEqual(
            analyzer.find_calls(
                '    case "$1" in w) : ;; esac', defined=set()
            ),
            set(),
        )

    def test_argument_is_not_a_function_call(self):
        analyzer = shoemaker.StaticAnalyzer(
            registry={"branch": "recipes/git/branch"}
        )
        self.assertEqual(
            analyzer.find_calls("    git branch -l", defined=set()),
            set(),
        )
        self.assertEqual(
            analyzer.find_calls(
                "    local types=(branch other)", defined=set()
            ),
            set(),
        )

    def test_closest_declaring_module_is_preferred(self):
        analyzer = shoemaker.StaticAnalyzer(registry={
            "requirements": [
                "recipes/other/requirements",
                "recipes/app/install/requirements",
            ],
        })
        self.assertEqual(
            analyzer.preferred_dependency(
                "requirements", "recipes/app/_before.sh"
            ),
            "recipes/app/install/requirements",
        )

    def test_depends_may_name_any_declaring_module(self):
        analyzer = shoemaker.StaticAnalyzer(registry={
            "requirements": [
                "recipes/other/requirements",
                "recipes/app/install/requirements",
            ],
        })
        self.assertEqual(
            analyzer.missing_depends(
                {"depends": ["recipes/other/requirements"]},
                "requirements",
                set(),
                "recipes/app/_before.sh",
            ),
            set(),
        )

    def test_wrong_namespace_value_repaired(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "nowhere/nothing"},
            body="", adds=None, namespace_value=None,
            wrong_namespace="ns",
        )
        self.assertEqual(fixed["namespace"], "ns")
        self.assertIn("repaired 'namespace' folder", fixes)

    def test_missing_namespace_inserted(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"summary": "s"},
            body="x", adds=None, namespace_value="ns",
            wrong_namespace=None,
        )
        self.assertEqual(list(fixed), ["namespace", "summary"])
        self.assertIn("inserted missing namespace", fixes)

    def test_empty_arrays_and_params_removed(self):
        fixed, fixes = shoemaker.ShoedocFixer().fix_dictionary(
            {"namespace": "ns", "requires": [], "params": []},
            body="", adds=None, namespace_value=None,
            wrong_namespace=None,
        )
        self.assertEqual(fixed, {"namespace": "ns"})
        self.assertIn("removed empty 'requires' array", fixes)
        self.assertIn("removed empty 'params' property", fixes)

    def validate(self, fixed):
        with tempfile.TemporaryDirectory() as tmp:
            (pathlib.Path(tmp) / "ns").mkdir()
            cwd = os.getcwd()
            os.chdir(tmp)
            try:
                return shoemaker.ShoedocLinter().validate(fixed, "test")
            finally:
                os.chdir(cwd)

    def test_param_names_allow_pipe_separated_aliases_only(self):
        valid, _warnings = self.validate({
            "namespace": "ns",
            "params": [{
                "position": 1,
                "name": "CONTAINER_NAME|CONTAINER_ID",
            }],
        })
        self.assertEqual(valid, [])

        invalid, _warnings = self.validate({
            "namespace": "ns",
            "options": [{"name": "CONTAINER_NAME|CONTAINER_ID"}],
        })
        self.assertIn(
            "test: options: invalid 'name': 'CONTAINER_NAME|CONTAINER_ID'",
            invalid,
        )
        for name in ("CONTAINER_NAME|", "|CONTAINER_ID", "A||B"):
            with self.subTest(name=name):
                errors, _warnings = self.validate({
                    "namespace": "ns",
                    "params": [{"position": 1, "name": name}],
                })
                self.assertIn(f"test: params: invalid 'name': {name!r}", errors)

    def test_position_must_be_a_positive_int(self):
        for bad in ("1", True, 0, -1, 1.5):
            errors, _ = self.validate({
                "namespace": "ns",
                "params": [{"name": "x", "position": bad}],
            })
            self.assertIn(
                "test: params: 'position' must be a positive integer",
                errors, f"position={bad!r}",
            )

    def test_position_must_match_rank(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "params": [
                {"name": "x", "position": 1},
                {"name": "y", "position": 3},
            ],
        })
        self.assertIn(
            "test: params: 'position' must match the entry's rank in the "
            "array: 3", errors,
        )

    def test_options_reject_position(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "options": [{"name": "y", "position": 1}],
        })
        self.assertIn("test: options: unknown key(s): position", errors)

    def test_param_entries_cannot_be_deprecated(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "params": [{
                "position": 1,
                "name": "x",
                "deprecated": "Use y instead.",
            }],
        })
        self.assertIn(
            "test: params: a 'params' entry cannot own a 'deprecated' "
            "property", errors,
        )

    def test_option_and_flag_entries_cannot_be_deprecated(self):
        for key in ("options", "flags"):
            errors, _ = self.validate({
                "namespace": "ns",
                key: [{"name": "x", "deprecated": "Use y instead."}],
            })
            self.assertIn(
                f"test: {key}: a '{key}' entry cannot own a 'deprecated' "
                f"property", errors,
            )

    def test_constant_entries_may_be_deprecated(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "constants": [{"name": "x", "deprecated": "Use y instead."}],
        })
        self.assertEqual(errors, [])

    def test_type_flag_is_invalid_outside_flags_array(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "params": [{
                "position": 1,
                "name": "VERBOSE",
                "type": "flag",
                "required": True,
            }],
        })
        self.assertIn(
            "test: params: 'flag' is not a valid 'type' (declare flags in "
            "the 'flags' array)", errors,
        )

    def test_entry_type_must_be_recognized(self):
        for key in ("params", "options", "constants"):
            for type_value in shoemaker.ShoedocSchema.TYPE_VALUES:
                with self.subTest(key=key, type=type_value):
                    entry = {"name": "x", "type": type_value}
                    if key == "params":
                        entry["position"] = 1
                    errors, _ = self.validate({
                        "namespace": "ns",
                        key: [entry],
                    })
                    self.assertEqual(errors, [])
            entry = {"name": "x", "type": "dir"}
            if key == "params":
                entry["position"] = 1
            errors, _ = self.validate({"namespace": "ns", key: [entry]})
            self.assertIn(
                f"test: {key}: invalid 'type': 'dir' (expected one of: "
                f"{', '.join(shoemaker.ShoedocSchema.TYPE_VALUES)})", errors,
            )

    def test_top_level_type_must_be_recognized(self):
        errors, _ = self.validate({"namespace": "ns", "type": "str"})
        self.assertEqual(errors, [])

        errors, _ = self.validate({"namespace": "ns", "type": "dir"})
        self.assertIn(
            f"test: 'type' must be one of: "
            f"{', '.join(shoemaker.ShoedocSchema.TYPE_VALUES)}",
            errors,
        )

    def test_name_property_is_accepted(self):
        errors, _ = self.validate({
            "namespace": "ns", "name": "hello", "summary": "s",
        })
        self.assertEqual(errors, [])

        errors, _ = self.validate({
            "namespace": "ns", "name": "", "summary": "s",
        })
        self.assertIn("test: 'name' must not be empty", errors)

    def test_links_property(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "links": ["https://example.test", "https://example.org"],
        })
        self.assertEqual(errors, [])

        for bad in ([], ["https://a.test", "https://a.test"], [""]):
            with self.subTest(links=bad):
                errors, _ = self.validate({
                    "namespace": "ns", "links": list(bad),
                })
                self.assertTrue(errors, f"links={bad!r} should fail")

        errors, _ = self.validate({"namespace": "ns", "links": "x"})
        self.assertIn(
            "test: 'links' must be an array of non-empty strings", errors)

    def test_variables_entries(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "variables": [{
                "name": "who",
                "type": "str",
                "constraint": "/^[a-z]+$/",
                "description": "Greeting recipient name.",
            }],
        })
        self.assertEqual(errors, [])

        errors, _ = self.validate({
            "namespace": "ns",
            "variables": [{"name": "who", "deprecated": "Use x instead."}],
        })
        self.assertEqual(errors, [])

        errors, _ = self.validate({
            "namespace": "ns",
            "variables": [{"name": "who", "position": 1}],
        })
        self.assertIn("test: variables: unknown key(s): position", errors)

        errors, _ = self.validate({
            "namespace": "ns",
            "variables": [{"name": "who|whom"}],
        })
        self.assertIn("test: variables: invalid 'name': 'who|whom'", errors)

    def test_constants_and_variables_name_is_optional(self):
        for key in ("constants", "variables"):
            with self.subTest(key=key):
                errors, _ = self.validate({
                    "namespace": "ns",
                    key: [{"type": "str", "description": "d."}],
                })
                self.assertEqual(errors, [])

                errors, _ = self.validate({
                    "namespace": "ns",
                    key: [{"name": "x", "type": "str"}],
                })
                self.assertEqual(errors, [])

    def test_script_block_scope(self):
        for key in ("namespace", "requires", "stdout", "stderr", "stdin"):
            with self.subTest(key=key):
                linter = shoemaker.ShoedocLinter()
                errors, _warnings = linter.validate(
                    {"summary": "s", key: ["x"]}, "test:1", scope="script"
                )
                self.assertIn(
                    f"test:1: script block cannot own a '{key}' property",
                    errors,
                )

        linter = shoemaker.ShoedocLinter()
        errors, warnings = linter.validate(
            {"name": "tool", "summary": "s", "copyright": "c"}, "test:1",
            scope="script",
        )
        self.assertEqual(errors, [])
        self.assertEqual(warnings, [])

    def test_function_blocks_keep_namespace(self):
        linter = shoemaker.ShoedocLinter()
        _errors, warnings = linter.validate({"summary": "s"}, "test:1")
        self.assertEqual(warnings, ["test:1: missing 'namespace' property"])

    def test_flag_entries_cannot_own_value_fields(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "flags": [{
                "name": "VERBOSE",
                "position": 1,
                "type": "str",
                "required": True,
            }],
        })
        for field in ("position", "type", "required"):
            self.assertIn(
                f"test: flags: a flag cannot own a '{field}' property",
                errors,
            )

    def test_options_reject_required_in_json(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "options": [{"name": "count", "default": 1, "required": True}],
        })
        self.assertIn(
            "test: options: an option cannot own a 'required' property",
            errors,
        )

    def test_nullable_is_rejected(self):
        errors, _ = self.validate({
            "namespace": "ns",
            "params": [{"name": "x", "nullable": False}],
        })
        self.assertIn("test: params: unknown key(s): nullable", errors)

    def test_envelope_lines_match_repo_style(self):
        lines = shoemaker.ShoedocSerializer().json_envelope_lines({"namespace": "ns"})
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
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(lines)
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
        self.assertEqual(shoemaker.ShoedocParser.missing_shoedoc_blocks(lines), [])

    def test_stray_open_after_proper_block_is_flagged(self):
        lines = [
            "## {\n",
            "##   \"namespace\": \"ns\"\n",
            "## }\n",
            "## {\n",
            "##   \"summary\": \"s\"\n",
            "foo() {\n",
        ]
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (5, "foo"))

    def test_double_open_single_close_is_flagged(self):
        lines = [
            "## {\n",
            "## {\n",
            "## }\n",
            "bar() {\n",
        ]
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (3, "bar"))

    def test_orphan_close_above_open_is_flagged(self):
        lines = [
            "## }\n",
            "## {\n",
            "##   \"summary\": \"s\"\n",
            "baz() {\n",
        ]
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (3, "baz"))

    def test_unannotated_function_is_not_flagged(self):
        lines = [
            "function() {\n",
            "    echo ok\n",
            "}\n",
        ]
        self.assertEqual(shoemaker.ShoedocParser.missing_shoedoc_blocks(lines), [])

    def test_crlf_annotation_lines(self):
        lines = [
            "## summary\r\n",
            "function() {\r\n",
        ]
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(lines)
        self.assertEqual(missing[0][:2], (1, "function"))


class EnvelopeSpansTest(unittest.TestCase):
    def test_single_envelope(self):
        spans = shoemaker.ShoedocParser.envelope_spans(
            ["{", "  \"k\": 1", "}"]
        )
        self.assertEqual(spans, [(0, 2)])

    def test_nested_brace_lines_belong_to_outer_envelope(self):
        spans = shoemaker.ShoedocParser.envelope_spans(
            ["{", "  \"params\": [", "    {", "      \"k\": 1", "    }",
             "  ]", "}"]
        )
        self.assertEqual(spans, [(0, 6)])

    def test_sequential_envelopes_are_separate_spans(self):
        spans = shoemaker.ShoedocParser.envelope_spans(
            ["{", "  \"k\": 1", "}", "", "{", "  \"j\": 2", "}"]
        )
        self.assertEqual(spans, [(0, 2), (4, 6)])

    def test_unclosed_envelope_returns_none(self):
        self.assertIsNone(
            shoemaker.ShoedocParser.envelope_spans(["{", "  \"k\": 1"])
        )
        self.assertIsNone(
            shoemaker.ShoedocParser.envelope_spans(["{", "{", "}"])
        )

    def test_stray_close_is_ignored(self):
        spans = shoemaker.ShoedocParser.envelope_spans(
            ["}", "{", "  \"k\": 1", "}"]
        )
        self.assertEqual(spans, [(1, 3)])


class SanitizeTest(unittest.TestCase):
    def test_deep_nesting_terminates(self):
        text = "$(echo " * 1000 + "ok" + ")" * 1000
        try:
            sanitized, _ = shoemaker.ShellSanitizer().sanitize(text)
        except RecursionError:
            self.fail("sanitize raised RecursionError on deep nesting")
        self.assertEqual(len(sanitized), len(text))

    def test_string_content_is_blanked(self):
        sanitized, _ = shoemaker.ShellSanitizer().sanitize('x "abc" \'def\'')
        self.assertNotIn("abc", sanitized)
        self.assertNotIn("def", sanitized)

    def test_substitution_content_is_preserved(self):
        sanitized, _ = shoemaker.ShellSanitizer().sanitize('x "$(cmd1)"')
        self.assertIn("cmd1", sanitized)


class EndToEndTest(unittest.TestCase):
    def setUp(self):
        self._temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self._temporary_directory.cleanup)
        self.root = pathlib.Path(self._temporary_directory.name)
        (self.root / "ns").mkdir()
        repository = pathlib.Path(shoemaker.__file__).resolve().parent

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
            "\n"
        )
        bare = (
            "#!/bin/sh\n"
            "\n"
            "## Bare summary\n"
            "bare() {\n"
            "    echo bare\n"
            "}\n"
            "\n"
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
            "\n"
        )
        (self.root / "ns" / "valid.sh").write_text(valid)
        (self.root / "ns" / "bare.sh").write_text(bare)
        (self.root / "ns" / "malformed.sh").write_text(malformed)
        self._repository = repository

    def run_shoemaker(self, arguments):
        return subprocess.run(
            [sys.executable, str(self._repository / "shoemaker.py"),
             "lint", str(self.root), *arguments],
            cwd=self.root, capture_output=True, text=True)

    def test_valid_file_completes_without_error(self):
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_bare_summary_is_warned(self):
        result = self.run_shoemaker([])
        self.assertIn(
            "invalid shoedoc: no '## {' ... '## }' JSON block around "
            "the annotation lines of function 'bare'", result.stdout)

    def test_malformed_block_is_warned_once(self):
        result = self.run_shoemaker([])
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
        repository = pathlib.Path(shoemaker.__file__).resolve().parent
        self._repository = repository

        (self.root / "src" / "x" / "_helper.sh").write_text(
            "_helper() {\n"
            "    echo helper\n"
            "}\n"
            "\n"
        )
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
            "\n"
        )

    def run_shoemaker(self, arguments, folder=None, env=None):
        return subprocess.run(
            [sys.executable, str(self._repository / "shoemaker.py"),
             "lint", str(folder or self.root), *arguments],
            cwd=self.root, capture_output=True, text=True, env=env)

    def test_bare_summary_is_warned_without_fix(self):
        result = self.run_shoemaker([])
        self.assertIn(
            "invalid shoedoc: no '## {' ... '## }' JSON block around "
            "the annotation lines of function 'bare'", result.stdout)

    def test_fix_generates_namespace_and_depends(self):
        result = self.run_shoemaker(["--fix"])
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
            "\n"
        ))

    def test_fixed_file_is_clean_on_re_run(self):
        self.run_shoemaker(["--fix"])
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)
        self.assertNotIn("warning:", result.stdout)

    def test_fix_adds_hyphenated_requires(self):
        bin_dir = self.root / "bin"
        bin_dir.mkdir()
        ssh_add = bin_dir / "ssh-add"
        ssh_add.write_text("#!/bin/sh\n")
        ssh_add.chmod(0o755)
        (self.root / "ns" / "agent.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Check the agent"\n'
            "## }\n"
            "agent() {\n"
            '    SSH_AUTH_SOCK="$1" ssh-add -l >/dev/null 2>&1\n'
            "}\n"
            "\n"
        )
        env = dict(os.environ)
        env["PATH"] = f"{bin_dir}{os.pathsep}{env.get('PATH', '')}"

        result = self.run_shoemaker(["--fix"], env=env)

        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "agent.sh").read_text()
        self.assertIn('##     "ssh-add"\n', content)

    def test_fix_adds_depends_for_command_substitution(self):
        (self.root / "src" / "x" / "_pwd.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "_pwd() {\n"
            "    pwd\n"
            "}\n"
            "\n"
        )
        (self.root / "ns" / "backup.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Create a backup folder",\n'
            '##   "requires": [\n'
            '##     "mkdir"\n'
            "##   ]\n"
            "## }\n"
            "backup() {\n"
            '    set -- "$(_pwd)/backups"\n'
            '    mkdir -p "$1"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker(["--fix"])

        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "backup.sh").read_text()
        self.assertIn('##     "src/x/_pwd"\n', content)

    def test_lint_reports_missing_recipe_dependency(self):
        (self.root / "recipes" / "app" / "install").mkdir(parents=True)
        (self.root / "recipes" / "other").mkdir(parents=True)
        (self.root / "recipes" / "app" / "install" /
         "requirements.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "recipes/app/install",\n'
            '##   "summary": "Check requirements"\n'
            "## }\n"
            "requirements() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "recipes" / "other" / "requirements.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "recipes/other",\n'
            '##   "summary": "Other requirements"\n'
            "## }\n"
            "requirements() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "recipes" / "app" / "_before.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "recipes/app",\n'
            '##   "summary": "Run before",\n'
            '##   "depends": [\n'
            '##     "src/x/_helper"\n'
            "##   ]\n"
            "## }\n"
            "_before() {\n"
            "    _helper\n"
            "    requirements\n"
            "}\n"
            "\n"
        )

        result = self.run_shoemaker([])

        self.assertIn(
            "'depends' missing entry: "
            '"recipes/app/install/requirements"',
            result.stdout,
        )
        self.assertNotIn(
            "'depends' missing entry: "
            '"recipes/other/requirements"',
            result.stdout,
        )

        fixed = self.run_shoemaker(["--fix"])
        self.assertEqual(fixed.returncode, 0, fixed.stdout)
        content = (
            self.root / "recipes" / "app" / "_before.sh"
        ).read_text()
        self.assertIn('"recipes/app/install/requirements"', content)
        self.assertNotIn('"recipes/other/requirements"', content)

    def test_overrides_core_module_is_valid(self):
        (self.root / "recipes" / "r").mkdir(parents=True)
        (self.root / "recipes" / "r" / "_helper.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "recipes/r",\n'
            '##   "summary": "Replace the core helper",\n'
            '##   "overrides": "src/x/_helper"\n'
            "## }\n"
            "_helper() {\n"
            "    :\n"
            "}\n"
            "\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_overrides_must_be_a_single_module(self):
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Replace a helper",\n'
            '##   "overrides": ["src/x/_helper"]\n'
            "## }\n"
            "_helper() {\n"
            "    :\n"
            "}\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'overrides' must be a string", result.stdout)

    def test_overrides_must_reference_a_core_module(self):
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Replace a helper",\n'
            '##   "overrides": "ns/_helper"\n'
            "## }\n"
            "_helper() {\n"
            "    :\n"
            "}\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "'overrides' must reference a core module: 'ns/_helper'",
            result.stdout)

    def test_overrides_target_must_exist(self):
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Replace a helper",\n'
            '##   "overrides": "src/x/_missing"\n'
            "## }\n"
            "_missing() {\n"
            "    :\n"
            "}\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "'overrides' file not found: 'src/x/_missing'.sh",
            result.stdout)

    def test_each_function_span_uses_its_own_record(self):
        folder = self.root / "spans"
        folder.mkdir()
        (folder / "spans.sh").write_text(
            "## one\n"
            "## two\n"
            "## three\n"
            "## four\n"
            "## {\n"
            '##   "namespace": "ns"\n'
            "## }\n"
            "first() {\n"
            "    :\n"
            "}\n"
            "## {\n"
            '##   "namespace": "ns"\n'
            "## }\n"
            "second() {\n"
            "    :\n"
            "}\n"
        )
        result = self.run_shoemaker([], folder=folder)
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("module defines 2 functions", result.stdout)
        self.assertNotIn("Traceback", result.stderr)

    def test_fix_removes_default_from_required_entry(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "params": [\n'
            "##     {\n"
            '##       "position": 1,\n'
            '##       "name": "who",\n'
            '##       "default": "World",\n'
            '##       "required": true\n'
            "##     }\n"
            "##   ]\n"
            "## }\n"
            "bare() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn(
            "removed 'default' from required 'params' entries", result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertNotIn('"default"', content)
        self.assertIn('"required": true', content)
        rerun = self.run_shoemaker([])
        self.assertEqual(rerun.returncode, 0, rerun.stdout)
        self.assertNotIn("error:", rerun.stdout)

    def test_fix_orders_properties_canonically(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "summary": "Stand alone",\n'
            '##   "namespace": "ns"\n'
            "## }\n"
            "bare() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("ordered properties", result.stdout)
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
            "\n"
        ))

    def test_fix_without_calls_generates_namespace_only(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Stand alone\n"
            "bare() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
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
            "\n"
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
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
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
            "\n"
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
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
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
            "\n"
        ))
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(content.splitlines(True))
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
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
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
            "\n"
        ))
        missing = shoemaker.ShoedocParser.missing_shoedoc_blocks(content.splitlines(True))
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
            "\n"
        )
        (self.root / "ns" / "bare.sh").write_text(content)
        result = self.run_shoemaker(["--fix"])
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
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
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
            "\n"
        ))

    def test_subfolder_scan_still_resolves_src_depends(self):
        result = self.run_shoemaker(
            ["--fix"], folder=self.root / "ns"
        )
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertIn('"depends": [', content)
        self.assertIn('"src/x/_helper"', content)

    def test_lint_fix_does_not_migrate_legacy_parameters(self):
        (self.root / "ns" / "legacy.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Legacy function\n"
            "##\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Legacy function",\n'
            '##   "parameters": [\n'
            "##     {\n"
            '##       "position": 1,\n'
            '##       "name": "who",\n'
            '##       "type": "str",\n'
            '##       "description": "Name.",\n'
            '##       "nullable": false\n'
            "##     }\n"
            "##   ]\n"
            "## }\n"
            "legacy() {\n"
            '    echo "${who:-World}"\n'
            "}\n"
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("unknown property: 'parameters'", result.stdout)
        content = (self.root / "ns" / "legacy.sh").read_text()
        self.assertIn('"parameters"', content)
        self.assertNotIn('"params"', content)

    def test_lint_tolerates_non_utf8_files(self):
        (self.root / "ns" / "greet.sh").write_bytes(
            b"Greet caf\xe9\n"
            b"## {\n"
            b'##   "namespace": "ns"\n'
            b"}\n"
            b"greet() {\n"
            b"    :\n"
            b"}\n"
            b"\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)

    def test_adjacent_script_header_and_function_block_lint_clean(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "name": "tool",\n'
            '##   "summary": "Tool"\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_script_header_without_blank_line_lints_clean(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "name": "tool",\n'
            '##   "summary": "Tool"\n'
            "## }\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_script_block_cannot_own_namespace(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Tool"\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "script block cannot own a 'namespace' property", result.stdout)

    def test_script_header_is_linted(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "summary": "Tool",\n'
            '##   "version": 1\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'version' must be a string", result.stdout)
        self.assertNotIn("missing 'namespace'", result.stdout)

    def test_fix_orders_script_header_properties(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "summary": "Tool",\n'
            '##   "name": "tool"\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("ordered properties", result.stdout)
        content = (self.root / "ns" / "public_task.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "name": "tool",\n'
            '##   "summary": "Tool"\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        ))

    def test_fix_folds_script_header_bare_summary(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Tool summary\n"
            "## {\n"
            '##   "name": "tool"\n'
            "## }\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "public_task.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "name": "tool",\n'
            '##   "summary": "Tool summary"\n'
            "## }\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Run task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        ))

HELLO_CLASSIC = """\
## Hello World!
##
## Greets a specified user a given number of times.
##
## @shell     bash
## @namespace recipes/shoe
## @requires  getopt echo
## @param     {str} <who>    /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
## @option    {int} <count>  [-c|--count]   (default:1)       The repetition count.
## @flag            <prefix> [-p|--prefix]                    Prefix output with a line number.
hello() {
    :
}
"""


def parse_block(content):
    lines = content.split("\n")
    opened = min(
        index for index, line in enumerate(lines)
        if line.startswith("##") and line[2:].strip() == "{"
    )
    closed = max(
        index for index, line in enumerate(lines)
        if line.startswith("##") and line[2:].strip() == "}"
    )
    return json.loads("\n".join(
        line[2:].strip() for line in lines[opened:closed + 1]
    ))


def tags_of(data):
    """Render a dict as a JSON block, then convert it to classic tags."""
    text = json.dumps(data, indent=2)
    content = "".join("## %s\n" % line for line in text.split("\n"))
    classic, count, had_error = convert_content(content, "tags")
    return classic, count, had_error


class ClassicToJsonTest(unittest.TestCase):
    def test_hello_block_converted(self):
        new_content, count, had_error = convert_content(
            HELLO_CLASSIC, "json"
        )
        self.assertEqual((count, had_error), (1, False))
        parsed = parse_block(new_content)
        self.assertEqual(parsed["summary"], "Hello World!")
        self.assertEqual(
            parsed["description"],
            "Greets a specified user a given number of times.",
        )
        self.assertEqual(parsed["shell"], "bash")
        self.assertEqual(parsed["namespace"], "recipes/shoe")
        self.assertEqual(parsed["requires"], ["getopt", "echo"])
        self.assertEqual(parsed["params"], [{
            "position": 1,
            "type": "str",
            "name": "who",
            "constraint": "/^[a-zA-Z-]+$/",
            "default": "World",
            "description": "The recipient's name.",
        }])
        self.assertEqual(parsed["options"], [{
            "type": "int",
            "name": "count",
            "short": "c",
            "long": "count",
            "default": 1,
            "description": "The repetition count.",
        }])
        self.assertEqual(parsed["flags"], [{
            "name": "prefix",
            "short": "p",
            "long": "prefix",
            "description": "Prefix output with a line number.",
        }])

    def test_json_properties_follow_canonical_order(self):
        content = (
            "## T\n"
            "##\n"
            "## @namespace ns\n"
            "## @requires echo\n"
            "## @param {str} <who> Name.\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, had_error = convert_content(content, "json")
        self.assertEqual((count, had_error), (1, False))
        parsed = parse_block(new_content)
        self.assertEqual(
            list(parsed), ["namespace", "summary", "requires", "params"]
        )
        self.assertEqual(
            list(parsed["params"][0]),
            ["position", "name", "description", "type"],
        )

    def test_overrides_tag_converted(self):
        content = (
            "## T\n"
            "##\n"
            "## @namespace ns\n"
            "## @overrides src/shell/hooks/_before\n"
            "_before() {\n"
            "    :\n"
            "}\n"
        )

        new_content, count, had_error = convert_content(content, "json")

        self.assertEqual((count, had_error), (1, False))
        parsed = parse_block(new_content)
        self.assertEqual(
            parsed["overrides"], "src/shell/hooks/_before"
        )

    def test_parameter_aliases_survive_format_conversion(self):
        content = (
            "## Container id or name\n"
            "##\n"
            "## @param {str} <CONTAINER_NAME|CONTAINER_ID> Container lookup.\n"
            "inspect_container() {\n"
            "    :\n"
            "}\n"
        )
        json_content, count, had_error = convert_content(content, "json")

        self.assertEqual((count, had_error), (1, False))
        self.assertEqual(
            parse_block(json_content)["params"][0]["name"],
            "CONTAINER_NAME|CONTAINER_ID",
        )
        classic_content, count, had_error = convert_content(json_content, "tags")
        self.assertEqual((count, had_error), (1, False))
        self.assertIn(
            "<CONTAINER_NAME|CONTAINER_ID>", classic_content
        )

    def test_description_is_preserved(self):
        content = (
            "## Title\n"
            "##\n"
            "## Desc line one\n"
            "## Desc line two\n"
            "##\n"
            "## @namespace ns\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual(count, 1)
        parsed = parse_block(new_content)
        self.assertEqual(parsed["summary"], "Title")
        self.assertEqual(
            parsed["description"], "Desc line one\nDesc line two"
        )

    def test_author_value_is_parsed_into_authors(self):
        content = (
            "## T\n"
            "##\n"
            '## @author "Matthias Morin" <mat@tangoman.io>'
            " https://tangoman.io\n"
            "foo() {\n"
            "}\n"
        )
        _new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual(count, 1)

    def test_new_tags_are_parsed(self):
        content = (
            "## T\n"
            "##\n"
            "## @private\n"
            "## @deprecated Use bar instead.\n"
            "## @type {str}\n"
            "## @example hello World\n"
            "## @constant {str} Default recipient name.\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual(count, 1)
        parsed = parse_block(new_content)
        self.assertIs(parsed["private"], True)
        self.assertEqual(parsed["deprecated"], "Use bar instead.")
        self.assertEqual(parsed["type"], "str")
        self.assertEqual(parsed["examples"], ["hello World"])
        self.assertEqual(parsed["constants"], [{
            "type": "str",
            "description": "Default recipient name.",
        }])

    def test_repeated_array_tags_accumulate(self):
        content = (
            "## T\n"
            "##\n"
            "## @requires awk\n"
            "## @requires sed\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, had_error = convert_content(content, "json")
        self.assertEqual((count, had_error), (1, False))
        self.assertEqual(parse_block(new_content)["requires"], ["awk", "sed"])

    def test_public_tag_sets_private_false(self):
        content = "## T\n##\n## @public\nfoo() {\n}\n"
        new_content, _count, _had_error = convert_content(content, "json")
        self.assertIs(parse_block(new_content)["private"], False)

    def test_required_marker_on_params(self):
        content = (
            "## T\n"
            "##\n"
            "## @param {file} <input> (required) Input.\n"
            "foo() {\n"
            "}\n"
        )
        new_content, _count, _had_error = convert_content(content, "json")
        entry = parse_block(new_content)["params"][0]
        self.assertEqual(entry, {
            "position": 1,
            "type": "file",
            "name": "input",
            "required": True,
            "description": "Input.",
        })

    def test_option_required_marker_is_ignored(self):
        content = (
            "## T\n"
            "##\n"
            "## @option {file} <input> [-i|--input] (required) Input.\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual(count, 1)
        entry = parse_block(new_content)["options"][0]
        self.assertEqual(entry, {
            "type": "file",
            "name": "input",
            "short": "i",
            "long": "input",
            "description": "Input.",
        })
        self.assertNotIn("required", entry)

    def test_params_keep_required_marker_when_rendering_tags(self):
        classic, _count, _had_error = tags_of({
            "params": [{"name": "x", "required": True}],
        })
        self.assertEqual(classic, "## @param <x> (required)\n")

    def test_removed_tags_are_not_recognized(self):
        content = (
            "## T\n"
            "##\n"
            "## @return 0\n"
            "## @returns int\n"
            "## @arguments 1\n"
            "foo() {\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual((new_content, count), (content, 0))

    def test_unrecognized_chunk_is_left_untouched(self):
        content = "## Just a comment\n## Another\nfoo() {\n}\n"
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual((new_content, count), (content, 0))

    def test_classic_tags_inside_function_body_are_not_converted(self):
        content = (
            "#!/bin/sh\n"
            "foo() {\n"
            "    cat <<EOT\n"
            "## Greeting\n"
            "##\n"
            "## @namespace ns\n"
            "EOT\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "json")
        self.assertEqual((new_content, count), (content, 0))

    def test_json_block_inside_heredoc_is_not_converted_to_tags(self):
        content = (
            "#!/bin/sh\n"
            "foo() {\n"
            "    cat <<EOT\n"
            "## {\n"
            '##   "summary": "Greeting"\n'
            "## }\n"
            "EOT\n"
            "}\n"
        )
        new_content, count, _had_error = convert_content(content, "tags")
        self.assertEqual((new_content, count), (content, 0))


class JsonToClassicTest(unittest.TestCase):
    def test_hello_json_converted_back(self):
        classic_json, _count, _had_error = convert_content(
            HELLO_CLASSIC, "json"
        )
        json_content, _count, _had_error = convert_content(classic_json, "json")
        classic_content, count, had_error = convert_content(
            json_content, "tags"
        )
        self.assertEqual((count, had_error), (1, False))
        self.assertIn("## @param {str} <who>", classic_content)
        self.assertIn('(default:"World")', classic_content)
        self.assertIn("## @option {int} <count> [-c|--count]", classic_content)
        self.assertIn("(default:1)", classic_content)
        self.assertIn("## @flag <prefix> [-p|--prefix]", classic_content)
        self.assertIn("## @requires getopt echo", classic_content)

    def test_full_round_trip_is_stable(self):
        once, _count, _had_error = convert_content(HELLO_CLASSIC, "json")
        classic, _count, _had_error = convert_content(once, "tags")
        twice, _count, _had_error = convert_content(classic, "json")
        self.assertEqual(twice, once)

    def test_authors_render_one_tag_each(self):
        classic, count, _had_error = tags_of({
            "authors": [
                {"name": "Matthias Morin", "email": "mat@tangoman.io"},
            ],
        })
        self.assertEqual(count, 1)
        self.assertEqual(
            classic,
            '## @author "Matthias Morin" <mat@tangoman.io>\n',
        )

    def test_private_and_public_rendered(self):
        true_case, _count, _had_error = tags_of({"private": True})
        self.assertEqual(true_case, "## @private\n")
        false_case, _count, _had_error = tags_of({"private": False})
        self.assertEqual(false_case, "## @public\n")

    def test_type_and_examples_rendered(self):
        classic, _count, _had_error = tags_of({
            "type": "str",
            "examples": ["a", "b"],
        })
        self.assertEqual(
            classic, "## @type {str}\n## @example a\n## @example b\n"
        )

    def test_overrides_rendered_as_tag(self):
        classic, count, _had_error = tags_of({
            "overrides": "src/shell/hooks/_before",
        })
        self.assertEqual(count, 1)
        self.assertEqual(
            classic, "## @overrides src/shell/hooks/_before\n"
        )

    def test_name_has_no_classic_form_and_variables_render(self):
        classic, count, _had_error = tags_of({
            "name": "foo",
            "variables": [{"name": "x", "type": "str"}],
        })
        self.assertEqual(count, 1)
        self.assertEqual(classic, "## @variable {str} <x>\n")

    def test_position_is_derived_from_param_order(self):
        content = (
            "## T\n"
            "##\n"
            "## @param {str} <first> First.\n"
            "## @param {str} <second> Second.\n"
            "## @param {str} <third> Third.\n"
            "foo() {\n"
            "}\n"
        )
        new_content, _count, _had_error = convert_content(content, "json")
        self.assertEqual(
            [entry["position"] for entry in parse_block(new_content)["params"]],
            [1, 2, 3],
        )

    def test_position_is_dropped_when_rendering_tags(self):
        classic, _count, _had_error = tags_of({
            "params": [{"name": "x", "position": 1}],
            "options": [{"name": "y", "position": 3}],
        })
        self.assertEqual(classic, "## @param <x>\n## @option <y>\n")

    def test_position_round_trip_is_stable(self):
        classic, _count, _had_error = tags_of({"params": [{"name": "x"}]})
        once, _count, _had_error = convert_content(classic, "json")
        re_classic, _count, _had_error = convert_content(once, "tags")
        twice, _count, _had_error = convert_content(re_classic, "json")
        self.assertEqual(twice, once)

    def test_position_mismatch_is_normalized_by_conversion(self):
        classic, _count, _had_error = tags_of({
            "params": [{"name": "x", "position": 2}],
        })
        self.assertEqual(classic, "## @param <x>\n")
        once, _count, _had_error = convert_content(classic, "json")
        self.assertEqual(once, '## {\n##   "params": [\n##     {\n'
                              '##       "position": 1,\n'
                              '##       "name": "x"\n'
                              "##     }\n##   ]\n## }\n")

    def test_required_false_renders_optional_marker(self):
        classic, _count, _had_error = tags_of({
            "params": [{"name": "x", "required": False}],
        })
        self.assertEqual(classic, "## @param <x> (optional)\n")

    def test_default_renders_quoted_strings(self):
        classic, _count, _had_error = tags_of({
            "params": [{"name": "x", "default": "World"}],
        })
        self.assertEqual(classic, '## @param <x> (default:"World")\n')


class SynopsisMigrationTest(unittest.TestCase):
    def setUp(self):
        self.migrator = shoemaker.SynopsisMigrator()

    def migrate(self, content):
        return self.migrator.migrate_content(content)

    def test_synopsis_block_is_removed(self):
        content = (
            "#!/bin/sh\n"
            "\n"
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "\n"
            "    printf '%s\\n' \"$1\"\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, (
            "#!/bin/sh\n"
            "\n"
            "greet() {\n"
            "    printf '%s\\n' \"$1\"\n"
            "}\n"
        ))

    def test_two_space_details_and_continuations_are_removed(self):
        content = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #  NAME: The name to greet.\n"
            "    #  note: A long note\n"
            "    #        continued on the next line.\n"
            "\n"
            "    :\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, "greet() {\n    :\n}\n")

    def test_unrelated_comment_is_preserved(self):
        content = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "    # remove previous install if any\n"
            "    :\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, (
            "greet() {\n"
            "    # remove previous install if any\n"
            "    :\n"
            "}\n"
        ))

    def test_script_level_synopsis_is_preserved(self):
        content = (
            "# Synopsis: script documentation\n"
            "## {\n"
            '##   "summary": "Tool"\n'
            "## }\n"
            "\n"
            "greet() {\n"
            "    :\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 0)
        self.assertEqual(new_content, content)

    def test_heredoc_payload_synopsis_is_preserved(self):
        content = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "    cat <<'EOF'\n"
            "    # Synopsis: echo <TEXT>\n"
            "    #   TEXT: Payload, not a comment.\n"
            "EOF\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, (
            "greet() {\n"
            "    cat <<'EOF'\n"
            "    # Synopsis: echo <TEXT>\n"
            "    #   TEXT: Payload, not a comment.\n"
            "EOF\n"
            "}\n"
        ))

    def test_nested_function_synopsis_is_removed(self):
        content = (
            "install() {\n"
            "    inner() {\n"
            "        # Synopsis: inner <PATH>\n"
            "        #   PATH: The target path.\n"
            "        :\n"
            "    }\n"
            "    inner\n"
            "}\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, (
            "install() {\n"
            "    inner() {\n"
            "        :\n"
            "    }\n"
            "    inner\n"
            "}\n"
        ))

    def test_crlf_line_endings_are_preserved(self):
        content = (
            "greet() {\r\n"
            "    # Synopsis: greet <NAME>\r\n"
            "    #   NAME: The name to greet.\r\n"
            "\r\n"
            "    :\r\n"
            "}\r\n"
        )
        new_content, removed = self.migrate(content)
        self.assertEqual(removed, 1)
        self.assertEqual(new_content, "greet() {\r\n    :\r\n}\r\n")

    def test_migration_is_idempotent(self):
        content = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "    :\n"
            "}\n"
        )
        once, removed = self.migrate(content)
        twice, removed_again = self.migrate(once)
        self.assertEqual(removed, 1)
        self.assertEqual(removed_again, 0)
        self.assertEqual(twice, once)


class FileEndingRuleTest(unittest.TestCase):
    def test_exactly_one_trailing_blank_line_is_valid(self):
        lines = ["#!/bin/sh\n", "\n", "check() {\n", "    :\n", "}\n", "\n"]
        self.assertIsNone(shoemaker.FileEndingRule.issue(lines))

    def test_missing_trailing_blank_line_is_flagged(self):
        lines = ["#!/bin/sh\n", "\n", "check() {\n", "    :\n", "}\n"]
        self.assertIn(
            "trailing blank line",
            shoemaker.FileEndingRule.issue(lines),
        )

    def test_extra_trailing_blank_lines_are_flagged(self):
        lines = ["#!/bin/sh\n", "\n", "check() {\n", "    :\n", "}\n",
                 "\n", "\n"]
        self.assertIn(
            "trailing blank line",
            shoemaker.FileEndingRule.issue(lines),
        )

    def test_missing_final_newline_is_flagged(self):
        lines = ["#!/bin/sh\n", "check() {\n", "    :\n", "}"]
        self.assertIn(
            "trailing blank line",
            shoemaker.FileEndingRule.issue(lines),
        )

    def test_crlf_ending_is_preserved(self):
        lines = ["#!/bin/sh\r\n", "check() {\r\n", "    :\r\n", "}\r\n"]
        normalized = shoemaker.FileEndingRule.normalize(lines)
        self.assertEqual(normalized[-1], "\r\n")
        self.assertIsNone(shoemaker.FileEndingRule.issue(normalized))

    def test_normalize_adds_exactly_one_trailing_blank_line(self):
        for lines in (
            ["#!/bin/sh\n", "check() {\n", "    :\n", "}\n"],
            ["#!/bin/sh\n", "check() {\n", "    :\n", "}\n", "\n", "\n"],
            ["#!/bin/sh\n", "check() {\n", "    :\n", "}"],
        ):
            with self.subTest(lines=lines):
                normalized = shoemaker.FileEndingRule.normalize(lines)
                self.assertEqual(normalized[-1], "\n")
                self.assertIsNone(
                    shoemaker.FileEndingRule.issue(normalized)
                )

    def test_empty_file_gets_one_blank_line(self):
        self.assertIn("found 0", shoemaker.FileEndingRule.issue([]))
        normalized = shoemaker.FileEndingRule.normalize([])
        self.assertEqual(normalized, ["\n"])
        self.assertIsNone(shoemaker.FileEndingRule.issue(normalized))


ROOT = pathlib.Path(__file__).resolve().parents[2]
SHOEMAKER = ROOT / "shoemaker.py"


class ShoemakerCliTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary_directory.cleanup)
        self.root = pathlib.Path(self.temporary_directory.name)
        (self.root / "ns").mkdir()

    def run_shoemaker(self, *arguments):
        return subprocess.run(
            [sys.executable, str(SHOEMAKER), *map(str, arguments)],
            cwd=self.root,
            capture_output=True,
            text=True,
        )

    def test_help_lists_commands_and_common_pytools_options(self):
        result = self.run_shoemaker("--help")

        self.assertEqual(result.returncode, 0, result.stderr)
        for command in (
            "lint", "convert", "migrate", "dump", "tree", "build",
            "generate_doc", "generate_makefile", "completion",
        ):
            self.assertIn(command, result.stdout)
        for option in ("--verbose", "--quiet", "--log", "--completion"):
            self.assertIn(option, result.stdout)

    def test_help_lists_command_specific_options(self):
        result = self.run_shoemaker("--help")

        self.assertEqual(result.returncode, 0, result.stderr)
        for option in (
            "--fix", "--tags", "--json", "--dry-run", "--file",
            "--destination", "--sh", "--bash", "--private",
        ):
            self.assertIn(option, result.stdout)
        for command in (
            "lint", "migrate", "generate_doc", "generate_makefile",
        ):
            self.assertIn(f"  {command}:", result.stdout)

    def test_file_options_follow_long_only_convention(self):
        result = self.run_shoemaker("dump", "--help")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--file", result.stdout)
        self.assertIn("--destination", result.stdout)
        self.assertNotIn("-f,", result.stdout)
        self.assertNotIn("-d,", result.stdout)

    def assert_valid_completion(self, result):
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("#!/bin/bash", result.stdout)
        self.assertIn("complete -f -F _shoemaker_completions shoemaker", result.stdout)
        self.assertIn("generate_makefile", result.stdout)
        self.assertIn("--dry-run", result.stdout)
        self.assertIn("--sh", result.stdout)
        self.assertIn("--bash", result.stdout)
        syntax = subprocess.run(
            ["bash", "-n"],
            input=result.stdout,
            capture_output=True,
            text=True,
            check=False,
        )
        self.assertEqual(syntax.returncode, 0, syntax.stderr)

    def test_completion_subcommand_prints_bash_script(self):
        self.assert_valid_completion(self.run_shoemaker("completion"))

    def test_completion_option_prints_before_required_subcommand(self):
        self.assert_valid_completion(self.run_shoemaker("--completion"))

    def test_quiet_suppresses_output_but_propagates_exit_code(self):
        result = self.run_shoemaker("convert", "missing.sh", "--quiet")

        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_lint_subcommand_accepts_folder(self):
        source = (
            "## {\n"
            '##   "namespace": "ns"\n'
            "## }\n"
            "check() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "ns" / "check.sh").write_text(source)

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("1 block(s) checked, no error", result.stdout)

    def test_lint_rejects_multiple_functions_per_module(self):
        (self.root / "ns" / "tool.sh").write_text(
            "#!/bin/sh\n"
            "first() {\n    :\n}\n"
            "second() {\n    :\n}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "module defines 2 functions (first, second); "
            "expected exactly one", result.stdout)

    def test_lint_rejects_function_name_mismatch(self):
        (self.root / "ns" / "tool.sh").write_text(
            "#!/bin/sh\n"
            "other() {\n    :\n}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "function 'other' does not match module name 'tool'",
            result.stdout)

    def test_lint_allows_component_files_without_function(self):
        (self.root / "ns" / "constants.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "NAME='value'\n"
            "\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("no error", result.stdout)

    def test_lint_ignores_function_definitions_inside_heredocs(self):
        (self.root / "ns" / "module.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "module() {\n"
            "    cat <<EOF\n"
            "fake() {\n"
            "}\n"
            "EOF\n"
            "}\n"
            "\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("no error", result.stdout)

    def test_lint_allows_indented_nested_helpers(self):
        (self.root / "ns" / "module.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "module() {\n"
            "    _usage() {\n"
            "        :\n"
            "    }\n"
            "    _usage\n"
            "}\n"
            "\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("no error", result.stdout)

    def test_lint_rejects_missing_trailing_blank_line(self):
        (self.root / "ns" / "check.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "check() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "expected exactly one trailing blank line (found 0)",
            result.stdout,
        )

    def test_lint_rejects_extra_trailing_blank_lines(self):
        (self.root / "ns" / "check.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "check() {\n"
            "    :\n"
            "}\n"
            "\n"
            "\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "expected exactly one trailing blank line (found 2)",
            result.stdout,
        )

    def test_lint_fix_normalizes_trailing_blank_line(self):
        path = self.root / "ns" / "check.sh"
        path.write_text(
            "#!/bin/sh\n"
            "\n"
            "check() {\n"
            "    :\n"
            "}\n"
            "\n"
            "\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("lint", self.root / "ns", "--fix")

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("fixed:", result.stdout)
        self.assertEqual(
            path.read_text(encoding="utf-8"),
            "#!/bin/sh\n"
            "\n"
            "check() {\n"
            "    :\n"
            "}\n"
            "\n",
        )

    def test_lint_fix_preserves_crlf(self):
        path = self.root / "ns" / "check.sh"
        path.write_bytes(
            b"#!/bin/sh\r\n"
            b"\r\n"
            b"check() {\r\n"
            b"    :\r\n"
            b"}\r\n"
        )

        result = self.run_shoemaker("lint", self.root / "ns", "--fix")

        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertEqual(
            path.read_bytes(),
            b"#!/bin/sh\r\n"
            b"\r\n"
            b"check() {\r\n"
            b"    :\r\n"
            b"}\r\n"
            b"\r\n",
        )

    def write_depends_fixture(self):
        (self.root / "ns").mkdir(exist_ok=True)
        envelopes = {
            "root": ["ns/_a", "ns/_cycle", "missing"],
            "_a": ["ns/_b", "ns/_c"],
            "_b": ["ns/_c"],
            "_c": [],
            "_cycle": ["ns/_cycle"],
        }
        for stem, depends in envelopes.items():
            lines = ["#!/bin/sh", "", "## {"]
            if depends:
                lines.append('##   "namespace": "ns",')
                lines.append('##   "depends": [')
                for position, dep in enumerate(depends):
                    comma = "," if position < len(depends) - 1 else ""
                    lines.append('##     "%s"%s' % (dep, comma))
                lines.append("##   ]")
            else:
                lines.append('##   "namespace": "ns"')
            lines.extend(["## }", "%s() {" % stem, "    :", "}", ""])
            (self.root / "ns" / f"{stem}.sh").write_text("\n".join(lines))

    def test_tree_command_prints_transitive_depends(self):
        self.write_depends_fixture()

        result = self.run_shoemaker("tree", self.root / "ns" / "root.sh")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, (
            "ns/_a.sh\n"
            "ns/_b.sh\n"
            "ns/_c.sh\n"
            "ns/_cycle.sh\n"
        ))

    def test_tree_command_warns_about_missing_and_cycle(self):
        self.write_depends_fixture()

        result = self.run_shoemaker("tree", self.root / "ns" / "root.sh")

        self.assertIn(
            'warning: dependency not found: "missing" '
            '(from "ns/root")', result.stderr)
        self.assertIn(
            "warning: dependency cycle detected: "
            "ns/_cycle -> ns/_cycle -> ns/_cycle", result.stderr)

    def test_tree_command_writes_destination_file(self):
        self.write_depends_fixture()
        destination = self.root / "build"

        result = self.run_shoemaker(
            "tree", self.root / "ns" / "root.sh",
            "--destination", destination,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        target = destination / "root.shoe"
        self.assertEqual(target.read_text(), (
            "ns/_a.sh\n"
            "ns/_b.sh\n"
            "ns/_c.sh\n"
            "ns/_cycle.sh\n"
        ))

    def test_tree_command_fails_for_missing_source(self):
        result = self.run_shoemaker("tree", self.root / "ns" / "nope.sh")

        self.assertEqual(result.returncode, 1)
        self.assertIn("file not found", result.stderr)

    def test_convert_dry_run_leaves_file_unchanged(self):
        source = (
            "## Greeting\n"
            "##\n"
            "## @namespace ns\n"
            "greet() {\n"
            "    :\n"
            "}\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("convert", "--json", "--dry-run", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("==> %s <==" % path, result.stdout)
        self.assertIn('"summary": "Greeting"', result.stdout)
        self.assertEqual(path.read_text(), source)

    def test_convert_defaults_to_tags(self):
        source = (
            "## {\n"
            '##   "summary": "Greeting"\n'
            "## }\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("convert", "--dry-run", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("## Greeting", result.stdout)
        self.assertEqual(path.read_text(), source)

    def test_convert_writes_file_when_not_dry_run(self):
        source = (
            "## {\n"
            '##   "summary": "Greeting"\n'
            "## }\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("convert", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Converted", result.stderr)
        self.assertEqual(path.read_text(), "## Greeting\n##\n")

    def test_convert_rejects_non_shell_file(self):
        path = self.root / "ns" / "notes.txt"
        path.write_text("## {}\nnotes\n")

        result = self.run_shoemaker("convert", path)

        self.assertEqual(result.returncode, 1)
        self.assertIn("expected a .sh file", result.stderr)

    def test_convert_handles_braces_inside_string_values(self):
        source = (
            "## {\n"
            '##   "summary": "returns {",\n'
            '##   "namespace": "ns"\n'
            "## }\n"
            "greet() {\n"
            "    :\n"
            "}\n"
        )
        path = self.root / "ns" / "brace.sh"
        path.write_text(source)

        result = self.run_shoemaker("convert", "--dry-run", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("returns {", result.stdout)
        self.assertIn("@namespace ns", result.stdout)
        self.assertNotIn('## {', result.stdout.split("==>")[1])

    def test_migrate_removes_synopsis_blocks(self):
        source = (
            "#!/bin/sh\n"
            "\n"
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "\n"
            "    :\n"
            "}\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("migrate", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Migrated", result.stderr)
        self.assertEqual(path.read_text(), (
            "#!/bin/sh\n"
            "\n"
            "greet() {\n"
            "    :\n"
            "}\n"
        ))

    def test_migrate_dry_run_leaves_file_unchanged(self):
        source = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "\n"
            "    :\n"
            "}\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("migrate", "--dry-run", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("==> %s <==" % path, result.stdout)
        self.assertNotIn("# Synopsis:", result.stdout)
        self.assertEqual(path.read_text(), source)

    def test_migrate_writes_through_a_directory(self):
        source = (
            "greet() {\n"
            "    # Synopsis: greet <NAME>\n"
            "    #   NAME: The name to greet.\n"
            "\n"
            "    :\n"
            "}\n"
        )
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("migrate", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Migrated", result.stderr)
        self.assertNotIn("# Synopsis:", path.read_text())

    def test_migrate_reports_nothing_when_no_block_is_found(self):
        source = "greet() {\n    :\n}\n"
        path = self.root / "ns" / "greet.sh"
        path.write_text(source)

        result = self.run_shoemaker("migrate", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("Migrated", result.stderr)
        self.assertEqual(path.read_text(), source)

    def test_migrate_rejects_non_shell_file(self):
        path = self.root / "ns" / "notes.txt"
        path.write_text("# Synopsis: notes\n")

        result = self.run_shoemaker("migrate", path)

        self.assertEqual(result.returncode, 1)
        self.assertIn("expected a .sh file", result.stderr)

    def write_documented_script(self):
        path = self.root / "tool.sh"
        path.write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "summary": "Fixture Tool",\n'
            '##   "description": "A script for command tests.",\n'
            '##   "authors": [{"name": "Tester"}],\n'
            '##   "version": "1.0",\n'
            '##   "links": ["https://example.test"]\n'
            "## }\n"
            "\n"
            "## A public constant.\n"
            'PUBLIC_CONSTANT="public"\n'
            "\n"
            "## A private constant.\n"
            '_PRIVATE_CONSTANT="private"\n'
            "\n"
            "## {\n"
            '##   "namespace": "demo",\n'
            '##   "summary": "Run a public task",\n'
            '##   "params": [{"position": 1, "name": "name"}]\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
            "## {\n"
            '##   "namespace": "demo",\n'
            '##   "summary": "Run a private task",\n'
            '##   "private": true\n'
            "## }\n"
            "_private_task() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        return path

    def test_dump_extracts_functions_and_writes_recipe(self):
        source = self.write_documented_script()
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", "--file", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        public_dump = (destination / "demo" / "public_task.sh").read_text()
        self.assertTrue(public_dump.startswith("#!/bin/sh\n\n## {\n"))
        self.assertIn("public_task() {", public_dump)
        self.assertTrue((destination / "demo" / "_private_task.sh").is_file())
        self.assertEqual(
            (destination / "tool.shoe").read_text(),
            "#!/bin/sh\n"
            "## {\n"
            '##   "summary": "Fixture Tool",\n'
            '##   "description": "A script for command tests.",\n'
            '##   "authors": [{"name": "Tester"}],\n'
            '##   "version": "1.0",\n'
            '##   "links": ["https://example.test"]\n'
            "## }\n"
            "\n"
            "## A public constant.\n"
            'PUBLIC_CONSTANT="public"\n'
            "\n"
            "## A private constant.\n"
            '_PRIVATE_CONSTANT="private"\n'
            "\n"
            "demo/public_task.sh\n"
            "\n"
            "demo/_private_task.sh\n",
        )

    def test_dump_writes_unexported_source_lines_to_recipe(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            'GREETING="Hello"\n'
            "\n"
            "greet() {\n"
            "    printf '%s\\n' \"${GREETING}\"\n"
            "}\n"
            "\n"
            "greet\n",
            encoding="utf-8",
        )
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            (destination / "tool.shoe").read_text(),
            "#!/bin/sh\n"
            "\n"
            'GREETING="Hello"\n'
            "\n"
            "greet.sh\n"
            "\n"
            "greet\n",
        )

    def test_dump_converts_annotations_to_json_on_request(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Print a greeting\n"
            "##\n"
            "## @namespace demo\n"
            "## @param <name> Name to greet\n"
            "greet() {\n"
            "    printf '%s\\n' \"$1\"\n"
            "}\n",
            encoding="utf-8",
        )
        classic_destination = self.root / "classic"
        json_destination = self.root / "json"

        result = self.run_shoemaker(
            "dump", source, "--destination", classic_destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        classic = (classic_destination / "demo" / "greet.sh").read_text()
        self.assertIn("## @param <name> Name to greet", classic)
        self.assertNotIn("## {\n", classic)

        result = self.run_shoemaker(
            "dump", source, "--destination", json_destination, "--json"
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        converted = (json_destination / "demo" / "greet.sh").read_text()
        self.assertTrue(converted.startswith("#!/bin/sh\n\n## {\n"))
        self.assertIn('"namespace": "demo"', converted)
        self.assertIn('"summary": "Print a greeting"', converted)
        self.assertIn('"name": "name"', converted)
        self.assertNotIn("## @param", converted)

    def test_dump_organises_functions_by_namespace(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "src/shell/colors",\n'
            '##   "summary": "Print info"\n'
            "## }\n"
            "_echo_info() {\n"
            "    :\n"
            "}\n"
            "\n"
            "## {\n"
            '##   "namespace": "recipes/app",\n'
            '##   "summary": "Build the app"\n'
            "## }\n"
            "build_app() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(
            (destination / "src" / "shell" / "colors" / "_echo_info.sh")
            .is_file()
        )
        self.assertTrue(
            (destination / "recipes" / "app" / "build_app.sh").is_file()
        )
        self.assertEqual(
            (destination / "tool.shoe").read_text(),
            "#!/bin/sh\n"
            "\n"
            "src/shell/colors/_echo_info.sh\n"
            "\n"
            "recipes/app/build_app.sh\n",
        )

    def test_dump_ignores_heredoc_function_definitions(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "demo",\n'
            '##   "summary": "Install the sample"\n'
            "## }\n"
            "install() {\n"
            "    cat <<EOF\n"
            "test_can_fail() {\n"
            "    :\n"
            "}\n"
            "EOF\n"
            "}\n",
            encoding="utf-8",
        )
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue(
            (destination / "demo" / "install.sh").is_file()
        )
        self.assertFalse(
            (destination / "demo" / "test_can_fail.sh").exists()
        )

    def test_dump_keeps_unannotated_function_at_root(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "plain() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertTrue((destination / "plain.sh").is_file())

    def test_dump_rejects_escaping_namespace(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "../../escape",\n'
            '##   "summary": "Escape the destination"\n'
            "## }\n"
            "escape() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        destination = self.root / "nested" / "extracted"

        result = self.run_shoemaker(
            "dump", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("invalid namespace", result.stderr)
        self.assertTrue((destination / "escape.sh").is_file())
        self.assertEqual(
            (destination / "tool.shoe").read_text(),
            "#!/bin/sh\n\nescape.sh\n",
        )
        self.assertFalse((self.root / "escape.sh").exists())

    def test_build_command_assembles_components(self):
        recipe = self.root / "tool.shoe"
        recipe.write_text(
            "## Build fixture\n"
            "first.sh\n"
            "\n"
            "second.sh\n",
            encoding="utf-8",
        )
        (self.root / "first.sh").write_text(
            "#!/bin/sh\n\nfirst() {\n    :\n}\n\n\n",
            encoding="utf-8",
        )
        (self.root / "second.sh").write_text(
            "#!/bin/bash\nsecond() {\n    :\n}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("build", recipe, "--bash")

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertTrue(built.startswith("#!/usr/bin/env bash\n"))
        self.assertIn("first() {", built)
        self.assertIn("second() {", built)
        self.assertNotIn("#!/bin/sh", built)
        self.assertNotIn("#!/bin/bash", built)
        self.assertNotIn("\n\n\n", built)

    def test_build_command_orders_src_modules_and_puts_kernel_last(self):
        (self.root / "app.sh").write_text(
            "#!/bin/sh\napp() {\n    :\n}\n", encoding="utf-8"
        )
        modules = {
            "src/shell/zeta/_zeta.sh": ("src/shell/zeta", "_zeta"),
            "src/shell/alpha/_alpha.sh": ("src/shell/alpha", "_alpha"),
            "src/shell/kernel/_kernel.sh": ("src/shell/kernel", "_kernel"),
        }
        for relative, (namespace, name) in modules.items():
            path = self.root / relative
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(
                "#!/bin/sh\n"
                "## {\n"
                '##   "namespace": "%s"\n'
                "## }\n"
                "%s() {\n    :\n}\n" % (namespace, name),
                encoding="utf-8",
            )
        recipe = self.root / "tool.shoe"
        recipe.write_text(
            "src/shell/kernel/_kernel.sh\n"
            "src/shell/zeta/_zeta.sh\n"
            "app.sh\n"
            "src/shell/alpha/_alpha.sh\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        expected = ["app", "_alpha", "_zeta", "_kernel"]
        positions = [built.index("%s() {" % name) for name in expected]
        self.assertEqual(positions, sorted(positions))

    def test_build_command_converts_annotations_to_classic_tags(self):
        (self.root / "ns" / "greet.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Greeting",\n'
            '##   "requires": [\n'
            '##     "printf"\n'
            "##   ]\n"
            "## }\n"
            "greet() {\n"
            '    printf "Hello\\n"\n'
            "}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/greet.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertIn("## Greeting\n", built)
        self.assertIn("## @namespace ns\n", built)
        self.assertIn("## @requires printf\n", built)
        self.assertNotIn("## {", built)
        self.assertNotIn('"namespace"', built)

    def test_build_command_json_option_keeps_json_annotations(self):
        (self.root / "ns" / "greet.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Greeting"\n'
            "## }\n"
            "greet() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/greet.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe, "--json")

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertIn('##   "namespace": "ns"', built)
        self.assertIn('##   "summary": "Greeting"', built)
        self.assertNotIn("## @namespace", built)

    def test_build_command_converts_dependency_annotations_to_classic_tags(
        self,
    ):
        (self.root / "ns" / "helper.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Helper"\n'
            "## }\n"
            "helper() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "root.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Root",\n'
            '##   "depends": [\n'
            '##     "ns/helper"\n'
            "##   ]\n"
            "## }\n"
            "root() {\n"
            "    helper\n"
            "}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/root.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertIn("## Helper\n", built)
        self.assertIn("## @depends ns/helper\n", built)
        self.assertNotIn("## {", built)

    def test_build_command_defaults_to_bash_and_accepts_sh(self):
        recipe = self.root / "tool.shoe"
        recipe.write_text("first.sh\n", encoding="utf-8")
        (self.root / "first.sh").write_text(
            "#!/bin/sh\nfirst() {\n    :\n}\n", encoding="utf-8"
        )

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertTrue(built.startswith("#!/usr/bin/env bash\n"))

        result = self.run_shoemaker("build", recipe, "--sh")

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertTrue(built.startswith("#!/usr/bin/env sh\n"))

    def test_build_command_includes_transitive_depends(self):
        self.write_depends_fixture()
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/root.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        expected = ["_a", "_b", "_c", "_cycle", "root"]
        positions = [built.index(f"{name}() {{") for name in expected]
        self.assertEqual(positions, sorted(positions))
        for name in expected:
            self.assertEqual(built.count(f"{name}() {{"), 1)

    def test_build_command_warns_about_missing_dependency(self):
        self.write_depends_fixture()
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/root.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(
            'warning: dependency not found: "missing" '
            '(from "ns/root")', result.stderr)

    def test_build_command_ignores_overridden_dependency(self):
        (self.root / "src" / "core").mkdir(parents=True)
        (self.root / "src" / "core" / "_hook.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "src/core",\n'
            '##   "summary": "Core hook"\n'
            "## }\n"
            "_hook() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Override hook",\n'
            '##   "overrides": "src/core/_hook"\n'
            "## }\n"
            "_hook() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "consumer.sh").write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "summary": "Consumer",\n'
            '##   "depends": [\n'
            '##     "src/core/_hook"\n'
            "##   ]\n"
            "## }\n"
            "consumer() {\n    _hook\n}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text(
            "ns/consumer.sh\nns/override.sh\n", encoding="utf-8"
        )

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertEqual(built.count("_hook() {"), 1)
        self.assertNotIn("defined multiple times", result.stderr)

    def test_build_command_warns_about_duplicate_function(self):
        (self.root / "first.sh").write_text(
            "#!/bin/sh\n"
            "alpha() {\n    :\n}\n"
            "beta() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "second.sh").write_text(
            "#!/bin/sh\n"
            "alpha() {\n    :\n}\n"
            "beta() {\n    :\n}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("first.sh\nsecond.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(
            'warning: function "alpha" is defined multiple times: '
            '"first.sh:2", "second.sh:2"', result.stderr)
        self.assertIn(
            'warning: function "beta" is defined multiple times: '
            '"first.sh:5", "second.sh:5"', result.stderr)

    def test_build_command_warns_about_duplicate_transitive_function(self):
        (self.root / "ns" / "root.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "depends": [\n'
            '##     "ns/extra"\n'
            "##   ]\n"
            "## }\n"
            "_common() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "extra.sh").write_text(
            "#!/bin/sh\n_common() {\n    :\n}\n", encoding="utf-8"
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("ns/root.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(
            'warning: function "_common" is defined multiple times: '
            '"ns/extra.sh:2", "ns/root.sh:9"', result.stderr)

    def test_build_command_warns_about_function_defined_twice(self):
        (self.root / "first.sh").write_text(
            "#!/bin/sh\n"
            "alpha() {\n    :\n}\n"
            "alpha() {\n    :\n}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text("first.sh\n", encoding="utf-8")

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn(
            'warning: function "alpha" is defined multiple times: '
            '"first.sh:2", "first.sh:5"', result.stderr)

    def test_build_hello_recipe_includes_shoe_framework(self):
        destination = self.root / "build"

        result = self.run_shoemaker(
            "build", ROOT / "recipes" / "hello" / "hello.shoe",
            "--destination", destination,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (destination / "hello.sh").read_text()
        for name in ("_kernel", "_echo_error", "_help", "help"):
            self.assertIn(f"{name}() {{", built)
        execution = subprocess.run(
            ["sh", str(destination / "hello.sh"), "hello"],
            capture_output=True,
            text=True,
        )
        self.assertEqual(execution.returncode, 0, execution.stderr)
        self.assertEqual(execution.stdout, "Hello, World !\n")

    def test_build_agnostic_companion_honors_overrides(self):
        destination = self.root / "build"
        recipe = (
            ROOT / "recipes" / "agnostic-companion"
            / "agnostic-companion.shoe"
        )

        result = self.run_shoemaker(
            "build", recipe, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("defined multiple times", result.stderr)
        built = (destination / "agnostic-companion.sh").read_text()
        self.assertEqual(built.count("_before() {"), 1)

    def test_generate_doc_command_creates_destination_folder(self):
        source = self.write_documented_script()
        destination = self.root / "doc" / "nested"

        result = self.run_shoemaker(
            "generate_doc", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (destination / "tool.md").read_text()
        self.assertIn("Fixture Tool", documentation)
        self.assertIn("public_task", documentation)

    def test_generate_doc_command_honors_private_flag(self):
        source = self.write_documented_script()

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("Fixture Tool", documentation)
        self.assertIn("Run a public task", documentation)
        self.assertIn("public_task", documentation)
        self.assertIn("PUBLIC_CONSTANT", documentation)
        self.assertNotIn("_private_task", documentation)
        self.assertNotIn("_PRIVATE_CONSTANT", documentation)

        result = self.run_shoemaker("generate_doc", source, "--private")

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("_private_task", documentation)
        self.assertIn("_PRIVATE_CONSTANT", documentation)

    def test_generate_doc_reads_header_after_license_and_startup_code(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "set -e\n"
            "# This file is distributed under the MIT license.\n"
            "\n"
            "## TangoMan Tool\n"
            "##\n"
            "## A documented description.\n"
            "##\n"
            '## @author  "Tester" <tester@example.test>\n'
            "## @version 1.2.3\n"
            "## @link    https://example.test\n"
            "\n"
            "## {\n"
            '##   "namespace": "demo",\n'
            '##   "summary": "Run a task"\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertTrue(documentation.startswith("# TangoMan Tool\n"))
        self.assertNotIn("===", documentation)
        self.assertIn(
            '- author:  "Tester" <tester@example.test>', documentation
        )
        self.assertIn("- version:  1.2.3", documentation)
        self.assertIn("- link:  https://example.test", documentation)
        self.assertIn("A documented description.", documentation)
        self.assertIn("Run a task", documentation)

    def test_generate_doc_uses_section_dividers_as_headings(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## TangoMan Tool\n"
            "##\n"
            "## A documented description.\n"
            "\n"
            "##################################################\n"
            "### App\n"
            "##################################################\n"
            "\n"
            "## Serve the app\n"
            "##\n"
            '## @namespace recipes/tool/app\n'
            "serve() {\n"
            "    :\n"
            "}\n"
            "\n"
            "##################################################\n"
            "### Install\n"
            "##################################################\n"
            "\n"
            "## Install the app\n"
            "##\n"
            '## @namespace recipes/tool/install\n'
            "install() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("### ⚡ App", documentation)
        self.assertIn("### ⚡ Install", documentation)
        self.assertNotIn("RECIPES/TOOL/APP", documentation)
        self.assertNotIn("##########", documentation)
        self.assertIn("Serve the app", documentation)

    def test_generate_doc_renders_detailed_function_synopsis(self):
        source = self.root / "deploy.sh"
        source.write_text(
            "#!/bin/sh\n"
            "## {\n"
            '##   "summary": "Deploy Tool"\n'
            "## }\n"
            "\n"
            "## {\n"
            '##   "namespace": "demo",\n'
            '##   "summary": "Deploy the project",\n'
            '##   "requires": ["git", "rsync"],\n'
            '##   "depends": ["src/shell/system/_pwd"],\n'
            '##   "params": [\n'
            "##     {\n"
            '##       "position": 1,\n'
            '##       "name": "DESTINATION|TARGET",\n'
            '##       "summary": "Destination",\n'
            '##       "description": "Folder to write to.",\n'
            '##       "type": "folder",\n'
            '##       "constraint": "/^[a-z]+$/",\n'
            '##       "required": true\n'
            "##     },\n"
            "##     {\n"
            '##       "position": 2,\n'
            '##       "name": "COUNT",\n'
            '##       "description": "Number of runs.",\n'
            '##       "type": "int",\n'
            '##       "default": 3\n'
            "##     }\n"
            "##   ],\n"
            '##   "options": [\n'
            "##     {\n"
            '##       "name": "mode",\n'
            '##       "short": "m",\n'
            '##       "long": "mode",\n'
            '##       "summary": "Execution mode",\n'
            '##       "description": "Either fast or safe.",\n'
            '##       "type": "str",\n'
            '##       "constraint": "/^(fast|safe)$/",\n'
            '##       "default": "safe"\n'
            "##     }\n"
            "##   ],\n"
            '##   "flags": [\n'
            "##     {\n"
            '##       "name": "verbose",\n'
            '##       "short": "v",\n'
            '##       "long": "verbose",\n'
            '##       "description": "Print more details."\n'
            "##     }\n"
            "##   ]\n"
            "## }\n"
            "deploy() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "deploy.md").read_text()
        self.assertIn(
            "> `deploy <DESTINATION|TARGET> [COUNT] "
            "[-m|--mode VALUE] [-v|--verbose]`",
            documentation,
        )
        self.assertIn(
            "- `DESTINATION|TARGET`: _(type: \"folder\")_ Destination - "
            "Folder to write to. _Constraint: `/^[a-z]+$/`._",
            documentation,
        )
        self.assertIn(
            "- `COUNT`: _(type: \"int\")_ (optional) Number of runs. "
            '_Defaults to "3"._',
            documentation,
        )
        self.assertIn(
            "- `-m`, `--mode`: _(type: \"str\")_ Execution mode - Either "
            "fast or safe. _Constraint: `/^(fast|safe)$/`._ "
            '_Defaults to "safe"._',
            documentation,
        )
        self.assertIn(
            "- `-v`, `--verbose`: Print more details.", documentation
        )
        self.assertIn("- ⚠️ Requires: `git`, `rsync`", documentation)
        self.assertIn(
            "- 🔗 Depends: `src/shell/system/_pwd`", documentation
        )

    def test_generate_makefile_command_creates_public_targets(self):
        source = self.write_documented_script()

        result = self.run_shoemaker("generate_makefile", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        makefile = (self.root / "tool.makefile").read_text()
        self.assertIn(".PHONY: help public_task", makefile)
        self.assertIn("public_task:", makefile)
        self.assertIn(f"@sh {source} public_task", makefile)
        self.assertNotIn("_private_task:", makefile)
        result = subprocess.run(
            ["make", "-f", str(self.root / "tool.makefile"), "help"],
            cwd=self.root,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        result = subprocess.run(
            ["make", "-f", str(self.root / "tool.makefile"), "public_task"],
            cwd=self.root,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_generated_makefile_targets_run_from_sibling_folder(self):
        source = self.write_documented_script()
        destination = self.root / "doc" / "nested"

        result = self.run_shoemaker(
            "generate_makefile", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        result = subprocess.run(
            ["make", "-f", str(destination / "tool.makefile"),
             "public_task"],
            cwd=self.root,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
