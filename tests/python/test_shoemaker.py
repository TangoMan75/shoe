#!/usr/bin/env python3
"""Tests for shoemaker.py Shoedoc linting and classic annotations.

Run from the repository root: python3 tests/python/test_shoemaker.py
"""

import os
import pathlib
import subprocess
import sys
import tempfile
import unittest
from unittest import mock

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent.parent.parent))

import shoemaker


class CaptureAnnotationTest(unittest.TestCase):
    def test_annotation_run_captured_before_function(self):
        content = (
            "## Run following code before each execution\n"
            "##\n"
            "## @namespace ns\n"
            "foo() {\n"
        )
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(
            records,
            [shoemaker.AnnotationRecord(
                3,
                "foo",
                [0, 1, 2],
                ["## Run following code before each execution", "##",
                 "## @namespace ns"],
            )],
        )

    def test_annotation_after_blank_gap_is_still_captured(self):
        content = (
            "## @namespace ns\n"
            "## @requires echo\n"
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
            (3, "foo", [0, 1]),
        )

    def test_run_terminated_by_code_line(self):
        content = (
            "x=1\n"
            "## @namespace ns\n"
            "## @requires echo\n"
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
        content = "## @namespace ns\r\n## @requires echo\r\nfoo() {\r\n"
        records = shoemaker.ShoedocParser.capture_function_annotations(
            content.splitlines(keepends=True)
        )
        self.assertEqual(len(records), 1)
        self.assertEqual(len(records[0].lines), 2)


class FixPipelineTest(unittest.TestCase):
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
        for key in (
            "namespace", "requires", "params", "options", "flags",
            "stdout", "stderr", "stdin",
        ):
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

    def test_options_reject_required(self):
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

    def test_classic_lines_match_repo_style(self):
        lines = shoemaker.ShoedocSerializer().classic_lines({
            "namespace": "ns",
            "requires": ["awk"],
            "params": [{
                "position": 1,
                "name": "who",
                "type": "str",
                "description": "Who to greet.",
            }],
        })
        self.assertEqual(
            lines,
            [
                "## @namespace ns",
                "## @requires awk",
                "## @param {str} <who> Who to greet.",
            ],
        )


class AssumesAnalysisTest(unittest.TestCase):
    def setUp(self):
        self.analyzer = shoemaker.StaticAnalyzer(registry={})

    def test_variable_read_from_outer_scope_is_assumed(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'open() {\n'
                '    echo "https://${ALIAS}.localhost"\n'
                '}\n'
            ),
            {"ALIAS"},
        )
        self.assertEqual(
            self.analyzer.assumed_variables(
                'open() {\n'
                '    echo "https://$ALIAS.localhost"\n'
                '}\n'
            ),
            {"ALIAS"},
        )

    def test_assigned_variable_is_not_assumed(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'requirements() {\n'
                '    _error=0\n'
                '    return "${_error}"\n'
                '}\n'
            ),
            set(),
        )

    def test_read_before_assignment_is_assumed(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'own() {\n'
                '    if [ -z "${owner}" ]; then owner=nobody; fi\n'
                '    echo "${owner}"\n'
                '}\n'
            ),
            {"owner"},
        )

    def test_local_declaration_is_not_assumed(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'check() {\n'
                '    local loop=0\n'
                '    echo "${loop}"\n'
                '}\n'
            ),
            set(),
        )

    def test_nested_function_sees_late_local_declaration(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'pull() {\n'
                '    _inner() {\n'
                '        echo "${force}"\n'
                '    }\n'
                '    local force=false\n'
                '    _inner\n'
                '}\n'
            ),
            set(),
        )

    def test_top_level_definitions_are_not_assumed(self):
        lines = [
            '#!/bin/sh\n',
            'ALIAS="agnostic-companion"\n',
            '\n',
            'open() {\n',
            '    echo "${ALIAS}"\n',
            '}\n',
        ]
        self.assertEqual(
            self.analyzer.top_level_definitions(lines, 3),
            {"ALIAS"},
        )
        self.assertEqual(
            self.analyzer.missing_assumes(
                {}, "".join(lines[3:]), {"ALIAS"}
            ),
            set(),
        )

    def test_missing_assumes_reports_outer_variable(self):
        self.assertEqual(
            self.analyzer.missing_assumes(
                {"namespace": "ns"}, 'echo "${ALIAS}"\n'
            ),
            {"ALIAS"},
        )
        self.assertEqual(
            self.analyzer.missing_assumes(
                {"namespace": "ns", "assumes": ["ALIAS"]},
                'echo "${ALIAS}"\n',
            ),
            set(),
        )

    def test_unused_assumes_reports_entry_never_read(self):
        self.assertEqual(
            self.analyzer.unused_assumes(
                {"namespace": "ns", "assumes": ["ALIAS", "EXTRA"]},
                'echo "${ALIAS}"\n',
            ),
            {"EXTRA"},
        )

    def test_awk_variable_is_not_a_shell_variable(self):
        body = (
            'awk -v PRIMARY="${_PRIMARY}" '
            "'BEGIN{print PRIMARY}'\n"
        )
        self.assertEqual(
            self.analyzer.find_variable_references(body), {"_PRIMARY"}
        )
        self.assertEqual(
            self.analyzer.unused_assumes(
                {"namespace": "ns", "assumes": ["PRIMARY"]}, body
            ),
            {"PRIMARY"},
        )

    def test_arithmetic_variables_are_analyzed(self):
        self.assertEqual(
            self.analyzer.assumed_variables(
                'count() {\n    echo "$((count + 1))"\n}\n'
            ),
            {"count"},
        )
        self.assertEqual(
            self.analyzer.assumed_variables(
                'count() {\n'
                '    count=0\n'
                '    echo "$((count + 1))"\n'
                '}\n'
            ),
            set(),
        )


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
            "## @namespace ns\n"
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
        header = (
            "#!/bin/sh\n"
            "\n"
            "## Tool\n"
            "##\n"
            "## @author \"A\" <a@example.com>\n"
            "## @version 0.1.0\n"
            "\n"
            "## Run tool\n"
            "##\n"
            "## @namespace ns\n"
            "header() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "ns" / "valid.sh").write_text(valid)
        (self.root / "ns" / "bare.sh").write_text(bare)
        (self.root / "ns" / "header.sh").write_text(header)
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
        self.assertIn("missing 'namespace' property", result.stdout)

    def test_script_header_is_not_warned(self):
        result = self.run_shoemaker([])
        self.assertNotIn(
            "warning: " + str(self.root / "ns" / "header.sh") + ":",
            result.stdout,
        )

    def test_legacy_json_block_is_warned(self):
        (self.root / "ns" / "legacy.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Legacy\n"
            "##\n"
            "## {\n"
            '##   "namespace": "ns"\n'
            "## }\n"
            "legacy() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertIn(
            "legacy JSON shoedoc annotations are no longer supported",
            result.stdout,
        )


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
        self.assertIn("missing 'namespace' property", result.stdout)

    def test_fix_generates_namespace_and_depends(self):
        result = self.run_shoemaker(["--fix"])
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends src/x/_helper\n"
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
            "## Check the agent\n"
            "##\n"
            "## @namespace ns\n"
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
        self.assertIn("## @requires ssh-add\n", content)

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
            "## Create a backup folder\n"
            "##\n"
            "## @namespace ns\n"
            "## @requires mkdir\n"
            "backup() {\n"
            '    set -- "$(_pwd)/backups"\n'
            '    mkdir -p "$1"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker(["--fix"])

        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "backup.sh").read_text()
        self.assertIn("## @depends src/x/_pwd\n", content)

    def test_lint_reports_missing_recipe_dependency(self):
        (self.root / "recipes" / "app" / "install").mkdir(parents=True)
        (self.root / "recipes" / "other").mkdir(parents=True)
        (self.root / "recipes" / "app" / "install" /
         "requirements.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Check requirements\n"
            "##\n"
            "## @namespace recipes/app/install\n"
            "requirements() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "recipes" / "other" / "requirements.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Other requirements\n"
            "##\n"
            "## @namespace recipes/other\n"
            "requirements() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        (self.root / "recipes" / "app" / "_before.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Run before\n"
            "##\n"
            "## @namespace recipes/app\n"
            "## @depends src/x/_helper\n"
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
        self.assertIn("recipes/app/install/requirements", content)
        self.assertNotIn("recipes/other/requirements", content)

    def test_lint_reports_missing_assumes(self):
        (self.root / "ns" / "open.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Open the app\n"
            "##\n"
            "## @namespace ns\n"
            "open() {\n"
            '    echo "https://${ALIAS}.localhost"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            '\'assumes\' missing entry: "ALIAS"', result.stdout)

    def test_fix_adds_missing_assumes(self):
        path = self.root / "ns" / "open.sh"
        path.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Open the app\n"
            "##\n"
            "## @namespace ns\n"
            "open() {\n"
            '    echo "https://${ALIAS}.localhost"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker(["--fix"])

        self.assertEqual(result.returncode, 0, result.stdout)
        content = path.read_text()
        self.assertIn("## @assumes ALIAS\n", content)

    def test_lint_rejects_unused_assumes(self):
        (self.root / "ns" / "open.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Open the app\n"
            "##\n"
            "## @namespace ns\n"
            "## @assumes EXTRA\n"
            "open() {\n"
            '    echo "https://${ALIAS}.localhost"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'assumes' unused entry: 'EXTRA'", result.stdout)

    def test_lint_accepts_assigned_variable(self):
        (self.root / "ns" / "requirements.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Check requirements\n"
            "##\n"
            "## @namespace ns\n"
            "requirements() {\n"
            "    _error=0\n"
            '    return "${_error}"\n'
            "}\n"
            "\n"
        )

        result = self.run_shoemaker([])

        self.assertNotIn(
            "'assumes' missing entry: \"_error\"", result.stdout)

    def test_overrides_core_module_is_valid(self):
        (self.root / "recipes" / "r").mkdir(parents=True)
        (self.root / "recipes" / "r" / "_helper.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Replace the core helper\n"
            "##\n"
            "## @namespace recipes/r\n"
            "## @overrides src/x/_helper\n"
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
            "## Replace a helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @overrides src/x/_helper src/x/_other\n"
            "_helper() {\n"
            "    :\n"
            "}\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'overrides': not a valid relative path", result.stdout)

    def test_overrides_must_reference_a_core_module(self):
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Replace a helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @overrides ns/_helper\n"
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
            "## Replace a helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @overrides src/x/_missing\n"
            "_missing() {\n"
            "    :\n"
            "}\n"
        )

        result = self.run_shoemaker([])

        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn(
            "'overrides' file not found: 'src/x/_missing'.sh",
            result.stdout)

    def test_fix_orders_properties_canonically(self):
        (self.root / "ns" / "bare.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Stand alone\n"
            "##\n"
            "## @requires echo\n"
            "## @namespace ns\n"
            "bare() {\n"
            "    echo stand\n"
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
            "## Stand alone\n"
            "##\n"
            "## @namespace ns\n"
            "## @requires echo\n"
            "bare() {\n"
            "    echo stand\n"
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
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## Stand alone\n"
            "##\n"
            "## @namespace ns\n"
            "bare() {\n"
            "    :\n"
            "}\n"
            "\n"
        ))

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
        self.assertEqual(result.returncode, 0, result.stdout)
        content = (self.root / "ns" / "bare.sh").read_text()
        self.assertEqual(content, (
            "#!/bin/sh\n"
            "\n"
            "## Run helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @requires awk\n"
            "## @depends src/x/_helper\n"
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
        self.assertIn("## @depends src/x/_helper\n", content)

    def test_lint_tolerates_non_utf8_files(self):
        (self.root / "ns" / "greet.sh").write_bytes(
            b"Greet caf\xe9\n"
            b"## @namespace ns\n"
            b"greet() {\n"
            b"    :\n"
            b"}\n"
            b"\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 0, result.stdout)

    def test_script_block_cannot_own_namespace(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Tool\n"
            "##\n"
            "## @namespace ns\n"
            "\n"
            "## Run task\n"
            "##\n"
            "## @namespace ns\n"
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
            "## Tool\n"
            "##\n"
            "## @shell zsh\n"
            "\n"
            "## Run task\n"
            "##\n"
            "## @namespace ns\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        )
        result = self.run_shoemaker([])
        self.assertEqual(result.returncode, 1, result.stdout)
        self.assertIn("'shell' must be one of: sh, bash", result.stdout)
        self.assertNotIn(
            "public_task.sh:3: missing 'namespace'", result.stdout)

    def test_fix_orders_script_header_properties(self):
        (self.root / "ns" / "public_task.sh").write_text(
            "#!/bin/sh\n"
            "\n"
            "## Tool\n"
            "##\n"
            "## @version 1.0\n"
            "## @author \"A\" <a@example.com>\n"
            "\n"
            "## Run task\n"
            "##\n"
            "## @namespace ns\n"
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
            "## Tool\n"
            "##\n"
            "## @author \"A\" <a@example.com>\n"
            "## @version 1.0\n"
            "\n"
            "## Run task\n"
            "##\n"
            "## @namespace ns\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
        ))


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
            "## Tool\n"
            "##\n"
            "## @author Tester\n"
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
            "lint", "migrate", "dump", "tree", "build",
            "generate_doc", "generate_makefile", "completion",
        ):
            self.assertIn(command, result.stdout)
        for option in ("--verbose", "--quiet", "--log", "--completion"):
            self.assertIn(option, result.stdout)

    def test_help_lists_command_specific_options(self):
        result = self.run_shoemaker("--help")

        self.assertEqual(result.returncode, 0, result.stderr)
        for option in (
            "--fix", "--dry-run", "--file",
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
        result = self.run_shoemaker("migrate", "missing.sh", "--quiet")

        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_lint_subcommand_accepts_folder(self):
        source = (
            "## Check\n"
            "##\n"
            "## @namespace ns\n"
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
        depends = {
            "root": ["ns/_a", "ns/_cycle", "missing"],
            "_a": ["ns/_b", "ns/_c"],
            "_b": ["ns/_c"],
            "_c": [],
            "_cycle": ["ns/_cycle"],
        }
        for stem, entries in depends.items():
            lines = ["#!/bin/sh", "", "## %s" % stem, "##", "## @namespace ns"]
            if entries:
                lines.append("## @depends %s" % " ".join(entries))
            lines.extend(["%s() {" % stem, "    :", "}", ""])
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
            "## Fixture Tool\n"
            "##\n"
            "## A script for command tests.\n"
            "##\n"
            '## @author "Tester"\n'
            "## @version 1.0\n"
            "## @link https://example.test\n"
            "\n"
            "## A public constant.\n"
            'PUBLIC_CONSTANT="public"\n'
            "\n"
            "## A private constant.\n"
            '_PRIVATE_CONSTANT="private"\n'
            "\n"
            "## Run a public task\n"
            "##\n"
            "## @namespace demo\n"
            "## @param {str} <name> Name to run.\n"
            "public_task() {\n"
            "    :\n"
            "}\n"
            "\n"
            "## Run a private task\n"
            "##\n"
            "## @namespace demo\n"
            "## @private\n"
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
        self.assertTrue(
            public_dump.startswith("#!/bin/sh\n\n## Run a public task\n")
        )
        self.assertIn("## @namespace demo\n", public_dump)
        self.assertIn("public_task() {", public_dump)
        self.assertTrue((destination / "demo" / "_private_task.sh").is_file())
        self.assertEqual(
            (destination / "tool.shoe").read_text(),
            "#!/bin/sh\n"
            "## Fixture Tool\n"
            "##\n"
            "## A script for command tests.\n"
            "##\n"
            '## @author "Tester"\n'
            "## @version 1.0\n"
            "## @link https://example.test\n"
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

    def test_dump_organises_functions_by_namespace(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Print info\n"
            "##\n"
            "## @namespace src/shell/colors\n"
            "_echo_info() {\n"
            "    :\n"
            "}\n"
            "\n"
            "## Build the app\n"
            "##\n"
            "## @namespace recipes/app\n"
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
            "## Install the sample\n"
            "##\n"
            "## @namespace demo\n"
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
            "## Escape the destination\n"
            "##\n"
            "## @namespace ../../escape\n"
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
                "## %s\n"
                "##\n"
                "## @namespace %s\n"
                "%s() {\n    :\n}\n" % (name, namespace, name),
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

    def test_build_command_keeps_classic_tags(self):
        (self.root / "ns" / "greet.sh").write_text(
            "#!/bin/sh\n"
            "## Greeting\n"
            "##\n"
            "## @namespace ns\n"
            "## @requires printf\n"
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

    def test_build_command_keeps_dependency_annotations_classic(
        self,
    ):
        (self.root / "ns" / "helper.sh").write_text(
            "#!/bin/sh\n"
            "## Helper\n"
            "##\n"
            "## @namespace ns\n"
            "helper() {\n"
            "    :\n"
            "}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "root.sh").write_text(
            "#!/bin/sh\n"
            "## Root\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends ns/helper\n"
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

    def test_build_command_preserves_recipe_order_for_explicit_depends(
        self,
    ):
        (self.root / "ns" / "helper.sh").write_text(
            "#!/bin/sh\n"
            "## Helper\n"
            "##\n"
            "## @namespace ns\n"
            "helper() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "root.sh").write_text(
            "#!/bin/sh\n"
            "## Root\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends ns/helper\n"
            "root() {\n    helper\n}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text(
            "ns/root.sh\nns/helper.sh\n", encoding="utf-8"
        )

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        expected = ["root", "helper"]
        positions = [built.index(f"{name}() {{") for name in expected]
        self.assertEqual(positions, sorted(positions))
        self.assertEqual(built.count("helper() {"), 1)

    def test_build_command_defers_explicit_dependency_subtree(self):
        (self.root / "ns" / "deep.sh").write_text(
            "#!/bin/sh\n"
            "## Deep\n"
            "##\n"
            "## @namespace ns\n"
            "deep() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "helper.sh").write_text(
            "#!/bin/sh\n"
            "## Helper\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends ns/deep\n"
            "helper() {\n    deep\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "root.sh").write_text(
            "#!/bin/sh\n"
            "## Root\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends ns/helper\n"
            "root() {\n    helper\n}\n",
            encoding="utf-8",
        )
        recipe = self.root / "tool.shoe"
        recipe.write_text(
            "ns/root.sh\nns/helper.sh\n", encoding="utf-8"
        )

        result = self.run_shoemaker("build", recipe)

        self.assertEqual(result.returncode, 0, result.stderr)
        built = (self.root / "build" / "tool.sh").read_text()
        expected = ["root", "deep", "helper"]
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
            "## Core hook\n"
            "##\n"
            "## @namespace src/core\n"
            "_hook() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "override.sh").write_text(
            "#!/bin/sh\n"
            "## Override hook\n"
            "##\n"
            "## @namespace ns\n"
            "## @overrides src/core/_hook\n"
            "_hook() {\n    :\n}\n",
            encoding="utf-8",
        )
        (self.root / "ns" / "consumer.sh").write_text(
            "#!/bin/sh\n"
            "## Consumer\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends src/core/_hook\n"
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
            "## Root\n"
            "##\n"
            "## @namespace ns\n"
            "## @depends ns/extra\n"
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
            '"ns/extra.sh:2", "ns/root.sh:7"', result.stderr)

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

    def test_generate_doc_parses_extended_assignment_annotations(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Tool\n"
            "\n"
            "## Script alias\n"
            "##\n"
            "## Used to execute the script.\n"
            "##\n"
            "## @type str\n"
            'SCRIPT_ALIAS="tool"\n'
            "\n"
            "## Default recipient name\n"
            "##\n"
            "## The name to greet.\n"
            "##\n"
            "## @type str\n"
            "## @constraint /^[a-zA-Z-]+$/\n"
            'default_name="World"\n'
            "\n"
            "## Print additional details\n"
            "##\n"
            "## @deprecated Use --trace instead.\n"
            "verbose=false\n",
            encoding="utf-8",
        )

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("Script alias", documentation)
        self.assertIn("Used to execute the script.", documentation)
        self.assertIn("Default recipient name", documentation)
        self.assertIn("The name to greet.", documentation)
        self.assertIn("Constraint: `/^[a-zA-Z-]+$/`", documentation)
        self.assertIn("Deprecated: Use --trace instead.", documentation)
        self.assertNotIn("@type", documentation)
        self.assertNotIn("@constraint", documentation)

    def test_generate_doc_parses_classic_assignment_entry_tags(self):
        source = self.root / "tool.sh"
        source.write_text(
            "#!/bin/sh\n"
            "\n"
            "## Tool\n"
            "\n"
            "## @constant {str} Script alias - Used to execute the script.\n"
            'SCRIPT_ALIAS="tool"\n'
            "\n"
            "## @variable {str} /^[a-zA-Z-]+$/ Recipient name - The name "
            "to greet.\n"
            'who="World"\n',
            encoding="utf-8",
        )

        result = self.run_shoemaker("generate_doc", source)

        self.assertEqual(result.returncode, 0, result.stderr)
        documentation = (self.root / "tool.md").read_text()
        self.assertIn("Script alias", documentation)
        self.assertIn("Used to execute the script.", documentation)
        self.assertIn("Recipient name", documentation)
        self.assertIn("The name to greet.", documentation)
        self.assertIn("Constraint: `/^[a-zA-Z-]+$/`", documentation)
        self.assertNotIn("@constant", documentation)
        self.assertNotIn("@variable", documentation)

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
            "## Run a task\n"
            "##\n"
            "## @namespace demo\n"
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
            "## Deploy Tool\n"
            "\n"
            "## Deploy the project\n"
            "##\n"
            "## @namespace demo\n"
            "## @requires git rsync\n"
            "## @depends src/shell/system/_pwd\n"
            "## @param {folder} <DESTINATION|TARGET> /^[a-z]+$/ (required) Destination - Folder to write to.\n"
            "## @param {int} <COUNT> (default:3) Number of runs.\n"
            "## @option {str} <mode> [-m|--mode] /^(fast|safe)$/ (default:\"safe\") Execution mode - Either fast or safe.\n"
            "## @flag <verbose> [-v|--verbose] Print more details.\n"
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
        self.assertIn("@sh tool.sh public_task", makefile)
        self.assertNotIn(str(source), makefile)
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
        makefile = (destination / "tool.makefile").read_text()
        self.assertIn("@sh ../../tool.sh public_task", makefile)
        result = subprocess.run(
            ["make", "-f", "tool.makefile", "public_task"],
            cwd=destination,
            capture_output=True,
            text=True,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
