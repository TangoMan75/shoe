#!/usr/bin/env python3
"""Tests for the standalone Shoedoc converter.

Run from the repository root: python3 tests/python/test_converter.py
"""

import pathlib
import subprocess
import sys
import tempfile
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[2]
CONVERTER = ROOT / "converter.py"

sys.path.insert(0, str(ROOT))

from converter import ShoedocConverter


CLASSIC = (
    "## Greeting\n"
    "##\n"
    "## Greets a user.\n"
    "##\n"
    "## @namespace ns\n"
    "## @param {str} <who> Recipient.\n"
    "greet() {\n"
    "    :\n"
    "}\n"
)

JSON = (
    "## {\n"
    '##   "namespace": "ns",\n'
    '##   "summary": "Greeting",\n'
    '##   "params": [\n'
    "##     {\n"
    '##       "position": 1,\n'
    '##       "name": "who",\n'
    '##       "description": "Recipient.",\n'
    '##       "type": "str"\n'
    "##     }\n"
    "##   ]\n"
    "## }\n"
)


class ConverterApiTest(unittest.TestCase):
    def test_classic_annotation_converts_to_json(self):
        content, count, had_error = ShoedocConverter().convert_content(
            CLASSIC, "json"
        )

        self.assertEqual((count, had_error), (1, False))
        self.assertIn('"summary": "Greeting"', content)
        self.assertIn('"name": "who"', content)
        self.assertNotIn("## @param", content)

    def test_json_annotation_converts_to_classic(self):
        content, count, had_error = ShoedocConverter().convert_content(
            JSON, "tags"
        )

        self.assertEqual((count, had_error), (1, False))
        self.assertIn("## Greeting", content)
        self.assertIn("## @param {str} <who> Recipient.", content)
        self.assertNotIn('## "', content)

    def test_converter_does_not_import_shoemaker(self):
        result = subprocess.run(
            [
                sys.executable,
                "-c",
                "import converter, sys; "
                "print('shoemaker' in sys.modules)",
            ],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.strip(), "False")


class ConverterCliTest(unittest.TestCase):
    def setUp(self):
        self.temporary_directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary_directory.cleanup)
        self.root = pathlib.Path(self.temporary_directory.name)
        (self.root / "ns").mkdir()

    def run_converter(self, *arguments):
        return subprocess.run(
            [sys.executable, str(CONVERTER), *map(str, arguments)],
            cwd=self.root,
            capture_output=True,
            text=True,
        )

    def write_script(self, source, name="greet.sh"):
        path = self.root / "ns" / name
        path.write_text(source, encoding="utf-8")
        return path

    def test_help_lists_both_directions(self):
        result = self.run_converter("--help")

        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIn("--json", result.stdout)
        self.assertIn("--tags", result.stdout)
        self.assertIn("--dry-run", result.stdout)

    def test_cli_converts_classic_annotation_to_json(self):
        path = self.write_script(CLASSIC)

        result = self.run_converter("--json", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Converted: %s (1 block(s))" % path, result.stderr)
        self.assertIn('"summary": "Greeting"', path.read_text())

    def test_cli_defaults_to_classic_tags(self):
        path = self.write_script(JSON)

        result = self.run_converter(path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("## Greeting", path.read_text())
        self.assertIn("## @param {str} <who> Recipient.", path.read_text())

    def test_cli_dry_run_leaves_file_unchanged(self):
        path = self.write_script(CLASSIC)

        result = self.run_converter("--json", "--dry-run", path)

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("==> %s <==" % path, result.stdout)
        self.assertIn('"summary": "Greeting"', result.stdout)
        self.assertEqual(path.read_text(), CLASSIC)

    def test_cli_converts_every_script_in_a_directory(self):
        self.write_script(CLASSIC, "first.sh")
        self.write_script(CLASSIC, "second.sh")
        (self.root / "ns" / "notes.txt").write_text(CLASSIC)

        result = self.run_converter("--json", self.root / "ns")

        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        converted = sorted(
            path.name for path in (self.root / "ns").glob("*.sh")
            if '"summary": "Greeting"' in path.read_text()
        )
        self.assertEqual(converted, ["first.sh", "second.sh"])

    def test_cli_rejects_non_shell_file(self):
        path = self.root / "ns" / "notes.txt"
        path.write_text(CLASSIC)

        result = self.run_converter(path)

        self.assertEqual(result.returncode, 1)
        self.assertIn("expected a .sh file", result.stderr)


if __name__ == "__main__":
    unittest.main()
