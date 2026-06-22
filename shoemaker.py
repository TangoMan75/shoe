#!/usr/bin/env python3
"""
shoemaker
"""

import argparse
import contextlib
import datetime
import difflib
import io
import json
import os
import re
import shlex
import shutil
import sys
from collections import namedtuple
from pathlib import Path

REL_PATH_RE = re.compile(r"^(?!/|\\|\./|\.\./)([a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?/)*[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?$")
VAR_NAME_RE = re.compile(r"^[a-zA-Z_][a-zA-Z0-9_]*$")
PARAM_NAME_RE = re.compile(
    r"^[a-zA-Z_][a-zA-Z0-9_]*(?:\|[a-zA-Z_][a-zA-Z0-9_]*)*$"
)
CONSTANT_RE = re.compile(r"^_{0,2}[A-Z0-9]+(?:_[A-Z0-9]+)*_{0,2}$")
GROUP_COMMAND_RE = re.compile(r"^[a-zA-Z0-9_][a-zA-Z0-9_./+-]*( [a-zA-Z0-9_.+-]+)?$")
COMMAND_RE = re.compile(r"^[a-zA-Z0-9_][a-zA-Z0-9_.+-]*$")
CONSTRAINT_RE = re.compile(r"^/.*/[a-z]*$")
SHORT_RE = re.compile(r"^[a-zA-Z0-9]$")
LONG_RE = re.compile(r"^[a-zA-Z0-9][a-zA-Z0-9-]*$")

FUNCTION_RE = re.compile(
    r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)\s*\{"
)
# a call: identifier followed by a space, or by '(' (subshell / command
# substitution), preceded by anything that is not a word character, not part
# of a variable/option: excludes "$name", "-name", "name=value"...
CALL_RE = re.compile(
    r"(?<![\w.$/-])([a-zA-Z_][a-zA-Z0-9_]*)(?=\s|[|;&]|$|\()"
)
SANITIZE_DEPTH_LIMIT = 200
ARRAY_KEYS = ("requires", "depends", "assumes")

# Recognized values for the "type" property.
TYPE_VALUES = (
    "str", "int", "number", "bool", "array", "url", "path", "file",
    "folder", "json", "regex",
)

# Top-level string properties, validated as non-empty strings.
STRING_PROPERTIES = (
    "name", "description", "copyright", "version", "license", "update",
    "deprecated", "type", "stdout", "stderr", "stdin",
)

# Top-level entry-array properties. Each array carries its own object
# shape (see check_entry_array).
ENTRY_ARRAY_KEYS = ("constants", "variables", "params", "options", "flags")

# Allowed fields per entry-array property. Only constants and variables
# entries may carry "deprecated": deprecation is a function / constant /
# variable concern. Options are addressed by name and cannot be
# "required": a missing option falls back to its "default" value.
ENTRY_FIELDS = {
    "params": (
        "position", "name", "summary", "description", "type", "constraint",
        "required", "default",
    ),
    "options": (
        "name", "summary", "description", "type", "constraint",
        "short", "long", "default",
    ),
    "flags": (
        "name", "summary", "description", "short", "long",
    ),
    "constants": (
        "name", "summary", "description", "private", "type", "deprecated",
    ),
    "variables": (
        "name", "summary", "description", "private", "type", "constraint",
        "deprecated",
    ),
}

# Value-carrying fields that a flag must not own.
FLAG_VALUE_FIELDS = ("position", "type", "constraint", "required", "default")

# Fields an entry-array property must never carry, per key. A flag owns
# no value fields; an option cannot be "required".
FORBIDDEN_ENTRY_FIELDS = {
    "options": ("required",),
    "flags": FLAG_VALUE_FIELDS,
}

# Properties a script-level block cannot own: namespace, requires and
# the std streams are function concerns.
SCRIPT_FORBIDDEN_PROPERTIES = ("namespace", "requires", "stdout", "stderr",
                               "stdin")

# Legacy (previous-revision) properties handled by ShoedocMigrator; see
# VOCABULARY.md. The "parameters" array is split into "params", "options"
# and "flags"; "arguments", "return" and "returns" are dropped; the
# "nullable" entry field is dropped.
LEGACY_ENTRY_ARRAY_KEY = "parameters"
LEGACY_DROPPED_PROPERTIES = ("arguments", "return", "returns")
LEGACY_DROPPED_ENTRY_FIELDS = ("nullable",)


AnnotationRecord = namedtuple(
    "AnnotationRecord",
    ["function_line_index", "function_name", "line_indexes", "lines"],
)


#--------------------------------------------------
class ShoedocValidator:
    """Validate single shoedoc properties against the vocabulary."""

    @staticmethod
    def validate_rel_path(value, key):
        """Return the list of error strings for a relative-path property."""
        if not value:
            return [f"{key} must not be empty"]
        if not REL_PATH_RE.match(value):
            return [f"not a valid relative path: {value!r}"]
        return []

    @staticmethod
    def check_entry_array(value, key, errors):
        """Check a constants/variables/params/options/flags array against
        the field set allowed for that array (see ENTRY_FIELDS)."""
        if not isinstance(value, list):
            errors.append(f"'{key}' must be an array of objects")
            return
        if not value:
            errors.append(f"'{key}' must not be empty")
            return
        allowed = set(ENTRY_FIELDS[key])
        for index, entry in enumerate(value):
            if not isinstance(entry, dict):
                errors.append(f"'{key}' must contain objects")
                continue
            name = entry.get("name")
            if name is None and key not in ("constants", "variables"):
                errors.append(
                    f"{key}: {json.dumps(entry)}: missing 'name'"
                )
            elif name is not None and (
                not isinstance(name, str) or not (
                    PARAM_NAME_RE if key == "params" else VAR_NAME_RE
                ).match(name)
            ):
                errors.append(f"{key}: invalid 'name': {name!r}")
            position = entry.get("position")
            if position is not None and (
                not isinstance(position, int) or isinstance(position, bool)
                or position < 1
            ):
                errors.append(f"{key}: 'position' must be a positive integer")
            elif (
                key == "params" and position is not None
                and position != index + 1
            ):
                errors.append(
                    f"{key}: 'position' must match the entry's rank in the "
                    f"array: {position!r}"
                )
            summary = entry.get("summary")
            if summary is not None and not isinstance(summary, str):
                errors.append(f"{key}: 'summary' must be a string")
            description = entry.get("description")
            if description is not None and not isinstance(description, str):
                errors.append(f"{key}: 'description' must be a string")
            type_ = entry.get("type")
            if type_ is not None:
                if not isinstance(type_, str) or not type_.strip():
                    errors.append(f"{key}: 'type' must be a non-empty string")
                elif type_ == "flag" and key != "flags":
                    errors.append(
                        f"{key}: 'flag' is not a valid 'type' (declare flags "
                        f"in the 'flags' array)"
                    )
                elif key != "flags" and type_ not in TYPE_VALUES:
                    errors.append(
                        f"{key}: invalid 'type': {type_!r} (expected one of: "
                        f"{', '.join(TYPE_VALUES)})"
                    )
            constraint = entry.get("constraint")
            if constraint is not None:
                if not isinstance(constraint, str):
                    errors.append(f"{key}: 'constraint' must be a string")
                elif not CONSTRAINT_RE.match(constraint):
                    errors.append(
                        f"{key}: invalid 'constraint': {constraint!r} "
                        f"(expected '/regex/flags')"
                    )
            short = entry.get("short")
            if short is not None and (
                not isinstance(short, str) or not SHORT_RE.match(short)
            ):
                errors.append(f"{key}: invalid 'short': {short!r} (expected a "
                              f"single character without dash)")
            long_ = entry.get("long")
            if long_ is not None and (
                not isinstance(long_, str) or not LONG_RE.match(long_)
            ):
                errors.append(f"{key}: invalid 'long': {long_!r} (expected a "
                              f"name without dash)")
            required = entry.get("required")
            if required is not None and not isinstance(required, bool):
                errors.append(f"{key}: 'required' must be a boolean")
            if "default" in entry and not isinstance(
                entry["default"], (str, int, float, bool, type(None))
            ):
                errors.append(f"{key}: 'default' must be a scalar or null")
            if key == "constants":
                deprecated = entry.get("deprecated")
                if deprecated is not None and (
                    not isinstance(deprecated, str) or not deprecated.strip()
                ):
                    errors.append(
                        f"{key}: 'deprecated' must be a non-empty string"
                    )
            private = entry.get("private")
            if private is not None and not isinstance(private, bool):
                errors.append(f"{key}: 'private' must be a boolean")
            if required is True and "default" in entry:
                errors.append(
                    f"{key}: 'required' entries cannot own a 'default' value"
                )
            forbidden = set()
            if key in FORBIDDEN_ENTRY_FIELDS:
                subject = {"options": "an option", "flags": "a flag"}[key]
                for field in FORBIDDEN_ENTRY_FIELDS[key]:
                    if field in entry:
                        forbidden.add(field)
                        errors.append(
                            f"{key}: {subject} cannot own a '{field}' "
                            f"property"
                        )
            if "deprecated" in entry and key not in (
                "constants", "variables"
            ):
                # only functions, constants and variables may be deprecated
                if "deprecated" not in forbidden:
                    errors.append(
                        f"{key}: a '{key}' entry cannot own a 'deprecated' "
                        f"property"
                    )
                forbidden.add("deprecated")
            unknown = set(entry) - allowed - forbidden
            if unknown:
                errors.append(
                    f"{key}: unknown key(s): {', '.join(sorted(unknown))}"
                )

    @staticmethod
    def validate_authors(value, errors):
        """Check the 'authors' array: objects carrying optional 'name',
        'email' and 'homepage' strings, at least one of them per object."""
        if not isinstance(value, list) or not value:
            errors.append("'authors' must be a non-empty array of objects")
            return
        for author in value:
            if not isinstance(author, dict):
                errors.append("'authors' must contain objects")
                continue
            for field in ("name", "email", "homepage"):
                field_value = author.get(field)
                if field_value is not None and not isinstance(
                    field_value, str
                ):
                    errors.append(f"'authors': '{field}' must be a string")
            if not any(
                author.get(field) for field in ("name", "email", "homepage")
            ):
                errors.append(
                    "'authors': at least one of 'name', 'email' or "
                    "'homepage' is required"
                )
            unknown = set(author) - {"name", "email", "homepage"}
            if unknown:
                errors.append(
                    f"'authors': unknown key(s): {', '.join(sorted(unknown))}"
                )

    @staticmethod
    def entry_token(entry, key):
        """Return the word referenced in the shell code by the given entry:
        the command name for "requires" (first word of a grouped command),
        the base function name for "depends" (last path segment), and the
        variable name for "assumes"."""
        if key == "requires":
            return entry.split()[0] if entry.split() else entry
        if key == "depends":
            return entry.split("/")[-1]
        return entry

    @staticmethod
    def check_string_array_usage(values, key, body, errors):
        """Check that every entry of a requires/depends/assumes array is
        referenced in the file body."""
        for item in values:
            if not isinstance(item, str) or not item:
                continue
            token = re.escape(ShoedocValidator.entry_token(item, key))
            if not re.search(rf"\b{token}\b", body):
                errors.append(f"'{key}' unused entry: {item!r}")

    @staticmethod
    def validate_string_array(value, key, errors):
        """Check that a string array is not empty, deduplicated, and sorted
        alphabetically."""
        if not value:
            errors.append(f"'{key}' must not be empty")
            return
        if value != sorted(value):
            errors.append(f"'{key}' must be sorted alphabetically")
        if len(set(value)) != len(value):
            errors.append(f"'{key}' contains duplicated entries")

    @staticmethod
    def validate_property(key, value, errors):
        if key == "namespace":
            if not isinstance(value, str):
                errors.append("'namespace' must be a string")
            else:
                for error in ShoedocValidator.validate_rel_path(value, key):
                    errors.append(error)
                if not Path(value).is_dir():
                    errors.append(f"'namespace' folder not found: {value!r}")
        elif key == "requires":
            if not isinstance(value, list) or not all(
                isinstance(item, str) for item in value
            ):
                errors.append("'requires' must be an array of strings")
            else:
                for item in value:
                    if not GROUP_COMMAND_RE.match(item):
                        errors.append(f"'requires' invalid command: {item!r}")
                ShoedocValidator.validate_string_array(
                    value, "requires", errors
                )
        elif key == "depends":
            if not isinstance(value, list) or not all(
                isinstance(item, str) for item in value
            ):
                errors.append("'depends' must be an array of strings")
            else:
                for item in value:
                    for error in ShoedocValidator.validate_rel_path(
                        item, "depends"
                    ):
                        errors.append(f"'depends': {error}")
                for item in value:
                    if not Path(f"{item}.sh").is_file():
                        errors.append(f"'depends' file not found: {item!r}.sh")
                ShoedocValidator.validate_string_array(value, "depends", errors)
        elif key == "assumes":
            if not isinstance(value, list) or not all(
                isinstance(item, str) for item in value
            ):
                errors.append("'assumes' must be an array of strings")
            else:
                for item in value:
                    if not CONSTANT_RE.match(item) and not VAR_NAME_RE.match(
                        item
                    ):
                        errors.append(f"'assumes' invalid variable: {item!r}")
                ShoedocValidator.validate_string_array(value, "assumes", errors)
        elif key == "authors":
            ShoedocValidator.validate_authors(value, errors)
        elif key == "links":
            if not isinstance(value, list) or not all(
                isinstance(item, str) and item.strip() for item in value
            ):
                errors.append("'links' must be an array of non-empty strings")
            else:
                if not value:
                    errors.append("'links' must not be empty")
                if len(set(value)) != len(value):
                    errors.append("'links' contains duplicated entries")
        elif key == "examples":
            if not isinstance(value, list) or not all(
                isinstance(item, str) and item.strip() for item in value
            ):
                errors.append("'examples' must be an array of non-empty strings")
        elif key == "shell":
            if value not in ("sh", "bash"):
                errors.append("'shell' must be one of: sh, bash")
        elif key == "private":
            if not isinstance(value, bool):
                errors.append("'private' must be a boolean")
        elif key == "summary":
            if not isinstance(value, str):
                errors.append("'summary' must be a string")
        elif key == "type":
            if not isinstance(value, str):
                errors.append("'type' must be a string")
            elif not value.strip():
                errors.append("'type' must not be empty")
            elif value not in TYPE_VALUES:
                errors.append(
                    f"'type' must be one of: {', '.join(TYPE_VALUES)}"
                )
        elif key in STRING_PROPERTIES:
            if not isinstance(value, str):
                errors.append(f"'{key}' must be a string")
            elif not value.strip():
                errors.append(f"'{key}' must not be empty")
        elif key in ENTRY_ARRAY_KEYS:
            ShoedocValidator.check_entry_array(value, key, errors)
        else:
            errors.append(f"unknown property: '{key}'")


_TAG_RE = re.compile(r"^@([A-Za-z_][A-Za-z0-9_]*):?\s*(.*)$")
_AUTHOR_RE = re.compile(
    r'^\s*(?:"(?P<quoted>[^"]*)"|(?P<bare>[^<]*?))?\s*'
    r"(?:<(?P<email>[^>]*)>)?\s*"
    r"(?P<homepage>https?://\S+)?\s*$"
)
_CONVERT_ARRAY_KEYS = ("requires", "depends", "assumes")
_CONVERT_STRING_KEYS = (
    "namespace", "summary", "copyright", "version", "license", "update",
    "shell", "deprecated", "stdout", "stderr", "stdin",
)
_CONVERT_ENTRY_ARRAY_KEYS = ("constants", "variables", "params", "options",
                             "flags")
_ENTRY_TAG_BY_KEY = {
    "constants": "constant",
    "variables": "variable",
    "params": "param",
    "options": "option",
    "flags": "flag",
}
# Canonical order of the top-level properties: "namespace" first.
_ORDERED_KEYS = (
    "namespace", "name", "summary", "description", "authors", "copyright",
    "version", "license", "links", "update", "shell", "requires",
    "depends", "assumes", "private", "type", "deprecated", "examples",
    "stdout", "stderr", "stdin", "constants", "variables", "params",
    "options", "flags",
)


class ShoedocParser:
    """Parse JSON envelopes and classic Shoedoc tag blocks."""

    def __init__(self, fixer=None):
        self.fixer = ShoedocFixer() if fixer is None else fixer

    @staticmethod
    def _strip_eol(line: str) -> str:
        """Strip the trailing newline (and carriage return for CRLF files)."""
        return line.rstrip("\r\n")

    @classmethod
    def capture_function_annotations(cls, file_lines: list) -> list:
        """Collect the annotation of every function definition, BEFORE any
        parsing: the run of consecutive "##" lines immediately preceding the
        function definition (blank lines skipped in between, exactly like
        _get_function_shoedoc.sh attaches annotations to the function that
        follows them). Returns a list of AnnotationRecord with the function
        line index, function name, absolute annotation line indexes (they are
        needed because a run may span blank lines) and the annotation lines
        themselves, in file order."""
        records = []
        for index, line in enumerate(file_lines):
            match = FUNCTION_RE.match(ShoedocParser._strip_eol(line))
            if not match:
                continue
            run_indexes = []
            cursor = index - 1
            while cursor >= 0:
                stripped = ShoedocParser._strip_eol(file_lines[cursor])
                if not stripped:
                    cursor -= 1
                    continue
                if not stripped.startswith("##"):
                    break
                run_indexes.append(cursor)
                cursor -= 1
            if run_indexes:
                run_indexes.reverse()
                records.append(AnnotationRecord(
                    index,
                    match.group(1),
                    run_indexes,
                    [ShoedocParser._strip_eol(file_lines[i])
                     for i in run_indexes],
                ))
        return records

    @staticmethod
    def strip_shoedoc_prefix(line: str) -> str:
        """Remove the leading double pound sign (and one optional space) from
        an annotation line, like _get_shoedoc.sh does, so that the annotation
        can be parsed with plain `json.loads`."""
        if line.startswith("## "):
            return line[3:]
        if line == "##":
            return ""
        if line.startswith("##"):
            return line[2:]
        return line

    @classmethod
    def strip_shoedoc_prefixes(cls, annotation_lines: list) -> list:
        """Apply strip_shoedoc_prefix to every annotation line."""
        return [cls.strip_shoedoc_prefix(line) for line in annotation_lines]

    @staticmethod
    def locate_envelope(stripped_lines: list) -> tuple:
        """Locate the JSON envelope in the annotation lines whose '##'
        prefixes were stripped: the first bare '{' line and the last bare
        '}' line. Returns (first_open_index, last_close_index); missing
        bounds are None."""
        first_open = None
        last_close = None
        for index, stripped in enumerate(stripped_lines):
            if stripped == "{":
                if first_open is None:
                    first_open = index
            elif stripped == "}":
                last_close = index
        return first_open, last_close

    @staticmethod
    def envelope_spans(stripped_lines: list):
        """Locate every balanced '## {' ... '## }' envelope in the stripped
        annotation lines. Returns the list of (first_open_index,
        last_close_index) tuples, in file order, or None when the run is
        malformed (an unclosed envelope: a '{' line whose matching '}'
        line is missing). Nested brace lines (array of objects, object
        values...) belong to the surrounding envelope."""
        spans = []
        stack = []
        for index, stripped in enumerate(stripped_lines):
            if stripped == "{":
                stack.append(index)
            elif stripped == "}" and stack:
                open_index = stack.pop()
                if not stack:
                    spans.append((open_index, index))
        if stack:
            return None
        return spans

    @staticmethod
    def envelope_json_text(stripped_lines: list, first_open: int,
                           last_close: int) -> str:
        """Join the envelope lines (between '{' and '}') into one plain JSON
        string ready for `json.loads`."""
        return "\n".join(stripped_lines[first_open:last_close + 1])

    @classmethod
    def envelope_state(cls, stripped_lines: list) -> str:
        """Classify the stripped annotation: 'bare' (no '{' line at all),
        'unclosed' ('## {' without matching '## }'), or 'envelope' (a
        balanced '{' ... '}' envelope is present)."""
        opens = closes = 0
        depth = 0
        for stripped in stripped_lines:
            if stripped == "{":
                opens += 1
                depth += 1
            elif stripped == "}" and depth > 0:
                closes += 1
                depth -= 1
        if opens == 0:
            return "bare"
        if depth > 0:
            return "unclosed"
        first_open, last_close = cls.locate_envelope(stripped_lines)
        if first_open is None or last_close is None or first_open > last_close:
            return "bare"
        return "envelope"

    @staticmethod
    def parse_json(json_text: str):
        """Parse the shoedoc annotation like a normal script: `json.loads`."""
        return json.loads(json_text)

    @classmethod
    def missing_shoedoc_blocks(cls, file_lines: list) -> list:
        """Find the function definitions whose captured annotation lines
        (the consecutive "##" lines above them, blank lines skipped) form
        no balanced "## {" ... "## }" envelope. Returns a list of
        (function_line_index, function_name, annotation_start_index)
        tuples."""
        return [
            (record.function_line_index, record.function_name,
             record.line_indexes[0])
            for record in cls.capture_function_annotations(file_lines)
            if cls.envelope_state(
                cls.strip_shoedoc_prefixes(record.lines)
            ) != "envelope"
        ]

    @staticmethod
    def is_shoedoc_line(line: str) -> bool:
        return line.startswith("##") and (
            len(line) == 2 or line[2] in (" ", "\t")
        )

    @classmethod
    def is_json_block_start(cls, line: str) -> bool:
        return cls.is_shoedoc_line(line) and line[2:].strip() == "{"

    @staticmethod
    def extract_json_block(lines: list, start_index: int) -> tuple:
        """Return JSON text and the closing line index for a comment block.
        The block ends as soon as the accumulated stripped lines parse as
        a JSON document, so braces carried inside string values cannot
        confuse the detection."""
        json_lines = []
        index = start_index
        while index < len(lines):
            line = lines[index]
            if not line.startswith("##"):
                return None, start_index
            stripped = line[2:].strip()
            json_lines.append(stripped)
            text = "\n".join(json_lines)
            try:
                json.loads(text)
            except ValueError:
                index += 1
                continue
            return text, index
        return None, start_index

    @staticmethod
    def parse_default(text: str):
        text = text.strip()
        try:
            return json.loads(text)
        except ValueError:
            return text

    @staticmethod
    def decode_constraint(raw: str) -> str:
        try:
            return json.loads('"%s"' % raw)
        except ValueError:
            return raw

    @classmethod
    def parse_entry_value(cls, raw: str) -> dict:
        """Parse one rich ``@param``/``@option``/``@flag`` value."""
        entry = {}
        value = raw.strip()
        if value.startswith("{") and "}" in value:
            head, _separator, tail = value.partition("}")
            entry["type"] = head[1:].strip()
            value = tail.strip()
        if value.startswith("<") and ">" in value:
            head, _separator, tail = value.partition(">")
            entry["name"] = head[1:].strip()
            value = tail.strip()
        if value.startswith("[") and "]" in value:
            head, _separator, tail = value.partition("]")
            parts = [part.strip() for part in head[1:].split("|") if part.strip()]
            if len(parts) >= 2:
                entry["short"] = parts[0].lstrip("-")
                entry["long"] = parts[1].lstrip("-")
            elif parts:
                token = parts[0]
                if token.startswith("--"):
                    entry["long"] = token[2:]
                elif token.startswith("-"):
                    entry["short"] = token[1:]
                else:
                    entry["long"] = token
            value = tail.strip()
        first, _separator, rest = value.partition(" ")
        if first.startswith("/"):
            entry["constraint"] = cls.decode_constraint(first)
            value = rest.strip()
        if value.startswith("(") and ")" in value:
            head, _separator, tail = value.partition(")")
            marker = head[1:].strip()
            if marker == "required":
                entry["required"] = True
            elif marker == "optional":
                entry["required"] = False
            elif marker.startswith("default:"):
                entry["default"] = cls.parse_default(marker[len("default:"):])
            value = tail.strip()
        value = value.strip()
        if value:
            if " - " in value:
                summary, _separator, description = value.partition(" - ")
                entry["summary"] = summary.strip()
                entry["description"] = description.strip()
            else:
                entry["description"] = value
        return entry

    @staticmethod
    def parse_author(value: str) -> dict:
        match = _AUTHOR_RE.match(value)
        if match is None:
            return {"name": value.strip()}
        name = match.group("quoted")
        if name is None:
            name = (match.group("bare") or "").strip()
        author = {}
        if name:
            author["name"] = name
        if match.group("email") is not None:
            author["email"] = match.group("email").strip()
        if match.group("homepage") is not None:
            author["homepage"] = match.group("homepage").strip()
        if not author:
            author["name"] = value.strip()
        return author

    @classmethod
    def parse_classic_block(cls, chunk_lines: list, base_index: int) -> tuple:
        """Return ``(data, warnings)`` for a classic comment block."""
        data = {}
        entries = {key: [] for key in _CONVERT_ENTRY_ARRAY_KEYS}
        summary_parts = []
        description_parts = []
        warnings = []
        seen_tag = False
        seen_separator = False

        for offset, line in enumerate(chunk_lines):
            line_number = base_index + offset + 1
            body = line[2:].strip()
            if not body:
                if not seen_tag:
                    seen_separator = True
                continue
            match = _TAG_RE.match(body)
            if match is None:
                if seen_tag:
                    warnings.append(
                        "warning: non-tag comment ignored at line %d\n"
                        % line_number
                    )
                elif seen_separator:
                    description_parts.append(body)
                else:
                    summary_parts.append(body)
                continue

            seen_tag = True
            tag = match.group(1)
            value = match.group(2).strip()
            if tag in ("param", "option", "flag", "constant", "variable"):
                array_key = {
                    "param": "params",
                    "constant": "constants",
                    "variable": "variables",
                }.get(tag, tag + "s")
                if not value:
                    warnings.append(
                        "warning: empty @%s ignored at line %d\n"
                        % (tag, line_number)
                    )
                    continue
                entry = cls.parse_entry_value(value)
                if not entry or (
                    "name" not in entry and array_key not in (
                        "constants", "variables"
                    )
                ):
                    warnings.append(
                        "warning: empty @%s ignored at line %d\n"
                        % (tag, line_number)
                    )
                    continue
                if array_key == "options" and "required" in entry:
                    # options are optional by design: a missing option
                    # falls back to its default value
                    entry.pop("required")
                    warnings.append(
                        "warning: @option '(required)' ignored at line %d\n"
                        % line_number
                    )
                entries[array_key].append(entry)
            elif tag == "author":
                if not value:
                    warnings.append(
                        "warning: empty @author ignored at line %d\n"
                        % line_number
                    )
                    continue
                data.setdefault("authors", []).append(cls.parse_author(value))
            elif tag == "link":
                if not value:
                    warnings.append(
                        "warning: empty @link ignored at line %d\n"
                        % line_number
                    )
                    continue
                data.setdefault("links", []).append(value)
            elif tag == "example":
                if not value:
                    warnings.append(
                        "warning: empty @example ignored at line %d\n"
                        % line_number
                    )
                    continue
                data.setdefault("examples", []).append(value)
            elif tag == "private":
                data["private"] = True
            elif tag == "public":
                data["private"] = False
            elif tag == "type":
                type_value = value.strip()
                if type_value.startswith("{") and type_value.endswith("}"):
                    type_value = type_value[1:-1].strip()
                data["type"] = type_value
            elif tag in _CONVERT_ARRAY_KEYS:
                data.setdefault(tag, []).extend(value.split())
            elif tag in _CONVERT_STRING_KEYS:
                data[tag] = value
            else:
                warnings.append(
                    'warning: unknown tag "@%s" ignored at line %d\n'
                    % (tag, line_number)
                )

        if not data and not any(entries.values()):
            return None, warnings
        for index, entry in enumerate(entries["params"]):
            entry["position"] = index + 1
        if summary_parts and "summary" not in data:
            data["summary"] = " ".join(summary_parts)
        if description_parts:
            data["description"] = "\n".join(description_parts)

        ordered = {}
        for key in _ORDERED_KEYS:
            if key in entries:
                if entries[key]:
                    ordered[key] = entries[key]
            elif key in data:
                ordered[key] = data[key]
        return (ordered or None), warnings

    def parse_annotation_lines(self, annotation_lines: list, base_index=0,
                               span=-1) -> dict:
        """Parse a JSON envelope or classic tags from an annotation run.
        When the run holds several balanced envelopes (a script header
        sitting directly above a function annotation), `span` selects the
        envelope carrying the annotated element's metadata: -1 (the
        default) targets the last envelope, 0 the first one."""
        stripped = self.strip_shoedoc_prefixes(annotation_lines)
        state = self.envelope_state(stripped)
        if state == "unclosed":
            raise ValueError("Shoedoc JSON envelope is not closed")
        if state == "envelope":
            spans = self.envelope_spans(stripped)
            if spans:
                index = span if span >= 0 else len(spans) + span
                first_open, last_close = spans[index]
                boundary = spans[index - 1][1] + 1 if index > 0 else 0
            else:
                first_open, last_close = self.locate_envelope(stripped)
                boundary = 0
            parsed = self.parse_json(
                self.envelope_json_text(stripped, first_open, last_close)
            )
            if not isinstance(parsed, dict):
                raise ValueError("Shoedoc JSON envelope must contain an object")
            summary_lines = [
                line.strip()
                for line in stripped[boundary:first_open] if line.strip()
            ]
            if summary_lines and "summary" not in parsed:
                parsed = self.fixer.fold_summary_property(
                    parsed, "\n".join(summary_lines)
                )
            return parsed

        parsed, _warnings = self.parse_classic_block(
            annotation_lines, base_index
        )
        if parsed is not None:
            return parsed
        summary_lines = [
            self.strip_shoedoc_prefix(line).strip()
            for line in annotation_lines
        ]
        summary_lines = [line for line in summary_lines if line]
        return {"summary": "\n".join(summary_lines)} if summary_lines else {}

    def script_metadata_indices(self, file_lines: list) -> list:
        """Return line indexes for the first script-level annotation run."""
        index = 0
        while index < len(file_lines):
            line = file_lines[index].rstrip("\r\n")
            if line.startswith("##"):
                start = index
                while index < len(file_lines) and file_lines[index].startswith("##"):
                    index += 1
                json_start = next(
                    (
                        cursor for cursor in range(start, index)
                        if self.is_json_block_start(file_lines[cursor])
                    ),
                    None,
                )
                annotation_end = index
                if json_start is not None:
                    _json_text, json_end = self.extract_json_block(
                        file_lines, json_start
                    )
                    if json_end >= json_start:
                        annotation_end = json_end + 1
                return list(range(start, annotation_end))
            if not line.strip() or line.startswith("#"):
                index += 1
                continue
            break
        return []

    def parse_script_metadata(self, file_lines: list) -> dict:
        """Read the first script-level Shoedoc annotation after the shebang."""
        indexes = self.script_metadata_indices(file_lines)
        if not indexes:
            return {}
        annotation_lines = [
            file_lines[index].rstrip("\r\n") for index in indexes
        ]
        return self.parse_annotation_lines(
            annotation_lines, indexes[0], span=0
        )

    def parse_function_metadata(self, file_lines: list) -> list:
        """Return each function's annotation record and parsed metadata."""
        records = []
        script_indices = set(self.script_metadata_indices(file_lines))
        for annotation in self.capture_function_annotations(file_lines):
            line_indexes = [
                index for index in annotation.line_indexes
                if index not in script_indices
            ]
            if not line_indexes:
                continue
            annotation_lines = [
                file_lines[index].rstrip("\r\n")
                for index in line_indexes
            ]
            metadata = self.parse_annotation_lines(
                annotation_lines, line_indexes[0]
            )
            records.append((annotation, metadata))
        return records

    def annotation_runs(self, file_lines: list) -> dict:
        """Map each legitimate Shoedoc run start to its line indexes: the
        first script-level run and the runs attached to function
        definitions. Comment lines inside function bodies (notably
        heredoc payloads) never belong to a run and must be left
        untouched."""
        runs = {}
        script_indexes = self.script_metadata_indices(file_lines)
        if script_indexes:
            runs[script_indexes[0]] = script_indexes
        script_set = set(script_indexes)
        for annotation in self.capture_function_annotations(file_lines):
            line_indexes = [
                index for index in annotation.line_indexes
                if index not in script_set
            ]
            if line_indexes:
                runs[line_indexes[0]] = line_indexes
        return runs


class ShoedocSerializer:
    """Serialize Shoedoc data as JSON envelopes or classic tags."""

    def __init__(self, ordering=None):
        self.ordering = ShoedocOrdering() if ordering is None else ordering

    def json_envelope_lines(self, parsed) -> list:
        """Serialize the object back into shoedoc lines: a leading '## '
        per line of the JSON rendering, exactly like a normal annotation."""
        text = json.dumps(
            self.ordering.order_keys(parsed), indent=2, ensure_ascii=False
        )
        return [f"## {line}\n" for line in text.splitlines()]

    def json_comment_lines(self, parsed, ensure_ascii=False) -> list:
        text = json.dumps(
            self.ordering.order_keys(parsed),
            indent=2,
            ensure_ascii=ensure_ascii,
        )
        return ["## " + line for line in text.split("\n")]

    @staticmethod
    def format_default(value) -> str:
        if value is True:
            return "default:true"
        if value is False:
            return "default:false"
        if isinstance(value, (int, float)):
            return "default:%s" % value
        return "default:%s" % json.dumps(value)

    @classmethod
    def format_entry_tag(cls, array_key: str, entry: dict) -> str:
        tag = "@%s" % _ENTRY_TAG_BY_KEY[array_key]
        if entry.get("type") is not None:
            tag += " {%s}" % entry["type"]
        if entry.get("name") is not None:
            tag += " <%s>" % entry["name"]
        short = entry.get("short")
        long_name = entry.get("long")
        if short is not None and long_name is not None:
            tag += " [-%s|--%s]" % (short, long_name)
        elif short is not None:
            tag += " [-%s]" % short
        elif long_name is not None:
            tag += " [--%s]" % long_name
        if entry.get("constraint") is not None:
            tag += " %s" % json.dumps(entry["constraint"])[1:-1]
        if array_key == "params":
            if entry.get("required") is True:
                tag += " (required)"
            elif "default" in entry:
                tag += " (%s)" % cls.format_default(entry["default"])
            elif entry.get("required") is False:
                tag += " (optional)"
        elif "default" in entry and array_key == "options":
            tag += " (%s)" % cls.format_default(entry["default"])
        summary = entry.get("summary")
        description = entry.get("description")
        if summary is not None and description is not None:
            tag += " %s - %s" % (summary, description)
        elif summary is not None:
            tag += " %s" % summary
        elif description is not None:
            tag += " %s" % description
        return "## %s" % tag

    @staticmethod
    def format_author(author) -> str:
        if isinstance(author, str):
            return author
        parts = []
        if author.get("name"):
            parts.append('"%s"' % author["name"])
        if author.get("email"):
            parts.append("<%s>" % author["email"])
        if author.get("homepage"):
            parts.append(author["homepage"])
        return " ".join(parts)

    @classmethod
    def json_to_classic(cls, data) -> list:
        out = []
        if "summary" in data:
            out.append("## %s" % data["summary"])
        if "description" in data:
            if "summary" in data:
                out.append("##")
            out.extend("## %s" % line for line in data["description"].split("\n"))
        if "summary" in data or "description" in data:
            out.append("##")

        for key in _ORDERED_KEYS:
            if key in ("summary", "description", "name"):
                continue
            if key in _CONVERT_ARRAY_KEYS:
                value = data.get(key)
                if isinstance(value, list) and all(
                    isinstance(item, str) for item in value
                ):
                    out.append("## @%s %s" % (key, " ".join(value)))
            elif key in _CONVERT_ENTRY_ARRAY_KEYS:
                entries = data.get(key)
                if isinstance(entries, list):
                    for entry in entries:
                        if isinstance(entry, dict):
                            out.append(cls.format_entry_tag(key, entry))
            elif key == "authors":
                authors = data.get(key)
                if isinstance(authors, list):
                    for author in authors:
                        out.append("## @author %s" % cls.format_author(author))
            elif key == "links":
                links = data.get(key)
                if isinstance(links, list):
                    out.extend(
                        "## @link %s" % link for link in links
                        if isinstance(link, str)
                    )
            elif key == "examples":
                examples = data.get(key)
                if isinstance(examples, list):
                    out.extend("## @example %s" % example for example in examples)
            elif key == "private" and key in data:
                out.append("## @private" if data[key] else "## @public")
            elif key == "type":
                if data.get(key):
                    out.append("## @type {%s}" % data[key])
            elif key in data:
                out.append("## @%s %s" % (key, data[key]))
        return out


class ShoedocRule:
    """Reusable validator for a group of Shoedoc properties."""

    def __init__(self, property_names, validator=None):
        self.property_names = frozenset(property_names)
        self.validator = ShoedocValidator() if validator is None else validator

    def supports(self, property_name: str) -> bool:
        return property_name in self.property_names

    def validate(self, property_name: str, value, errors: list) -> None:
        self.validator.validate_property(property_name, value, errors)


class ShoedocOrdering:
    """Apply and check the canonical order of Shoedoc objects:
    "namespace" first at the top level, "position" first in "params"
    entries."""

    @staticmethod
    def _ordered_object(value, order):
        """Return a copy of the object `value` with its keys ordered by
        `order`; keys not listed keep their relative order, appended
        last."""
        ordered = {key: value[key] for key in order if key in value}
        for key in value:
            if key not in ordered:
                ordered[key] = value[key]
        return ordered

    @classmethod
    def order_keys(cls, parsed):
        """Return a copy of a parsed shoedoc object with every object
        ordered by the canonical order: top-level properties ("namespace"
        first), entry fields ("position" first in "params"), and author
        fields. Array element order is preserved (notably the "params"
        positions)."""
        if not isinstance(parsed, dict):
            return parsed
        ordered = cls._ordered_object(parsed, _ORDERED_KEYS)
        for key in ENTRY_ARRAY_KEYS:
            entries = ordered.get(key)
            if isinstance(entries, list):
                ordered[key] = [
                    cls._ordered_object(entry, ENTRY_FIELDS[key])
                    if isinstance(entry, dict) else entry
                    for entry in entries
                ]
        authors = ordered.get("authors")
        if isinstance(authors, list):
            ordered["authors"] = [
                cls._ordered_object(author, ("name", "email", "homepage"))
                if isinstance(author, dict) else author
                for author in authors
            ]
        return ordered

    @classmethod
    def keys_ordered(cls, parsed) -> bool:
        """Return True when every object in `parsed` already carries its
        keys in the canonical order; array element order is ignored."""
        if not isinstance(parsed, dict):
            return True
        return json.dumps(parsed) == json.dumps(cls.order_keys(parsed))


class ShoedocFixer:
    """Repair malformed annotation text and normalize parsed blocks."""

    DANGLING_COMMA_RE = re.compile(r",\s*$")
    EMPTY_DEPENDS_RE = re.compile(r'^(\s*)"depends":\s*\[\]\s*,?\s*$')
    ENTRY_ONLY_RE = re.compile(r'^\s*"([^"]+)",?\s*$')
    ARRAY_CLOSE_RE = re.compile(r"^\s*\]\s*,?\s*$")

    def __init__(self, validator=None, ordering=None):
        self.validator = ShoedocValidator() if validator is None else validator
        self.ordering = ShoedocOrdering() if ordering is None else ordering

    @staticmethod
    def remove_dangling_commas(lines: list, fixes: list) -> list:
        """Remove dangling commas before '}' / ']' lines so that the
        stripped envelope can be parsed like a normal JSON document."""
        new_lines = list(lines)
        for index in range(len(new_lines) - 1):
            current = new_lines[index].rstrip()
            next_line = new_lines[index + 1].lstrip()
            if (
                ShoedocFixer.DANGLING_COMMA_RE.search(current)
                and (
                    next_line.startswith("}")
                    or next_line.startswith("]")
                )
            ):
                new_lines[index] = (
                    ShoedocFixer.DANGLING_COMMA_RE.sub("", current)
                )
                fixes.append("removed dangling comma")
        return new_lines

    @staticmethod
    def merge_orphan_depends_lines(lines: list, fixes: list) -> list:
        """Merge orphan depends entry lines / stray array terminator(s)
        that follow a stripped "depends": [], header back into the
        array."""
        new_lines = list(lines)
        body_end = next(
            (index for index in range(1, len(new_lines))
             if new_lines[index].strip() == "}"),
            len(new_lines),
        )
        for index in range(body_end):
            current = new_lines[index].rstrip()
            if not (match := ShoedocFixer.EMPTY_DEPENDS_RE.match(current)):
                continue
            indent = match.group(1)
            entries = []
            terminator = None
            for cursor in range(index + 1, body_end):
                entry_line = new_lines[cursor].strip()
                if ShoedocFixer.ENTRY_ONLY_RE.match(entry_line):
                    entries.append(cursor)
                    continue
                if ShoedocFixer.ARRAY_CLOSE_RE.match(entry_line):
                    terminator = cursor
                break
            if not entries and terminator is None:
                continue
            if not entries:
                if terminator != index + 1:
                    continue
                # stray terminators directly after the empty inline array:
                # remove them all
                merged_any = False
                cursor = terminator
                while (
                    cursor < body_end
                    and ShoedocFixer.ARRAY_CLOSE_RE.match(
                        new_lines[cursor].strip()
                    )
                ):
                    del new_lines[cursor]
                    body_end -= 1
                    merged_any = True
                if merged_any:
                    next_line = (
                        new_lines[cursor].strip()
                        if cursor < len(new_lines)
                        else ""
                    )
                    if next_line.startswith("}"):
                        new_lines[index] = f'{indent}"depends": []'
                    fixes.append("removed stray depends array terminator")
                    break
                continue
            fixes.append("merged orphan depends array lines")
            new_lines[index] = '  "depends": ['
            for position, cursor in enumerate(entries):
                entry = new_lines[cursor].strip()
                if not entry.endswith(","):
                    entry += ","
                if position == len(entries) - 1:
                    entry = entry[:-1]
                new_lines[cursor] = "    " + entry
            if terminator is not None:
                next_line = (
                    new_lines[terminator + 1].strip()
                    if terminator + 1 < len(new_lines)
                    else ""
                )
                new_lines[terminator] = "  ]" + (
                    "," if not next_line.startswith("}") else ""
                )
                # drop duplicate terminators
                for cursor in range(terminator + 1, body_end):
                    if ShoedocFixer.ARRAY_CLOSE_RE.match(
                        new_lines[cursor].strip()
                    ):
                        del new_lines[cursor]
                        fixes.append(
                            "removed stray depends array terminator"
                        )
                        break
            break
        return new_lines

    @staticmethod
    def fix_required_defaults(entries, key, fixes):
        """Drop the 'default' field from entries marked as required: a
        required entry has no default value."""
        cleaned = []
        for entry in entries:
            if (
                isinstance(entry, dict)
                and entry.get("required") is True
                and "default" in entry
            ):
                entry = dict(entry)
                entry.pop("default")
                fixes.append(
                    f"removed 'default' from required '{key}' entries"
                )
            cleaned.append(entry)
        return cleaned

    def fix_string_array_entries(self, entries, key, body):
        """Deduplicate and sort the entries of a requires/depends/assumes
        array, dropping the unused ones. Returns (cleaned_entries,
        fixes)."""
        fixes = []
        deduplicated = list(dict.fromkeys(entries))
        if len(deduplicated) < len(entries):
            fixes.append(f"removed duplicated '{key}' entries")
        dropped_unused = [
            entry for entry in deduplicated
            if not re.search(
                rf"\b{re.escape(self.validator.entry_token(entry, key))}\b",
                body,
            )
        ]
        if dropped_unused:
            fixes.append(f"removed unused '{key}' entries")
        cleaned = sorted(
            entry for entry in deduplicated if entry not in dropped_unused
        )
        return cleaned, fixes

    def fix_dictionary(self, parsed, body, adds, namespace_value,
                       wrong_namespace):
        """Apply the whole-fix pipeline to the parsed shoedoc object;
        returns (new_object, fixes). `adds` maps array keys (requires /
        depends) to the entries to merge; a missing array property is
        created right after the namespace, in canonical order."""
        if not isinstance(parsed, dict):
            return None, []
        fixes = []
        result = {}

        if not self.ordering.keys_ordered(parsed):
            fixes.append("ordered properties")

        if wrong_namespace and "namespace" in parsed:
            parsed = dict(parsed)
            parsed["namespace"] = wrong_namespace
            fixes.append("repaired 'namespace' folder")

        if namespace_value is not None:
            result["namespace"] = namespace_value
            fixes.append("inserted missing namespace")

        for key, value in parsed.items():
            if key == "namespace" and key in result:
                continue
            if key in ARRAY_KEYS and isinstance(value, list) and (
                all(isinstance(entry, str) for entry in value)
            ):
                if not value:
                    fixes.append(f"removed empty '{key}' array")
                    continue
                cleaned, array_fixes = self.fix_string_array_entries(
                    value, key, body
                )
                fixes.extend(array_fixes)
                to_add = adds.get(key) if adds else None
                if to_add:
                    added = [
                        entry for entry in sorted(to_add)
                        if entry not in cleaned
                    ]
                    if added:
                        fixes.append(f"added missing '{key}' entries")
                        cleaned = sorted(cleaned + added)
                if not cleaned:
                    fixes.append(f"removed empty '{key}' array")
                    continue
                original = [
                    entry for entry in dict.fromkeys(value)
                    if entry in cleaned
                ]
                if cleaned != original:
                    fixes.append(f"sorted '{key}' entries")
                result[key] = cleaned
            elif key in ENTRY_ARRAY_KEYS and isinstance(value, list):
                if not value:
                    fixes.append(f"removed empty '{key}' property")
                    continue
                result[key] = self.fix_required_defaults(value, key, fixes)
            else:
                result[key] = value

        additions = []
        for key in ("requires", "depends"):
            to_add = adds.get(key) if adds else None
            if to_add and key not in result:
                fixes.append(f"added missing '{key}' entries")
                additions.append((key, sorted(set(to_add))))
        if additions:
            additions_by_key = dict(additions)
            ordered = []
            if "namespace" in result:
                ordered.append(("namespace", result.pop("namespace")))
            for key in ("requires", "depends"):
                if key in result:
                    ordered.append((key, result.pop(key)))
                elif key in additions_by_key:
                    ordered.append((key, additions_by_key[key]))
            result = {**dict(ordered), **result}

        return self.ordering.order_keys(result), fixes

    @staticmethod
    def fold_summary_property(parsed, summary_text) -> dict:
        """Fold the bare annotation lines' text into the parsed shoedoc
        object as a "summary" property, placed right after "namespace"
        when present, first otherwise."""
        result = {}
        inserted = False
        for key, value in parsed.items():
            result[key] = value
            if key == "namespace":
                result["summary"] = summary_text
                inserted = True
        if not inserted:
            result = {"summary": summary_text, **result}
        return result

    def requires_ordering(self, parsed) -> bool:
        """Return True when `parsed` holds at least one object whose keys
        are not in the canonical order."""
        return not self.ordering.keys_ordered(parsed)


class ShellSanitizer:
    """Blank out shell comments, quoted strings and heredoc bodies while
    retaining executable substitutions (command substitutions)."""

    def sanitize(self, text: str, heredoc=None):
        """Blank out comments, quoted strings and heredoc bodies to avoid
        false call detection. Command substitutions (backticks and
        $( ... )) inside quoted strings or heredocs are preserved: they
        are actually executed. Returns (sanitized_text,
        trailing_heredoc_delimiter)."""
        chars = list(text)
        heredoc = self._scan(text, chars, 0, len(text), heredoc)
        return "".join(chars), heredoc

    @staticmethod
    def _blank(chars, start, stop):
        """Replace the given character range with spaces."""
        for index in range(start, min(stop, len(chars))):
            chars[index] = " "

    def _scan(self, text, chars, start, stop, heredoc=None, depth=0):
        """Walk a character range in 'code' context and blank, in place:
          - comments (#...),
          - single-quoted strings,
          - double-quoted strings (recursing into command substitutions),
          - parameter expansions (${...} ... ${}),
          - heredoc bodies, whose payload is bounded on each line by a
            delimiter line equal to `heredoc` (recursing into command
            substitutions).
        Ranges nested deeper than SANITIZE_DEPTH_LIMIT command
        substitutions are blanked instead of recursed, so pathological
        input cannot overflow the Python recursion stack.
        Returns the heredoc delimiter still open at the end of the
        range."""
        if depth > SANITIZE_DEPTH_LIMIT:
            self._blank(chars, start, stop)
            return heredoc
        index = start
        while index < stop:
            char = text[index]
            if heredoc is not None:
                # heredoc body line: blank it, unless it terminates the
                # heredoc
                delimiter, quoted = heredoc
                line_end = text.find("\n", index, stop)
                if line_end == -1:
                    if not quoted:
                        self._payload(text, chars, index, stop, depth + 1)
                    else:
                        self._blank(chars, index, stop)
                    return heredoc
                if text[index:line_end].rstrip(" \t") == delimiter:
                    heredoc = None
                elif not quoted:
                    self._payload(text, chars, index, line_end, depth + 1)
                else:
                    self._blank(chars, index, line_end)
                index = line_end + 1
                continue
            if (
                char == "#"
                and (index == start or text[index - 1] in " \t;|&(\n")
            ):
                line_end = text.find("\n", index, stop)
                if line_end == -1:
                    self._blank(chars, index, stop)
                    return heredoc
                self._blank(chars, index, line_end)
                index = line_end
                continue
            if char == "'":
                close = text.find("'", index + 1, stop)
                end = stop if close == -1 else close + 1
                self._blank(chars, index, end)
                index = end
                # skip a trailing escaped quote ("...'\'...'"), otherwise
                # the unmatched apostrophe would open a string spanning
                # lines
                if (
                    close != -1 and index + 1 < stop
                    and text[index] == "\\" and text[index + 1] == "'"
                ):
                    self._blank(chars, index, index + 2)
                    index += 2
                continue
            if char == '"':
                end = self._dquote(text, chars, index, stop, depth + 1)
                index = end
                continue
            if char == "`":
                close = text.find("`", index + 1, stop)
                end = stop if close == -1 else close + 1
                if close != -1:
                    self._scan(text, chars, index + 1, close, None, depth + 1)
                index = end
                continue
            if char == "$" and index + 1 < stop and text[index + 1] == "{":
                close = text.find("}", index + 1, stop)
                index = stop if close == -1 else close + 1
                continue
            if (
                char == "$" and index + 1 < stop and text[index + 1] == "("
            ):
                close = self._matching_delim(text, index + 1, stop, "(", ")")
                inner_end = stop if close == -1 else close
                self._scan(text, chars, index + 2, inner_end, None, depth + 1)
                index = stop if close == -1 else close + 1
                continue
            if char == "<" and index + 1 < stop and text[index + 1] == "<":
                if index + 2 < stop and text[index + 2] == "<":
                    # here-string: not a heredoc
                    index += 2
                    continue
                delimiter, quoted, index = self._heredoc_prefix(
                    text, chars, index, stop
                )
                if delimiter is not None:
                    heredoc = (delimiter, quoted)
                continue
            index += 1
        return heredoc

    def _dquote(self, text, chars, start, stop, depth=0):
        """Blank a double-quoted string in place (including the quotes);
        the command substitutions it contains are recursed instead of
        blanked. Ranges nested deeper than SANITIZE_DEPTH_LIMIT are
        blanked outright. Returns the index just past the closing quote
        (or `stop`)."""
        if depth > SANITIZE_DEPTH_LIMIT:
            self._blank(chars, start, stop)
            return stop
        chars[start] = " "
        index = start + 1
        while index < stop:
            char = text[index]
            if char == "\\" and index + 1 < stop:
                self._blank(chars, index, index + 2)
                index += 2
                continue
            if char == "`":
                close = text.find("`", index + 1, stop)
                end = stop if close == -1 else close + 1
                if close != -1:
                    chars[close] = " "
                    self._scan(text, chars, index + 1, close, None, depth + 1)
                chars[index] = " "
                index = end
                continue
            if char == "$" and index + 1 < stop and text[index + 1] == "(":
                close = self._matching_delim(text, index + 1, stop, "(", ")")
                inner_end = stop if close == -1 else close
                self._scan(text, chars, index + 2, inner_end, None, depth + 1)
                index = stop if close == -1 else close + 1
                continue
            if char == "$" and index + 1 < stop and text[index + 1] == "{":
                close = text.find("}", index + 1, stop)
                index = stop if close == -1 else close + 1
                continue
            if char == '"':
                chars[index] = " "
                return index + 1
            chars[index] = " "
            index += 1
        return stop

    @staticmethod
    def _matching_delim(text, open_index, stop, open_char, close_char):
        """Index of the matching `close_char` for the `open_char` at
        open_index (single/double-quoted strings and backslashes inside
        are skipped), or -1."""
        depth = 1
        index = open_index + 1
        while index < stop:
            char = text[index]
            if char == "\\":
                index += 2
                continue
            if char == "'":
                close = text.find("'", index + 1, stop)
                index = stop if close == -1 else close + 1
                continue
            if char == '"':
                index += 1
                while index < stop:
                    if text[index] == "\\":
                        index += 2
                        continue
                    if text[index] == '"':
                        break
                    index += 1
                index += 1
                continue
            if char == open_char:
                depth += 1
            elif char == close_char:
                depth -= 1
                if depth == 0:
                    return index
            index += 1
        return -1

    def _heredoc_prefix(self, text, chars, index, stop):
        """Blank the `<< [out] delimiter` prefix of a heredoc redirection
        and return (delimiter, quoted, index_of_end_of_line); (None,
        False, ...) when no delimiter follows the redirection."""
        cursor = index + 2
        self._blank(chars, index, cursor)
        if cursor < stop and text[cursor] == "-":
            cursor += 1
        while cursor < stop and text[cursor] in " \t":
            self._blank(chars, cursor, cursor + 1)
            cursor += 1
        delimiter = None
        quoted = False
        if cursor < stop and text[cursor] in "'\"":
            quote = text[cursor]
            close = text.find(quote, cursor + 1, stop)
            end = stop if close == -1 else close
            self._blank(chars, cursor, cursor + 1)
            delimiter_start = cursor + 1
            stripped = text[delimiter_start:end]
            self._blank(chars, delimiter_start, end)
            if close != -1:
                self._blank(chars, close, close + 1)
            if stripped:
                delimiter = stripped
                quoted = True
        else:
            word_start = cursor
            while cursor < stop and (
                text[cursor].isalnum() or text[cursor] == "_"
            ):
                self._blank(chars, cursor, cursor + 1)
                cursor += 1
            word = text[word_start:cursor]
            if word:
                delimiter = word
        line_end = text.find("\n", index, stop)
        return (
            delimiter,
            quoted,
            stop if line_end == -1 else line_end,
        )

    def _payload(self, text, chars, start, stop, depth=0):
        """Blank a quoted / heredoc payload in place, except command
        substitutions (backticks and $( ... )), which are recursed
        instead. Ranges nested deeper than SANITIZE_DEPTH_LIMIT are
        blanked outright."""
        if depth > SANITIZE_DEPTH_LIMIT:
            self._blank(chars, start, stop)
            return stop
        index = start
        while index < stop:
            char = text[index]
            if char == "\\" and index + 1 < stop:
                self._blank(chars, index, index + 2)
                index += 2
                continue
            if char == "`":
                close = text.find("`", index + 1, stop)
                end = stop if close == -1 else close + 1
                if close != -1:
                    chars[close] = " "
                    self._scan(text, chars, index + 1, close, None, depth + 1)
                chars[index] = " "
                index = end
                continue
            if char == "$" and index + 1 < stop and text[index + 1] == "(":
                close = self._matching_delim(text, index + 1, stop, "(", ")")
                inner_end = stop if close == -1 else close
                self._scan(text, chars, index + 2, inner_end, None, depth + 1)
                index = stop if close == -1 else close + 1
                continue
            if char == "$" and index + 1 < stop and text[index + 1] == "{":
                close = text.find("}", index + 1, stop)
                index = stop if close == -1 else close + 1
                continue
            chars[index] = " "
            index += 1
        return stop


class FunctionRegistry:
    """Map each top-level function name to its defining file, as a
    relative path from the working directory (without the .sh
    extension)."""

    @staticmethod
    def build() -> dict:
        """Build the registry from the working directory - not from the
        scanned folder - so that functions defined under "src" are
        resolved even when --fix runs on a subfolder. Files under a
        "build" folder and files outside the "src" folder are excluded:
        --fix must only ever add "src" dependencies."""
        registry = {}
        for path in sorted(Path.cwd().rglob("*.sh")):
            if "build" in path.parts:
                continue
            entry = os.path.relpath(path.with_suffix(""), Path.cwd())
            if entry != "src" and not entry.startswith("src" + os.sep):
                continue
            content = path.read_text(encoding="utf-8", errors="replace")
            for line in content.splitlines():
                match = FUNCTION_RE.match(line)
                if match:
                    registry.setdefault(
                        match.group(1),
                        entry,
                    )
        return registry


class StaticAnalyzer:
    """Analyze shell source for function dependencies and external
    commands."""

    def __init__(self, registry=None, sanitizer=None):
        self.registry = (
            FunctionRegistry.build() if registry is None else dict(registry)
        )
        self.sanitizer = ShellSanitizer() if sanitizer is None else sanitizer

    @staticmethod
    def find_defined_functions(file_lines: list) -> set:
        """All functions defined in the file, including nested
        definitions."""
        return {
            match.group(1)
            for line in file_lines
            if (match := FUNCTION_RE.match(line.rstrip("\n")))
        }

    def function_body_below(self, file_lines: list, from_index: int):
        """Return the raw source of the function defined after the given
        line index (blank lines allowed between the shoedoc block and the
        function), or None."""
        index = from_index
        total = len(file_lines)
        while index < total and not file_lines[index].strip():
            index += 1
        if index >= total or not FUNCTION_RE.match(
            file_lines[index].rstrip("\n")
        ):
            return None
        body = []
        depth = 0
        started = False
        heredoc = None
        while index < total:
            line = file_lines[index]
            body.append(line)
            # braces inside quoted strings or comments are plain
            # characters and must not affect depth
            counted, heredoc = self.sanitizer.sanitize(line, heredoc)
            depth += counted.count("{") - counted.count("}")
            if depth > 0:
                started = True
            elif started and depth <= 0:
                break
            index += 1
        return "".join(body)

    def find_calls(self, function_body: str, defined: set) -> set:
        """Calls to registry entries, excluding locally defined functions.
        Calls inside quotes, comments or heredocs are ignored, except when
        performed through a command substitution (backticks or $( ... ))."""
        calls = set()
        sanitized, _heredoc = self.sanitizer.sanitize(function_body)
        for match in CALL_RE.finditer(sanitized):
            name = match.group(1)
            if name in self.registry and name not in defined:
                calls.add(name)
        return calls

    def find_external_commands(self, function_body: str, defined: set) -> set:
        """External commands called by the function body, excluding
        locally defined functions and registry (src) functions: a command
        is detected when an executable with this name exists on PATH. The
        identifier right after for / while is a loop variable, not a
        command. Calls inside quotes, comments or heredocs are ignored,
        except when performed through a command substitution (backticks or
        $( ... ))."""
        commands = set()
        sanitized, _heredoc = self.sanitizer.sanitize(function_body)
        previous = ""
        for match in CALL_RE.finditer(sanitized):
            name = match.group(1)
            loop_variable = previous in ("for", "while")
            previous = name
            if name in defined or name in self.registry or loop_variable:
                continue
            if shutil.which(name):
                commands.add(name)
        return commands

    @staticmethod
    def find_missing_array_entries(parsed, key, computed) -> set:
        """Entries of `computed` (calls / external commands) that are not
        listed in the parsed block's given array (requires / depends)."""
        if not computed:
            return set()
        existing = parsed.get(key)
        existing_set = (
            {entry for entry in existing if isinstance(entry, str)}
            if isinstance(existing, list)
            else set()
        )
        return computed - existing_set

    def missing_requires(self, parsed, function_body, defined) -> set:
        """Return the executable names of statically detected external
        commands that are not listed in the parsed block's "requires"
        array."""
        if not function_body or not isinstance(parsed, dict):
            return set()
        computed = self.find_external_commands(function_body, defined)
        return self.find_missing_array_entries(parsed, "requires", computed)

    def missing_depends(self, parsed, function_body, defined) -> set:
        """Return the registry paths of statically detected function calls
        that are not listed in the parsed block's "depends" array."""
        if not function_body or not isinstance(parsed, dict):
            return set()
        expected = {
            self.registry[call]
            for call in self.find_calls(function_body, defined)
        }
        if not expected:
            return set()
        existing = parsed.get("depends")
        existing_set = (
            {entry for entry in existing if isinstance(entry, str)}
            if isinstance(existing, list)
            else set()
        )
        return expected - existing_set


class ShoedocLinter:
    """Validate and optionally repair JSON Shoedoc annotations."""

    def __init__(
        self,
        rules=None,
        parser=None,
        analyzer=None,
        serializer=None,
        fixer=None,
        validator=None,
    ):
        self.validator = ShoedocValidator() if validator is None else validator
        fixer = ShoedocFixer(self.validator) if fixer is None else fixer
        if rules is None:
            rules = (
                ShoedocRule(("namespace",), self.validator),
                ShoedocRule(ARRAY_KEYS, self.validator),
                ShoedocRule(
                    ("authors", "examples", "links", "shell", "private",
                     "summary")
                    + STRING_PROPERTIES,
                    self.validator,
                ),
                ShoedocRule(ENTRY_ARRAY_KEYS, self.validator),
            )
        self.rules = tuple(rules)
        self.fixer = fixer
        self.parser = ShoedocParser(fixer) if parser is None else parser
        self.analyzer = analyzer
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )

    def validate(self, parsed, source: str, body: str = "",
                 scope: str = "function") -> tuple:
        """Validate a parsed shoedoc block. `scope` is "function" or
        "script": script-level blocks cannot own namespace, requires or
        the std stream properties."""
        if not isinstance(parsed, dict):
            return [f"{source}: shoedoc block is not a JSON object"], []
        errors = []
        for key, value in parsed.items():
            if scope == "script" and key in SCRIPT_FORBIDDEN_PROPERTIES:
                errors.append(f"script block cannot own a '{key}' property")
                continue
            rule = next((candidate for candidate in self.rules
                         if candidate.supports(key)), None)
            if rule is None:
                errors.append(f"unknown property: '{key}'")
            else:
                rule.validate(key, value, errors)
        if body:
            for key in ARRAY_KEYS:
                value = parsed.get(key)
                if isinstance(value, list) and all(
                    isinstance(item, str) for item in value
                ):
                    self.validator.check_string_array_usage(
                        value, key, body, errors
                    )
        warnings = []
        if "namespace" not in parsed and scope != "script":
            warnings.append("missing 'namespace' property")
        return (
            [f"{source}: {error}" for error in errors],
            [f"{source}: {warning}" for warning in warnings],
        )

    def _lint_script_envelope(self, path, run_indexes: list, span: tuple,
                              boundary: int, stripped: list, fix: bool,
                              body: str, replacements: list) -> tuple:
        """Validate (and optionally repair) one script-level JSON envelope.
        `boundary` is the index of the first stripped line owned by this
        envelope (its preceding bare summary lines included). Returns
        (errors, warnings)."""
        parser = self.parser
        fixer = self.fixer
        first_open, last_close = span
        envelope_start = run_indexes[first_open]
        source = f"{path}:{envelope_start + 1}"
        json_text = parser.envelope_json_text(stripped, first_open, last_close)
        try:
            parsed = parser.parse_json(json_text)
        except json.JSONDecodeError as error:
            parsed = None
            errors = [f"{source}: invalid shoedoc JSON: {error}"]
            warnings = []
        else:
            errors, warnings = self.validate(parsed, source, body, "script")
        unordered = (
            fixer.requires_ordering(parsed)
            if isinstance(parsed, dict) else False
        )
        bare_summary_texts = [
            text
            for text in (
                line.strip() for line in stripped[boundary:first_open]
            )
            if text
        ]
        if not fix or not (
            errors or unordered
            or (bare_summary_texts and isinstance(parsed, dict)
                and "summary" not in parsed)
            or parsed is None
        ):
            return errors, warnings
        # -- Repair: try to parse the stripped envelope leniently
        fixes = []
        envelope_stripped = stripped[first_open:last_close + 1]
        repaired = fixer.remove_dangling_commas(envelope_stripped, fixes)
        repaired = fixer.merge_orphan_depends_lines(repaired, fixes)
        repaired = fixer.remove_dangling_commas(repaired, fixes)
        try:
            fixed_parsed = parser.parse_json("\n".join(repaired))
        except json.JSONDecodeError:
            fixed_parsed = None
        if fixed_parsed is None:
            return errors, warnings
        # a script block owns neither namespace nor requires/depends
        # entries: nothing to add, nothing to re-namespace
        fixed_parsed, fix_fixes = fixer.fix_dictionary(
            fixed_parsed, body, {}, None, None,
        )
        fixes.extend(fix_fixes)
        folded = False
        if bare_summary_texts and "summary" not in fixed_parsed:
            fixed_parsed = fixer.fold_summary_property(
                fixed_parsed, "\n".join(bare_summary_texts)
            )
            fixes.append("folded summary lines into 'summary'")
            folded = True
        post_errors, post_warnings = self.validate(
            fixed_parsed, source, body, "script"
        )
        # when the original block could not be parsed at all, its errors
        # were masked by the parse failure: any repaired state is an
        # improvement
        new_errors = (
            [error for error in post_errors if error not in errors]
            if parsed is not None else []
        )
        if not fixes or new_errors:
            return errors, warnings
        replace_start = run_indexes[boundary] if folded else envelope_start
        replace_len = run_indexes[last_close] - replace_start + 1
        replacements.append((
            replace_start, replace_len,
            self.serializer.json_envelope_lines(fixed_parsed),
        ))
        print(f"fixed: {source} ({', '.join(sorted(fixes))})")
        return post_errors, post_warnings

    def lint(self, folder, fix: bool = False) -> int:
        """Lint (and optionally repair) the shoedoc blocks of every .sh
        file under `folder`, skipping build artifacts."""
        folder = Path(folder)
        if not folder.is_dir():
            print(f"error: not a directory: {folder}", file=sys.stderr)
            return 2

        parser = self.parser
        if self.analyzer is None:
            analyzer = StaticAnalyzer()
        else:
            analyzer = self.analyzer
        registry = analyzer.registry
        serializer = self.serializer
        fixer = self.fixer
        count = warnings_count = blocks = 0
        failed = False
        for path in sorted(folder.rglob("*.sh")):
            if "build" in path.parts:
                # build artifacts are not scanned
                continue
            content = path.read_text(encoding="utf-8", errors="replace")
            file_lines = content.splitlines(keepends=True)

            # -- Step 1: capture the functions' annotations first
            annotations = parser.capture_function_annotations(file_lines)
            script_indexes = parser.script_metadata_indices(file_lines)
            if not annotations and not script_indexes:
                continue

            annotation_spans = {
                index
                for record in annotations
                for index in record.line_indexes
            }
            body = analyzer.sanitizer.sanitize("".join(
                line for index, line in enumerate(file_lines)
                if index not in annotation_spans
            ))[0]
            defined = analyzer.find_defined_functions(file_lines)
            replacements = []

            # A run may hold several balanced envelopes: the script header
            # envelope(s) come first, the function annotation is the last
            # one. Precompute the spans and remember which envelope each
            # function annotation ends with, so that the script-level
            # pre-pass can leave it alone.
            record_spans = []
            for record in annotations:
                record_stripped = parser.strip_shoedoc_prefixes(record.lines)
                record_state = parser.envelope_state(record_stripped)
                record_envelope_spans = (
                    parser.envelope_spans(record_stripped)
                    if record_state == "envelope" else None
                )
                record_spans.append((record, record_stripped, record_state,
                                     record_envelope_spans))
            function_span_starts = {
                record.line_indexes[spans[-1][0]]
                for _record, _stripped, _state, spans in record_spans if spans
            }
            processed_spans = set()

            def process_script_envelope(span_indexes, span_bounds, boundary,
                                        span_stripped):
                """Validate (or repair) one script-level envelope once."""
                nonlocal blocks, count, warnings_count, failed
                start_index = span_indexes[span_bounds[0]]
                if start_index in processed_spans:
                    return
                processed_spans.add(start_index)
                blocks += 1
                errors, warnings = self._lint_script_envelope(
                    path, span_indexes, span_bounds, boundary, span_stripped,
                    fix, body, replacements,
                )
                if errors:
                    failed = True
                    count += len(errors)
                    for error in errors:
                        print(f"error: {error}")
                if warnings:
                    warnings_count += len(warnings)
                    for warning in warnings:
                        print(f"warning: {warning}")

            # -- Step 1b: the script-level annotation (the file's first
            #    shoedoc run). Every envelope it holds is a script block,
            #    except the last one when it is the annotation of a
            #    function directly adjacent (no blank line in between).
            if script_indexes:
                script_lines = [
                    file_lines[index].rstrip("\r\n") for index in script_indexes
                ]
                script_stripped = parser.strip_shoedoc_prefixes(script_lines)
                if parser.envelope_state(script_stripped) == "envelope":
                    script_spans = parser.envelope_spans(script_stripped)
                    if script_spans:
                        for span_index, span_bounds in enumerate(
                            script_spans
                        ):
                            if (
                                span_index == len(script_spans) - 1
                                and script_indexes[span_bounds[0]]
                                in function_span_starts
                            ):
                                continue
                            process_script_envelope(
                                script_indexes, span_bounds,
                                (
                                    script_spans[span_index - 1][1] + 1
                                    if span_index else 0
                                ),
                                script_stripped,
                            )

            for record, stripped, state, record_envelope_spans in record_spans:
                function_line_index = record.function_line_index
                function_name = record.function_name
                run_indexes = record.line_indexes
                if state == "bare":
                    if not fix:
                        warnings_count += 1
                        print(
                            f"warning: {path}:{function_line_index + 1}: "
                            f"invalid shoedoc: no '## {{' ... '## }}' JSON "
                            f"block around the annotation lines of function "
                            f"'{function_name}'"
                        )
                        continue
                    summary_texts = [
                        stripped.strip()
                        for stripped in (
                            parser.strip_shoedoc_prefix(line)
                            for line in record.lines
                        )
                    ]
                    summary_texts = [text for text in summary_texts if text]
                    namespace_value = os.path.relpath(
                        path.parent, Path.cwd()
                    )
                    function_source = analyzer.function_body_below(
                        file_lines, function_line_index
                    )
                    expected_calls = {
                        registry[call]
                        for call in analyzer.find_calls(
                            function_source or "", defined
                        )
                    }
                    expected_commands = analyzer.find_external_commands(
                        function_source or "", defined
                    )
                    generated = {"namespace": namespace_value}
                    if summary_texts:
                        generated["summary"] = "\n".join(summary_texts)
                    if expected_commands:
                        generated["requires"] = sorted(expected_commands)
                    if expected_calls:
                        generated["depends"] = sorted(expected_calls)
                    insertion_source = f"{path}:{function_line_index + 1}"
                    post_errors, _ = self.validate(
                        generated, insertion_source, body
                    )
                    if post_errors:
                        warnings_count += 1
                        print(
                            f"warning: {path}:{function_line_index + 1}: "
                            f"invalid shoedoc: no '## {{' ... '## }}' JSON "
                            f"block around the annotation lines of function "
                            f"'{function_name}'"
                        )
                        for error in post_errors:
                            print(f"error: {error}")
                            count += 1
                            failed = True
                        continue
                    replacements.append((
                        run_indexes[0],
                        run_indexes[-1] - run_indexes[0] + 1,
                        serializer.json_envelope_lines(generated),
                    ))
                    print(f"fixed: {insertion_source} (generated JSON block)")
                    continue
                if state == "unclosed":
                    warnings_count += 1
                    print(
                        f"warning: {path}:{run_indexes[0] + 1}: malformed "
                        f"shoedoc: '## {{' without matching '## }}'"
                    )
                    continue

                # -- Step 3: parse the envelope like a normal JSON document
                blocks += 1
                if record_envelope_spans:
                    # the last envelope is the function annotation; the
                    # earlier ones belong to the script header
                    for span_index in range(len(record_envelope_spans) - 1):
                        process_script_envelope(
                            run_indexes, record_envelope_spans[span_index],
                            (
                                record_envelope_spans[span_index - 1][1] + 1
                                if span_index else 0
                            ),
                            stripped,
                        )
                    first_open, last_close = record_envelope_spans[-1]
                    boundary = (
                        record_envelope_spans[-2][1] + 1
                        if len(record_envelope_spans) > 1 else 0
                    )
                else:
                    first_open, last_close = parser.locate_envelope(stripped)
                    boundary = 0
                envelope_start = run_indexes[first_open]
                envelope_end = run_indexes[last_close]
                bare_summary_texts = [
                    text
                    for text in (
                        line.strip() for line in stripped[boundary:first_open]
                    )
                    if text
                ]
                source = f"{path}:{envelope_start + 1}"
                json_text = parser.envelope_json_text(
                    stripped, first_open, last_close
                )
                try:
                    parsed = parser.parse_json(json_text)
                except json.JSONDecodeError as error:
                    parsed = None
                    errors = [f"{source}: invalid shoedoc JSON: {error}"]
                    warnings = []
                else:
                    errors, warnings = self.validate(parsed, source, body)
                function_source = analyzer.function_body_below(
                    file_lines, envelope_end + 1
                )
                missing = analyzer.missing_depends(
                    parsed, function_source, defined
                )
                if missing:
                    for entry in sorted(missing):
                        warnings.append(
                            f'{source}: \'depends\' missing entry: "{entry}"'
                        )
                requires_missing = (
                    analyzer.missing_requires(parsed, function_source, defined)
                    if fix else set()
                )
                unordered_properties = fixer.requires_ordering(parsed)
                namespace_value = os.path.relpath(path.parent, Path.cwd())
                # a root-level file has no valid relative namespace ("." is
                # not a valid relative path): namespace insertion/repair is
                # then skipped
                if not REL_PATH_RE.match(namespace_value):
                    namespace_value = None
                missing_namespace = parsed is not None and any(
                    warning.endswith("missing 'namespace' property")
                    for warning in warnings
                ) and fix and namespace_value is not None
                wrong_namespace = None
                if (
                    fix and isinstance(parsed, dict)
                    and namespace_value is not None
                ):
                    value = parsed.get("namespace")
                    if (
                        isinstance(value, str)
                        and not Path(value).is_dir()
                    ):
                        wrong_namespace = namespace_value
                if fix and (
                    errors or missing_namespace
                    or wrong_namespace is not None
                    or missing
                    or requires_missing
                    or unordered_properties
                    or (
                        bare_summary_texts
                        and isinstance(parsed, dict)
                        and "summary" not in parsed
                    )
                ):
                    # -- Repair: try to parse the stripped envelope
                    #    leniently
                    fixes = []
                    envelope_stripped = stripped[first_open:last_close + 1]
                    repaired = fixer.remove_dangling_commas(
                        envelope_stripped, fixes
                    )
                    repaired = fixer.merge_orphan_depends_lines(repaired, fixes)
                    repaired = fixer.remove_dangling_commas(repaired, fixes)
                    try:
                        fixed_parsed = parser.parse_json("\n".join(repaired))
                    except json.JSONDecodeError:
                        fixed_parsed = None
                    if fixed_parsed is not None:
                        if parsed is None:
                            # the original block could not be parsed: its
                            # missing entries are computed against the
                            # repaired block instead
                            missing = analyzer.missing_depends(
                                fixed_parsed, function_source, defined
                            )
                            requires_missing = analyzer.missing_requires(
                                fixed_parsed, function_source, defined
                            )
                        fixed_parsed, fix_fixes = fixer.fix_dictionary(
                            fixed_parsed, body,
                            {
                                "depends": missing if missing else (),
                                "requires": (
                                    requires_missing if requires_missing
                                    else ()
                                ),
                            },
                            namespace_value if missing_namespace else None,
                            wrong_namespace,
                        )
                        fixes.extend(fix_fixes)
                        folded = False
                        if (
                            fixed_parsed is not None
                            and bare_summary_texts
                            and "summary" not in fixed_parsed
                        ):
                            fixed_parsed = fixer.fold_summary_property(
                                fixed_parsed, "\n".join(bare_summary_texts)
                            )
                            fixes.append(
                                "folded summary lines into 'summary'"
                            )
                            folded = True
                        post_errors, post_warnings = self.validate(
                            fixed_parsed, source, body
                        )
                        # when the original block could not be parsed at
                        # all, its errors were masked by the parse failure:
                        # any repaired state is an improvement
                        new_errors = (
                            [
                                error for error in post_errors
                                if error not in errors
                            ]
                            if parsed is not None
                            else []
                        )
                        if fixes and not new_errors and not (
                            analyzer.missing_depends(
                                fixed_parsed, function_source, defined
                            )
                        ) and not (
                            analyzer.missing_requires(
                                fixed_parsed, function_source, defined
                            )
                        ):
                            new_block = serializer.json_envelope_lines(
                                fixed_parsed
                            )
                            # when the run holds several envelopes, the
                            # bare summary lines start after the previous
                            # envelope: the replacement must not swallow
                            # the script header
                            single_span = (
                                record_envelope_spans is None
                                or len(record_envelope_spans) == 1
                            )
                            replace_start = (
                                run_indexes[0] if folded and single_span
                                else envelope_start
                            )
                            replace_len = (
                                envelope_end - replace_start + 1
                            )
                            replacements.append(
                                (replace_start, replace_len, new_block)
                            )
                            print(
                                f"fixed: {source} "
                                f"({', '.join(sorted(fixes))})"
                            )
                            warnings = post_warnings
                            # the repaired errors are gone; pre-existing
                            # ones (namespace folder, depends paths, ...)
                            # still hold against the rewritten block and
                            # keep being reported
                            errors = post_errors
                if errors:
                    failed = True
                    count += len(errors)
                    for error in errors:
                        print(f"error: {error}")
                if warnings:
                    warnings_count += len(warnings)
                    for warning in warnings:
                        print(f"warning: {warning}")
            if replacements:
                for opened, old_len, new_block in reversed(replacements):
                    file_lines[opened:opened + old_len] = new_block
                path.write_text("".join(file_lines))
        if failed:
            print(
                f"{blocks} block(s) checked, {count} error(s), "
                f"{warnings_count} warning(s)"
            )
            return 1
        print(
            f"{blocks} block(s) checked, no error, "
            f"{warnings_count} warning(s)"
        )
        return 0


class ShoedocConverter:
    """Convert classic tag blocks and JSON Shoedoc envelopes."""

    def __init__(self, parser=None, serializer=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )

    def convert_content(self, content: str, direction: str) -> tuple:
        """Convert the legitimate annotation runs of `content` between
        classic tags and JSON envelopes. Runs are the script metadata and
        the annotations attached to function definitions; comment lines
        inside function bodies (notably heredoc payloads) are left
        untouched."""
        if direction not in ("json", "tags"):
            raise ValueError("direction must be 'json' or 'tags'")
        lines = content.split("\n")
        runs = self.parser.annotation_runs(lines)
        output = []
        converted = 0
        had_error = False
        index = 0
        while index < len(lines):
            if index in runs:
                run_indexes = runs[index]
                run_lines, run_converted, run_error = self._convert_run(
                    [lines[position] for position in run_indexes],
                    run_indexes,
                    direction,
                    index,
                )
                output.extend(run_lines)
                converted += run_converted
                had_error = had_error or run_error
                index = run_indexes[-1] + 1
                continue
            output.append(lines[index])
            index += 1
        return "\n".join(output), converted, had_error

    def _convert_run(self, chunk: list, run_indexes: list, direction: str,
                     base_index: int) -> tuple:
        """Convert one annotation run according to `direction`. Returns
        (output_lines, converted, had_error)."""
        if direction == "json":
            return self._convert_run_to_json(chunk, run_indexes, base_index)
        return self._convert_run_to_tags(chunk, run_indexes)

    def _convert_run_to_json(self, chunk: list, run_indexes: list,
                             base_index: int) -> tuple:
        """Convert a classic tag run to a JSON envelope; runs already
        carrying a JSON envelope (or carrying no tag at all) are left
        untouched."""
        if any(self.parser.is_json_block_start(item) for item in chunk):
            return chunk, 0, False
        parsed, warnings = self.parser.parse_classic_block(
            chunk, base_index
        )
        if parsed is None:
            return chunk, 0, False
        for warning in warnings:
            sys.stderr.write(warning)
        return self.serializer.json_comment_lines(parsed), 1, False

    def _convert_run_to_tags(self, chunk: list, run_indexes: list) -> tuple:
        """Convert the JSON envelope(s) carried by a run to classic tags;
        every other line of the run is passed through unchanged."""
        output = []
        converted = 0
        had_error = False
        cursor = 0
        while cursor < len(chunk):
            line = chunk[cursor]
            if self.parser.is_json_block_start(line):
                json_text, end_index = self.parser.extract_json_block(
                    chunk, cursor
                )
                if json_text is None:
                    output.append(line)
                    cursor += 1
                    continue
                try:
                    parsed = json.loads(json_text)
                    classic_lines = self.serializer.json_to_classic(parsed)
                except (json.JSONDecodeError, TypeError):
                    classic_lines = None
                if classic_lines is None:
                    sys.stderr.write(
                        "error: invalid JSON in shoedoc block at line %d\n"
                        % (run_indexes[cursor] + 1)
                    )
                    had_error = True
                    output.extend(chunk[cursor:end_index + 1])
                else:
                    output.extend(classic_lines)
                    converted += 1
                cursor = end_index + 1
                continue
            output.append(line)
            cursor += 1
        return output, converted, had_error

    @staticmethod
    def collect_files(path: str) -> tuple:
        """Return (files, errors) for a file or directory path: only .sh
        files are accepted."""
        source = Path(path)
        if source.is_file():
            if source.suffix != ".sh":
                return [], [f'error: expected a .sh file: "{source}"']
            return [str(source)], []
        if source.is_dir():
            return [
                str(file_path)
                for file_path in FileHandler.walk_paths(source, recursive=True)
                if file_path.suffix == ".sh"
            ], []
        return [], [f'error: not a file or directory: "{source}"']

    def convert_paths(self, paths: list, direction="tags", dry_run=False) -> int:
        exit_code = 0
        expanded = []
        seen = set()
        for raw_path in paths:
            files, errors = self.collect_files(raw_path)
            for error in errors:
                sys.stderr.write(error + "\n")
                exit_code = 1
            for file_path in files:
                if file_path not in seen:
                    seen.add(file_path)
                    expanded.append(file_path)

        for file_path in expanded:
            try:
                with open(file_path, "r", encoding="utf-8",
                          errors="replace") as source_file:
                    content = source_file.read()
            except OSError as error:
                sys.stderr.write(
                    "error: cannot read %s: %s\n" % (file_path, error)
                )
                exit_code = 1
                continue
            new_content, converted, had_error = self.convert_content(
                content, direction
            )
            if had_error:
                exit_code = 1
            if converted == 0:
                continue
            if dry_run:
                sys.stdout.write("==> %s <==\n" % file_path)
                sys.stdout.write(new_content)
                if not new_content.endswith("\n"):
                    sys.stdout.write("\n")
            else:
                if new_content != content:
                    with open(file_path, "w") as destination:
                        destination.write(new_content)
                sys.stderr.write(
                    "Converted: %s (%d block(s))\n" % (file_path, converted)
                )
        return exit_code


class ShellFunctionParser:
    """Find shell function declarations and extract their source blocks."""

    FUNCTION_HEADER_RE = re.compile(
        r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)"
    )

    def __init__(self, source: str, sanitizer=None):
        self.lines = source.splitlines(keepends=True)
        self.sanitizer = ShellSanitizer() if sanitizer is None else sanitizer

    def function_definitions(self) -> list:
        definitions = []
        for index, line in enumerate(self.lines):
            match = self.FUNCTION_HEADER_RE.match(line.rstrip("\r\n"))
            if match:
                definitions.append((match.group(1), index))
        return definitions

    def function_names(self, include_private: bool = True) -> list:
        return [
            name for name, _index in self.function_definitions()
            if include_private or not name.startswith("_")
        ]

    def extract_function(self, name: str) -> str:
        function_index = next(
            (
                index for function_name, index in self.function_definitions()
                if function_name == name
            ),
            None,
        )
        if function_index is None:
            raise KeyError(f"function not found: {name}")

        annotation_start = function_index
        while (
            annotation_start > 0
            and self.lines[annotation_start - 1].startswith("#")
        ):
            annotation_start -= 1

        body = []
        brace_depth = 0
        function_started = False
        heredoc = None
        for index in range(function_index, len(self.lines)):
            line = self.lines[index]
            body.append(line)
            sanitized, heredoc = self.sanitizer.sanitize(line, heredoc)
            brace_depth += sanitized.count("{") - sanitized.count("}")
            if brace_depth > 0:
                function_started = True
            elif index == function_index and "{" in sanitized:
                function_started = True
            if function_started and brace_depth <= 0:
                break
        return "".join(self.lines[annotation_start:function_index] + body)


class ShoemakerPathResolver:
    """Resolve command inputs and prepare their output directories."""

    @staticmethod
    def require_file(file_path, suffix=None) -> Path:
        path = Path(file_path).expanduser()
        if not path.is_file():
            raise FileNotFoundError(f'file not found: "{file_path}"')
        path = path.resolve()
        if suffix is not None and path.suffix != suffix:
            raise ValueError(f'file should be type "{suffix}"')
        return path

    @staticmethod
    def output_directory(destination, default, create=False) -> Path:
        target = Path(destination).expanduser() if destination else default
        target = target.resolve()
        if create:
            target.mkdir(parents=True, exist_ok=True)
        elif not target.is_dir():
            raise NotADirectoryError(f'folder not found: "{target}"')
        return target


class RecipeCommandService:
    """Implement source extraction and build-list commands."""

    def __init__(self, paths=None, function_parser_factory=None):
        self.paths = ShoemakerPathResolver() if paths is None else paths
        self.function_parser_factory = (
            ShellFunctionParser
            if function_parser_factory is None
            else function_parser_factory
        )

    def dump(self, file_path, destination=None) -> Path:
        source = self.paths.require_file(file_path)
        output_dir = self.paths.output_directory(
            destination, Path.cwd() / "dump" / source.stem, create=True
        )
        functions = self.function_parser_factory(
            source.read_text(encoding="utf-8")
        )
        for name in functions.function_names(include_private=True):
            body = functions.extract_function(name)
            output = "#!/bin/sh\n\n" + body
            if not output.endswith("\n"):
                output += "\n"
            (output_dir / f"{name}.sh").write_text(
                output, encoding="utf-8"
            )
        return output_dir

    def list(self, file_path, destination=None) -> Path:
        source = self.paths.require_file(file_path)
        output_dir = self.paths.output_directory(
            destination, Path.cwd() / "dump" / source.stem, create=True
        )
        names = self.function_parser_factory(
            source.read_text(encoding="utf-8")
        ).function_names(include_private=True)
        output = output_dir / f"{source.stem}.shoe"
        content = "\n".join(f"{name}.sh" for name in names)
        if names:
            content += "\n"
        output.write_text(content, encoding="utf-8")
        return output

    def build(self, file_path, destination=None, script_type="shell") -> Path:
        recipe = self.paths.require_file(file_path)
        output_dir = self.paths.output_directory(
            destination, Path.cwd() / "build", create=True
        )
        if script_type not in ("shell", "sh", "bash"):
            raise ValueError("script type must be one of: shell, sh, bash")
        shell = "bash" if script_type == "bash" else "sh"

        pieces = []
        for entry in recipe.read_text(encoding="utf-8").splitlines():
            entry = entry.strip()
            if not entry or entry.startswith("#"):
                pieces.append(entry)
                continue
            component = recipe.parent / entry
            if not component.is_file():
                raise FileNotFoundError(
                    f'component file not found: "{component}"'
                )
            component_lines = component.read_text(
                encoding="utf-8"
            ).rstrip("\r\n").splitlines()
            # strip each component's own shebang: the built script carries
            # the requested interpreter line
            if component_lines and component_lines[0].startswith("#!"):
                component_lines = component_lines[1:]
            pieces.append("\n".join(component_lines))
        content = "#!/usr/bin/env %s\n" % shell
        if pieces:
            content += "\n".join(pieces) + "\n"
        content = re.sub(r"\n{3,}", "\n\n", content)

        name = recipe.name[:-5] if recipe.name.endswith(".shoe") else recipe.name
        output = output_dir / f"{name}.sh"
        output.write_text(content, encoding="utf-8")
        return output


class DocumentationGenerator:
    """Generate Markdown documentation from Shoedoc annotations."""

    VARIABLE_RE = re.compile(r"^([A-Za-z0-9_]+)=(.*)$")

    def __init__(self, parser=None, serializer=None, paths=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )
        self.paths = ShoemakerPathResolver() if paths is None else paths

    def _script_variables(self, file_lines: list, include_private: bool) -> dict:
        parser = ShellFunctionParser("".join(file_lines))
        definitions = parser.function_definitions()
        first_function = min(
            (index for _name, index in definitions),
            default=len(file_lines),
        )
        sections = {"constants": [], "flags": [], "options": [], "private": []}
        description = None
        for raw_line in file_lines[:first_function]:
            line = raw_line.rstrip("\r\n")
            if line.startswith("## "):
                description = line[3:].strip()
                continue
            match = self.VARIABLE_RE.match(line)
            if match is None:
                if not line.startswith("#"):
                    description = None
                continue
            name, value = match.groups()
            is_constant = name.upper() == name
            is_private = name.startswith("_") or not description
            item = {
                "name": name,
                "description": description or "",
                "value": value,
                "private": is_private,
            }
            if is_constant:
                if description or include_private:
                    sections["constants"].append(item)
            elif value == "false" and description and not name.startswith("_"):
                sections["flags"].append(item)
            elif description and not name.startswith("_"):
                sections["options"].append(item)
            elif include_private and name.startswith("_"):
                sections["private"].append(item)
            description = None
        return sections

    @staticmethod
    def _entry_synopsis(name: str, metadata: dict) -> str:
        arguments = [name]
        for entry in metadata.get("params", []):
            parameter = entry.get("name")
            if not parameter:
                continue
            if entry.get("required") is True:
                arguments.append(f"<{parameter}>")
            else:
                arguments.append(f"[{parameter}]")
        for entry in metadata.get("options", []):
            option = entry.get("long") or entry.get("short") or entry.get("name")
            if not option:
                continue
            option = f"--{option}" if entry.get("long") else f"-{option}"
            token = f"{option} VALUE"
            arguments.append(token if entry.get("required") else f"[{token}]")
        for entry in metadata.get("flags", []):
            flag = entry.get("long") or entry.get("short") or entry.get("name")
            if flag:
                arguments.append(f"--{flag}" if entry.get("long") else f"-{flag}")
        return " ".join(arguments)

    def _render(self, source: Path, file_lines: list, metadata: dict,
                include_private: bool) -> str:
        title = metadata.get("summary") or metadata.get("name") or source.stem
        description = metadata.get("description", "")
        lines = [f"## {title}", "", "===", "", "## ℹ️ Infos", ""]

        authors = metadata.get("authors", [])
        author = metadata.get("author")
        if not author and authors:
            author = self.serializer.format_author(authors[0])
        info_rows = [
            ("author", author),
            ("version", metadata.get("version")),
        ]
        info_rows.extend(
            ("link", link) for link in metadata.get("links", [])
            if isinstance(link, str)
        )
        for label, value in info_rows:
            if value:
                lines.append(f"- {label}:  {value}")
        lines.extend(["", "## 📑 Description", "", str(description), ""])

        variable_sections = self._script_variables(file_lines, include_private)
        usage = []
        for item in variable_sections["flags"]:
            usage.append(f"(--{item['name']})")
        for item in variable_sections["options"]:
            usage.append(f"(--{item['name']} {item['value']})")
        lines.extend([
            "## 🔥 Usage",
            "",
            "`sh %s [command]%s`" % (
                source.name, (" " + " ".join(usage)) if usage else ""
            ),
            "",
        ])

        self._append_variable_section(
            lines, "## 🧱 Constants", variable_sections["constants"], "constant"
        )
        self._append_variable_section(
            lines, "## ⚙️ Global Variables", variable_sections["private"], "private"
        )
        self._append_variable_section(
            lines, "## 🚩 Flags", variable_sections["flags"], "flag"
        )
        self._append_variable_section(
            lines, "## ⚙️ Options", variable_sections["options"], "option"
        )

        functions = []
        for annotation, function_metadata in self.parser.parse_function_metadata(
            file_lines
        ):
            name = annotation.function_name
            private = bool(function_metadata.get("private")) or name.startswith("_")
            if private and not include_private:
                continue
            functions.append((annotation, function_metadata, private))

        lines.extend(["## 🤖 Commands", ""])
        current_namespace = None
        for index, (annotation, function_metadata, private) in enumerate(
            functions, start=1
        ):
            namespace = function_metadata.get("namespace")
            if namespace and namespace != current_namespace:
                current_namespace = namespace
                lines.extend([f"### ⚡ {namespace.upper()}", ""])
            scope = "private" if private else "public"
            summary = function_metadata.get("summary", "")
            lines.extend([
                f"#### ⌨️ {index}. `{annotation.function_name}` ({scope})",
                "",
                str(summary),
                "",
                "> Synopsis:",
                f"> `{self._entry_synopsis(annotation.function_name, function_metadata)}`",
                "",
            ])
            if function_metadata.get("requires"):
                required = ", ".join(
                    f"`{value}`" for value in function_metadata["requires"]
                )
                lines.extend([f"- ⚠️ Requires: {required}", ""])
            if function_metadata.get("depends"):
                depends = ", ".join(
                    f"`{value}`" for value in function_metadata["depends"]
                )
                lines.extend([f"- 🔗 Depends: {depends}", ""])
        return "\n".join(lines).rstrip() + "\n"

    @staticmethod
    def _append_variable_section(lines: list, heading: str, items: list,
                                 kind: str) -> None:
        if not items:
            return
        lines.extend([heading, ""])
        for index, item in enumerate(items, start=1):
            name = item["name"]
            private_label = " (private)" if item["private"] else ""
            if kind == "constant":
                lines.extend([
                    f"{index}. **{name}{private_label}**",
                    f"> {item['description']}",
                    f"  - Value: _{item['value']}_",
                    "",
                ])
            elif kind == "private":
                lines.extend([
                    f"{index}. **`{name}` (private)**",
                    f"> {item['description']}",
                    f"  - 🚩 Default: _{item['value']}_",
                    "",
                ])
            else:
                switch = "--" + name
                lines.extend([
                    f"{index}. **`{switch}`{private_label}**",
                    f"> {item['description']}",
                ])
                if kind == "option":
                    lines.append(f"  - 🚩 Default: _{item['value']}_")
                lines.append("")

    def generate(self, file_path, destination=None, private=False,
                 output_file_name=None) -> Path:
        source = self.paths.require_file(file_path, suffix=".sh")
        output_dir = self.paths.output_directory(destination, source.parent)
        output_name = output_file_name or f"{source.stem}.md"
        file_lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
        metadata = self.parser.parse_script_metadata(file_lines)
        content = self._render(source, file_lines, metadata, private)
        output = output_dir / output_name
        output.write_text(content, encoding="utf-8")
        return output


class MakefileGenerator:
    """Generate a Makefile that dispatches to documented shell functions."""

    COLORS = {
        "_PRIMARY": r"\033[0;34m",
        "_SECONDARY": r"\033[0;36m",
        "_SUCCESS": r"\033[0;32m",
        "_DANGER": r"\033[0;31m",
        "_WARNING": r"\033[0;33m",
        "_INFO": r"\033[0;36m",
        "_LIGHT": r"\033[0;37m",
        "_DARK": r"\033[0;30m",
        "_DEFAULT": r"\033[0m",
        "_EOL": r"\033[0m",
        "_ALERT_PRIMARY": r"\033[1;34m",
        "_ALERT_SECONDARY": r"\033[1;36m",
        "_ALERT_SUCCESS": r"\033[1;32m",
        "_ALERT_DANGER": r"\033[1;31m",
        "_ALERT_WARNING": r"\033[1;33m",
        "_ALERT_INFO": r"\033[1;36m",
        "_ALERT_LIGHT": r"\033[1;37m",
        "_ALERT_DARK": r"\033[1;30m",
    }

    def __init__(self, parser=None, paths=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.paths = ShoemakerPathResolver() if paths is None else paths

    def _render(self, source: Path, file_lines: list, metadata: dict,
                script_ref: str) -> str:
        title = metadata.get("summary") or metadata.get("name") or source.stem
        description = " ".join(
            str(metadata.get("description", "")).splitlines()
        )
        author = metadata.get("author")
        if not author and metadata.get("authors"):
            author = ShoedocSerializer.format_author(metadata["authors"][0])
        links = [
            link for link in metadata.get("links", [])
            if isinstance(link, str)
        ]
        header = [
            f"## {title}",
            "##",
            f"## {description}",
            "##",
            f"## @version {metadata.get('version', '')}",
            f"## @author  {author or ''}",
            f"## @license {metadata.get('license', '')}",
            *[f"## @link    {link}" for link in links],
            "",
            "",
        ]

        annotated = {}
        sections = {}
        section = ""
        for index, line in enumerate(file_lines):
            raw = line.rstrip("\r\n")
            if raw.startswith("### "):
                section = raw[4:].strip()
            sections[index] = section
        for annotation, function_metadata in self.parser.parse_function_metadata(
            file_lines
        ):
            name = annotation.function_name
            if name.startswith("_") or name == "help":
                continue
            if function_metadata.get("private") is True:
                continue
            annotated[name] = (
                annotation, function_metadata,
                sections.get(annotation.function_line_index, ""),
            )

        names = list(annotated)
        lines = header + [".PHONY: help %s" % " ".join(names), ""]
        for name, value in self.COLORS.items():
            lines.append(f"{name} = {value}")
        lines.extend([
            "",
            "define _echo_primary",
            '\t@printf "$(_PRIMARY)%b$(_EOL)" $(1)',
            "endef",
            "define _echo_info",
            '\t@printf "$(_INFO)%b$(_EOL)" $(1)',
            "endef",
            "define _echo_success",
            '\t@printf "$(_SUCCESS)%b$(_EOL)" $(1)',
            "endef",
            "",
            "## Print this help",
            "help:",
            f"\t@printf '%s\\n' {shlex.quote(title)}",
            f"\t@printf '%s\\n' {shlex.quote(description)}",
            "\t@printf '%s\\n' 'Usage: make [command]'",
            "\t@printf '%s\\n' 'Commands:'",
        ])
        for name, (_annotation, function_metadata, _section) in annotated.items():
            summary = str(function_metadata.get("summary", ""))
            lines.append(
                f"\t@printf '  %-20s %s\\n' {shlex.quote(name)} "
                f"{shlex.quote(summary)}"
            )

        current_section = None
        for name, (_annotation, function_metadata, section) in annotated.items():
            if section and section != current_section:
                current_section = section
                lines.extend([
                    "",
                    "##################################################",
                    f"### {section}",
                    "##################################################",
                    "",
                ])
            summary = str(function_metadata.get("summary", ""))
            if summary:
                lines.append(f"## {summary}")
            lines.extend([
                f"{name}:",
                f'\t@printf "$(_INFO)sh {script_ref} {name}$(_EOL)\\n"',
                f"\t@sh {shlex.quote(script_ref)} {name}",
                "",
            ])
        return "\n".join(lines).rstrip() + "\n"

    def generate(self, file_path, destination=None,
                 output_file_name=None) -> Path:
        source = self.paths.require_file(file_path, suffix=".sh")
        output_dir = self.paths.output_directory(destination, source.parent)
        output_name = output_file_name or f"{source.stem}.makefile"
        file_lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
        metadata = self.parser.parse_script_metadata(file_lines)
        # reference the script by its resolved absolute path, so that
        # targets keep working whatever the make working directory or the
        # --destination folder is
        script_ref = str(source)
        content = self._render(source, file_lines, metadata, script_ref)
        output = output_dir / output_name
        output.write_text(content, encoding="utf-8")
        return output


class ShoedocMigrator:
    """Migrate legacy Shoedoc vocabularies independently of lint repairs."""

    def __init__(self, parser=None, serializer=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )

    @staticmethod
    def migrate_legacy_flag(flag_value: str) -> dict:
        """Split a legacy "flag" alias value into "short" / "long" fields:
        "-c" becomes {"short": "c"}, "--count" and bare multi-character
        names become {"long": ...}, bare single characters become
        short."""
        if flag_value.startswith("--"):
            return {"long": flag_value[2:]}
        if flag_value.startswith("-"):
            return {"short": flag_value[1:]}
        if len(flag_value) == 1:
            return {"short": flag_value}
        return {"long": flag_value}

    @staticmethod
    def migrate_legacy_name(name: str) -> str:
        """Collapse legacy option and flag names to their canonical
        name."""
        parts = [part for part in name.split("|") if part]
        return parts[-1] if parts else name

    @staticmethod
    def renumber_param_positions(params: list) -> bool:
        """Renumber params positions to match their rank in the array.
        Returns True when at least one position changed."""
        renumbered = False
        for index, entry in enumerate(params):
            if not isinstance(entry, dict):
                continue
            position = entry.get("position")
            if (
                not isinstance(position, int) or isinstance(position, bool)
                or position != index + 1
            ):
                entry["position"] = index + 1
                renumbered = True
        return renumbered

    @staticmethod
    def migrate_flag_typed_entries(entries: list, key: str,
                                   fixes: list) -> tuple:
        """Move entries whose "type" is "flag" out of params / options
        into the flags array, dropping the value-carrying fields a flag
        cannot own. Returns (kept_entries, moved_entries)."""
        kept = []
        moved = []
        for entry in entries:
            if isinstance(entry, dict) and entry.get("type") == "flag":
                entry = dict(entry)
                for field in FLAG_VALUE_FIELDS:
                    entry.pop(field, None)
                moved.append(entry)
            else:
                kept.append(entry)
        if moved:
            fixes.append(f"moved '{key}' entries typed 'flag' to 'flags'")
        return kept, moved

    @classmethod
    def migrate_legacy_parameters(cls, value: list, fixes: list) -> tuple:
        """Split the legacy "parameters" array into (params, options,
        flags) entry lists. An entry carrying a "flag" alias is an
        "option", or a "flag" when its type is a bool switch (its "type"
        and "default": false are then dropped, "default": true keeping
        the entry an option so the non-default value survives); the other
        entries stay "params". The "position" field is preserved on
        params entries and renumbered to match the array rank (options
        and flags are addressed by name and carry none). Pipe-separated
        parameter names are retained as aliases; legacy option and flag
        names keep their canonical final segment."""
        params = []
        options = []
        flags = []
        for entry in value:
            if not isinstance(entry, dict):
                params.append(entry)
                continue
            entry = dict(entry)
            for field in LEGACY_DROPPED_ENTRY_FIELDS:
                entry.pop(field, None)
            if entry.get("required") is True and entry.get("default") is None:
                if "default" in entry:
                    entry.pop("default")
                    fixes.append(
                        "removed null 'default' from required legacy "
                        "parameter"
                    )
            name = entry.get("name")
            flag_value = entry.pop("flag", None)
            if (
                flag_value is not None
                and isinstance(name, str)
                and "|" in name
            ):
                entry["name"] = cls.migrate_legacy_name(name)
                fixes.append("collapsed legacy pipe-separated 'name'")
            if flag_value is None:
                params.append(entry)
                continue
            entry.pop("position", None)
            entry.update(cls.migrate_legacy_flag(flag_value))
            if entry.get("type") == "bool" and entry.get("default") is not True:
                entry.pop("type", None)
                entry.pop("default", None)
                entry.pop("required", None)
                flags.append(entry)
            else:
                entry.pop("required", None)
                options.append(entry)
        params, flag_params = cls.migrate_flag_typed_entries(
            params, "params", fixes
        )
        options, flag_options = cls.migrate_flag_typed_entries(
            options, "options", fixes
        )
        flags.extend(flag_params + flag_options)
        if cls.renumber_param_positions(params):
            fixes.append("renumbered legacy 'position' fields")
        fixes.append("migrated legacy 'parameters' property")
        return params, options, flags

    @classmethod
    def migrate_legacy_properties(cls, parsed: dict, fixes: list) -> dict:
        """Migrate the previous-revision properties of a parsed shoedoc
        object to the current vocabulary: the "parameters" array is
        renamed to "params" (its flagged entries joining "options" /
        "flags"), entries typed "flag" are moved out of "params" /
        "options" into "flags", and the removed "arguments" / "return" /
        "returns" properties are dropped. Returns the input dict
        unchanged when it holds no legacy property."""
        migrated = {}
        pending = {"params": [], "options": [], "flags": []}
        has_legacy = False
        for key, value in parsed.items():
            if key in LEGACY_DROPPED_PROPERTIES:
                has_legacy = True
                fixes.append(f"removed legacy '{key}' property")
                continue
            if key == "link" and isinstance(value, str):
                # scripts may own several links: the singular legacy
                # property maps to the "links" array
                has_legacy = True
                fixes.append("migrated legacy 'link' property")
                migrated.setdefault("links", []).append(value)
                continue
            if key == LEGACY_ENTRY_ARRAY_KEY and isinstance(value, list):
                has_legacy = True
                params, options, flags = cls.migrate_legacy_parameters(
                    value, fixes
                )
                pending["params"].extend(params)
                pending["options"].extend(options)
                pending["flags"].extend(flags)
                continue
            migrated[key] = value
        moved_params = False
        for key in ("params", "options"):
            value = migrated.get(key)
            if not isinstance(value, list):
                continue
            kept, moved = cls.migrate_flag_typed_entries(value, key, fixes)
            if not moved:
                continue
            has_legacy = True
            if key == "params":
                moved_params = True
            if kept:
                migrated[key] = kept
            else:
                del migrated[key]
            pending["flags"].extend(moved)
        if not has_legacy:
            return parsed
        for key in ("params", "options", "flags"):
            if not pending[key]:
                continue
            existing = migrated.get(key)
            if isinstance(existing, list):
                existing.extend(pending[key])
            else:
                migrated[key] = pending[key]
        if moved_params and isinstance(migrated.get("params"), list):
            if cls.renumber_param_positions(migrated["params"]):
                fixes.append("renumbered 'position' fields")
        return migrated

    def migrate_content(self, content: str) -> tuple:
        """Migrate the JSON envelopes of every shoedoc run: the script
        header (the file's first run) and the function annotations."""
        file_lines = content.splitlines(keepends=True)
        replacements = []
        changes = []
        runs = []
        script_indexes = self.parser.script_metadata_indices(file_lines)
        if script_indexes:
            runs.append((None, script_indexes))
        for record in self.parser.capture_function_annotations(file_lines):
            runs.append((record.function_name, record.line_indexes))
        processed_spans = set()
        for function_name, indexes in runs:
            lines = [file_lines[index] for index in indexes]
            cursor = 0
            while cursor < len(lines):
                if not self.parser.is_json_block_start(lines[cursor]):
                    cursor += 1
                    continue
                json_text, end = self.parser.extract_json_block(
                    lines, cursor
                )
                if json_text is None:
                    cursor += 1
                    continue
                try:
                    parsed = self.parser.parse_json(json_text)
                except json.JSONDecodeError:
                    cursor = end + 1
                    continue
                if not isinstance(parsed, dict):
                    cursor = end + 1
                    continue
                # the script header run and a function run may share their
                # envelopes when the blocks are adjacent: migrate each
                # envelope only once
                start_line = indexes[cursor]
                if start_line not in processed_spans:
                    processed_spans.add(start_line)
                    fixes = []
                    migrated = self.migrate_legacy_properties(parsed, fixes)
                    if fixes:
                        end_line = indexes[end]
                        replacements.append((
                            start_line,
                            end_line - start_line + 1,
                            self.serializer.json_envelope_lines(migrated),
                        ))
                        changes.append((function_name, fixes))
                cursor = end + 1

        updated_lines = list(file_lines)
        for start, old_length, new_lines in reversed(replacements):
            updated_lines[start:start + old_length] = new_lines
        return "".join(updated_lines), len(replacements), changes

    @staticmethod
    def _collect_files(paths: list) -> tuple:
        files = []
        errors = []
        seen = set()
        for raw_path in paths:
            path = Path(raw_path).expanduser()
            try:
                candidates = list(
                    FileHandler.walk_paths(
                        path, recursive=True, include="*.sh"
                    )
                )
            except FileNotFoundError:
                errors.append(f'error: not a file or directory: "{path}"')
                continue
            for candidate in candidates:
                if candidate.suffix != ".sh":
                    errors.append(f'error: expected a .sh file: "{candidate}"')
                    continue
                resolved = candidate.resolve()
                if resolved not in seen:
                    seen.add(resolved)
                    files.append(resolved)
        return files, errors

    def migrate_paths(self, paths: list, dry_run=False) -> int:
        files, errors = self._collect_files(paths)
        for error in errors:
            Console.danger(error)
        exit_code = 1 if errors else 0
        migrated_total = 0

        for path in files:
            try:
                original = path.read_text(encoding="utf-8", errors="replace")
                updated, count, _changes = self.migrate_content(original)
                if count == 0:
                    continue
                migrated_total += count
                if dry_run:
                    Console.info(f"Would migrate {count} Shoedoc block(s): {path}")
                    sys.stdout.writelines(difflib.unified_diff(
                        original.splitlines(keepends=True),
                        updated.splitlines(keepends=True),
                        fromfile=str(path),
                        tofile=f"{path} (migrated)",
                    ))
                else:
                    path.write_text(updated, encoding="utf-8")
                    Console.success(f"Migrated {count} Shoedoc block(s): {path}")
            except OSError as error:
                Console.error(f"cannot migrate {path}: {error}")
                exit_code = 1

        if migrated_total == 0 and not errors:
            Console.info("No legacy Shoedoc blocks found.")
        return exit_code


class Console:
    """Semantic terminal output used by Shoemaker commands."""

    ALERT_PRIMARY = "\033[1;104;97m"
    ALERT_SECONDARY = "\033[1;45;97m"
    ALERT_SUCCESS = "\033[1;42;97m"
    ALERT_DANGER = "\033[1;41;97m"
    ALERT_WARNING = "\033[1;43;97m"
    ALERT_INFO = "\033[1;44;97m"
    ALERT_LIGHT = "\033[1;47;90m"
    ALERT_DARK = "\033[1;40;37m"
    PRIMARY = "\033[97m"
    SECONDARY = "\033[94m"
    SUCCESS = "\033[32m"
    DANGER = "\033[31m"
    WARNING = "\033[33m"
    INFO = "\033[95m"
    LIGHT = "\033[47;90m"
    DARK = "\033[40;37m"
    DEFAULT = "\033[0m"
    quiet = False

    @classmethod
    def _write(cls, text, color, stream=None, *, end="\n"):
        if cls.quiet:
            return
        stream = sys.stdout if stream is None else stream
        print(f"{color}{text}{cls.DEFAULT}", file=stream, end=end)

    @classmethod
    def primary(cls, text, *, end="\n"):
        cls._write(text, cls.PRIMARY, end=end)

    @classmethod
    def secondary(cls, text, *, end="\n"):
        cls._write(text, cls.SECONDARY, end=end)

    @classmethod
    def success(cls, text, *, end="\n"):
        cls._write(text, cls.SUCCESS, end=end)

    @classmethod
    def warning(cls, text, *, end="\n"):
        cls._write(text, cls.WARNING, end=end)

    @classmethod
    def info(cls, text, *, end="\n"):
        cls._write(text, cls.INFO, end=end)

    @classmethod
    def danger(cls, text, *, end="\n"):
        cls._write(text, cls.DANGER, sys.stderr, end=end)

    @classmethod
    def error(cls, text):
        cls.danger(f"error: {text}")

    @classmethod
    def alert_primary(cls, text):
        cls._alert(cls.ALERT_PRIMARY, text)

    @classmethod
    def alert_secondary(cls, text):
        cls._alert(cls.ALERT_SECONDARY, text)

    @classmethod
    def alert_success(cls, text):
        cls._alert(cls.ALERT_SUCCESS, text)

    @classmethod
    def alert_danger(cls, text):
        cls._alert(cls.ALERT_DANGER, text)

    @classmethod
    def alert_warning(cls, text):
        cls._alert(cls.ALERT_WARNING, text)

    @classmethod
    def alert_info(cls, text):
        cls._alert(cls.ALERT_INFO, text)

    @classmethod
    def alert_light(cls, text):
        cls._alert(cls.ALERT_LIGHT, text)

    @classmethod
    def alert_dark(cls, text):
        cls._alert(cls.ALERT_DARK, text)

    @classmethod
    def _alert(cls, color, text):
        if cls.quiet:
            return
        title = " ".join(str(text).splitlines())[:63]
        print(f"\n{color}{'':>64}{cls.DEFAULT}")
        print(f"{color} {title:<63}{cls.DEFAULT}")
        print(f"{color}{'':>64}{cls.DEFAULT}\n")


class NullLogger:
    """No-op logger for command runs without verbosity or log output."""

    def __getattr__(self, _name):
        return lambda *_args, **_kwargs: None


class Logger:
    """Write optional command logs and route verbose output to Console."""

    def __init__(self, verbose=0, quiet=False, script_file=None):
        self.verbose = verbose
        self.quiet = quiet
        self.script_file = (
            Path(script_file).resolve()
            if script_file is not None
            else Path(sys.argv[0]).resolve()
        )
        self.log_dir = self.script_file.parent / "log"
        self.log_file = self.log_dir / (
            f"{datetime.date.today().isoformat()}_"
            f"{self.script_file.stem}.log"
        )

    def print(self) -> bool:
        if not self.log_file.is_file():
            Console.error(f'"{self.log_file}" file not found.')
            return False
        if not self.quiet:
            Console.info(str(self.log_file))
            print(self.log_file.read_text(encoding="utf-8"), end="")
        return True

    def log(self, message: str, level=0) -> None:
        self.log_dir.mkdir(parents=True, exist_ok=True)
        level_name = ("ERROR", "SUCCESS", "WARNING", "INFO")[min(level, 3)]
        timestamp = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
        with self.log_file.open("a", encoding="utf-8") as log_file:
            log_file.write(f"{timestamp} {level_name} {message}\n")
        if self.verbose >= level and not self.quiet:
            output = (Console.danger, Console.success, Console.warning,
                      Console.info)[min(level, 3)]
            output(message)

    def info(self, message: str) -> None:
        self.log(message, 3)

    def warning(self, message: str) -> None:
        self.log(message, 2)

    def success(self, message: str) -> None:
        self.log(message, 1)

    def danger(self, message: str) -> None:
        self.log(message, 0)


class FileHandler:
    """Base handler for consistent file and directory traversal."""

    def __init__(self, logger=None):
        self.logger = NullLogger() if logger is None else logger
        self.files_processed = 0
        self.files_skipped = 0

    @staticmethod
    def walk_paths(input_path, *, recursive=False, include=None, exclude=None):
        path = Path(input_path).expanduser()
        if not path.exists():
            raise FileNotFoundError(f"input path not found: {path}")
        iterator = [path] if path.is_file() else (
            path.rglob("*") if recursive else path.glob("*")
        )
        for item in sorted(iterator):
            if not item.is_file():
                continue
            if include and not item.match(include):
                continue
            if exclude and item.match(exclude):
                continue
            yield item

    def process_file(self, path: Path, *, output=None, dry_run=False) -> None:
        self.files_skipped += 1

    @staticmethod
    def get_unique_filename(path: Path, base_filename: str) -> Path:
        directory = path if path.is_dir() else path.parent
        base_path = Path(base_filename)
        candidate = directory / base_path.name
        counter = 1
        while candidate.exists():
            candidate = directory / (
                f"{base_path.stem}_{counter}{base_path.suffix}"
            )
            counter += 1
        return candidate

    def process_directory(
        self,
        path,
        *,
        output=None,
        recursive=False,
        include=None,
        exclude=None,
        dry_run=False,
    ) -> None:
        for file_path in self.walk_paths(
            path,
            recursive=recursive,
            include=include,
            exclude=exclude,
        ):
            self.process_file(file_path, output=output, dry_run=dry_run)


class Completion:
    """Build bash completion scripts from argparse parser definitions."""

    @staticmethod
    def classify_parser_actions(arg_parser: argparse.ArgumentParser) -> tuple:
        all_options = set()
        categories = {"boolean": [], "verbose": [], "file": [], "glob": []}
        file_keys = ("input", "output", "file", "path", "paths", "source", "dest")
        glob_keys = ("include", "exclude", "glob", "pattern")
        pending = [arg_parser]
        while pending:
            current = pending.pop()
            for action in current._actions:  # noqa: SLF001
                options = action.option_strings
                if options:
                    all_options.update(options)
                    joined = " ".join(options).lower()
                    if action.nargs == 0 and action.const is True:
                        categories["boolean"].extend(options)
                    if action.__class__.__name__ == "_CountAction":
                        categories["verbose"].extend(options)
                    if any(key in joined for key in file_keys):
                        categories["file"].extend(options)
                    if any(key in joined for key in glob_keys):
                        categories["glob"].extend(options)
                choices = getattr(action, "choices", None)
                if isinstance(choices, dict):
                    pending.extend(
                        parser for parser in choices.values()
                        if isinstance(parser, argparse.ArgumentParser)
                    )
        return all_options, categories

    @staticmethod
    def subcommands(arg_parser: argparse.ArgumentParser) -> list:
        for action in arg_parser._actions:  # noqa: SLF001
            choices = getattr(action, "choices", None)
            if isinstance(choices, dict):
                return sorted(choices)
        return []

    @staticmethod
    def render_case(option: str, kind: str) -> str:
        bodies = {
            "boolean": "            COMPREPLY=()\n",
            "verbose": (
                "            COMPREPLY=( $(compgen -W \"-v -vv -vvv\" "
                "-- \"${cur}\") )\n"
            ),
            "file": "            COMPREPLY=( $(compgen -f -- \"${cur}\") )\n",
            "glob": "            COMPREPLY=( $(compgen -G \"${cur}*\") )\n",
        }
        return (
            f"        {option})\n{bodies[kind]}"
            "            return 0\n            ;;\n"
        )

    @classmethod
    def generate(cls, parser: argparse.ArgumentParser, name: str) -> str:
        all_options, categories = cls.classify_parser_actions(parser)
        option_cases = "".join(
            cls.render_case(option, kind)
            for kind, options in categories.items()
            for option in sorted(set(options))
        )
        completion_name = re.sub(r"[^a-zA-Z0-9_]", "_", name)
        options_text = " ".join(sorted(
            all_options,
            key=lambda option: (not option.startswith("--"), option.lower()),
        ))
        subcommands = cls.subcommands(parser)
        subcommands_text = " ".join(subcommands)
        command_case = ""
        if subcommands_text:
            command_case = f'''    if [ "${{COMP_CWORD}}" -eq 1 ]; then
        case "${{cur}}" in
            -*) ;;
            *)
                COMPREPLY=( $(compgen -W "{subcommands_text}" -- "${{cur}}") )
                return 0
                ;;
        esac
    fi
'''
        path_commands = (
            "lint", "migrate", "convert", "dump", "list", "build",
            "generate_doc", "generate_makefile",
        )
        path_cases = "".join(
            f'''        {command})
            COMPREPLY=( $(compgen -f -- "${{cur}}") )
            return 0
            ;;
'''
            for command in path_commands
            if command in subcommands
        )
        return f'''#!/bin/bash

_{completion_name}_completions()
{{
    local cur prev opts
    COMPREPLY=()
    cur="${{COMP_WORDS[COMP_CWORD]}}"
    prev="${{COMP_WORDS[COMP_CWORD-1]}}"
    opts="{options_text}"

{command_case}    case "${{prev}}" in
{option_cases}{path_cases}        *)
            COMPREPLY=( $(compgen -W "${{opts}}" -- "${{cur}}") )
            return 0
            ;;
    esac
}}

complete -f -F _{completion_name}_completions {shlex.quote(name)}
'''


class Kernel:
    """Common standalone CLI behavior following the pytools template."""

    def __init__(self, author: str, title: str, description: str):
        self.author = author
        self.title = title
        self.description = description
        self.script_file = Path(__file__).resolve()
        self.name = self.script_file.stem
        self.logger = NullLogger()
        self.args = None

    def _build_early_parser(self) -> argparse.ArgumentParser:
        parser = argparse.ArgumentParser(add_help=False)
        parser.add_argument("--log", action="store_true")
        parser.add_argument("--verbose", "-v", action="count", default=0)
        parser.add_argument("--quiet", action="store_true")
        parser.add_argument("--completion", action="store_true")
        return parser

    def _handle_early_arguments(self, arguments) -> bool:
        early_args, _unknown = self._build_early_parser().parse_known_args(arguments)
        self.logger = Logger(
            verbose=early_args.verbose,
            quiet=early_args.quiet,
            script_file=self.script_file,
        )
        Console.quiet = early_args.quiet
        if early_args.verbose:
            self.hero()
        if early_args.completion:
            print(self.generate_completion())
            return True
        if early_args.log:
            self.logger.print()
            return True
        return False

    def hero(self) -> None:
        Console.alert_primary(self.title)

    def generate_completion(self) -> str:
        return Completion.generate(self.build_parser(), self.name)

    def build_parser(self) -> argparse.ArgumentParser:
        parser = argparse.ArgumentParser(description=self.description)
        parser.add_argument("input", help="File or directory to process")
        parser.add_argument("--output", help="Output file or directory")
        parser.add_argument("--recursive", action="store_true")
        parser.add_argument("--include", help="Include filter (glob pattern)")
        parser.add_argument("--exclude", help="Exclude filter (glob pattern)")
        parser.add_argument("--dry-run", action="store_true")
        parser.add_argument("--log", action="store_true")
        parser.add_argument("--verbose", "-v", action="count", default=0)
        parser.add_argument("--quiet", action="store_true")
        parser.add_argument("--completion", action="store_true")
        return parser

    def build_early_parser(self) -> argparse.ArgumentParser:
        return self._build_early_parser()

    def _configure_handler(self, _handler) -> None:
        return None

    def run(self, handler_class=None, argv=None) -> int:
        arguments = list(sys.argv[1:] if argv is None else argv)
        if self._handle_early_arguments(arguments):
            return 0
        args = self.build_parser().parse_args(arguments)
        self.args = args
        self.logger = Logger(
            verbose=args.verbose,
            quiet=args.quiet,
            script_file=self.script_file,
        )
        if handler_class is None:
            handler_class = FileHandler
        handler = handler_class(logger=self.logger)
        self._configure_handler(handler)
        try:
            paths = handler.walk_paths(
                args.input,
                recursive=args.recursive,
                include=args.include,
                exclude=args.exclude,
            )
            for path in paths:
                self.logger.info(f"Processing {path}")
                handler.process_file(
                    path, output=args.output, dry_run=args.dry_run
                )
        except FileNotFoundError as error:
            Console.error(str(error))
            return 1
        if handler.files_processed:
            self.logger.success(
                f"Processed {handler.files_processed} files"
            )
        else:
            self.logger.warning("Processed 0 files")
        return 0


class Shoemaker(Kernel):
    """Command-line application for linting, migration, and shell tooling."""

    def __init__(
        self,
        recipe_commands=None,
        documentation_generator=None,
        makefile_generator=None,
        migrator=None,
    ):
        super().__init__(
            author="TangoMan75",
            title="TangoMan Shoemaker",
            description="Lint, migrate, convert, and build Shoedoc shell tools.",
        )
        paths = ShoemakerPathResolver()
        shoedoc_parser = ShoedocParser()
        shoedoc_serializer = ShoedocSerializer()
        self.recipe_commands = (
            RecipeCommandService(paths=paths)
            if recipe_commands is None else recipe_commands
        )
        self.documentation_generator = (
            DocumentationGenerator(
                parser=shoedoc_parser,
                serializer=shoedoc_serializer,
                paths=paths,
            )
            if documentation_generator is None
            else documentation_generator
        )
        self.makefile_generator = (
            MakefileGenerator(parser=shoedoc_parser, paths=paths)
            if makefile_generator is None
            else makefile_generator
        )
        self.migrator = (
            ShoedocMigrator(
                parser=shoedoc_parser,
                serializer=shoedoc_serializer,
            )
            if migrator is None else migrator
        )

    @staticmethod
    def _add_source_arguments(command_parser) -> None:
        command_parser.add_argument("source", nargs="?", metavar="FILE")
        command_parser.add_argument(
            "--file", dest="file_option", metavar="FILE",
            help="Source file. Positional FILE is also accepted.",
        )
        command_parser.add_argument(
            "--destination", metavar="DIR",
            help="Destination directory",
        )

    @staticmethod
    def _add_common_arguments(command_parser, *, subparser=False) -> None:
        default = argparse.SUPPRESS if subparser else False
        verbose_default = argparse.SUPPRESS if subparser else 0
        command_parser.add_argument("--log", action="store_true", default=default)
        command_parser.add_argument(
            "--verbose", "-v", action="count", default=verbose_default,
            help="Increase verbosity (stackable)",
        )
        command_parser.add_argument(
            "--quiet", action="store_true", default=default,
            help="Suppress non-primary output",
        )
        command_parser.add_argument(
            "--completion", action="store_true", default=default,
            help="Print bash completion script and exit",
        )

    def build_parser(self) -> argparse.ArgumentParser:
        parser = argparse.ArgumentParser(
            prog="shoemaker",
            description=self.description,
        )
        self._add_common_arguments(parser)
        commands = parser.add_subparsers(dest="command", required=True)
        lint_parser = commands.add_parser("lint", help="Lint Shoedoc blocks")
        self._add_common_arguments(lint_parser, subparser=True)
        lint_parser.add_argument("folder", help="Folder containing .sh files")
        lint_parser.add_argument(
            "--fix", action="store_true", help="Repair supported issues in place"
        )

        migrate_parser = commands.add_parser(
            "migrate", help="Migrate legacy Shoedoc blocks to the current format"
        )
        self._add_common_arguments(migrate_parser, subparser=True)
        migrate_parser.add_argument(
            "paths", nargs="+", metavar="PATH",
            help="Shell script files or directories to migrate",
        )
        migrate_parser.add_argument(
            "--dry-run", action="store_true",
            help="Show proposed changes without modifying files",
        )

        convert_parser = commands.add_parser(
            "convert", help="Convert JSON and classic Shoedoc formats"
        )
        self._add_common_arguments(convert_parser, subparser=True)
        convert_parser.add_argument(
            "paths", nargs="+", metavar="PATH",
            help="Shell script files or directories to convert",
        )
        direction = convert_parser.add_mutually_exclusive_group()
        direction.add_argument(
            "--tags", action="store_true",
            help="Convert JSON blocks to classic @-tags (default)",
        )
        direction.add_argument(
            "--json", action="store_true",
            help="Convert classic @-tags to JSON blocks",
        )
        convert_parser.add_argument(
            "--dry-run", action="store_true",
            help="Print converted content without overwriting files",
        )

        dump_parser = commands.add_parser(
            "dump", help="Extract shell functions into individual files"
        )
        self._add_common_arguments(dump_parser, subparser=True)
        Shoemaker._add_source_arguments(dump_parser)

        list_parser = commands.add_parser(
            "list", help="Write a build list of shell functions"
        )
        self._add_common_arguments(list_parser, subparser=True)
        Shoemaker._add_source_arguments(list_parser)

        build_parser = commands.add_parser(
            "build", help="Build a shell script from a .shoe list"
        )
        self._add_common_arguments(build_parser, subparser=True)
        Shoemaker._add_source_arguments(build_parser)
        build_parser.add_argument(
            "--type", choices=("shell", "sh", "bash"), default="shell",
            help="Output interpreter (default: shell)",
        )

        doc_parser = commands.add_parser(
            "generate_doc", help="Generate Markdown documentation for a script"
        )
        self._add_common_arguments(doc_parser, subparser=True)
        Shoemaker._add_source_arguments(doc_parser)
        doc_parser.add_argument(
            "--private", action="store_true",
            help="Include private constants, variables, and functions",
        )

        makefile_parser = commands.add_parser(
            "generate_makefile", help="Generate a Makefile for a script"
        )
        self._add_common_arguments(makefile_parser, subparser=True)
        Shoemaker._add_source_arguments(makefile_parser)

        completion_parser = commands.add_parser(
            "completion", help="Print the bash completion script"
        )
        self._add_common_arguments(completion_parser, subparser=True)
        return parser

    def run(self, argv=None) -> int:
        arguments = list(sys.argv[1:] if argv is None else argv)
        if self._handle_early_arguments(arguments):
            return 0

        parser = self.build_parser()
        args = parser.parse_args(arguments)
        self.args = args
        Console.quiet = args.quiet

        if args.command == "completion":
            print(self.generate_completion())
            return 0

        if args.quiet:
            with contextlib.redirect_stdout(io.StringIO()):
                with contextlib.redirect_stderr(io.StringIO()):
                    # quiet mode suppresses output, not the exit code
                    return self._execute(args, parser)
        return self._execute(args, parser)

    def convert(self, argv=None) -> int:
        """Run the converter with the former standalone command-line
        syntax."""
        arguments = list(sys.argv[1:] if argv is None else argv)
        return self.run(["convert", *arguments])

    def _execute(self, args, parser) -> int:
        if args.command == "lint":
            return ShoedocLinter().lint(args.folder, args.fix)
        if args.command == "migrate":
            return self.migrator.migrate_paths(args.paths, args.dry_run)
        if args.command == "convert":
            direction = "json" if args.json else "tags"
            return ShoedocConverter().convert_paths(
                args.paths, direction, args.dry_run
            )

        source = args.file_option or args.source
        if args.file_option and args.source:
            parser.error("provide FILE either positionally or with --file")
        if not source:
            parser.error(f"{args.command} requires a source FILE")

        try:
            if args.command == "dump":
                output = self.recipe_commands.dump(source, args.destination)
                Console.success(f"Dumped functions to {output}")
            elif args.command == "list":
                output = self.recipe_commands.list(source, args.destination)
                Console.success(f"Function list written to {output}")
            elif args.command == "build":
                output = self.recipe_commands.build(
                    source, args.destination, args.type
                )
                Console.success(f"Built script: {output}")
            elif args.command == "generate_doc":
                output = self.documentation_generator.generate(
                    source, args.destination, args.private
                )
                Console.success(f"Documentation generated: {output}")
            else:
                output = self.makefile_generator.generate(
                    source, args.destination
                )
                Console.success(f"Makefile generated: {output}")
        except (OSError, ValueError, KeyError) as error:
            Console.error(str(error))
            return 1
        return 0


def main(argv=None) -> int:
    return Shoemaker().run(argv)


if __name__ == "__main__":
    sys.exit(main())
