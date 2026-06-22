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

    @staticmethod
    def migrate(parsed):
        fixes = []
        return shoemaker.ShoedocMigrator().migrate_legacy_properties(parsed, fixes), fixes

    def test_legacy_parameters_migrated_to_params(self):
        fixed, fixes = self.migrate({
            "namespace": "ns",
            "parameters": [{
                "position": 1,
                "name": "who",
                "type": "str",
                "description": "Name.",
                "nullable": False,
            }],
        })
        self.assertEqual(fixed["params"], [
            {
                "position": 1,
                "name": "who",
                "type": "str",
                "description": "Name.",
            },
        ])
        self.assertNotIn("parameters", fixed)
        self.assertNotIn("nullable", fixed["params"][0])
        self.assertIn("migrated legacy 'parameters' property", fixes)
        errors, _ = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_required_legacy_parameter_drops_null_default(self):
        fixed, fixes = self.migrate({
            "namespace": "ns",
            "parameters": [{
                "position": 1,
                "name": "arguments",
                "type": "str",
                "description": "Arguments string.",
                "nullable": False,
                "default": None,
                "required": True,
            }],
        })
        self.assertEqual(fixed["params"], [{
            "position": 1,
            "name": "arguments",
            "type": "str",
            "description": "Arguments string.",
            "required": True,
        }])
        self.assertIn(
            "removed null 'default' from required legacy parameter", fixes
        )
        errors, _warnings = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_legacy_flagged_entries_split_into_options_and_flags(self):
        fixed, _fixes = self.migrate({
            "namespace": "ns",
            "parameters": [
                {
                    "name": "all",
                    "flag": "-a",
                    "type": "bool",
                    "description": "All.",
                    "default": False,
                },
                {
                    "name": "count",
                    "flag": "-c",
                    "type": "int",
                    "default": 1,
                },
            ],
        })
        self.assertEqual(fixed["flags"], [
            {"name": "all", "short": "a", "description": "All."},
        ])
        self.assertEqual(fixed["options"], [
            {"name": "count", "short": "c", "type": "int", "default": 1},
        ])
        errors, _ = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_flag_typed_params_moved_to_flags(self):
        fixed, fixes = self.migrate({
            "namespace": "ns",
            "params": [
                {
                    "position": 1,
                    "name": "VERBOSE",
                    "type": "flag",
                    "description": "Print the command.",
                    "required": True,
                },
                {
                    "position": 2,
                    "name": "HELP",
                    "type": "flag",
                    "description": "Display help.",
                    "required": True,
                },
                {
                    "position": 3,
                    "name": "target",
                    "type": "str",
                },
            ],
        })
        self.assertEqual(fixed["params"], [{
            "position": 1,
            "name": "target",
            "type": "str",
        }])
        self.assertEqual(fixed["flags"], [
            {
                "name": "VERBOSE",
                "description": "Print the command.",
            },
            {
                "name": "HELP",
                "description": "Display help.",
            },
        ])
        self.assertIn("moved 'params' entries typed 'flag' to 'flags'", fixes)
        self.assertIn("renumbered 'position' fields", fixes)
        errors, _warnings = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_flag_typed_legacy_parameters_moved_to_flags(self):
        fixed, fixes = self.migrate({
            "namespace": "ns",
            "parameters": [{
                "position": 1,
                "name": "VERBOSE",
                "type": "flag",
                "required": True,
            }],
        })
        self.assertNotIn("params", fixed)
        self.assertEqual(fixed["flags"], [{"name": "VERBOSE"}])
        self.assertIn("moved 'params' entries typed 'flag' to 'flags'", fixes)
        errors, _warnings = self.validate(fixed)
        self.assertEqual(errors, [])

    def test_legacy_long_flag_and_default_true_stay_options(self):
        fixed, _fixes = self.migrate({
            "namespace": "ns",
            "parameters": [
                {"name": "dest", "flag": "--destination", "type": "str"},
                {
                    "name": "verbose",
                    "flag": "-v",
                    "type": "bool",
                    "default": True,
                },
            ],
        })
        self.assertNotIn("params", fixed)
        self.assertEqual(fixed["options"], [
            {"name": "dest", "long": "destination", "type": "str"},
            {"name": "verbose", "short": "v", "type": "bool",
             "default": True},
        ])

    def test_legacy_removed_properties_dropped(self):
        fixed, fixes = self.migrate({
            "namespace": "ns",
            "returns": "str",
            "return": "int",
            "arguments": "1",
        })
        self.assertEqual(fixed, {"namespace": "ns"})
        self.assertIn("removed legacy 'returns' property", fixes)
        self.assertIn("removed legacy 'return' property", fixes)
        self.assertIn("removed legacy 'arguments' property", fixes)

    def test_migration_merges_into_existing_arrays(self):
        fixed, _fixes = self.migrate({
            "namespace": "ns",
            "parameters": [
                {"name": "force", "flag": "-f", "type": "bool"},
            ],
            "flags": [
                {"name": "quiet", "short": "q", "long": "quiet"},
            ],
        })
        self.assertEqual(fixed["flags"], [
            {"name": "quiet", "short": "q", "long": "quiet"},
            {"name": "force", "short": "f"},
        ])

    def test_migration_is_noop_on_current_vocabulary(self):
        parsed = {"namespace": "ns", "params": [{"name": "x"}]}
        fixed, fixes = self.migrate(parsed)
        self.assertEqual(fixed, parsed)
        self.assertEqual(fixes, [])

    def test_legacy_positional_aliases_are_preserved(self):
        fixed, _fixes = self.migrate({
            "namespace": "ns",
            "parameters": [{"name": "CONTAINER_NAME|CONTAINER_ID"}],
        })
        self.assertEqual(
            fixed["params"][0]["name"], "CONTAINER_NAME|CONTAINER_ID"
        )

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
            for type_value in shoemaker.TYPE_VALUES:
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
                f"{', '.join(shoemaker.TYPE_VALUES)})", errors,
            )

    def test_top_level_type_must_be_recognized(self):
        errors, _ = self.validate({"namespace": "ns", "type": "str"})
        self.assertEqual(errors, [])

        errors, _ = self.validate({"namespace": "ns", "type": "dir"})
        self.assertIn(
            f"test: 'type' must be one of: {', '.join(shoemaker.TYPE_VALUES)}",
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

    def test_legacy_link_property_is_migrated(self):
        fixed, fixes = self.migrate({"namespace": "ns", "link": "https://a.test"})
        self.assertEqual(fixed["links"], ["https://a.test"])
        self.assertIn("migrated legacy 'link' property", fixes)
        errors, _ = self.validate(fixed)
        self.assertEqual(errors, [])

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
        )
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "bare() {\n"
            "    _helper\n"
            "}\n"
        )

    def run_shoemaker(self, arguments, folder=None):
        return subprocess.run(
            [sys.executable, str(self._repository / "shoemaker.py"),
             "lint", str(folder or self.root), *arguments],
            cwd=self.root, capture_output=True, text=True)

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
        ))

    def test_fixed_file_is_clean_on_re_run(self):
        self.run_shoemaker(["--fix"])
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)
        self.assertNotIn("warning:", result.stdout)

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
        ))

    def test_fix_without_calls_generates_namespace_only(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Stand alone\n"
            "bare() {\n"
            "    :\n"
            "}\n"
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
        (self.root / "ns" / "latin1.sh").write_bytes(
            b"Greet caf\xe9\n"
            b"## {\n"
            b'##   "namespace": "ns"\n'
            b"}\n"
            b"greet() {\n"
            b"    :\n"
            b"}\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)

    def test_adjacent_script_header_and_function_block_lint_clean(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_script_header_without_blank_line_lints_clean(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertNotIn("error:", result.stdout)

    def test_script_block_cannot_own_namespace(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "script block cannot own a 'namespace' property", result.stdout)

    def test_script_header_is_linted(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'version' must be a string", result.stdout)
        self.assertNotIn("missing 'namespace'", result.stdout)

    def test_fix_orders_script_header_properties(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        self.assertIn("ordered properties", result.stdout)
        content = (self.root / "ns" / "tool.sh").read_text()
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
        ))

    def test_fix_folds_script_header_bare_summary(self):
        (self.root / "ns" / "tool.sh").write_text(
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
        )
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "tool.sh").read_text()
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
            "lint", "migrate", "convert", "dump", "list", "build",
            "generate_doc", "generate_makefile", "completion",
        ):
            self.assertIn(command, result.stdout)
        for option in ("--verbose", "--quiet", "--log", "--completion"):
            self.assertIn(option, result.stdout)

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
        result = self.run_shoemaker("migrate", "missing.sh", "--quiet")

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
        )
        (self.root / "ns" / "valid.sh").write_text(source)

        result = self.run_shoemaker("lint", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("1 block(s) checked, no error", result.stdout)

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

    def write_legacy_script(self):
        path = self.root / "ns" / "legacy.sh"
        path.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Legacy required argument\n"
            "##\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "parameters": [{\n'
            '##     "position": 1,\n'
            '##     "name": "arguments",\n'
            '##     "type": "str",\n'
            '##     "description": "Arguments string.",\n'
            '##     "nullable": false,\n'
            '##     "default": null,\n'
            '##     "required": true\n'
            "##   }]\n"
            "## }\n"
            "legacy() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        return path

    def test_migrate_dry_run_previews_without_writing(self):
        source = self.write_legacy_script()
        original = source.read_text()

        result = self.run_shoemaker("migrate", "--dry-run", source)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Would migrate 1 Shoedoc block(s)", result.stdout)
        self.assertIn('"params"', result.stdout)
        self.assertEqual(source.read_text(), original)

    def test_migrate_command_rewrites_legacy_parameters(self):
        source = self.write_legacy_script()

        result = self.run_shoemaker("migrate", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Migrated 1 Shoedoc block(s)", result.stdout)
        content = source.read_text()
        self.assertNotIn('"parameters"', content)
        self.assertNotIn('"nullable"', content)
        self.assertNotIn('"default": null', content)
        self.assertIn('"params"', content)
        self.assertIn('"required": true', content)

        rerun = self.run_shoemaker("migrate", source)
        self.assertEqual(rerun.returncode, 0, rerun.stdout + rerun.stderr)
        self.assertIn("No legacy Shoedoc blocks found", rerun.stdout)

    def test_migrate_command_rewrites_legacy_script_header(self):
        source = self.root / "ns" / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Fixture Tool\n"
            "##\n"
            "## {\n"
            '##   "name": "tool",\n'
            '##   "summary": "Tool",\n'
            '##   "link": "https://example.test",\n'
            '##   "parameters": []\n'
            "## }\n"
            "public_task() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("migrate", source)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        content = source.read_text()
        self.assertNotIn('"link"', content)
        self.assertNotIn('"parameters"', content)
        self.assertIn('"links"', content)
        self.assertIn('"https://example.test"', content)

    def test_migrate_skips_non_shell_files_in_directory(self):
        destination = self.root / "mixed"
        destination.mkdir()
        (destination / "README.md").write_text("# readme\n")
        legacy = destination / "legacy.sh"
        legacy.write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "parameters": [\n'
            '##     {"position": 1, "name": "who", "nullable": false}\n'
            "##   ]\n"
            "## }\n"
            "legacy() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("migrate", destination)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertNotIn("expected a .sh file", result.stderr)
        self.assertIn('"params"', legacy.read_text())

    def test_migrate_command_moves_flag_typed_params(self):
        source = self.root / "ns" / "flags.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## {\n"
            '##   "namespace": "ns",\n'
            '##   "params": [\n'
            "##     {\n"
            '##       "position": 1,\n'
            '##       "name": "VERBOSE",\n'
            '##       "type": "flag",\n'
            '##       "description": "Print the command.",\n'
            '##       "required": true\n'
            "##     }\n"
            "##   ]\n"
            "## }\n"
            "flags() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("migrate", source)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        content = source.read_text()
        self.assertNotIn('"params"', content)
        self.assertNotIn('"type": "flag"', content)
        self.assertIn('"flags"', content)
        self.assertIn('"name": "VERBOSE"', content)
        self.assertNotIn('"required"', content)
        self.assertNotIn('"position"', content)

    def test_dump_and_list_commands(self):
        source = self.write_documented_script()
        destination = self.root / "extracted"

        result = self.run_shoemaker(
            "dump", "--file", source, "--destination", destination
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        public_dump = (destination / "public_task.sh").read_text()
        self.assertTrue(public_dump.startswith("#!/bin/sh\n\n## {\n"))
        self.assertIn("public_task() {", public_dump)
        self.assertTrue((destination / "_private_task.sh").is_file())

        result = self.run_shoemaker("list", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        listing = self.root / "dump" / "tool" / "tool.shoe"
        self.assertEqual(
            listing.read_text(), "public_task.sh\n_private_task.sh\n"
        )

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

        result = self.run_shoemaker("build", recipe, "--type", "bash")

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        self.assertTrue(built.startswith("#!/usr/bin/env bash\n"))
        self.assertIn("first() {", built)
        self.assertIn("second() {", built)
        self.assertNotIn("#!/bin/sh", built)
        self.assertNotIn("#!/bin/bash", built)
        self.assertNotIn("\n\n\n", built)

    def test_generate_doc_command_honors_private_flag(self):
        source = self.write_documented_script()

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("Fixture Tool", documentation)
        self.assertIn("Run a public task", documentation)
        self.assertIn("public_task", documentation)
        self.assertNotIn("_private_task", documentation)

        result = self.run_shoemaker("generate_doc", source, "--private")

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("_private_task", documentation)

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
        destination = self.root / "doc"
        destination.mkdir()

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
