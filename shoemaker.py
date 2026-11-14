#!/usr/bin/env python3
"""Lint, document, and build Shoedoc shell scripts."""

import argparse
import contextlib
import datetime
import io
import json
import os
import re
import shlex
import shutil
import sys
from pathlib import Path
from types import MappingProxyType
from typing import NamedTuple


class ShoedocSchema:
    """Own the Shoedoc vocabulary and the shape of every property.

    The schema is the single source of truth: collaborators reference its
    attributes instead of module-level constants, so the vocabulary stays
    attached to the concept it describes.
    """

    REL_PATH_RE = re.compile(
        r"^(?!/|\\|\./|\.\./)"
        r"([a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?/)*"
        r"[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?$"
    )
    VAR_NAME_RE = re.compile(r"^[a-zA-Z_][a-zA-Z0-9_]*$")
    PARAM_NAME_RE = re.compile(
        r"^[a-zA-Z_][a-zA-Z0-9_]*(?:\|[a-zA-Z_][a-zA-Z0-9_]*)*$"
    )
    CONSTANT_RE = re.compile(r"^_{0,2}[A-Z0-9]+(?:_[A-Z0-9]+)*_{0,2}$")
    GROUP_COMMAND_RE = re.compile(
        r"^[a-zA-Z0-9_][a-zA-Z0-9_./+-]*( [a-zA-Z0-9_.+-]+)?$"
    )
    CONSTRAINT_RE = re.compile(r"^/.*/[a-z]*$")
    SHORT_RE = re.compile(r"^[a-zA-Z0-9]$")
    LONG_RE = re.compile(r"^[a-zA-Z0-9][a-zA-Z0-9-]*$")

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
    # shape (see ENTRY_FIELDS).
    ENTRY_ARRAY_KEYS = ("constants", "variables", "params", "options", "flags")

    # Allowed fields per entry-array property. Only constants and variables
    # entries may carry "deprecated": deprecation is a function / constant /
    # variable concern. Options are addressed by name and cannot be
    # "required": a missing option falls back to its "default" value.
    ENTRY_FIELDS = MappingProxyType({
        "params": (
            "position", "name", "summary", "description", "type",
            "constraint", "required", "default",
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
    })

    # Value-carrying fields that a flag must not own.
    FLAG_VALUE_FIELDS = (
        "position", "type", "constraint", "required", "default",
    )

    # Fields an entry-array property must never carry, per key. A flag owns
    # no value fields; an option cannot be "required".
    FORBIDDEN_ENTRY_FIELDS = MappingProxyType({
        "options": ("required",),
        "flags": FLAG_VALUE_FIELDS,
    })

    # Properties a script-level block cannot own: namespace, requires,
    # function entries and the std streams are function concerns.
    SCRIPT_FORBIDDEN_PROPERTIES = (
        "namespace", "requires", "params", "options", "flags",
        "stdout", "stderr", "stdin",
    )

    # Properties emitted by a classic @-tag block.
    CLASSIC_STRING_KEYS = (
        "namespace", "summary", "copyright", "version", "license", "update",
        "shell", "overrides", "deprecated", "stdout", "stderr", "stdin",
    )
    ENTRY_TAG_BY_KEY = MappingProxyType({
        "constants": "constant",
        "variables": "variable",
        "params": "param",
        "options": "option",
        "flags": "flag",
    })

    # Canonical order of the top-level properties: "namespace" first.
    ORDERED_KEYS = (
        "namespace", "name", "summary", "description", "authors", "copyright",
        "version", "license", "links", "update", "shell", "requires",
        "depends", "overrides", "assumes", "private", "type", "deprecated",
        "examples", "stdout", "stderr", "stdin", "constants", "variables",
        "params", "options", "flags",
    )

    AUTHOR_FIELDS = ("name", "email", "homepage")


class AnnotationRecord(NamedTuple):
    """Capture one function annotation run and its target function."""

    function_line_index: int
    function_name: str
    line_indexes: list
    lines: list


class ShoedocValidator:
    """Validate single shoedoc properties against the vocabulary."""

    def __init__(self):
        self._special_validators = {
            "namespace": self._validate_namespace,
            "requires": self._validate_requires,
            "depends": self._validate_depends,
            "overrides": self._validate_overrides,
            "assumes": self._validate_assumes,
            "authors": self._validate_authors,
            "links": self._validate_links,
            "examples": self._validate_examples,
            "shell": self._validate_shell,
            "private": self._validate_private,
            "summary": self._validate_summary,
            "type": self._validate_type,
        }

    def validate_property(self, key, value, errors) -> None:
        """Validate one property, appending human-readable errors."""
        validator = self._special_validators.get(key)
        if validator is not None:
            validator(value, errors)
            return
        if key in ShoedocSchema.STRING_PROPERTIES:
            self._validate_string(key, value, errors)
            return
        if key in ShoedocSchema.ENTRY_ARRAY_KEYS:
            self.check_entry_array(value, key, errors)
            return
        errors.append(f"unknown property: '{key}'")

    @staticmethod
    def validate_rel_path(value, key) -> list:
        """Return the list of error strings for a relative-path property."""
        if not value:
            return [f"{key} must not be empty"]
        if not ShoedocSchema.REL_PATH_RE.match(value):
            return [f"not a valid relative path: {value!r}"]
        return []

    def _validate_namespace(self, value, errors) -> None:
        if not isinstance(value, str):
            errors.append("'namespace' must be a string")
            return
        errors.extend(self.validate_rel_path(value, "namespace"))
        if not Path(value).is_dir():
            errors.append(f"'namespace' folder not found: {value!r}")

    @staticmethod
    def _validate_string_array(value, key, errors) -> None:
        """Require a string array to be non-empty, sorted and unique."""
        if not value:
            errors.append(f"'{key}' must not be empty")
            return
        if value != sorted(value):
            errors.append(f"'{key}' must be sorted alphabetically")
        if len(set(value)) != len(value):
            errors.append(f"'{key}' contains duplicated entries")

    @staticmethod
    def _is_string_array(value) -> bool:
        return isinstance(value, list) and all(
            isinstance(item, str) for item in value
        )

    def _validate_requires(self, value, errors) -> None:
        if not self._is_string_array(value):
            errors.append("'requires' must be an array of strings")
            return
        for item in value:
            if not ShoedocSchema.GROUP_COMMAND_RE.match(item):
                errors.append(f"'requires' invalid command: {item!r}")
        self._validate_string_array(value, "requires", errors)

    def _validate_depends(self, value, errors) -> None:
        if not self._is_string_array(value):
            errors.append("'depends' must be an array of strings")
            return
        for item in value:
            for error in self.validate_rel_path(item, "depends"):
                errors.append(f"'depends': {error}")
        for item in value:
            if not Path(f"{item}.sh").is_file():
                errors.append(f"'depends' file not found: {item!r}.sh")
        self._validate_string_array(value, "depends", errors)

    def _validate_overrides(self, value, errors) -> None:
        """Require overrides to name exactly one existing core module."""
        if not isinstance(value, str):
            errors.append("'overrides' must be a string")
            return
        for error in self.validate_rel_path(value, "overrides"):
            errors.append(f"'overrides': {error}")
        if not value.startswith("src/"):
            errors.append(
                f"'overrides' must reference a core module: {value!r}"
            )
        elif not Path(f"{value}.sh").is_file():
            errors.append(f"'overrides' file not found: {value!r}.sh")

    def _validate_assumes(self, value, errors) -> None:
        if not self._is_string_array(value):
            errors.append("'assumes' must be an array of strings")
            return
        for item in value:
            if (
                not ShoedocSchema.CONSTANT_RE.match(item)
                and not ShoedocSchema.VAR_NAME_RE.match(item)
            ):
                errors.append(f"'assumes' invalid variable: {item!r}")
        self._validate_string_array(value, "assumes", errors)

    @staticmethod
    def _validate_authors(value, errors) -> None:
        """Check the 'authors' array: objects carrying optional 'name',
        'email' and 'homepage' strings, at least one of them per object."""
        if not isinstance(value, list) or not value:
            errors.append("'authors' must be a non-empty array of objects")
            return
        for author in value:
            if not isinstance(author, dict):
                errors.append("'authors' must contain objects")
                continue
            for field in ShoedocSchema.AUTHOR_FIELDS:
                field_value = author.get(field)
                if field_value is not None and not isinstance(
                    field_value, str
                ):
                    errors.append(f"'authors': '{field}' must be a string")
            if not any(
                author.get(field) for field in ShoedocSchema.AUTHOR_FIELDS
            ):
                errors.append(
                    "'authors': at least one of 'name', 'email' or "
                    "'homepage' is required"
                )
            unknown = set(author) - set(ShoedocSchema.AUTHOR_FIELDS)
            if unknown:
                errors.append(
                    f"'authors': unknown key(s): {', '.join(sorted(unknown))}"
                )

    @staticmethod
    def _validate_links(value, errors) -> None:
        if not isinstance(value, list) or not all(
            isinstance(item, str) and item.strip() for item in value
        ):
            errors.append("'links' must be an array of non-empty strings")
            return
        if not value:
            errors.append("'links' must not be empty")
        if len(set(value)) != len(value):
            errors.append("'links' contains duplicated entries")

    @staticmethod
    def _validate_examples(value, errors) -> None:
        if not isinstance(value, list) or not all(
            isinstance(item, str) and item.strip() for item in value
        ):
            errors.append("'examples' must be an array of non-empty strings")

    @staticmethod
    def _validate_shell(value, errors) -> None:
        if value not in ("sh", "bash"):
            errors.append("'shell' must be one of: sh, bash")

    @staticmethod
    def _validate_private(value, errors) -> None:
        if not isinstance(value, bool):
            errors.append("'private' must be a boolean")

    @staticmethod
    def _validate_summary(value, errors) -> None:
        if not isinstance(value, str):
            errors.append("'summary' must be a string")

    @staticmethod
    def _validate_type(value, errors) -> None:
        if not isinstance(value, str):
            errors.append("'type' must be a string")
            return
        if not value.strip():
            errors.append("'type' must not be empty")
            return
        if value not in ShoedocSchema.TYPE_VALUES:
            errors.append(
                f"'type' must be one of: "
                f"{', '.join(ShoedocSchema.TYPE_VALUES)}"
            )

    @staticmethod
    def _validate_string(key: str, value, errors) -> None:
        if not isinstance(value, str):
            errors.append(f"'{key}' must be a string")
        elif not value.strip():
            errors.append(f"'{key}' must not be empty")

    def check_entry_array(self, value, key, errors) -> None:
        """Check a constants/variables/params/options/flags array against
        the field set allowed for that array (see ENTRY_FIELDS)."""
        if not isinstance(value, list):
            errors.append(f"'{key}' must be an array of objects")
            return
        if not value:
            errors.append(f"'{key}' must not be empty")
            return
        allowed = set(ShoedocSchema.ENTRY_FIELDS[key])
        for index, entry in enumerate(value):
            if not isinstance(entry, dict):
                errors.append(f"'{key}' must contain objects")
                continue
            self._check_entry(entry, key, index, allowed, errors)

    def _check_entry(self, entry, key, index, allowed, errors) -> None:
        self._check_entry_name(entry, key, errors)
        self._check_entry_position(entry, key, index, errors)
        self._check_entry_text(entry, key, errors)
        self._check_entry_type(entry, key, errors)
        self._check_entry_constraint(entry, key, errors)
        self._check_entry_option_names(entry, key, errors)
        self._check_entry_required(entry, key, errors)
        self._check_entry_default(entry, key, errors)
        self._check_entry_flags(entry, key, errors)
        forbidden = self._check_forbidden_fields(entry, key, errors)
        unknown = set(entry) - allowed - forbidden
        if unknown:
            errors.append(
                f"{key}: unknown key(s): {', '.join(sorted(unknown))}"
            )

    @staticmethod
    def _check_entry_name(entry, key, errors) -> None:
        name = entry.get("name")
        if name is None and key not in ("constants", "variables"):
            errors.append(f"{key}: {json.dumps(entry)}: missing 'name'")
            return
        if name is None:
            return
        pattern = (
            ShoedocSchema.PARAM_NAME_RE
            if key == "params"
            else ShoedocSchema.VAR_NAME_RE
        )
        if not isinstance(name, str) or not pattern.match(name):
            errors.append(f"{key}: invalid 'name': {name!r}")

    @staticmethod
    def _check_entry_position(entry, key, index, errors) -> None:
        position = entry.get("position")
        if position is not None and (
            not isinstance(position, int)
            or isinstance(position, bool)
            or position < 1
        ):
            errors.append(f"{key}: 'position' must be a positive integer")
            return
        if (
            key == "params"
            and position is not None
            and position != index + 1
        ):
            errors.append(
                f"{key}: 'position' must match the entry's rank in the "
                f"array: {position!r}"
            )

    @staticmethod
    def _check_entry_text(entry, key, errors) -> None:
        summary = entry.get("summary")
        if summary is not None and not isinstance(summary, str):
            errors.append(f"{key}: 'summary' must be a string")
        description = entry.get("description")
        if description is not None and not isinstance(description, str):
            errors.append(f"{key}: 'description' must be a string")

    @staticmethod
    def _check_entry_type(entry, key, errors) -> None:
        type_ = entry.get("type")
        if type_ is None:
            return
        if not isinstance(type_, str) or not type_.strip():
            errors.append(f"{key}: 'type' must be a non-empty string")
            return
        if type_ == "flag" and key != "flags":
            errors.append(
                f"{key}: 'flag' is not a valid 'type' (declare flags in "
                f"the 'flags' array)"
            )
            return
        if key != "flags" and type_ not in ShoedocSchema.TYPE_VALUES:
            errors.append(
                f"{key}: invalid 'type': {type_!r} (expected one of: "
                f"{', '.join(ShoedocSchema.TYPE_VALUES)})"
            )

    @staticmethod
    def _check_entry_constraint(entry, key, errors) -> None:
        constraint = entry.get("constraint")
        if constraint is None:
            return
        if not isinstance(constraint, str):
            errors.append(f"{key}: 'constraint' must be a string")
            return
        if not ShoedocSchema.CONSTRAINT_RE.match(constraint):
            errors.append(
                f"{key}: invalid 'constraint': {constraint!r} "
                f"(expected '/regex/flags')"
            )

    @staticmethod
    def _check_entry_option_names(entry, key, errors) -> None:
        short = entry.get("short")
        if short is not None and (
            not isinstance(short, str)
            or not ShoedocSchema.SHORT_RE.match(short)
        ):
            errors.append(
                f"{key}: invalid 'short': {short!r} (expected a single "
                f"character without dash)"
            )
        long_ = entry.get("long")
        if long_ is not None and (
            not isinstance(long_, str)
            or not ShoedocSchema.LONG_RE.match(long_)
        ):
            errors.append(
                f"{key}: invalid 'long': {long_!r} (expected a name "
                f"without dash)"
            )

    @staticmethod
    def _check_entry_required(entry, key, errors) -> None:
        required = entry.get("required")
        if required is not None and not isinstance(required, bool):
            errors.append(f"{key}: 'required' must be a boolean")

    @staticmethod
    def _check_entry_default(entry, key, errors) -> None:
        if "default" not in entry:
            return
        if not isinstance(
            entry["default"], (str, int, float, bool, type(None))
        ):
            errors.append(f"{key}: 'default' must be a scalar or null")

    @staticmethod
    def _check_entry_flags(entry, key, errors) -> None:
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
        if entry.get("required") is True and "default" in entry:
            errors.append(
                f"{key}: 'required' entries cannot own a 'default' value"
            )

    @staticmethod
    def _check_forbidden_fields(entry, key, errors) -> set:
        forbidden = set()
        if key in ShoedocSchema.FORBIDDEN_ENTRY_FIELDS:
            subject = {"options": "an option", "flags": "a flag"}[key]
            for field in ShoedocSchema.FORBIDDEN_ENTRY_FIELDS[key]:
                if field in entry:
                    forbidden.add(field)
                    errors.append(
                        f"{key}: {subject} cannot own a '{field}' property"
                    )
        if (
            "deprecated" in entry
            and key not in ("constants", "variables")
        ):
            # Only functions, constants and variables may be deprecated.
            if "deprecated" not in forbidden:
                errors.append(
                    f"{key}: a '{key}' entry cannot own a 'deprecated' "
                    f"property"
                )
            forbidden.add("deprecated")
        return forbidden

    @staticmethod
    def entry_token(entry, key) -> str:
        """Return the word referenced in the shell code by the given entry:
        the command name for "requires" (first word of a grouped command),
        the base function name for "depends" and "overrides" (last path
        segment), and the variable name for "assumes"."""
        if key == "requires":
            return entry.split()[0] if entry.split() else entry
        if key in ("depends", "overrides"):
            return entry.split("/")[-1]
        return entry

    @staticmethod
    def check_string_array_usage(values, key, body, errors) -> None:
        """Check that every entry of a requires/depends/assumes array is
        referenced in the file body."""
        for item in values:
            if not isinstance(item, str) or not item:
                continue
            token = re.escape(ShoedocValidator.entry_token(item, key))
            if not re.search(rf"\b{token}\b", body):
                errors.append(f"'{key}' unused entry: {item!r}")


class _ClassicBlockBuilder:
    """Accumulate a classic @-tag comment block into a Shoedoc object."""

    ENTRY_TAGS = ("param", "option", "flag", "constant", "variable")
    ENTRY_KEYS = MappingProxyType({
        "param": "params",
        "constant": "constants",
        "variable": "variables",
    })
    OPTIONAL_ENTRY_KEYS = ("constants", "variables")

    def __init__(self, parser_class):
        self.parser_class = parser_class
        self.data = {}
        self.entries = {
            key: [] for key in ShoedocSchema.ENTRY_ARRAY_KEYS
        }
        self.summary_parts = []
        self.description_parts = []
        self.warnings = []
        self.seen_tag = False
        self.seen_separator = False

    def consume(self, line: str, line_number: int) -> None:
        """Consume one stripped classic comment line."""
        body = line[2:].strip()
        if not body:
            if not self.seen_tag:
                self.seen_separator = True
            return
        match = self.parser_class.TAG_RE.match(body)
        if match is None:
            self._consume_text(body, line_number)
            return
        self.seen_tag = True
        self._consume_tag(match.group(1), match.group(2).strip(), line_number)

    def _consume_text(self, body: str, line_number: int) -> None:
        if self.seen_tag:
            self._warn("non-tag comment ignored", line_number)
        elif self.seen_separator:
            self.description_parts.append(body)
        else:
            self.summary_parts.append(body)

    def _consume_tag(self, tag: str, value: str, line_number: int) -> None:
        if tag in self.ENTRY_TAGS:
            self._add_entry(tag, value, line_number)
        elif tag == "author":
            self._add_author(value, line_number)
        elif tag == "link":
            self._add_string_entry("links", value, tag, line_number)
        elif tag == "example":
            self._add_string_entry("examples", value, tag, line_number)
        elif tag == "private":
            self.data["private"] = True
        elif tag == "public":
            self.data["private"] = False
        elif tag == "type":
            self._add_type(value)
        elif tag in ShoedocSchema.ARRAY_KEYS:
            self.data.setdefault(tag, []).extend(value.split())
        elif tag in ShoedocSchema.CLASSIC_STRING_KEYS:
            self.data[tag] = value
        else:
            self.warnings.append(
                'warning: unknown tag "@%s" ignored at line %d\n'
                % (tag, line_number)
            )

    def _add_entry(self, tag: str, value: str, line_number: int) -> None:
        array_key = self.ENTRY_KEYS.get(tag, tag + "s")
        if not value:
            self._warn(f"empty @{tag} ignored", line_number)
            return
        entry = self.parser_class.parse_entry_value(value)
        if not entry or (
            "name" not in entry
            and array_key not in self.OPTIONAL_ENTRY_KEYS
        ):
            self._warn(f"empty @{tag} ignored", line_number)
            return
        if array_key == "options" and "required" in entry:
            # Options are optional by design: a missing option falls back
            # to its default value.
            if entry["required"] is True:
                self.warnings.append(
                    "warning: @option '(required)' ignored at line %d\n"
                    % line_number
                )
            entry.pop("required")
        self.entries[array_key].append(entry)

    def _add_author(self, value: str, line_number: int) -> None:
        if not value:
            self._warn("empty @author ignored", line_number)
            return
        self.data.setdefault("authors", []).append(
            self.parser_class.parse_author(value)
        )

    def _add_string_entry(
        self, key: str, value: str, tag: str, line_number: int
    ) -> None:
        if not value:
            self._warn(f"empty @{tag} ignored", line_number)
            return
        self.data.setdefault(key, []).append(value)

    def _add_type(self, value: str) -> None:
        type_value = value.strip()
        if type_value.startswith("{") and type_value.endswith("}"):
            type_value = type_value[1:-1].strip()
        self.data["type"] = type_value

    def _warn(self, message: str, line_number: int) -> None:
        self.warnings.append(
            "warning: %s at line %d\n" % (message, line_number)
        )

    def build(self) -> tuple:
        """Return ``(data, warnings)``, or ``(None, warnings)`` if empty."""
        if (
            not self.data
            and not any(self.entries.values())
            and not self.summary_parts
            and not self.description_parts
        ):
            return None, self.warnings
        for index, entry in enumerate(self.entries["params"]):
            entry["position"] = index + 1
        if self.summary_parts and "summary" not in self.data:
            self.data["summary"] = " ".join(self.summary_parts)
        if self.description_parts:
            self.data["description"] = "\n".join(self.description_parts)

        ordered = {}
        for key in ShoedocSchema.ORDERED_KEYS:
            if key in self.entries:
                if self.entries[key]:
                    ordered[key] = self.entries[key]
            elif key in self.data:
                ordered[key] = self.data[key]
        return (ordered or None), self.warnings


class ShoedocParser:
    """Parse classic Shoedoc @-tag blocks."""

    TAG_RE = re.compile(r"^@([A-Za-z_][A-Za-z0-9_]*):?\s*(.*)$")
    AUTHOR_RE = re.compile(
        r'^\s*(?:"(?P<quoted>[^"]*)"|(?P<bare>[^<]*?))?\s*'
        r"(?:<(?P<email>[^>]*)>)?\s*"
        r"(?P<homepage>https?://\S+)?\s*$"
    )

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
            match = ShellFunctionParser.FUNCTION_RE.match(
                cls._strip_eol(line)
            )
            if not match:
                continue
            run_indexes = []
            cursor = index - 1
            while cursor >= 0:
                stripped = cls._strip_eol(file_lines[cursor])
                if not stripped:
                    cursor -= 1
                    continue
                if not cls.is_shoedoc_line(stripped):
                    break
                run_indexes.append(cursor)
                cursor -= 1
            if run_indexes:
                run_indexes.reverse()
                records.append(AnnotationRecord(
                    index,
                    match.group(1),
                    run_indexes,
                    [cls._strip_eol(file_lines[i])
                     for i in run_indexes],
                ))
        return records

    @staticmethod
    def strip_shoedoc_prefix(line: str) -> str:
        """Remove the leading double pound sign (and one optional space)
        from an annotation line, like _get_shoedoc.sh does."""
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
    def is_shoedoc_line(line: str) -> bool:
        """Return True for a '##' comment line: two pound signs followed by
        whitespace or the end of the line. Section dividers such as
        ``##########`` and ``### Title`` are not shoedoc lines."""
        line = line.rstrip("\r\n")
        return line.startswith("##") and (
            len(line) == 2 or line[2] in (" ", "\t")
        )

    @staticmethod
    def parse_default(text: str):
        """Parse a classic default marker as JSON, or keep its text."""
        text = text.strip()
        try:
            return json.loads(text)
        except ValueError:
            return text

    @staticmethod
    def decode_constraint(raw: str) -> str:
        """Decode the escaped text of a classic /regex/flags constraint."""
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
        match = ShoedocParser.AUTHOR_RE.match(value)
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
        builder = _ClassicBlockBuilder(cls)
        for offset, line in enumerate(chunk_lines):
            builder.consume(line, base_index + offset + 1)
        return builder.build()

    @classmethod
    def parse_assignment_block(cls, chunk_lines: list,
                               base_index=0) -> dict:
        """Parse the annotation block documenting a script-level assignment.

        A block accepts both the classic single-line entry tag
        (``@constant``/``@variable``) and the extended form: a title, an
        optional description and standalone block tags such as ``@type``
        and ``@constraint``.
        """
        parsed, _warnings = cls.parse_classic_block(chunk_lines, base_index)
        parsed = dict(parsed or {})
        for line in chunk_lines:
            body = cls.strip_shoedoc_prefix(line).strip()
            match = cls.TAG_RE.match(body)
            if match is None or match.group(1) != "constraint":
                continue
            constraint = match.group(2).strip()
            if constraint:
                parsed["constraint"] = constraint
        return parsed

    def parse_annotation_lines(self, annotation_lines: list,
                               base_index=0) -> dict:
        """Parse classic tags from an annotation run."""
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

    @classmethod
    def script_metadata_indices(cls, file_lines: list) -> list:
        """Return line indexes for the first script-level annotation run.

        The script block does not have to sit at the very top of the file:
        it commonly follows a license header and startup statements such
        as ``set -e``. Only the lines before the first function definition
        are scanned, so annotation lines inside a function body are never
        considered."""
        limit = next(
            (
                index for index, line in enumerate(file_lines)
                if ShellFunctionParser.FUNCTION_HEADER_RE.match(
                    line.rstrip("\r\n")
                )
            ),
            len(file_lines),
        )
        index = 0
        while index < limit:
            if not cls.is_shoedoc_line(file_lines[index]):
                index += 1
                continue
            start = index
            while index < limit and cls.is_shoedoc_line(file_lines[index]):
                index += 1
            # A classic block belongs to the script only when a blank line
            # separates it from the code that follows, like
            # _get_script_shoedoc.sh does: otherwise it annotates the
            # function definition right below.
            if index < len(file_lines) and file_lines[index].strip():
                return []
            return list(range(start, index))
        return []

    def parse_script_metadata(self, file_lines: list) -> dict:
        """Read the first script-level Shoedoc annotation of the file."""
        indexes = self.script_metadata_indices(file_lines)
        if not indexes:
            return {}
        annotation_lines = [
            file_lines[index].rstrip("\r\n") for index in indexes
        ]
        return self.parse_annotation_lines(annotation_lines, indexes[0])

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

    @staticmethod
    def section_titles(file_lines: list) -> dict:
        """Map each line index to the nearest preceding '### Title'
        section divider, or an empty string before the first one."""
        titles = {}
        title = ""
        for index, line in enumerate(file_lines):
            stripped = line.rstrip("\r\n")
            if stripped.startswith("### "):
                title = stripped[4:].strip()
            titles[index] = title
        return titles


class ShoedocSerializer:
    """Serialize Shoedoc data as classic @-tag lines."""

    def __init__(self, ordering=None):
        self.ordering = ShoedocOrdering() if ordering is None else ordering

    @staticmethod
    def format_default(value) -> str:
        """Render a default value as a classic tag marker."""
        if value is True:
            return "default:true"
        if value is False:
            return "default:false"
        if isinstance(value, (int, float)):
            return "default:%s" % value
        return "default:%s" % json.dumps(value)

    @classmethod
    def format_entry_tag(cls, array_key: str, entry: dict) -> str:
        """Render one params/options/flags entry as a classic tag."""
        tag = "@%s" % ShoedocSchema.ENTRY_TAG_BY_KEY[array_key]
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
        """Render one author object as an @author value."""
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
    def classic_lines(cls, data) -> list:
        """Serialize a parsed object as classic @-tag lines."""
        out = []
        if "summary" in data:
            out.extend(
                ("## %s" % line) if line else "##"
                for line in str(data["summary"]).split("\n")
            )
        if "description" in data:
            out.append("##")
            out.extend(
                ("## %s" % line) if line else "##"
                for line in str(data["description"]).split("\n")
            )
        if "summary" in data or "description" in data:
            out.append("##")

        for key in ShoedocSchema.ORDERED_KEYS:
            if key in ("summary", "description", "name"):
                continue
            if key in ShoedocSchema.ARRAY_KEYS:
                value = data.get(key)
                if isinstance(value, list) and all(
                    isinstance(item, str) for item in value
                ):
                    out.append("## @%s %s" % (key, " ".join(value)))
            elif key in ShoedocSchema.ENTRY_ARRAY_KEYS:
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

    def validate(self, property_name: str, value, errors: list) -> None:
        """Validate one property through the shared validator."""
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
        ordered = cls._ordered_object(parsed, ShoedocSchema.ORDERED_KEYS)
        for key in ShoedocSchema.ENTRY_ARRAY_KEYS:
            entries = ordered.get(key)
            if isinstance(entries, list):
                ordered[key] = [
                    cls._ordered_object(entry, ShoedocSchema.ENTRY_FIELDS[key])
                    if isinstance(entry, dict) else entry
                    for entry in entries
                ]
        authors = ordered.get("authors")
        if isinstance(authors, list):
            ordered["authors"] = [
                cls._ordered_object(author, ShoedocSchema.AUTHOR_FIELDS)
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
    """Normalize parsed Shoedoc blocks."""

    def __init__(self, validator=None, ordering=None):
        self.validator = ShoedocValidator() if validator is None else validator
        self.ordering = ShoedocOrdering() if ordering is None else ordering

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

    def fix_string_array_entries(self, entries, key, body, used=None):
        """Deduplicate and sort the entries of a requires/depends/assumes
        array, dropping the unused ones. When ``used`` is given, an entry
        is kept only when that set holds it (variable-aware "assumes"
        check). Returns (cleaned_entries, fixes)."""
        fixes = []
        deduplicated = list(dict.fromkeys(entries))
        if len(deduplicated) < len(entries):
            fixes.append(f"removed duplicated '{key}' entries")
        if used is None:
            dropped_unused = []
            for entry in deduplicated:
                token = re.escape(self.validator.entry_token(entry, key))
                if not re.search(rf"\b{token}\b", body):
                    dropped_unused.append(entry)
        else:
            dropped_unused = [
                entry for entry in deduplicated if entry not in used
            ]
        if dropped_unused:
            fixes.append(f"removed unused '{key}' entries")
        cleaned = sorted(
            entry for entry in deduplicated if entry not in dropped_unused
        )
        return cleaned, fixes

    def fix_dictionary(self, parsed, body, adds, namespace_value,
                       wrong_namespace, used_assumes=None):
        """Apply the whole-fix pipeline to the parsed shoedoc object;
        returns (new_object, fixes). `adds` maps array keys (requires /
        depends / assumes) to the entries to merge; a missing array
        property is created right after the namespace, in canonical
        order. `used_assumes` holds the variables the source reads."""
        if not isinstance(parsed, dict):
            return None, []
        fixes = []
        if not self.ordering.keys_ordered(parsed):
            fixes.append("ordered properties")
        parsed, result = self._prepare_namespace(
            parsed, wrong_namespace, namespace_value, fixes
        )
        result = self._fix_properties(
            parsed, body, adds, result, fixes, used_assumes
        )
        result = self._insert_missing_arrays(result, adds, fixes)
        return self.ordering.order_keys(result), fixes

    @staticmethod
    def _prepare_namespace(
        parsed, wrong_namespace, namespace_value, fixes
    ) -> tuple:
        """Repair the existing namespace and seed the result object."""
        if wrong_namespace and "namespace" in parsed:
            parsed = dict(parsed)
            parsed["namespace"] = wrong_namespace
            fixes.append("repaired 'namespace' folder")
        result = {}
        if namespace_value is not None:
            result["namespace"] = namespace_value
            fixes.append("inserted missing namespace")
        return parsed, result

    def _fix_properties(self, parsed, body, adds, result, fixes,
                        used_assumes=None) -> dict:
        for key, value in parsed.items():
            if key == "namespace" and key in result:
                continue
            if (
                key in ShoedocSchema.ARRAY_KEYS
                and isinstance(value, list)
                and all(isinstance(entry, str) for entry in value)
            ):
                cleaned = self._fix_string_array(
                    key, value, body, adds, fixes, used_assumes
                )
                if cleaned is not None:
                    result[key] = cleaned
            elif (
                key in ShoedocSchema.ENTRY_ARRAY_KEYS
                and isinstance(value, list)
            ):
                if not value:
                    fixes.append(f"removed empty '{key}' property")
                    continue
                result[key] = self.fix_required_defaults(
                    value, key, fixes
                )
            else:
                result[key] = value
        return result

    def _fix_string_array(self, key, value, body, adds, fixes,
                          used_assumes=None):
        if not value:
            fixes.append(f"removed empty '{key}' array")
            return None
        used = used_assumes if key == "assumes" else None
        cleaned, array_fixes = self.fix_string_array_entries(
            value, key, body, used
        )
        fixes.extend(array_fixes)
        to_add = adds.get(key) if adds else None
        if to_add:
            added = [
                entry for entry in sorted(to_add) if entry not in cleaned
            ]
            if added:
                fixes.append(f"added missing '{key}' entries")
                cleaned = sorted(cleaned + added)
        if not cleaned:
            fixes.append(f"removed empty '{key}' array")
            return None
        original = [
            entry for entry in dict.fromkeys(value) if entry in cleaned
        ]
        if cleaned != original:
            fixes.append(f"sorted '{key}' entries")
        return cleaned

    @staticmethod
    def _insert_missing_arrays(result, adds, fixes) -> dict:
        additions = []
        for key in ("requires", "depends", "assumes"):
            to_add = adds.get(key) if adds else None
            if to_add and key not in result:
                fixes.append(f"added missing '{key}' entries")
                additions.append((key, sorted(set(to_add))))
        if not additions:
            return result
        additions_by_key = dict(additions)
        ordered = []
        if "namespace" in result:
            ordered.append(("namespace", result.pop("namespace")))
        for key in ("requires", "depends", "assumes"):
            if key in result:
                ordered.append((key, result.pop(key)))
            elif key in additions_by_key:
                ordered.append((key, additions_by_key[key]))
        return {**dict(ordered), **result}

    def requires_ordering(self, parsed) -> bool:
        """Return True when `parsed` holds at least one object whose keys
        are not in the canonical order."""
        return not self.ordering.keys_ordered(parsed)


class ShellSanitizer:
    """Blank out shell comments, quoted strings and heredoc bodies while
    retaining executable substitutions (command and parameter
    expansions)."""

    DEPTH_LIMIT = 200

    def sanitize(self, text: str, heredoc=None):
        """Blank out comments, quoted strings and heredoc bodies to avoid
        false call detection. Command substitutions (backticks and
        $( ... )) and parameter expansions (``$name``, ``${name}``) inside
        quoted strings or heredocs are preserved: they are actually
        executed or expanded. Returns (sanitized_text,
        trailing_heredoc_delimiter)."""
        chars = list(text)
        heredoc = self._scan(text, chars, 0, len(text), heredoc)
        return "".join(chars), heredoc

    @staticmethod
    def _blank(chars, start, stop) -> None:
        """Replace the given character range with spaces."""
        for index in range(start, min(stop, len(chars))):
            chars[index] = " "

    @staticmethod
    def _is_next(text: str, index: int, stop: int, expected: str) -> bool:
        return index + 1 < stop and text[index + 1] == expected

    @staticmethod
    def _skip_parameter_expansion(text: str, index: int, stop: int) -> int:
        """Skip the ``${...}`` expansion at `index`, nested expansions
        included, so that its braces stay balanced in the sanitized
        text."""
        depth = 0
        cursor = index + 1
        while cursor < stop:
            char = text[cursor]
            if char == "{":
                depth += 1
            elif char == "}":
                depth -= 1
                if depth == 0:
                    return cursor + 1
            cursor += 1
        return stop

    @staticmethod
    def _scan_variable(text: str, index: int, stop: int):
        """Return the index past an unbraced ``$name`` expansion at
        `index`, or None when the dollar does not start a name."""
        if index + 1 >= stop:
            return None
        next_char = text[index + 1]
        if not (next_char.isalpha() or next_char == "_"):
            return None
        index += 2
        while index < stop and (text[index].isalnum() or text[index] == "_"):
            index += 1
        return index

    def _scan(self, text, chars, start, stop, heredoc=None, depth=0):
        """Walk a character range in 'code' context and blank, in place:
          - comments (#...),
          - single-quoted strings,
          - double-quoted strings (recursing into command substitutions
            and preserving parameter expansions),
          - heredoc bodies, whose payload is bounded on each line by a
            delimiter line equal to `heredoc` (recursing into command
            substitutions and preserving parameter expansions).
        Ranges nested deeper than DEPTH_LIMIT command substitutions are
        blanked instead of recursed, so pathological input cannot
        overflow the Python recursion stack. Returns the heredoc
        delimiter still open at the end of the range."""
        if depth > self.DEPTH_LIMIT:
            self._blank(chars, start, stop)
            return heredoc
        index = start
        while index < stop:
            char = text[index]
            if heredoc is not None:
                heredoc, index = self._scan_heredoc_body(
                    text, chars, index, stop, heredoc, depth
                )
                continue
            if (
                char == "#"
                and (index == start or text[index - 1] in " \t;|&(\n")
            ):
                index = self._scan_comment(text, chars, index, stop)
                continue
            if char == "'":
                index = self._scan_single_quote(text, chars, index, stop)
                continue
            if char == '"':
                index = self._dquote(text, chars, index, stop, depth + 1)
                continue
            if char == "`":
                index = self._scan_backtick(
                    text, chars, index, stop, depth, blank_markers=False
                )
                continue
            if char == "$" and self._is_next(text, index, stop, "{"):
                index = self._skip_parameter_expansion(text, index, stop)
                continue
            if char == "$" and self._is_next(text, index, stop, "("):
                index = self._scan_command_substitution(
                    text, chars, index, stop, depth
                )
                continue
            if char == "<" and self._is_next(text, index, stop, "<"):
                if self._is_next(text, index + 1, stop, "<"):
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

    def _scan_heredoc_body(
        self, text, chars, index, stop, heredoc, depth
    ) -> tuple:
        """Blank one heredoc body line; return (heredoc, next_index)."""
        delimiter, quoted = heredoc
        line_end = text.find("\n", index, stop)
        if line_end == -1:
            if not quoted:
                self._payload(text, chars, index, stop, depth + 1)
            else:
                self._blank(chars, index, stop)
            return heredoc, stop
        if text[index:line_end].rstrip(" \t") == delimiter:
            return None, line_end + 1
        if not quoted:
            self._payload(text, chars, index, line_end, depth + 1)
        else:
            self._blank(chars, index, line_end)
        return heredoc, line_end + 1

    def _scan_comment(self, text, chars, index, stop) -> int:
        """Blank one shell comment; return the index of its newline."""
        line_end = text.find("\n", index, stop)
        if line_end == -1:
            self._blank(chars, index, stop)
            return stop
        self._blank(chars, index, line_end)
        return line_end

    def _scan_single_quote(self, text, chars, index, stop) -> int:
        """Blank one single-quoted string; return the index past it."""
        close = text.find("'", index + 1, stop)
        end = stop if close == -1 else close + 1
        self._blank(chars, index, end)
        # Skip a trailing escaped quote ("...'\'...'"), otherwise the
        # unmatched apostrophe would open a string spanning lines.
        if (
            close != -1
            and end + 1 < stop
            and text[end] == "\\"
            and text[end + 1] == "'"
        ):
            self._blank(chars, end, end + 2)
            end += 2
        return end

    def _scan_backtick(
        self, text, chars, index, stop, depth, *, blank_markers: bool
    ) -> int:
        """Recurse into a backtick substitution; return the index past it."""
        close = text.find("`", index + 1, stop)
        end = stop if close == -1 else close + 1
        if close != -1:
            self._scan(text, chars, index + 1, close, None, depth + 1)
        if blank_markers:
            chars[index] = " "
            if close != -1:
                chars[close] = " "
        return end

    def _scan_command_substitution(self, text, chars, index, stop, depth):
        """Recurse into a $( ... ) substitution; return the index past it.
        The closing parenthesis is kept: it terminates the command name it
        follows (e.g. ``$(_pwd)``) without being mistaken for a case
        label, because call detection only considers command positions."""
        close = self._matching_delim(text, index + 1, stop, "(", ")")
        inner_end = stop if close == -1 else close
        self._scan(text, chars, index + 2, inner_end, None, depth + 1)
        return stop if close == -1 else close + 1

    def _dquote(self, text, chars, start, stop, depth=0):
        """Blank a double-quoted string in place (including the quotes);
        the command substitutions it contains are recursed instead of
        blanked. Ranges nested deeper than DEPTH_LIMIT are blanked
        outright. Returns the index just past the closing quote (or
        `stop`)."""
        if depth > self.DEPTH_LIMIT:
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
                index = self._scan_backtick(
                    text, chars, index, stop, depth, blank_markers=True
                )
                continue
            if char == "$" and self._is_next(text, index, stop, "("):
                index = self._scan_command_substitution(
                    text, chars, index, stop, depth
                )
                continue
            if char == "$" and self._is_next(text, index, stop, "{"):
                index = self._skip_parameter_expansion(text, index, stop)
                continue
            if char == "$":
                end = self._scan_variable(text, index, stop)
                if end is not None:
                    index = end
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
        substitutions (backticks and $( ... )) and parameter expansions,
        which are recursed or preserved instead. Ranges nested deeper than
        DEPTH_LIMIT are blanked outright."""
        if depth > self.DEPTH_LIMIT:
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
                index = self._scan_backtick(
                    text, chars, index, stop, depth, blank_markers=True
                )
                continue
            if char == "$" and self._is_next(text, index, stop, "("):
                index = self._scan_command_substitution(
                    text, chars, index, stop, depth
                )
                continue
            if char == "$" and self._is_next(text, index, stop, "{"):
                index = self._skip_parameter_expansion(text, index, stop)
                continue
            if char == "$":
                end = self._scan_variable(text, index, stop)
                if end is not None:
                    index = end
                    continue
            chars[index] = " "
            index += 1
        return stop


class FunctionRegistry:
    """Map each top-level function name to its defining file(s), as
    relative paths from the working directory (without the .sh
    extension)."""

    # Generated artifacts duplicate source modules: they must never
    # become dependencies.
    EXCLUDED_PARTS = ("build", "dump")

    @classmethod
    def candidates(cls) -> dict:
        """Build the registry from the working directory - not from the
        scanned folder - so that functions defined under "src" or under a
        recipe are resolved even when --fix runs on a subfolder. Files
        under a "build" or "dump" folder are excluded.

        A function may be declared by several modules (a core helper and
        a recipe override, or the same helper in different recipes):
        every declaring module is kept so the caller can select the one
        closest to the linted file."""
        registry = {}
        for path in sorted(Path.cwd().rglob("*.sh")):
            if any(
                part in FunctionRegistry.EXCLUDED_PARTS
                for part in path.parts
            ):
                continue
            entry = os.path.relpath(path.with_suffix(""), Path.cwd())
            content = path.read_text(encoding="utf-8", errors="replace")
            for line in content.splitlines():
                match = ShellFunctionParser.FUNCTION_RE.match(line)
                if not match:
                    continue
                entries = registry.setdefault(match.group(1), [])
                if entry not in entries:
                    entries.append(entry)
        return registry

    @classmethod
    def build(cls) -> dict:
        """Map each function name to its defining module, using the first
        module in path order when several modules declare the same
        function."""
        return {
            name: entries[0]
            for name, entries in cls.candidates().items()
        }


class StaticAnalyzer:
    """Analyze shell source for function dependencies and external
    commands."""

    # A call is a command name followed by a separator, a redirection, a
    # backtick or '(' (subshell / command substitution), preceded by
    # anything that is not a word character and not part of a variable or
    # option. This excludes "$name", "-name" and "name=value". Command
    # names may carry hyphens (ssh-add, apt-get, docker-compose...),
    # exactly like shell function names.
    CALL_RE = re.compile(
        r"(?<![\w.$/-])([a-zA-Z_][a-zA-Z0-9_-]*)"
        r"(?=\s|[|;&]|$|\(|\)|[<>`])"
    )

    # Words that introduce a command, as opposed to a loop variable,
    # a case subject or an argument.
    COMMAND_KEYWORDS = frozenset((
        "if", "then", "elif", "else", "while", "until", "do", "time",
    ))
    COMMAND_PREFIXES = frozenset((
        "builtin", "command", "env", "exec", "ionice", "nice", "nohup",
        "stdbuf", "sudo", "xargs",
    ))
    ASSIGNMENT_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*=\S*$")
    WORD_RE = re.compile(r"([A-Za-z_][A-Za-z0-9_-]*)$")

    # Variables maintained by the shell itself: they are never expected
    # from the caller's environment, so they never belong to "assumes".
    SPECIAL_VARIABLES = frozenset((
        "_", "BASH_ARGC", "BASH_ARGV", "BASH_COMMAND", "BASH_LINENO",
        "BASH_REMATCH", "BASH_SOURCE", "BASH_SUBSHELL", "BASH_VERSINFO",
        "BASH_VERSION", "BASHOPTS", "BASHPID", "DIRSTACK", "EUID",
        "FUNCNAME", "GROUPS", "HOSTNAME", "HOSTTYPE", "IFS", "LINENO",
        "MACHTYPE", "OLDPWD", "OPTARG", "OPTIND", "OSTYPE", "PIPESTATUS",
        "PPID", "PWD", "RANDOM", "REPLY", "SECONDS", "SHELLOPTS", "SHLVL",
        "SRANDOM", "UID",
    ))

    # A shell variable read: "$name", "${name}", "${#name}" and
    # "${!name}" all reference the same variable.
    VARIABLE_RE = re.compile(
        r"(?<![\\$])\$\{?(?:[#!])?([A-Za-z_][A-Za-z0-9_]*)"
    )
    IDENTIFIER_RE = re.compile(
        r"(?<![A-Za-z0-9_$])([A-Za-z_][A-Za-z0-9_]*)"
    )
    # "name=value", "name+=value" and "array[index]=value".
    VARIABLE_ASSIGNMENT_RE = re.compile(
        r"(?<![A-Za-z0-9_$./+-])([A-Za-z_][A-Za-z0-9_]*)"
        r"(?:\[[^\]]*\])?\s*\+?=(?!=|~)"
    )
    VARIABLE_DECLARATION_RE = re.compile(
        r"\b(?:local|declare|typeset|export|readonly)\b([^\n;|&]*)"
    )
    LOCAL_VARIABLE_RE = re.compile(
        r"\b(?:local|declare|typeset)\b([^\n;|&]*)"
    )
    LOOP_VARIABLE_RE = re.compile(
        r"\b(?:for|select)\s+([A-Za-z_][A-Za-z0-9_]*)\s+in\b"
    )
    READ_RE = re.compile(r"\bread\b([^\n;|&]*)")
    MAPFILE_RE = re.compile(r"\b(?:mapfile|readarray)\b([^\n;|&]*)")
    GETOPTS_RE = re.compile(
        r"\bgetopts\s+\S+\s+([A-Za-z_][A-Za-z0-9_]*)"
    )
    PRINTF_VARIABLE_RE = re.compile(
        r"\bprintf\b[^\n;|&]*?-v\s+([A-Za-z_][A-Za-z0-9_]*)"
    )
    ARITHMETIC_RE = re.compile(r"\$?\(\((.+?)\)\)", re.DOTALL)
    ARITHMETIC_WRITE_RE = re.compile(
        r"\s*(?:<<|>>|[+\-*/%&|^])?=(?!=|~)"
    )

    def __init__(self, registry, sanitizer=None):
        # Accept both the historical ``name -> path`` mapping and the
        # ``name -> paths`` mapping built by FunctionRegistry.candidates.
        self.registry = {}
        self.registry_candidates = {}
        for name, value in registry.items():
            entries = [value] if isinstance(value, str) else list(value)
            self.registry[name] = entries[0]
            self.registry_candidates[name] = entries
        self.sanitizer = ShellSanitizer() if sanitizer is None else sanitizer
        self._module_requires_cache = {}

    @classmethod
    def from_working_directory(cls, sanitizer=None):
        """Build an analyzer over every function module of the working
        directory (core modules and recipe modules alike)."""
        return cls(FunctionRegistry.candidates(), sanitizer)

    @staticmethod
    def _matching_open_paren(sanitized: str, close_index: int):
        """Return the index of the '(' that matches the ')' at
        close_index, or None when the parenthesis is a case label."""
        depth = 0
        for index in range(close_index, -1, -1):
            char = sanitized[index]
            if char == ")":
                depth += 1
            elif char == "(":
                depth -= 1
                if depth == 0:
                    return index
        return None

    @staticmethod
    def _is_command_position(sanitized: str, start: int, depth=0) -> bool:
        """Return True when the identifier at `start` begins a command in
        the sanitized source, rather than being an argument, a loop
        variable, an array item or an assignment value."""
        if depth > 10:
            return False
        before = sanitized[:start]
        # "name=value": the value is not a command.
        if before.endswith("="):
            return False
        # A new line starts a new command unless the previous line is
        # continued with a backslash (a for-in list, a long command...).
        line_start = before.rfind("\n") + 1
        if not before[line_start:].strip():
            previous_line = before[:line_start].rstrip()
            if previous_line.endswith("\\"):
                previous_line = previous_line[:-1].rstrip()
                return previous_line.endswith((";", "&", "|"))
            return True
        stripped = before.rstrip()
        if stripped.endswith("$(") or stripped.endswith("`"):
            return True
        previous_char = stripped[-1]
        if previous_char in "\n;|&{!":
            if previous_char == "{" and stripped[-2:-1] == "$":
                # "${...}" is a parameter expansion, not a command block.
                return False
            return True
        if previous_char == ")":
            # A case pattern introduces a command; the word after a
            # command substitution is an argument to it, unless the
            # substitution is an assignment value.
            if not before.endswith((" ", "\t")):
                return False
            close_index = len(stripped) - 1
            open_index = StaticAnalyzer._matching_open_paren(
                sanitized, close_index
            )
            if open_index is None:
                return True
            if (
                open_index > 0
                and sanitized[open_index - 1] == "$"
            ):
                prefix = sanitized[:open_index - 1].rstrip()
                return prefix.endswith("=") or prefix.endswith("+=")
            return False
        if previous_char == "(":
            opener = stripped[:-1].rstrip()
            # An array literal follows "name=(" or "name+=(".
            if opener.endswith("=") or opener.endswith("+="):
                return False
            return True
        word_match = StaticAnalyzer.WORD_RE.search(stripped)
        if word_match:
            word = word_match.group(1)
            if word in StaticAnalyzer.COMMAND_KEYWORDS:
                return True
            if word in StaticAnalyzer.COMMAND_PREFIXES:
                return StaticAnalyzer._is_command_position(
                    sanitized, word_match.start(), depth + 1
                )
        assignment = StaticAnalyzer.ASSIGNMENT_RE.search(stripped)
        if assignment:
            value = stripped[assignment.start():]
            # The assigned value may itself be a command substitution:
            # evaluate the call inside it, not the assignment prefix.
            inner = max(value.rfind("$("), value.rfind("`"))
            if inner != -1:
                offset = 2 if value.startswith("$(", inner) else 1
                inner_start = assignment.start() + inner + offset
                return StaticAnalyzer._is_command_position(
                    sanitized[inner_start:],
                    start - inner_start,
                    depth + 1,
                )
            return StaticAnalyzer._is_command_position(
                sanitized, assignment.start(), depth + 1
            )
        return False

    @staticmethod
    def dependency_rank(candidate: str, source=None) -> tuple:
        """Rank a declaring module for a call made from `source`: modules
        sharing the longest path prefix with the source win, then the
        shortest path, then the alphabetical order."""
        candidate_parts = Path(candidate).parts
        source_parts = ()
        if source is not None:
            source_path = Path(source)
            source_parent = (
                source_path.parent if source_path.suffix else source_path
            )
            try:
                source_parent = source_parent.resolve()
                source_parts = source_parent.relative_to(
                    Path.cwd()
                ).parts
            except ValueError:
                source_parts = source_parent.parts
        common = 0
        for left, right in zip(source_parts, candidate_parts):
            if left != right:
                break
            common += 1
        return (-common, len(candidate_parts), candidate)

    def dependency_paths(self, call: str, source=None) -> list:
        """Return the modules declaring `call`, closest first."""
        return sorted(
            self.registry_candidates.get(call, ()),
            key=lambda candidate: StaticAnalyzer.dependency_rank(
                candidate, source
            ),
        )

    def preferred_dependency(self, call: str, source=None):
        """Return the module closest to `source` that declares `call`."""
        paths = self.dependency_paths(call, source)
        return paths[0] if paths else None

    @staticmethod
    def _source_root(source) -> tuple:
        """Return the core or recipe folder that owns `source`."""
        if source is None:
            return ()
        path = Path(source)
        parent = path.parent if path.suffix else path
        try:
            parts = parent.resolve().relative_to(Path.cwd()).parts
        except ValueError:
            parts = parent.parts
        if parts[:1] == ("recipes",):
            return parts[:2]
        return parts[:1]

    def _module_requires(self, module: str) -> set:
        """Return the external commands declared by a module's shoedoc."""
        if module in self._module_requires_cache:
            return self._module_requires_cache[module]
        requires = set()
        try:
            lines = Path(f"{module}.sh").read_text(
                encoding="utf-8", errors="replace"
            ).splitlines(keepends=True)
        except OSError:
            lines = []
        if lines:
            try:
                metadata = ShoedocParser().parse_script_metadata(lines)
            except (TypeError, ValueError):
                metadata = {}
            value = metadata.get("requires")
            if isinstance(value, list):
                requires = {
                    entry.split()[0]
                    for entry in value
                    if isinstance(entry, str) and entry.split()
                }
        self._module_requires_cache[module] = requires
        return requires

    def _is_external_required(self, call: str, candidates: list,
                              source=None) -> bool:
        """Return True when a call listed in the block's "requires" array
        is genuinely external: it has no declaring module in the source's
        core or recipe folder, or every local declaring module also
        documents the command as external."""
        root = StaticAnalyzer._source_root(source)
        local = [
            candidate for candidate in candidates
            if root and Path(candidate).parts[:len(root)] == root
        ]
        if not local:
            return True
        return all(
            call in self._module_requires(candidate)
            for candidate in local
        )

    @staticmethod
    def find_defined_functions(file_lines: list) -> set:
        """All functions defined in the file, including nested
        definitions."""
        return {
            match.group(1)
            for line in file_lines
            if (match := ShellFunctionParser.FUNCTION_RE.match(line.rstrip("\n")))
        }

    def find_function_definitions(self, file_lines: list) -> list:
        """Return ``(name, line_index)`` for every function definition,
        ignoring definitions inside comments, quoted strings and heredoc
        bodies."""
        sanitized, _heredoc = self.sanitizer.sanitize("".join(file_lines))
        definitions = []
        for index, line in enumerate(sanitized.splitlines()):
            match = ShellFunctionParser.FUNCTION_HEADER_RE.match(
                line.rstrip("\r\n")
            )
            if match:
                definitions.append((match.group(1), index))
        return definitions

    def function_body_below(self, file_lines: list, from_index: int):
        """Return the raw source of the function defined after the given
        line index (blank lines allowed between the shoedoc block and the
        function), or None."""
        index = from_index
        total = len(file_lines)
        while index < total and not file_lines[index].strip():
            index += 1
        if index >= total or not ShellFunctionParser.FUNCTION_RE.match(
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
        Only command positions are considered: arguments, loop variables
        and assignment values are not calls. Calls inside quotes, comments
        or heredocs are ignored, except when performed through a command
        substitution (backticks or $( ... ))."""
        calls = set()
        sanitized, _heredoc = self.sanitizer.sanitize(function_body)
        for match in StaticAnalyzer.CALL_RE.finditer(sanitized):
            name = match.group(1)
            if name not in self.registry or name in defined:
                continue
            if self._is_command_position(sanitized, match.start()):
                calls.add(name)
        return calls

    def find_external_commands(self, function_body: str, defined: set) -> set:
        """External commands called by the function body, excluding
        locally defined functions and registry functions: a command is
        detected when an executable with this name exists on PATH. The
        identifier right after for / while is a loop variable, not a
        command. Calls inside quotes, comments or heredocs are ignored,
        except when performed through a command substitution (backticks or
        $( ... ))."""
        commands = set()
        sanitized, _heredoc = self.sanitizer.sanitize(function_body)
        previous = ""
        for match in StaticAnalyzer.CALL_RE.finditer(sanitized):
            name = match.group(1)
            loop_variable = previous in ("for", "while")
            previous = name
            if name in defined or name in self.registry or loop_variable:
                continue
            if shutil.which(name):
                commands.add(name)
        return commands

    @staticmethod
    def _declared_variables(text: str, position: int) -> list:
        """Return the ``(name, position)`` definitions found in a
        declaration or read statement remainder."""
        variables = []
        offset = 0
        for token in text.split():
            token_position = text.find(token, offset)
            offset = token_position + len(token)
            if token.startswith("-"):
                continue
            if token in ("<", ">", ">>", "2>", "2>>", "&>"):
                break
            array_literal = "(" in token
            if array_literal:
                token = token.split("(", 1)[0]
            if "=" in token:
                token = token.split("=", 1)[0]
            if re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", token):
                variables.append((token, position + token_position))
            if array_literal:
                break
        return variables

    @classmethod
    def _variable_reads(cls, sanitized: str) -> list:
        """Return ``(name, position)`` for every variable read in the
        sanitized shell source."""
        reads = []
        for match in cls.VARIABLE_RE.finditer(sanitized):
            reads.append((match.group(1), match.start()))
        # Arithmetic expressions may reference variables without a
        # dollar sign: "$((count + 1))" and "((counter++))".
        for match in cls.ARITHMETIC_RE.finditer(sanitized):
            expression = match.group(1)
            for identifier in cls.IDENTIFIER_RE.finditer(expression):
                after = expression[identifier.end():]
                if cls.ARITHMETIC_WRITE_RE.match(after):
                    # "count=1" and "count+=1" define the variable.
                    continue
                reads.append((
                    identifier.group(1),
                    match.start(1) + identifier.start(),
                ))
        return reads

    @classmethod
    def _variable_definitions(cls, sanitized: str) -> list:
        """Return ``(name, position)`` for every variable definition in
        the sanitized shell source."""
        definitions = []
        for match in cls.VARIABLE_ASSIGNMENT_RE.finditer(sanitized):
            definitions.append((match.group(1), match.start()))
        for match in cls.VARIABLE_DECLARATION_RE.finditer(sanitized):
            definitions.extend(cls._declared_variables(
                match.group(1), match.start(1)
            ))
        for match in cls.LOOP_VARIABLE_RE.finditer(sanitized):
            definitions.append((match.group(1), match.start(1)))
        for match in cls.READ_RE.finditer(sanitized):
            names = cls._declared_variables(
                match.group(1), match.start(1)
            )
            if names:
                definitions.extend(names)
            else:
                # A bare "read" assigns the REPLY variable.
                definitions.append(("REPLY", match.start()))
        for match in cls.MAPFILE_RE.finditer(sanitized):
            names = cls._declared_variables(
                match.group(1), match.start(1)
            )
            definitions.extend(names or [("MAPFILE", match.start())])
        for match in cls.GETOPTS_RE.finditer(sanitized):
            definitions.append((match.group(1), match.start(1)))
        for match in cls.PRINTF_VARIABLE_RE.finditer(sanitized):
            definitions.append((match.group(1), match.start(1)))
        return definitions

    @classmethod
    def _local_variables(cls, sanitized: str) -> set:
        """Return the names declared by local/declare/typeset. A local
        declaration scopes the variable for the whole function, even
        when a nested function reads it before the declaration line."""
        names = set()
        for match in cls.LOCAL_VARIABLE_RE.finditer(sanitized):
            names.update(
                name for name, _position in cls._declared_variables(
                    match.group(1), match.start(1)
                )
            )
        return names

    def find_variable_references(self, text: str) -> set:
        """Return every variable name read by the shell source."""
        sanitized, _heredoc = self.sanitizer.sanitize(text)
        return {name for name, _position in self._variable_reads(sanitized)}

    def find_variable_definitions(self, text: str) -> set:
        """Return every variable name defined by the shell source."""
        sanitized, _heredoc = self.sanitizer.sanitize(text)
        return {
            name for name, _position in self._variable_definitions(sanitized)
        }

    def top_level_definitions(self, file_lines: list,
                              before_index: int) -> set:
        """Return the variables defined by the code before a function."""
        return self.find_variable_definitions(
            "".join(file_lines[:before_index])
        )

    def assumed_variables(self, text: str, defined=()) -> set:
        """Return the variables read before they are defined.

        A variable assigned before its first read is local to the
        element; a variable read before any definition comes from the
        caller (the script environment, a recipe constant or option).
        Variables defined by a sibling module are passed through
        ``defined``."""
        sanitized, _heredoc = self.sanitizer.sanitize(text)
        external = set(defined)
        local_variables = self._local_variables(sanitized)
        first_definition = {}
        for name, position in self._variable_definitions(sanitized):
            previous = first_definition.get(name)
            if previous is None or position < previous:
                first_definition[name] = position
        first_read = {}
        for name, position in self._variable_reads(sanitized):
            previous = first_read.get(name)
            if previous is None or position < previous:
                first_read[name] = position
        assumed = set()
        for name, position in first_read.items():
            if (
                name in self.SPECIAL_VARIABLES
                or name in external
                or name in local_variables
            ):
                continue
            definition = first_definition.get(name)
            if definition is None or definition > position:
                assumed.add(name)
        return assumed

    def missing_assumes(self, parsed, content: str, defined=()) -> set:
        """Return the variables read by the source that are missing from
        the parsed block's "assumes" array."""
        if not isinstance(parsed, dict):
            return set()
        computed = self.assumed_variables(content, defined)
        return self.find_missing_array_entries(parsed, "assumes", computed)

    def unused_assumes(self, parsed, content: str) -> set:
        """Return the "assumes" entries the source never reads."""
        if not isinstance(parsed, dict):
            return set()
        existing = parsed.get("assumes")
        if not isinstance(existing, list):
            return set()
        used = self.find_variable_references(content)
        return {
            entry for entry in existing
            if isinstance(entry, str) and entry not in used
        }

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

    def missing_depends(self, parsed, function_body, defined,
                        source=None) -> set:
        """Return the closest declaring module of each statically detected
        function call that is not covered by the parsed block's "depends"
        array. A call is covered when the array names any module that
        declares it, so an intentional cross-recipe dependency is not
        reported as missing."""
        if not function_body or not isinstance(parsed, dict):
            return set()
        existing = parsed.get("depends")
        existing_set = (
            {entry for entry in existing if isinstance(entry, str)}
            if isinstance(existing, list)
            else set()
        )
        requires = parsed.get("requires")
        required_commands = (
            {
                entry.split()[0]
                for entry in requires
                if isinstance(entry, str) and entry.split()
            }
            if isinstance(requires, list)
            else set()
        )
        missing = set()
        for call in self.find_calls(function_body, defined):
            candidates = self.dependency_paths(call, source)
            # A command documented as external is not a function
            # dependency when no local module provides it, or when the
            # local provider itself documents it as external.
            if call in required_commands and self._is_external_required(
                call, candidates, source
            ):
                continue
            if any(entry in existing_set for entry in candidates):
                continue
            if candidates:
                missing.add(candidates[0])
        return missing


class FileEndingRule:
    """Require a file to end with exactly one trailing blank line.

    A blank line is a line whose content is empty or whitespace-only.
    The file must also terminate that blank line with a newline, so the
    canonical ending is ``\\n\\n`` (or ``\\r\\n\\r\\n`` for CRLF files).
    """

    @staticmethod
    def count_trailing_blank_lines(file_lines: list) -> int:
        """Return the number of blank lines at the end of the file."""
        count = 0
        for line in reversed(file_lines):
            if line.strip():
                break
            count += 1
        return count

    @classmethod
    def issue(cls, file_lines: list):
        """Return a human-readable violation, or None when the file
        already ends with exactly one trailing blank line."""
        count = cls.count_trailing_blank_lines(file_lines)
        if count == 1 and file_lines[-1].endswith(("\n", "\r")):
            return None
        return f"expected exactly one trailing blank line (found {count})"

    @staticmethod
    def newline_for(file_lines: list) -> str:
        """Return the newline style used by the last terminated line."""
        for line in reversed(file_lines):
            if line.endswith("\r\n"):
                return "\r\n"
            if line.endswith("\n"):
                return "\n"
            if line.endswith("\r"):
                return "\r"
        return "\n"

    @classmethod
    def normalize(cls, file_lines: list) -> list:
        """Return the file lines with exactly one trailing blank line."""
        newline = cls.newline_for(file_lines)
        normalized = list(file_lines)
        while normalized and not normalized[-1].strip():
            normalized.pop()
        if not normalized:
            return [newline]
        if not normalized[-1].endswith(("\n", "\r")):
            normalized[-1] += newline
        normalized.append(newline)
        return normalized


class _FileLintContext:
    """Hold the state collected while linting a single shell file."""

    def __init__(self, path, file_lines, body, defined, analyzer, records,
                 script_indexes):
        self.path = path
        self.file_lines = file_lines
        self.body = body
        self.defined = defined
        self.analyzer = analyzer
        self.records = records
        self.script_indexes = set(script_indexes)
        self.replacements = []

    def source(self, line_index: int) -> str:
        """Return the ``path:line`` label used in diagnostics."""
        return f"{self.path}:{line_index + 1}"

    def add_replacement(self, start: int, length: int, lines: list) -> None:
        self.replacements.append((start, length, lines))

    def write(self, force: bool = False) -> None:
        """Apply the queued replacements and persist the file."""
        if not self.replacements and not force:
            return
        for start, length, lines in reversed(self.replacements):
            self.file_lines[start:start + length] = lines
        self.path.write_text("".join(self.file_lines), encoding="utf-8")


class _LintStats:
    """Count lint findings and expose the command exit code."""

    def __init__(self):
        self.blocks = 0
        self.error_count = 0
        self.warning_count = 0
        self.failed = False

    def add_errors(self, errors: list) -> None:
        if not errors:
            return
        self.failed = True
        self.error_count += len(errors)

    def add_warnings(self, warnings: list) -> None:
        self.warning_count += len(warnings)

    def add_warning(self) -> None:
        self.warning_count += 1

    def exit_code(self) -> int:
        return 1 if self.failed else 0

    def report(self) -> None:
        if self.failed:
            print(
                f"{self.blocks} block(s) checked, {self.error_count} "
                f"error(s), {self.warning_count} warning(s)"
            )
            return
        print(
            f"{self.blocks} block(s) checked, no error, "
            f"{self.warning_count} warning(s)"
        )


class ShoedocLinter:
    """Validate and optionally repair classic Shoedoc @-tag annotations."""

    # Classic tag name to Shoedoc property name, for ordering.
    TAG_KEYS = MappingProxyType({
        "author": "authors",
        "link": "links",
        "example": "examples",
        "param": "params",
        "option": "options",
        "flag": "flags",
        "constant": "constants",
        "variable": "variables",
        "private": "private",
        "public": "private",
    })

    def __init__(
        self,
        rules=None,
        parser=None,
        analyzer=None,
        serializer=None,
        fixer=None,
        validator=None,
    ):
        self.validator = (
            ShoedocValidator() if validator is None else validator
        )
        fixer = ShoedocFixer(self.validator) if fixer is None else fixer
        if rules is None:
            rules = (
                ShoedocRule(("namespace",), self.validator),
                ShoedocRule(ShoedocSchema.ARRAY_KEYS, self.validator),
                ShoedocRule(
                    (
                        "authors", "examples", "links", "overrides", "shell",
                        "private", "summary",
                    ) + ShoedocSchema.STRING_PROPERTIES,
                    self.validator,
                ),
                ShoedocRule(
                    ShoedocSchema.ENTRY_ARRAY_KEYS, self.validator
                ),
            )
        self.rules = tuple(rules)
        self._rules_by_property = {}
        for rule in self.rules:
            for name in rule.property_names:
                self._rules_by_property.setdefault(name, rule)
        self.fixer = fixer
        self.parser = ShoedocParser(fixer) if parser is None else parser
        self.analyzer = analyzer
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )

    def validate(
        self,
        parsed,
        source: str,
        body: str = "",
        scope: str = "function",
    ) -> tuple:
        """Validate a parsed shoedoc block.

        ``scope`` is "function" or "script": script-level blocks cannot
        own namespace, requires, or the std stream properties.
        """
        if not isinstance(parsed, dict):
            return [f"{source}: shoedoc block is not a mapping"], []
        errors = []
        for key, value in parsed.items():
            if (
                scope == "script"
                and key in ShoedocSchema.SCRIPT_FORBIDDEN_PROPERTIES
            ):
                errors.append(f"script block cannot own a '{key}' property")
                continue
            rule = self._rules_by_property.get(key)
            if rule is None:
                errors.append(f"unknown property: '{key}'")
            else:
                rule.validate(key, value, errors)
        if body:
            for key in ShoedocSchema.ARRAY_KEYS:
                value = parsed.get(key)
                if isinstance(value, list) and all(
                    isinstance(item, str) for item in value
                ):
                    self.validator.check_string_array_usage(
                        value, key, body, errors
                    )
            overrides = parsed.get("overrides")
            if isinstance(overrides, str):
                self.validator.check_string_array_usage(
                    [overrides], "overrides", body, errors
                )
        warnings = []
        if "namespace" not in parsed and scope != "script":
            warnings.append("missing 'namespace' property")
        return (
            [f"{source}: {error}" for error in errors],
            [f"{source}: {warning}" for warning in warnings],
        )

    def lint(self, folder, fix: bool = False) -> int:
        """Lint (and optionally repair) every .sh file under ``folder``."""
        folder_path = Path(folder)
        if not folder_path.is_dir():
            print(
                f"error: not a directory: {folder_path}", file=sys.stderr
            )
            return 2

        analyzer = (
            StaticAnalyzer.from_working_directory()
            if self.analyzer is None
            else self.analyzer
        )
        stats = _LintStats()
        for path in sorted(folder_path.rglob("*.sh")):
            if "build" in path.parts:
                # build artifacts are not scanned
                continue
            try:
                self._lint_file(path, analyzer, fix, stats)
            except OSError as error:
                stats.add_errors([f"{path}: {error}"])
                print(f"error: {path}: {error}", file=sys.stderr)
        stats.report()
        return stats.exit_code()

    def _lint_file(self, path, analyzer, fix: bool, stats: _LintStats) -> None:
        with path.open(
            "r", encoding="utf-8", errors="replace", newline=""
        ) as source:
            content = source.read()
        file_lines = content.splitlines(keepends=True)
        ending_fixed = self._lint_file_ending(path, file_lines, fix, stats)
        self._lint_module_shape(path, file_lines, analyzer, stats)
        annotations = self.parser.capture_function_annotations(file_lines)
        script_indexes = self.parser.script_metadata_indices(file_lines)
        if not annotations and not script_indexes:
            if ending_fixed:
                path.write_text("".join(file_lines), encoding="utf-8")
            return
        context = self._build_context(
            path, file_lines, annotations, script_indexes, analyzer
        )
        self._lint_script_annotations(context, script_indexes, fix, stats)
        for record in annotations:
            line_indexes = [
                index for index in record.line_indexes
                if index not in context.script_indexes
            ]
            if line_indexes:
                self._lint_function_annotation(
                    context, record, line_indexes, fix, stats
                )
        context.write(force=ending_fixed)

    def _lint_file_ending(
        self, path, file_lines, fix: bool, stats: _LintStats
    ) -> bool:
        """Check that the file ends with exactly one trailing blank line.

        Returns True when ``--fix`` rewrote the ending."""
        issue = FileEndingRule.issue(file_lines)
        if issue is None:
            return False
        if not fix:
            self._report_errors([f"{path}: {issue}"], stats)
            return False
        file_lines[:] = FileEndingRule.normalize(file_lines)
        print(f"fixed: {path} (normalized trailing blank line)")
        return True

    def _lint_module_shape(
        self, path, file_lines, analyzer, stats: _LintStats
    ) -> None:
        """Check a function module owns one function named after the file.

        Files without any function are component files (headers, constants,
        options, variables): they are not function modules and are left
        alone."""
        definitions = analyzer.find_function_definitions(file_lines)
        if not definitions:
            return
        if len(definitions) > 1:
            names = ", ".join(name for name, _index in definitions)
            self._report_errors(
                [
                    f"{path}: module defines {len(definitions)} functions "
                    f"({names}); expected exactly one"
                ],
                stats,
            )
            return
        name, index = definitions[0]
        if name != path.stem:
            self._report_errors(
                [
                    f"{path}:{index + 1}: function '{name}' does not "
                    f"match module name '{path.stem}'"
                ],
                stats,
            )

    def _build_context(
        self, path, file_lines, annotations, script_indexes, analyzer
    ) -> _FileLintContext:
        annotation_spans = {
            index
            for record in annotations
            for index in record.line_indexes
        }
        body = analyzer.sanitizer.sanitize(
            "".join(
                line
                for index, line in enumerate(file_lines)
                if index not in annotation_spans
            )
        )[0]
        defined = analyzer.find_defined_functions(file_lines)
        return _FileLintContext(
            path, file_lines, body, defined, analyzer, annotations,
            script_indexes,
        )

    def _lint_script_annotations(
        self, context, script_indexes, fix: bool, stats: _LintStats
    ) -> None:
        """Lint the first script-level annotation run of the file."""
        if not script_indexes:
            return
        annotation_lines = [
            context.file_lines[index].rstrip("\r\n")
            for index in script_indexes
        ]
        self._lint_block(
            context, annotation_lines, script_indexes[0], "script", fix, stats
        )

    def _lint_function_annotation(
        self, context, record, line_indexes, fix: bool, stats: _LintStats
    ) -> None:
        annotation_lines = [
            context.file_lines[index].rstrip("\r\n")
            for index in line_indexes
        ]
        self._lint_block(
            context,
            annotation_lines,
            line_indexes[0],
            "function",
            fix,
            stats,
            function_line_index=record.function_line_index,
        )

    def _lint_block(
        self,
        context,
        annotation_lines: list,
        start_index: int,
        scope: str,
        fix: bool,
        stats: _LintStats,
        function_line_index=None,
    ) -> None:
        """Validate, and optionally repair, one classic annotation run."""
        stats.blocks += 1
        source = context.source(start_index)
        if self._is_legacy_json_block(annotation_lines):
            self._warn(
                f"{source}: legacy JSON shoedoc annotations are no longer "
                f"supported; use classic @-tags",
                stats,
            )
            return
        parsed, parse_warnings = self.parser.parse_classic_block(
            annotation_lines, start_index
        )
        self._report_parse_warnings(parse_warnings, stats)
        if parsed is None:
            parsed = {}
        errors, warnings = self.validate(parsed, source, context.body, scope)
        unordered = not self._classic_tags_ordered(annotation_lines)
        missing = set()
        requires_missing = set()
        function_source = None
        if scope == "function" and function_line_index is not None:
            function_source = context.analyzer.function_body_below(
                context.file_lines, function_line_index
            )
            missing = context.analyzer.missing_depends(
                parsed, function_source, context.defined, context.path
            )
            warnings.extend(self._missing_depends_warnings(source, missing))
            requires_missing = context.analyzer.missing_requires(
                parsed, function_source, context.defined
            )
        assumes_missing, assumes_unused = self._assumes_findings(
            context, parsed, function_source, function_line_index, scope
        )
        errors.extend(self._assumes_errors(source, assumes_missing))
        for entry in sorted(assumes_unused):
            message = f"{source}: 'assumes' unused entry: {entry!r}"
            if message not in errors:
                errors.append(message)
        namespace_value = None
        missing_namespace = False
        wrong_namespace = None
        if scope == "function":
            namespace_value, missing_namespace, wrong_namespace = (
                self._namespace_state(context, parsed, fix)
            )
        needs_repair = bool(
            errors
            or unordered
            or missing
            or requires_missing
            or assumes_missing
            or assumes_unused
            or missing_namespace
            or wrong_namespace is not None
        )
        if not fix or not needs_repair:
            self._report(errors, warnings, stats)
            return
        used_assumes = context.analyzer.find_variable_references(
            "".join(context.file_lines)
        )
        fixed, fixes = self.fixer.fix_dictionary(
            parsed,
            context.body,
            {
                "depends": missing if missing else (),
                "requires": requires_missing if requires_missing else (),
                "assumes": assumes_missing if assumes_missing else (),
            },
            namespace_value if missing_namespace else None,
            wrong_namespace,
            used_assumes=used_assumes,
        )
        if fixed is None:
            self._report(errors, warnings, stats)
            return
        if unordered and not fixes:
            fixes.append("ordered properties")
        post_errors, post_warnings = self.validate(
            fixed, source, context.body, scope
        )
        # When the original block could not be parsed at all, its errors
        # were masked by the parse failure: any repaired state is an
        # improvement.
        new_errors = (
            [error for error in post_errors if error not in errors]
            if parsed else []
        )
        fixed_assumes_missing, fixed_assumes_unused = (
            self._assumes_findings(
                context, fixed, function_source, function_line_index, scope
            )
        )
        still_missing = bool(fixed_assumes_missing or fixed_assumes_unused)
        if scope == "function" and function_line_index is not None:
            still_missing = bool(
                still_missing
                or context.analyzer.missing_depends(
                    fixed, function_source, context.defined, context.path
                )
                or context.analyzer.missing_requires(
                    fixed, function_source, context.defined
                )
            )
        if not fixes or new_errors or still_missing:
            self._report(errors, warnings, stats)
            return
        context.add_replacement(
            start_index,
            len(annotation_lines),
            self._classic_block_lines(fixed),
        )
        print(f"fixed: {source} ({', '.join(sorted(fixes))})")
        self._report(post_errors, post_warnings, stats)

    def _assumes_findings(
        self, context, parsed, function_source, function_line_index, scope
    ) -> tuple:
        """Return the missing and unused "assumes" entries of a block."""
        if scope == "function" and function_source is not None:
            defined = context.analyzer.top_level_definitions(
                context.file_lines, function_line_index
            )
            missing = context.analyzer.missing_assumes(
                parsed, function_source, defined
            )
        else:
            missing = context.analyzer.missing_assumes(
                parsed, "".join(context.file_lines)
            )
        unused = context.analyzer.unused_assumes(
            parsed, "".join(context.file_lines)
        )
        return missing, unused

    @staticmethod
    def _assumes_errors(source: str, missing: set) -> list:
        return [
            f'{source}: \'assumes\' missing entry: "{entry}"'
            for entry in sorted(missing)
        ]

    @staticmethod
    def _is_legacy_json_block(annotation_lines: list) -> bool:
        """Return True for a run that opens a legacy JSON envelope."""
        return any(
            ShoedocParser.is_shoedoc_line(line)
            and line[2:].strip() == "{"
            for line in annotation_lines
        )

    @classmethod
    def _classic_tags_ordered(cls, annotation_lines: list) -> bool:
        """Return True when the classic tags follow the canonical order."""
        ranks = []
        for line in annotation_lines:
            if not ShoedocParser.is_shoedoc_line(line):
                continue
            body = line[2:].strip()
            match = ShoedocParser.TAG_RE.match(body)
            if match is None:
                continue
            key = cls.TAG_KEYS.get(match.group(1), match.group(1))
            if key in ShoedocSchema.ORDERED_KEYS:
                ranks.append(ShoedocSchema.ORDERED_KEYS.index(key))
        return not ranks or ranks == sorted(ranks)

    @staticmethod
    def _report_parse_warnings(warnings: list, stats: _LintStats) -> None:
        for warning in warnings:
            stats.add_warning()
            print(warning.rstrip("\n"))

    @staticmethod
    def _missing_depends_warnings(source: str, missing: set) -> list:
        return [
            f'{source}: \'depends\' missing entry: "{entry}"'
            for entry in sorted(missing)
        ]

    def _namespace_state(self, context, parsed, fix: bool):
        """Return the expected namespace and the repair flags it drives."""
        namespace_value = os.path.relpath(
            context.path.parent, Path.cwd()
        )
        # A root-level file has no valid relative namespace ("." is not a
        # valid relative path): namespace insertion/repair is then
        # skipped.
        if not ShoedocSchema.REL_PATH_RE.match(namespace_value):
            namespace_value = None
        missing_namespace = (
            isinstance(parsed, dict)
            and "namespace" not in parsed
            and fix
            and namespace_value is not None
        )
        wrong_namespace = None
        if (
            fix
            and isinstance(parsed, dict)
            and namespace_value is not None
        ):
            value = parsed.get("namespace")
            if isinstance(value, str) and not Path(value).is_dir():
                wrong_namespace = namespace_value
        return namespace_value, missing_namespace, wrong_namespace

    def _classic_block_lines(self, parsed) -> list:
        """Serialize a repaired block into file lines with newlines."""
        return [
            f"{line}\n" for line in self.serializer.classic_lines(parsed)
        ]

    @staticmethod
    def _report(errors: list, warnings: list, stats: _LintStats) -> None:
        if errors:
            stats.add_errors(errors)
            for error in errors:
                print(f"error: {error}")
        if warnings:
            stats.add_warnings(warnings)
            for warning in warnings:
                print(f"warning: {warning}")

    def _report_errors(self, errors: list, stats: _LintStats) -> None:
        self._report(errors, [], stats)

    @staticmethod
    def _warn(message: str, stats: _LintStats) -> None:
        stats.add_warning()
        print(f"warning: {message}")


class ShellFunctionParser:
    """Find shell function declarations and extract their source blocks."""

    FUNCTION_RE = re.compile(
        r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)\s*\{"
    )
    FUNCTION_HEADER_RE = re.compile(
        r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)"
    )

    def __init__(self, source: str, sanitizer=None):
        self.lines = source.splitlines(keepends=True)
        self.sanitizer = ShellSanitizer() if sanitizer is None else sanitizer

    def function_definitions(self) -> list:
        """Return ``(name, line_index)`` for every function definition,
        ignoring definitions carried by comments, quoted strings and
        heredoc payloads."""
        sanitized, _heredoc = self.sanitizer.sanitize("".join(self.lines))
        definitions = []
        for index, line in enumerate(sanitized.splitlines()):
            match = self.FUNCTION_HEADER_RE.match(line.rstrip("\r\n"))
            if match:
                definitions.append((match.group(1), index))
        return definitions

    def function_names(self, include_private: bool = True) -> list:
        return [
            name for name, _index in self.function_definitions()
            if include_private or not name.startswith("_")
        ]

    def function_ranges(self) -> list:
        """Return ``(name, first_line, last_line)`` for every function
        definition, closing line included. Nested definitions belong to
        their enclosing function, and braces carried by comments, quoted
        strings or heredoc payloads never close a function early."""
        sanitized, _heredoc = self.sanitizer.sanitize("".join(self.lines))
        ranges = []
        name = None
        start = 0
        opened = False
        depth = 0
        for index, line in enumerate(sanitized.splitlines(keepends=True)):
            if name is None:
                match = self.FUNCTION_HEADER_RE.match(
                    line.rstrip("\r\n")
                )
                if match is None:
                    continue
                name = match.group(1)
                start = index
                opened = False
                depth = 0
            if "{" in line:
                opened = True
            depth += line.count("{") - line.count("}")
            if opened and depth <= 0:
                ranges.append((name, start, index))
                name = None
        return ranges

    def extract_function(self, name: str) -> str:
        """Return the function source, including its leading comment run."""
        function_index = self._function_index(name)
        annotation_start = self._annotation_start(function_index)
        body_end = self._function_body_end(function_index)
        return "".join(self.lines[annotation_start:body_end + 1])

    def function_source_ranges(self) -> list:
        """Return ``(name, first_line, last_line)`` for every function
        source, leading comment run included."""
        return [
            (
                name,
                self._annotation_start(function_index),
                self._function_body_end(function_index),
            )
            for name, function_index in self.function_definitions()
        ]

    def _function_index(self, name: str) -> int:
        index = next(
            (
                function_index
                for function_name, function_index in self.function_definitions()
                if function_name == name
            ),
            None,
        )
        if index is None:
            raise KeyError(f"function not found: {name}")
        return index

    def _annotation_start(self, function_index: int) -> int:
        start = function_index
        while start > 0 and self.lines[start - 1].startswith("#"):
            start -= 1
        return start

    def _function_body(self, function_index: int) -> list:
        body_end = self._function_body_end(function_index)
        return self.lines[function_index:body_end + 1]

    def _function_body_end(self, function_index: int) -> int:
        """Return the index of the line that closes the function, or the
        last file line when the function never closes."""
        brace_depth = 0
        function_started = False
        heredoc = None
        for index in range(function_index, len(self.lines)):
            line = self.lines[index]
            sanitized, heredoc = self.sanitizer.sanitize(line, heredoc)
            brace_depth += sanitized.count("{") - sanitized.count("}")
            if brace_depth > 0:
                function_started = True
            elif index == function_index and "{" in sanitized:
                function_started = True
            if function_started and brace_depth <= 0:
                return index
        return len(self.lines) - 1


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

    @staticmethod
    def collect_scripts(path) -> tuple:
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
                for file_path in FileHandler.walk_paths(
                    source, recursive=True
                )
                if file_path.suffix == ".sh"
            ], []
        return [], [f'error: not a file or directory: "{source}"']

    @classmethod
    def unique_scripts(cls, paths) -> tuple:
        """Expand command-line paths into unique .sh file paths."""
        files = []
        seen = set()
        errors = []
        for raw_path in paths:
            collected, path_errors = cls.collect_scripts(raw_path)
            errors.extend(path_errors)
            for file_path in collected:
                if file_path in seen:
                    continue
                seen.add(file_path)
                files.append(file_path)
        return files, errors


class SynopsisBlock(NamedTuple):
    """Locate one legacy Synopsis comment block inside a function body."""

    function_name: str
    start_index: int
    length: int
    first_body_line: bool


class SynopsisMigrator:
    """Remove the legacy Synopsis comment blocks carried by functions.

    Before Shoedoc, every function repeated its signature and parameter
    documentation in a hand-written comment block at the top of its body:

        # Synopsis: _foo <FOO> [BAR]
        #   FOO: The first argument.
        #   BAR: (optional) The second argument.

    The Shoedoc annotation above the function now owns this information: the
    block is dead documentation. This one-shot migration strips the
    comment block without touching the function code; comment lines
    carried by heredoc payloads are data and are never removed.
    """

    SYNOPSIS_RE = re.compile(r"^\s*#{1,2}\s*synopsis\s*:", re.IGNORECASE)
    CONTINUATION_RE = re.compile(
        r"^\s*#{1,2}(?:\s{2,}\S|\s+[A-Za-z_][A-Za-z0-9_]*\s*:)"
    )

    def __init__(self, parser_factory=None, paths=None, sanitizer=None):
        self.parser_factory = (
            ShellFunctionParser if parser_factory is None else parser_factory
        )
        self.paths = ShoemakerPathResolver() if paths is None else paths
        self.sanitizer = ShellSanitizer() if sanitizer is None else sanitizer

    def find_blocks(self, file_lines: list) -> list:
        """Locate every Synopsis block sitting inside a function body,
        nested functions included. A script-level Synopsis comment does
        not belong to a function and is left untouched."""
        parser = self.parser_factory(
            "".join(file_lines), sanitizer=self.sanitizer
        )
        payload = self._heredoc_lines(file_lines)
        blocks = []
        for name, start, end in parser.function_ranges():
            index = start + 1
            while index < end:
                if (
                    index not in payload
                    and self.SYNOPSIS_RE.match(file_lines[index])
                ):
                    last = self._block_end(file_lines, index, end, payload)
                    blocks.append(SynopsisBlock(
                        name,
                        index,
                        last - index + 1,
                        index == start + 1,
                    ))
                    index = last + 1
                    continue
                index += 1
        return blocks

    def _heredoc_lines(self, file_lines: list) -> set:
        """Return the indexes of the lines that belong to a heredoc
        payload: a '#' line carried by a heredoc is data, not a comment."""
        indexes = set()
        heredoc = None
        for index, line in enumerate(file_lines):
            if heredoc is not None:
                indexes.add(index)
            _sanitized, heredoc = self.sanitizer.sanitize(line, heredoc)
        return indexes

    def _block_end(self, file_lines: list, start: int, limit: int,
                   payload: set) -> int:
        """Return the index of the last line of the block that starts at
        `start`: the Synopsis header plus the indented detail and
        continuation lines that follow it."""
        last = start
        cursor = start + 1
        while cursor < limit:
            if (
                cursor in payload
                or not self.CONTINUATION_RE.match(file_lines[cursor])
            ):
                break
            last = cursor
            cursor += 1
        return last

    def remove_blocks(self, file_lines: list) -> tuple:
        """Return ``(new_lines, blocks)``: the file lines stripped of the
        Synopsis blocks and the removed block records."""
        blocks = self.find_blocks(file_lines)
        if not blocks:
            return list(file_lines), []
        dropped = set()
        for block in blocks:
            dropped.update(range(
                block.start_index, block.start_index + block.length
            ))
            self._drop_leading_blank(file_lines, block, dropped)
        remaining = [
            line for index, line in enumerate(file_lines)
            if index not in dropped
        ]
        return remaining, blocks

    @staticmethod
    def _drop_leading_blank(file_lines: list, block: SynopsisBlock,
                            dropped: set) -> None:
        """Drop the blank line left at the top of the function body when
        the block was its first line."""
        if not block.first_body_line:
            return
        following = block.start_index + block.length
        if following < len(file_lines) and not file_lines[following].strip():
            dropped.add(following)

    def migrate_content(self, content: str) -> tuple:
        """Return ``(new_content, removed)`` for the given file content."""
        new_lines, blocks = self.remove_blocks(
            content.splitlines(keepends=True)
        )
        return "".join(new_lines), len(blocks)

    def migrate_paths(self, paths: list, dry_run=False) -> int:
        """Remove the Synopsis blocks of the given files or folders and
        return the command exit code."""
        files, errors = self.paths.unique_scripts(paths)
        exit_code = 0
        for error in errors:
            sys.stderr.write(error + "\n")
            exit_code = 1
        for file_path in files:
            if self._migrate_file(file_path, dry_run):
                exit_code = 1
        return exit_code

    def _migrate_file(self, file_path: str, dry_run: bool) -> int:
        """Remove the Synopsis blocks of one file; return 1 when it could
        not be processed."""
        try:
            with Path(file_path).open(
                "r", encoding="utf-8", errors="replace", newline=""
            ) as source:
                content = source.read()
        except OSError as error:
            sys.stderr.write(
                "error: cannot read %s: %s\n" % (file_path, error)
            )
            return 1
        new_content, removed = self.migrate_content(content)
        if removed == 0:
            return 0
        if dry_run:
            sys.stdout.write("==> %s <==\n" % file_path)
            sys.stdout.write(new_content)
            if not new_content.endswith("\n"):
                sys.stdout.write("\n")
            return 0
        try:
            Path(file_path).write_text(new_content, encoding="utf-8")
        except OSError as error:
            sys.stderr.write(
                "error: cannot write %s: %s\n" % (file_path, error)
            )
            return 1
        sys.stderr.write(
            "Migrated: %s (%d synopsis block(s))\n" % (file_path, removed)
        )
        return 0


class RecipeCommandService:
    """Implement source extraction, recipe writing and build commands."""

    HEADER_FILE = "header.sh"
    KERNEL_NAMESPACE = "src/shell/kernel"

    def __init__(self, paths=None, function_parser_factory=None,
                 dependencies=None):
        self.paths = ShoemakerPathResolver() if paths is None else paths
        self.function_parser_factory = (
            ShellFunctionParser
            if function_parser_factory is None
            else function_parser_factory
        )
        self.dependencies = (
            DependencyTreeResolver()
            if dependencies is None else dependencies
        )

    def dump(self, file_path, destination=None) -> Path:
        """Write each function source to its own file, under the folder
        named after the namespace declared by its annotation, and write
        the build recipe listing the extracted files together with every
        source line that was not exported. Shoedoc annotations are kept
        as classic @-tags."""
        source = self.paths.require_file(file_path)
        output_dir = self.paths.output_directory(
            destination, Path.cwd() / "dump" / source.stem, create=True
        )
        content = source.read_text(encoding="utf-8")
        functions = self.function_parser_factory(content)
        namespaces = self._function_namespaces(content)
        entries = []
        for name in functions.function_names(include_private=True):
            relative_path = self._function_path(name, namespaces)
            target = output_dir / relative_path
            target.parent.mkdir(parents=True, exist_ok=True)
            body = functions.extract_function(name)
            target.write_text(
                self._function_source(body), encoding="utf-8"
            )
            entries.append((name, relative_path.as_posix()))
        self._write_recipe(
            output_dir / f"{source.stem}.shoe",
            self._recipe_lines(functions, dict(entries)),
        )
        return output_dir

    @staticmethod
    def _recipe_lines(functions, entries: dict) -> list:
        """Return the recipe lines: each exported function run replaced by
        its module path, every other source line kept in place."""
        replacements = {}
        exported = set()
        for name, start, end in functions.function_source_ranges():
            if name in entries:
                replacements.setdefault(start, entries[name])
            exported.update(range(start, end + 1))
        lines = []
        for index, line in enumerate(functions.lines):
            if index in replacements:
                lines.append(replacements[index] + "\n")
            if index not in exported:
                lines.append(line)
        return lines

    def _function_source(self, body: str) -> str:
        """Render one extracted function as a standalone shell file."""
        output = "#!/bin/sh\n\n" + body
        if not output.endswith("\n"):
            output += "\n"
        return output

    @staticmethod
    def _write_recipe(recipe_path: Path, lines: list) -> Path:
        """Write a recipe from its rendered lines."""
        content = "".join(lines)
        if content and not content.endswith("\n"):
            content += "\n"
        recipe_path.write_text(content, encoding="utf-8")
        return recipe_path

    @staticmethod
    def _function_namespaces(content: str) -> dict:
        """Map each annotated function to the namespace it declares.

        The annotation runs are captured before the script/function
        scoping is applied: in a single-function module the Shoedoc
        block can be read as script metadata, yet it still describes the
        function below it. Unannotated functions are absent from the
        map: they carry no namespace and stay at the root of the output
        folder."""
        parser = ShoedocParser()
        namespaces = {}
        for annotation in parser.capture_function_annotations(
            content.splitlines(keepends=True)
        ):
            try:
                metadata = parser.parse_annotation_lines(
                    annotation.lines
                )
            except (TypeError, ValueError):
                continue
            if isinstance(metadata, dict):
                namespaces[annotation.function_name] = metadata.get(
                    "namespace"
                )
        return namespaces

    @staticmethod
    def _function_path(name: str, namespaces: dict) -> Path:
        """Return the path of a function relative to the output folder:
        its namespace folder, then the function file name. A namespace
        that is not a safe relative path is ignored with a warning, so a
        hostile annotation can never write outside the destination."""
        namespace = namespaces.get(name)
        if namespace is None:
            return Path(f"{name}.sh")
        if (
            isinstance(namespace, str)
            and ShoedocSchema.REL_PATH_RE.match(namespace)
        ):
            return Path(namespace) / f"{name}.sh"
        sys.stderr.write(
            'warning: invalid namespace for function "%s": %r\n'
            % (name, namespace)
        )
        return Path(f"{name}.sh")

    def build(self, file_path, destination=None, shell="bash") -> Path:
        """Concatenate a .shoe recipe's components, and their transitive
        `depends`, into one script, ignoring overridden modules. Shoedoc
        annotations are kept as classic @-tags."""
        recipe = self.paths.require_file(file_path)
        output_dir = self.paths.output_directory(
            destination, Path.cwd() / "build", create=True
        )
        shell = self._shell_for(shell)
        pieces, components, warnings = self._build_pieces(recipe)
        warnings.extend(self._duplicate_function_warnings(components))
        for warning in warnings:
            sys.stderr.write(warning)
        content = "#!/usr/bin/env %s\n" % shell
        if pieces:
            content += "\n".join(pieces) + "\n"
        content = re.sub(r"\n{3,}", "\n\n", content)
        output = output_dir / f"{self._script_name(recipe)}.sh"
        output.write_text(content, encoding="utf-8")
        return output

    @staticmethod
    def _shell_for(shell: str) -> str:
        if shell not in ("sh", "bash"):
            raise ValueError("shell must be one of: sh, bash")
        return shell

    def _build_pieces(self, recipe: Path) -> tuple:
        """Return ``(pieces, components, warnings)``: the ordered shell
        files included in the build, each preceded by its recipe comments,
        and the warnings. A module named by an `overrides` property is
        superseded: it is ignored even when another component requires it
        transitively.

        Components outside the `src` tree keep their dependency order.
        Components from the `src` tree are grouped by category then sorted
        by name, exactly like the source directory. The kernel is always
        emitted last, because importing it runs the command dispatcher at
        the bottom of the built script."""
        entries = self._recipe_entries(recipe)
        overridden = self._overridden_components(
            component
            for _entry, component in entries
            if component is not None
        )
        components, warnings = self._collect_components(entries, overridden)
        ordered = self._ordered_components(components)
        prefixes, trailing = self._recipe_prefixes(entries, overridden)
        pieces = []
        for component in ordered:
            prefix = prefixes.pop(
                self._component_category(component), None
            )
            if prefix:
                pieces.extend(prefix)
            pieces.append(self._component_body(component))
        pieces.extend(trailing)
        return pieces, ordered, warnings

    def _collect_components(self, entries: list,
                            overridden: set) -> tuple:
        """Return every component of the build, transitive dependencies
        included, in dependency-first discovery order.

        A dependency already listed in the recipe is left at its declared
        position: it is not pulled in as a transitive dependency, and its
        own dependencies are collected when that recipe entry is
        processed. Overridden entries are not boundaries: they are not
        emitted, so their dependencies keep being collected."""
        explicit = {
            component for _entry, component in entries
            if component is not None
        }
        # Overridden components are never emitted: their dependencies are
        # still collected, exactly like before.
        boundaries = explicit - overridden
        components = []
        included = set()
        warnings = []
        for _entry, component in entries:
            if component is None or component in overridden:
                continue
            labels, dependency_warnings = self.dependencies.collect(
                component, boundaries=boundaries
            )
            warnings.extend(dependency_warnings)
            for label in labels:
                dependency = self.dependencies.resolve_dep_file(
                    label, component.parent
                )
                if dependency is None:
                    continue
                dependency = dependency.resolve()
                if (
                    dependency == component
                    or dependency in included
                    or dependency in overridden
                    or dependency in explicit
                ):
                    continue
                included.add(dependency)
                components.append(dependency)
            if component not in included:
                included.add(component)
                components.append(component)
        return components, warnings

    def _ordered_components(self, components: list) -> list:
        """Sort the build components: recipe-local modules keep their
        dependency order, `src` modules are grouped by category and sorted
        by name, headers come first and the kernel comes last."""
        keyed = []
        for index, component in enumerate(components):
            namespace = self._component_namespace(component)
            src_parts = self._src_relative_parts(component)
            key = self._component_sort_key(
                component, index, namespace, src_parts
            )
            keyed.append((key, component))
        return [
            component
            for _key, component in sorted(keyed, key=lambda item: item[0])
        ]

    @classmethod
    def _component_sort_key(cls, component: Path, index: int,
                            namespace, src_parts) -> tuple:
        """Return the build rank of one component: header first, then
        recipe-local modules, then sorted `src` modules, kernel last."""
        if component.name == cls.HEADER_FILE:
            return (0, (), index)
        if cls._is_kernel(namespace, src_parts):
            return (3, cls._src_order_key(src_parts), index)
        if src_parts is None:
            return (1, (), index)
        return (2, cls._src_order_key(src_parts), index)

    @classmethod
    def _is_kernel(cls, namespace, src_parts) -> bool:
        """Tell whether a component carries the kernel namespace."""
        if namespace == cls.KERNEL_NAMESPACE:
            return True
        return src_parts is not None and src_parts[:2] == (
            "shell", "kernel"
        )

    @staticmethod
    def _src_order_key(src_parts) -> tuple:
        """Order a component like the `tree` command does: by category,
        then by name with leading underscores ignored for collation."""
        return tuple(
            (part.lstrip("_"), part) for part in src_parts
        )

    @staticmethod
    def _src_relative_parts(component: Path):
        """Return the path parts below the innermost `src` folder, or None
        for a recipe-local module."""
        parts = component.resolve().parts
        for index in range(len(parts) - 1, -1, -1):
            if parts[index] == "src":
                return parts[index + 1:]
        return None

    @classmethod
    def _component_namespace(cls, component: Path):
        """Read the namespace declared by a component, at script or
        function scope, or None when it declares none."""
        try:
            file_lines = component.read_text(
                encoding="utf-8", errors="replace"
            ).splitlines(keepends=True)
        except OSError:
            return None
        parser = ShoedocParser()
        try:
            metadata = parser.parse_script_metadata(file_lines)
        except (TypeError, ValueError):
            metadata = {}
        namespace = cls._metadata_namespace(metadata)
        if namespace is not None:
            return namespace
        try:
            records = parser.parse_function_metadata(file_lines)
        except (TypeError, ValueError):
            return None
        for _annotation, metadata in records:
            namespace = cls._metadata_namespace(metadata)
            if namespace is not None:
                return namespace
        return None

    @staticmethod
    def _metadata_namespace(metadata):
        namespace = (
            metadata.get("namespace") if isinstance(metadata, dict) else None
        )
        return namespace if isinstance(namespace, str) else None

    def _recipe_prefixes(self, entries: list,
                         overridden: set) -> tuple:
        """Attach each run of recipe comments to the category it precedes,
        so comments travel with the modules when the build is reordered."""
        prefixes = {}
        pending = []
        for entry, component in entries:
            if component is None:
                pending.append(entry)
                continue
            if component in overridden:
                continue
            category = self._component_category(component)
            prefixes.setdefault(category, []).extend(pending)
            pending = []
        return prefixes, pending

    @classmethod
    def _component_category(cls, component: Path) -> tuple:
        """Return the prefix bucket of a component: the header, a local
        module, or a `src` category folder."""
        if component.name == cls.HEADER_FILE:
            return ("header", component.resolve())
        src_parts = cls._src_relative_parts(component)
        if src_parts is None:
            return ("local", component.resolve())
        return ("src", tuple(src_parts[:-1]))

    def _recipe_entries(self, recipe: Path) -> list:
        """Return the recipe's ``(line, component)`` pairs, in file order:
        ``component`` is None for blank lines and comments."""
        entries = []
        for entry in recipe.read_text(encoding="utf-8").splitlines():
            entry = entry.strip()
            if not entry or entry.startswith("#"):
                entries.append((entry, None))
                continue
            component = (recipe.parent / entry).resolve()
            if not component.is_file():
                raise FileNotFoundError(
                    f'component file not found: "{component}"'
                )
            entries.append((entry, component))
        return entries

    def _overridden_components(self, components) -> set:
        """Resolve every module superseded by an `overrides` entry found
        in the recipe components or in their transitive dependencies."""
        overridden = set()
        pending = list(components)
        visited = set()
        while pending:
            component = pending.pop()
            if component in visited:
                continue
            visited.add(component)
            for entry in self.dependencies.script_overrides(component):
                target = self.dependencies.resolve_dep_file(
                    entry, component.parent
                )
                if target is not None:
                    overridden.add(target.resolve())
            for entry in self.dependencies.script_depends(component):
                dependency = self.dependencies.resolve_dep_file(
                    entry, component.parent
                )
                if dependency is not None:
                    pending.append(dependency.resolve())
        return overridden

    def _duplicate_function_warnings(self, components: list) -> list:
        """Warn about function names declared more than once in the build.

        The build concatenates every component's functions into a single
        script: a repeated name shadows the previous definition, and the
        Shoe kernel rejects the result. Every warning names the offending
        files and the line of each definition."""
        owners = {}
        for component in components:
            label = self.dependencies.dependency_label(component)
            if component.suffix == ".sh":
                # dependency_label strips the extension: restore it so
                # the warning names an actual file.
                label = "%s.sh" % label
            functions = self.function_parser_factory(
                component.read_text(encoding="utf-8", errors="replace")
            )
            for name, line_index in functions.function_definitions():
                owners.setdefault(name, []).append(
                    '"%s:%d"' % (label, line_index + 1)
                )
        warnings = []
        for name in sorted(owners):
            locations = owners[name]
            if len(locations) < 2:
                continue
            locations = list(dict.fromkeys(locations))
            warnings.append(
                'warning: function "%s" is defined multiple times: %s\n'
                % (name, ", ".join(locations))
            )
        return warnings

    def _component_body(self, component: Path) -> str:
        content = component.read_text(encoding="utf-8")
        lines = content.rstrip("\r\n").splitlines()
        # Strip each component's own shebang: the built script carries the
        # requested interpreter line.
        if lines and lines[0].startswith("#!"):
            lines = lines[1:]
        return "\n".join(lines)

    @staticmethod
    def _script_name(recipe: Path) -> str:
        if recipe.name.endswith(".shoe"):
            return recipe.name[:-5]
        return recipe.name


class _DependencyWalk:
    """Collect the transitive depends closure of one root script."""

    def __init__(self, resolver, boundaries=None):
        self.resolver = resolver
        self.boundaries = {
            Path(component).resolve()
            for component in (boundaries or ())
        }
        self.labels = set()
        self.warnings = []
        self.visited = set()

    def run(self, root) -> tuple:
        self._visit(root, self.resolver.dependency_label(root), [])
        return sorted(self.labels), self.warnings

    def _visit(self, source, label: str, stack: list) -> None:
        if source in self.visited:
            return
        self.visited.add(source)
        stack.append(label)
        for dep in self.resolver.script_depends(source):
            dep_file = self.resolver.resolve_dep_file(dep, source.parent)
            if dep_file is None:
                self.warnings.append(
                    'warning: dependency not found: "%s" (from "%s")\n'
                    % (dep, label)
                )
                continue
            dep_label = self.resolver.dependency_label(dep_file)
            if dep_label in stack:
                self.warnings.append(
                    "warning: dependency cycle detected: "
                    "%s -> %s -> %s\n" % (label, dep_label, label)
                )
                continue
            # A boundary module is imported at its own recipe position:
            # neither it nor its dependencies are collected here.
            if dep_file.resolve() in self.boundaries:
                continue
            self.labels.add(dep_label)
            self._visit(dep_file, dep_label, stack)
        stack.pop()


class DependencyTreeResolver:
    """Collect the transitive `depends` closure of a shoe script."""

    def __init__(self, parser=None, paths=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.paths = ShoemakerPathResolver() if paths is None else paths

    def script_depends(self, file_path: Path) -> list:
        """Return the depends entries declared by a script: those of the
        script-level shoedoc block, merged with those of each function
        annotation."""
        return self._script_entries(file_path, "depends")

    def script_overrides(self, file_path: Path) -> list:
        """Return the single override target declared by each shoedoc block
        of a script, at script and function scope."""
        return self._script_entries(file_path, "overrides", scalar=True)

    def _script_entries(self, file_path: Path, key: str,
                        scalar=False) -> list:
        """Return the string entries of a property declared at script and
        function scope: the items of an array, or the value itself for a
        scalar property."""
        file_lines = file_path.read_text(
            encoding="utf-8", errors="replace"
        ).splitlines()
        entries = self._metadata_entries(
            self.parser.parse_script_metadata(file_lines), key, scalar
        )
        for _annotation, metadata in self.parser.parse_function_metadata(
            file_lines
        ):
            entries.extend(self._metadata_entries(metadata, key, scalar))
        return entries

    @staticmethod
    def _metadata_entries(metadata, key: str, scalar=False) -> list:
        """Return the string entries of `key`: its value when `scalar` is
        set, the string items of its array otherwise."""
        value = metadata.get(key) if isinstance(metadata, dict) else None
        if scalar:
            return [value] if isinstance(value, str) else []
        if isinstance(value, list):
            return [entry for entry in value if isinstance(entry, str)]
        return []

    def collect(self, file_path, boundaries=None) -> tuple:
        """Walk the dependency graph of `file_path` depth-first,
        deduplicating entries and skipping cycles. Dependencies listed in
        `boundaries` are not traversed: the caller imports them at their
        own position. Returns (depends, warnings) where depends holds the
        sorted unique dependency labels and warnings holds one message per
        missing file or cycle."""
        root = self.paths.require_file(file_path)
        return _DependencyWalk(self, boundaries).run(root)

    def resolve_dep_file(self, dep, base) -> Path:
        """Locate the .sh file of a depends entry: entries are declared
        without their extension and are resolved against the working
        directory first, then against each ancestor of `base`."""
        dep_path = Path(dep)
        for candidate in self.dep_candidates(dep_path, base):
            resolved = self.resolve_suffix(candidate)
            if resolved is not None:
                return resolved
        return None

    @staticmethod
    def dep_candidates(dep_path: Path, base: Path) -> list:
        if dep_path.is_absolute():
            return [dep_path]
        candidates = [Path.cwd() / dep_path]
        directory = base if base.is_dir() else base.parent
        for ancestor in [directory, *directory.parents]:
            candidate = ancestor / dep_path
            if candidate not in candidates:
                candidates.append(candidate)
        return candidates

    @staticmethod
    def resolve_suffix(candidate: Path) -> Path:
        if candidate.is_file():
            return candidate
        extended = Path("%s.sh" % candidate)
        if candidate.suffix != ".sh" and extended.is_file():
            return extended
        return None

    @staticmethod
    def dependency_label(dep_file: Path) -> str:
        resolved = dep_file.resolve()
        try:
            label = resolved.relative_to(Path.cwd()).as_posix()
        except ValueError:
            label = resolved.as_posix()
        if label.endswith(".sh"):
            label = label[:-3]
        return label

    def render(self, depends: list) -> str:
        """Render the dependency list as shell file paths, one per line,
        ready to feed the build command."""
        lines = ["%s.sh" % label for label in depends]
        return "\n".join(lines) + "\n" if lines else ""

    def generate(self, file_path, destination=None) -> Path:
        """Collect the dependency tree of `file_path`; print the raw list
        of dependency shell files to stdout, or write it to
        `destination`."""
        depends, warnings = self.collect(file_path)
        for warning in warnings:
            sys.stderr.write(warning)
        output = self.render(depends)
        if destination:
            output_dir = self.paths.output_directory(
                destination, Path.cwd() / "dump" / Path(file_path).stem,
                create=True,
            )
            target = output_dir / f"{Path(file_path).stem}.shoe"
            target.write_text(output, encoding="utf-8")
            return target
        sys.stdout.write(output)
        return None


class DocumentationGenerator:
    """Generate Markdown documentation from Shoedoc annotations."""

    VARIABLE_RE = re.compile(r"^([A-Za-z0-9_]+)=(.*)$")
    ENTRY_SECTIONS = ("params", "options", "flags")

    def __init__(self, parser=None, serializer=None, paths=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )
        self.paths = ShoemakerPathResolver() if paths is None else paths

    def _script_variables(
        self, file_lines: list, include_private: bool
    ) -> dict:
        """Group the script-level assignments into documentation sections."""
        first_function = self._first_function_line(file_lines)
        sections = {
            "constants": [], "flags": [], "options": [], "private": [],
        }
        for index, raw_line in enumerate(file_lines[:first_function]):
            match = self.VARIABLE_RE.match(raw_line.rstrip("\r\n"))
            if match is None:
                continue
            name, value = match.groups()
            annotation = self._assignment_annotation(file_lines, index)
            self._classify_variable(
                sections, name, value, annotation, include_private
            )
        return sections

    def _assignment_annotation(self, file_lines: list, index: int) -> dict:
        """Return the annotation block documenting the assignment at
        ``index``, or an empty mapping when the assignment is undocumented.
        Only the run of ``##`` lines directly above the assignment is
        considered, exactly like the shell helpers do."""
        block = []
        cursor = index - 1
        while cursor >= 0 and self.parser.is_shoedoc_line(file_lines[cursor]):
            block.append(file_lines[cursor].rstrip("\r\n"))
            cursor -= 1
        if not block:
            return {}
        block.reverse()
        return self.parser.parse_assignment_block(block, cursor + 1)

    @staticmethod
    def _assignment_fields(annotation: dict) -> dict:
        """Merge a classic entry tag and the extended block tags."""
        fields = {}
        for key in ("variables", "constants"):
            entries = annotation.get(key)
            if isinstance(entries, list) and entries:
                if isinstance(entries[0], dict):
                    fields.update(entries[0])
                break
        for key in ("summary", "description"):
            if key in annotation and key not in fields:
                fields[key] = annotation[key]
        for key in ("type", "constraint", "private", "deprecated"):
            if key in annotation:
                fields[key] = annotation[key]
        return fields

    @staticmethod
    def _first_function_line(file_lines: list) -> int:
        definitions = ShellFunctionParser(
            "".join(file_lines)
        ).function_definitions()
        return min(
            (index for _name, index in definitions),
            default=len(file_lines),
        )

    @classmethod
    def _classify_variable(
        cls,
        sections: dict,
        name: str,
        value: str,
        annotation: dict,
        include_private: bool,
    ) -> None:
        fields = cls._assignment_fields(annotation)
        summary = fields.get("summary")
        description = fields.get("description")
        type_value = fields.get("type")
        constraint = fields.get("constraint")
        deprecated = fields.get("deprecated")
        documented = any(
            isinstance(text, str) and text
            for text in (summary, description, type_value, constraint,
                         deprecated)
        )
        explicitly_private = fields.get("private") is True
        is_private = (
            name.startswith("_") or explicitly_private or not documented
        )
        item = {
            "name": name,
            "value": value,
            "summary": summary if isinstance(summary, str) else "",
            "description": description if isinstance(description, str) else "",
            "type": type_value if isinstance(type_value, str) else "",
            "constraint": constraint if isinstance(constraint, str) else "",
            "deprecated": deprecated if isinstance(deprecated, str) else "",
            "private": is_private,
        }
        is_constant = name.upper() == name
        if is_constant:
            # An underscore-prefixed, explicitly private or undocumented
            # constant is private: document it only when requested.
            if include_private or not is_private:
                sections["constants"].append(item)
        elif value == "false" and not is_private:
            sections["flags"].append(item)
        elif not is_private:
            sections["options"].append(item)
        elif include_private and (name.startswith("_") or explicitly_private):
            sections["private"].append(item)

    @staticmethod
    def _entry_aliases(entry: dict) -> list:
        """Return the command-line spellings of an option or flag: its
        short alias, its long name, or both. An entry declaring neither
        falls back to its name as a long option."""
        aliases = []
        short = entry.get("short")
        if isinstance(short, str) and short:
            aliases.append(f"-{short}")
        long_name = entry.get("long")
        if isinstance(long_name, str) and long_name:
            aliases.append(f"--{long_name}")
        if not aliases:
            name = entry.get("name")
            if isinstance(name, str) and name:
                aliases.append(f"--{name}")
        return aliases

    @classmethod
    def _entry_signature(cls, entry: dict, kind: str) -> str:
        """Render one entry as the token it occupies in a synopsis:
        required parameters in angle brackets, optional entries in square
        brackets."""
        if kind == "params":
            name = entry.get("name")
            if not isinstance(name, str) or not name:
                return ""
            if entry.get("required") is True:
                return f"<{name}>"
            return f"[{name}]"
        aliases = cls._entry_aliases(entry)
        if not aliases:
            return ""
        token = "|".join(aliases)
        if kind == "options":
            token += " VALUE"
        if entry.get("required") is True:
            return token
        return f"[{token}]"

    @classmethod
    def _entry_synopsis(cls, name: str, metadata: dict) -> str:
        """Render the function call signature from every parameter, option
        and flag of the annotation, aliases included."""
        arguments = [name]
        for kind in cls.ENTRY_SECTIONS:
            entries = metadata.get(kind)
            if not isinstance(entries, list):
                continue
            for entry in entries:
                if not isinstance(entry, dict):
                    continue
                token = cls._entry_signature(entry, kind)
                if token:
                    arguments.append(token)
        return " ".join(arguments)

    @classmethod
    def _entry_label(cls, entry: dict, kind: str) -> str:
        """Render the inline-code label of one synopsis detail bullet."""
        if kind == "params":
            name = entry.get("name")
            return f"`{name}`" if isinstance(name, str) and name else ""
        aliases = cls._entry_aliases(entry)
        return ", ".join(f"`{alias}`" for alias in aliases)

    @staticmethod
    def _entry_text(entry: dict) -> str:
        """Flatten the summary and description of an entry into one line."""
        parts = []
        for key in ("summary", "description"):
            value = entry.get(key)
            if isinstance(value, str):
                value = " ".join(value.split())
                if value:
                    parts.append(value)
        return " - ".join(parts)

    @staticmethod
    def _format_default(value) -> str:
        """Render a default value inside a synopsis detail bullet."""
        if isinstance(value, str):
            rendered = json.dumps(value, ensure_ascii=False)
        elif value is True:
            rendered = '"true"'
        elif value is False:
            rendered = '"false"'
        elif value is None:
            rendered = '"null"'
        else:
            rendered = f'"{value}"'
        return f"_Defaults to {rendered}._"

    @classmethod
    def _entry_detail(cls, entry: dict, kind: str) -> str:
        """Render one entry as a detailed synopsis bullet: type,
        requiredness, summary, description, constraint and default."""
        label = cls._entry_label(entry, kind)
        if not label:
            return ""
        parts = [f"- {label}:"]
        type_value = entry.get("type")
        if kind != "flags" and isinstance(type_value, str) and type_value:
            parts.append(f'_(type: "{type_value}")_')
        if kind == "params" and entry.get("required") is not True:
            parts.append("(optional)")
        text = cls._entry_text(entry)
        if text:
            parts.append(text)
        constraint = entry.get("constraint")
        if isinstance(constraint, str) and constraint:
            parts.append(f"_Constraint: `{constraint}`._")
        if kind in ("params", "options") and "default" in entry:
            parts.append(cls._format_default(entry["default"]))
        return " ".join(parts)

    @classmethod
    def _entry_details(cls, metadata: dict) -> list:
        """Render the detail bullets of every parameter, option and flag
        documented by a function annotation."""
        lines = []
        for kind in cls.ENTRY_SECTIONS:
            entries = metadata.get(kind)
            if not isinstance(entries, list):
                continue
            for entry in entries:
                if not isinstance(entry, dict):
                    continue
                detail = cls._entry_detail(entry, kind)
                if detail:
                    lines.append(detail)
        return lines

    def _render(
        self,
        source: Path,
        file_lines: list,
        metadata: dict,
        include_private: bool,
    ) -> str:
        variable_sections = self._script_variables(
            file_lines, include_private
        )
        lines = self._render_header(source, metadata)
        lines.extend(self._render_usage(source, variable_sections))
        self._append_variable_sections(lines, variable_sections)
        lines.extend(self._render_commands(file_lines, include_private))
        return "\n".join(lines).rstrip() + "\n"

    def _render_header(self, source: Path, metadata: dict) -> list:
        title = (
            metadata.get("summary")
            or metadata.get("name")
            or source.stem
        )
        description = metadata.get("description", "")
        lines = [f"# {title}", "", "## ℹ️ Infos", ""]
        author = metadata.get("author")
        authors = metadata.get("authors", [])
        if not author and authors:
            author = self.serializer.format_author(authors[0])
        info_rows = [
            ("author", author),
            ("version", metadata.get("version")),
        ]
        info_rows.extend(
            ("link", link)
            for link in metadata.get("links", [])
            if isinstance(link, str)
        )
        for label, value in info_rows:
            if value:
                lines.append(f"- {label}:  {value}")
        lines.extend(["", "## 📑 Description", "", str(description), ""])
        return lines

    @staticmethod
    def _render_usage(source: Path, variable_sections: dict) -> list:
        usage = [
            f"(--{item['name']})"
            for item in variable_sections["flags"]
        ]
        usage.extend(
            f"(--{item['name']} {item['value']})"
            for item in variable_sections["options"]
        )
        return [
            "## 🔥 Usage",
            "",
            "`sh %s [command]%s`" % (
                source.name, (" " + " ".join(usage)) if usage else ""
            ),
            "",
        ]

    def _append_variable_sections(
        self, lines: list, variable_sections: dict
    ) -> None:
        self._append_variable_section(
            lines,
            "## 🧱 Constants",
            variable_sections["constants"],
            "constant",
        )
        self._append_variable_section(
            lines,
            "## ⚙️ Global Variables",
            variable_sections["private"],
            "private",
        )
        self._append_variable_section(
            lines, "## 🚩 Flags", variable_sections["flags"], "flag"
        )
        self._append_variable_section(
            lines, "## ⚙️ Options", variable_sections["options"], "option"
        )

    def _render_commands(
        self, file_lines: list, include_private: bool
    ) -> list:
        functions = []
        for annotation, metadata in self.parser.parse_function_metadata(
            file_lines
        ):
            name = annotation.function_name
            private = bool(metadata.get("private")) or name.startswith("_")
            if private and not include_private:
                continue
            functions.append((annotation, metadata, private))

        lines = ["## 🤖 Commands", ""]
        sections = self.parser.section_titles(file_lines)
        current_heading = None
        for index, (annotation, metadata, private) in enumerate(
            functions, start=1
        ):
            section = sections.get(annotation.function_line_index, "")
            namespace = metadata.get("namespace")
            heading = section or (namespace.upper() if namespace else "")
            if heading and heading != current_heading:
                current_heading = heading
                lines.extend([f"### ⚡ {heading}", ""])
            scope = "private" if private else "public"
            summary = metadata.get("summary", "")
            synopsis = self._entry_synopsis(
                annotation.function_name, metadata
            )
            lines.extend([
                f"#### ⌨️ {index}. `{annotation.function_name}` ({scope})",
                "",
                str(summary),
                "",
                "> Synopsis:",
                f"> `{synopsis}`",
            ])
            lines.extend(self._entry_details(metadata))
            lines.append("")
            if metadata.get("requires"):
                required = ", ".join(
                    f"`{value}`" for value in metadata["requires"]
                )
                lines.extend([f"- ⚠️ Requires: {required}", ""])
            if metadata.get("depends"):
                depends = ", ".join(
                    f"`{value}`" for value in metadata["depends"]
                )
                lines.extend([f"- 🔗 Depends: {depends}", ""])
        return lines

    @staticmethod
    def _variable_details(item: dict, kind: str) -> list:
        """Render the metadata lines of a script-level assignment."""
        details = []
        type_value = item.get("type")
        if type_value and kind in ("constant", "option", "private"):
            details.append(f"  - Type: _{type_value}_")
        constraint = item.get("constraint")
        if constraint and kind in ("option", "private"):
            details.append(f"  - Constraint: `{constraint}`")
        if kind == "constant":
            details.append(f"  - Value: _{item['value']}_")
        elif kind in ("option", "private"):
            details.append(f"  - 🚩 Default: _{item['value']}_")
        deprecated = item.get("deprecated")
        if deprecated:
            details.append(f"  - ⚠️ Deprecated: {deprecated}")
        return details

    @staticmethod
    def _variable_text_lines(item: dict) -> list:
        """Render the summary and description of an assignment as quoted
        Markdown lines, keeping the description line breaks."""
        summary = item.get("summary")
        description = item.get("description")
        text = []
        if isinstance(summary, str) and summary:
            text.append(str(summary))
        if isinstance(description, str) and description:
            if text:
                text.append("")
            text.extend(description.splitlines())
        return [f"> {line}" if line else ">" for line in text]

    @classmethod
    def _append_variable_section(cls, lines: list, heading: str, items: list,
                                 kind: str) -> None:
        if not items:
            return
        lines.extend([heading, ""])
        for index, item in enumerate(items, start=1):
            name = item["name"]
            private_label = " (private)" if item["private"] else ""
            if kind == "constant":
                title = f"{index}. **{name}{private_label}**"
            elif kind == "private":
                title = f"{index}. **`{name}` (private)**"
            else:
                title = f"{index}. **`--{name}`{private_label}**"
            lines.append(title)
            lines.extend(cls._variable_text_lines(item))
            lines.extend(cls._variable_details(item, kind))
            lines.append("")

    def generate(self, file_path, destination=None, private=False,
                 output_file_name=None) -> Path:
        """Write the Markdown documentation of a shell script."""
        source = self.paths.require_file(file_path, suffix=".sh")
        output_dir = self.paths.output_directory(
            destination, source.parent, create=True
        )
        output_name = output_file_name or f"{source.stem}.md"
        file_lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
        metadata = self.parser.parse_script_metadata(file_lines)
        content = self._render(source, file_lines, metadata, private)
        output = output_dir / output_name
        output.write_text(content, encoding="utf-8")
        return output


class MakefileGenerator:
    """Generate a Makefile that dispatches to documented shell functions."""

    COLORS = MappingProxyType({
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
    })

    def __init__(self, parser=None, paths=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.paths = ShoemakerPathResolver() if paths is None else paths

    def _render(
        self,
        source: Path,
        file_lines: list,
        metadata: dict,
        script_ref: str,
    ) -> str:
        annotated = self._annotated_functions(file_lines)
        title = (
            metadata.get("summary")
            or metadata.get("name")
            or source.stem
        )
        description = " ".join(
            str(metadata.get("description", "")).splitlines()
        )
        lines = self._render_header(source, metadata)
        lines.extend(self._render_phony(annotated))
        lines.extend(self._render_colors())
        lines.extend(self._render_help(title, description, annotated))
        lines.extend(self._render_targets(annotated, script_ref))
        return "\n".join(lines).rstrip() + "\n"

    def _annotated_functions(self, file_lines: list) -> dict:
        """Map each documented public function to its metadata and section."""
        sections = self.parser.section_titles(file_lines)

        annotated = {}
        for annotation, metadata in self.parser.parse_function_metadata(
            file_lines
        ):
            name = annotation.function_name
            if name.startswith("_") or name == "help":
                continue
            if metadata.get("private") is True:
                continue
            annotated[name] = (
                annotation,
                metadata,
                sections.get(annotation.function_line_index, ""),
            )
        return annotated

    def _render_header(self, source: Path, metadata: dict) -> list:
        title = (
            metadata.get("summary")
            or metadata.get("name")
            or source.stem
        )
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
        return [
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

    @staticmethod
    def _render_phony(annotated: dict) -> list:
        names = list(annotated)
        return [".PHONY: help %s" % " ".join(names), ""]

    def _render_colors(self) -> list:
        return [
            f"{name} = {value}" for name, value in self.COLORS.items()
        ]

    @staticmethod
    def _render_help(title: str, description: str, annotated: dict) -> list:
        lines = [
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
        ]
        for name, (_annotation, metadata, _section) in annotated.items():
            summary = str(metadata.get("summary", ""))
            lines.append(
                f"\t@printf '  %-20s %s\\n' {shlex.quote(name)} "
                f"{shlex.quote(summary)}"
            )
        return lines

    @staticmethod
    def _render_targets(annotated: dict, script_ref: str) -> list:
        lines = []
        current_section = None
        for name, (_annotation, metadata, section) in annotated.items():
            if section and section != current_section:
                current_section = section
                lines.extend([
                    "",
                    "##################################################",
                    f"### {section}",
                    "##################################################",
                    "",
                ])
            summary = str(metadata.get("summary", ""))
            if summary:
                lines.append(f"## {summary}")
            lines.extend([
                f"{name}:",
                f'\t@printf "$(_INFO)sh {script_ref} {name}$(_EOL)\\n"',
                f"\t@sh {shlex.quote(script_ref)} {name}",
                "",
            ])
        return lines

    def generate(self, file_path, destination=None,
                 output_file_name=None) -> Path:
        """Write the Makefile for a shell script."""
        source = self.paths.require_file(file_path, suffix=".sh")
        output_dir = self.paths.output_directory(
            destination, source.parent, create=True
        )
        output_name = output_file_name or f"{source.stem}.makefile"
        file_lines = source.read_text(encoding="utf-8").splitlines(keepends=True)
        metadata = self.parser.parse_script_metadata(file_lines)
        # reference the script by its path relative to the Makefile, so
        # the generated targets stay portable and run from the folder that
        # holds the Makefile
        script_ref = os.path.relpath(source, output_dir)
        content = self._render(source, file_lines, metadata, script_ref)
        output = output_dir / output_name
        output.write_text(content, encoding="utf-8")
        return output


class Console:
    """Semantic terminal output used by Shoemaker commands.

    The output policy (notably ``quiet``) belongs to the console instance,
    not to module-level state, so commands can be run independently.
    """

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

    def __init__(self, quiet=False):
        self.quiet = quiet

    def _write(self, text, color, stream=None, *, end="\n"):
        if self.quiet:
            return
        stream = sys.stdout if stream is None else stream
        print(f"{color}{text}{self.DEFAULT}", file=stream, end=end)

    def primary(self, text, *, end="\n"):
        self._write(text, self.PRIMARY, end=end)

    def secondary(self, text, *, end="\n"):
        self._write(text, self.SECONDARY, end=end)

    def success(self, text, *, end="\n"):
        self._write(text, self.SUCCESS, end=end)

    def warning(self, text, *, end="\n"):
        self._write(text, self.WARNING, end=end)

    def info(self, text, *, end="\n"):
        self._write(text, self.INFO, end=end)

    def danger(self, text, *, end="\n"):
        self._write(text, self.DANGER, sys.stderr, end=end)

    def error(self, text):
        self.danger(f"error: {text}")

    def alert_primary(self, text):
        self._alert(self.ALERT_PRIMARY, text)

    def alert_secondary(self, text):
        self._alert(self.ALERT_SECONDARY, text)

    def alert_success(self, text):
        self._alert(self.ALERT_SUCCESS, text)

    def alert_danger(self, text):
        self._alert(self.ALERT_DANGER, text)

    def alert_warning(self, text):
        self._alert(self.ALERT_WARNING, text)

    def alert_info(self, text):
        self._alert(self.ALERT_INFO, text)

    def alert_light(self, text):
        self._alert(self.ALERT_LIGHT, text)

    def alert_dark(self, text):
        self._alert(self.ALERT_DARK, text)

    def _alert(self, color, text):
        if self.quiet:
            return
        title = " ".join(str(text).splitlines())[:63]
        print(f"\n{color}{'':>64}{self.DEFAULT}")
        print(f"{color} {title:<63}{self.DEFAULT}")
        print(f"{color}{'':>64}{self.DEFAULT}\n")


class NullLogger:
    """No-op logger for command runs without verbosity or log output."""

    @staticmethod
    def _ignore(*_args, **_kwargs) -> None:
        return None

    def __getattr__(self, _name):
        return self._ignore


class Logger:
    """Write optional command logs and route verbose output to a console."""

    LEVEL_NAMES = ("ERROR", "SUCCESS", "WARNING", "INFO")

    def __init__(self, verbose=0, quiet=False, script_file=None, console=None):
        self.verbose = verbose
        self.quiet = quiet
        self.console = Console() if console is None else console
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

    def show(self) -> bool:
        """Print the current log file, if it exists."""
        if not self.log_file.is_file():
            self.console.error(f'"{self.log_file}" file not found.')
            return False
        if not self.quiet:
            self.console.info(str(self.log_file))
            print(self.log_file.read_text(encoding="utf-8"), end="")
        return True

    def log(self, message: str, level=0) -> None:
        self.log_dir.mkdir(parents=True, exist_ok=True)
        level = min(level, len(self.LEVEL_NAMES) - 1)
        timestamp = datetime.datetime.now().strftime("%Y-%m-%dT%H:%M:%S.%f")
        with self.log_file.open("a", encoding="utf-8") as log_file:
            log_file.write(f"{timestamp} {self.LEVEL_NAMES[level]} {message}\n")
        if self.verbose >= level and not self.quiet:
            outputs = (
                self.console.danger,
                self.console.success,
                self.console.warning,
                self.console.info,
            )
            outputs[level](message)

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
        """Yield the existing files under a path, filtered by glob."""
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
        """Process one file; subclasses override it."""
        self.files_skipped += 1

    @staticmethod
    def get_unique_filename(path: Path, base_filename: str) -> Path:
        """Return a non-existing filename in the target directory."""
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
        """Process every file of a directory."""
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
                    if action.nargs == 0 and action.const is not None:
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

    PATH_COMMANDS = (
        "lint", "migrate", "dump", "build",
        "generate_doc", "generate_makefile",
    )

    @classmethod
    def generate(cls, parser: argparse.ArgumentParser, name: str) -> str:
        all_options, categories = cls.classify_parser_actions(parser)
        subcommands = cls.subcommands(parser)
        completion_name = re.sub(r"[^a-zA-Z0-9_]", "_", name)
        return cls._script(
            name=name,
            completion_name=completion_name,
            options_text=cls._options_text(all_options),
            command_case=cls._command_case(subcommands),
            option_cases=cls._option_cases(categories),
            path_cases=cls._path_cases(subcommands),
        )

    @staticmethod
    def _options_text(all_options: set) -> str:
        return " ".join(sorted(
            all_options,
            key=lambda option: (not option.startswith("--"), option.lower()),
        ))

    @staticmethod
    def _command_case(subcommands: list) -> str:
        subcommands_text = " ".join(subcommands)
        if not subcommands_text:
            return ""
        return f'''    if [ "${{COMP_CWORD}}" -eq 1 ]; then
        case "${{cur}}" in
            -*) ;;
            *)
                COMPREPLY=( $(compgen -W "{subcommands_text}" -- "${{cur}}") )
                return 0
                ;;
        esac
    fi
'''

    @classmethod
    def _option_cases(cls, categories: dict) -> str:
        return "".join(
            cls.render_case(option, kind)
            for kind, options in categories.items()
            for option in sorted(set(options))
        )

    @classmethod
    def _path_cases(cls, subcommands: list) -> str:
        return "".join(
            f'''        {command})
            COMPREPLY=( $(compgen -f -- "${{cur}}") )
            return 0
            ;;
'''
            for command in cls.PATH_COMMANDS
            if command in subcommands
        )

    @staticmethod
    def _script(
        *,
        name: str,
        completion_name: str,
        options_text: str,
        command_case: str,
        option_cases: str,
        path_cases: str,
    ) -> str:
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
        self.console = Console()
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
        early_args, _unknown = self._build_early_parser().parse_known_args(
            arguments
        )
        self.console.quiet = early_args.quiet
        self.logger = Logger(
            verbose=early_args.verbose,
            quiet=early_args.quiet,
            script_file=self.script_file,
            console=self.console,
        )
        if early_args.verbose:
            self.hero()
        if early_args.completion:
            print(self.generate_completion())
            return True
        if early_args.log:
            self.logger.show()
            return True
        return False

    def hero(self) -> None:
        """Print the tool banner."""
        self.console.alert_primary(self.title)

    def generate_completion(self) -> str:
        """Return the bash completion script."""
        return Completion.generate(self.build_parser(), self.name)

    def build_parser(self) -> argparse.ArgumentParser:
        """Build the generic command-line parser."""
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
        """Return the parser for the global early options."""
        return self._build_early_parser()

    def _configure_handler(self, _handler) -> None:
        return None

    def run(self, handler_class=None, argv=None) -> int:
        """Run the generic file-processing command."""
        arguments = list(sys.argv[1:] if argv is None else argv)
        if self._handle_early_arguments(arguments):
            return 0
        args = self.build_parser().parse_args(arguments)
        self.args = args
        self.console.quiet = args.quiet
        self.logger = Logger(
            verbose=args.verbose,
            quiet=args.quiet,
            script_file=self.script_file,
            console=self.console,
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
            self.console.error(str(error))
            return 1
        if handler.files_processed:
            self.logger.success(
                f"Processed {handler.files_processed} files"
            )
        else:
            self.logger.warning("Processed 0 files")
        return 0


class Shoemaker(Kernel):
    """Command-line application for linting, documenting, and shell tooling."""

    def __init__(
        self,
        recipe_commands=None,
        documentation_generator=None,
        makefile_generator=None,
        linter=None,
        migrator=None,
    ):
        super().__init__(
            author="TangoMan75",
            title="TangoMan Shoemaker",
            description="Lint, document, and build Shoedoc shell tools.",
        )
        paths = ShoemakerPathResolver()
        shoedoc_parser = ShoedocParser()
        shoedoc_serializer = ShoedocSerializer()
        self.dependency_tree = (
            DependencyTreeResolver(parser=shoedoc_parser)
        )
        self.recipe_commands = (
            RecipeCommandService(
                paths=paths, dependencies=self.dependency_tree
            )
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
        self.linter = ShoedocLinter() if linter is None else linter
        self.migrator = (
            SynopsisMigrator(paths=paths) if migrator is None else migrator
        )

    @staticmethod
    def _add_source_arguments(command_parser) -> None:
        command_parser.add_argument(
            "source", nargs="?", metavar="FILE",
            help="Source .sh file (same as --file).",
        )
        command_parser.add_argument(
            "--file", dest="file_option", metavar="FILE",
            help="Source file. Positional FILE is also accepted.",
        )
        command_parser.add_argument(
            "--destination", metavar="DIR",
            help="Destination directory (created if missing).",
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

    # Options owned by every command; they are documented in the global
    # options section of the help, not repeated per command.
    COMMON_OPTION_DESTS = ("help", "log", "verbose", "quiet", "completion")

    def build_parser(self) -> argparse.ArgumentParser:
        parser = argparse.ArgumentParser(
            prog="shoemaker",
            description=self.description,
            formatter_class=argparse.RawDescriptionHelpFormatter,
        )
        self._add_common_arguments(parser)
        commands = parser.add_subparsers(dest="command", required=True)
        self._add_lint_command(commands)
        self._add_migrate_command(commands)
        self._add_dump_command(commands)
        self._add_tree_command(commands)
        self._add_build_command(commands)
        self._add_doc_command(commands)
        self._add_makefile_command(commands)
        self._add_completion_command(commands)
        parser.epilog = self._command_options_help(commands)
        return parser

    @classmethod
    def _command_options_help(cls, commands) -> str:
        """List every command with the options it accepts."""
        lines = ["command options:"]
        for name, command_parser in commands.choices.items():
            options = [
                cls._format_option_action(action)
                for action in command_parser._actions  # noqa: SLF001
                if action.option_strings
                and action.dest not in cls.COMMON_OPTION_DESTS
            ]
            lines.append(f"  {name}:")
            if options:
                lines.extend(f"    {option}" for option in options)
            else:
                lines.append("    (no command-specific options)")
        return "\n".join(lines)

    @staticmethod
    def _format_option_action(action) -> str:
        """Render one option with its value placeholder and help text."""
        invocation = ", ".join(action.option_strings)
        if action.nargs != 0:
            metavar = action.metavar
            if metavar is None:
                metavar = action.dest.upper()
            if isinstance(metavar, tuple):
                metavar = " ".join(metavar)
            invocation = f"{invocation} {metavar}"
        return f"{invocation:<24} {action.help or ''}".rstrip()

    def _add_lint_command(self, commands) -> None:
        parser = commands.add_parser(
            "lint", help="Lint classic Shoedoc @-tag blocks"
        )
        self._add_common_arguments(parser, subparser=True)
        parser.add_argument("folder", help="Folder containing .sh files")
        parser.add_argument(
            "--fix", action="store_true",
            help="Repair supported issues in place",
        )

    def _add_migrate_command(self, commands) -> None:
        parser = commands.add_parser(
            "migrate",
            help="Remove the legacy Synopsis comment blocks from shell "
            "functions",
        )
        self._add_common_arguments(parser, subparser=True)
        parser.add_argument(
            "paths", nargs="+", metavar="PATH",
            help="Shell script files or directories to migrate",
        )
        parser.add_argument(
            "--dry-run", action="store_true",
            help="Print migrated content without overwriting files",
        )

    def _add_dump_command(self, commands) -> None:
        parser = commands.add_parser(
            "dump",
            help="Extract shell functions into individual files, "
            "organised by namespace, and write the matching .shoe recipe "
            "with the remaining source lines",
        )
        self._add_common_arguments(parser, subparser=True)
        self._add_source_arguments(parser)

    def _add_tree_command(self, commands) -> None:
        parser = commands.add_parser(
            "tree",
            help="Print the raw list of shell files a shoe script depends "
            "on, transitively",
        )
        self._add_common_arguments(parser, subparser=True)
        self._add_source_arguments(parser)

    def _add_build_command(self, commands) -> None:
        parser = commands.add_parser(
            "build",
            help="Build a shell script from a .shoe list and its script "
            "dependencies",
        )
        self._add_common_arguments(parser, subparser=True)
        self._add_source_arguments(parser)
        shell = parser.add_mutually_exclusive_group()
        shell.add_argument(
            "--sh", dest="shell", action="store_const", const="sh",
            help="Output a POSIX sh script",
        )
        shell.add_argument(
            "--bash", dest="shell", action="store_const", const="bash",
            help="Output a bash script (default)",
        )
        parser.set_defaults(shell="bash")

    def _add_doc_command(self, commands) -> None:
        parser = commands.add_parser(
            "generate_doc",
            help="Generate Markdown documentation for a script",
        )
        self._add_common_arguments(parser, subparser=True)
        self._add_source_arguments(parser)
        parser.add_argument(
            "--private", action="store_true",
            help="Include private constants, variables, and functions",
        )

    def _add_makefile_command(self, commands) -> None:
        parser = commands.add_parser(
            "generate_makefile", help="Generate a Makefile for a script"
        )
        self._add_common_arguments(parser, subparser=True)
        self._add_source_arguments(parser)

    def _add_completion_command(self, commands) -> None:
        parser = commands.add_parser(
            "completion", help="Print the bash completion script"
        )
        self._add_common_arguments(parser, subparser=True)

    def run(self, argv=None) -> int:
        """Parse the command line and run one command."""
        arguments = list(sys.argv[1:] if argv is None else argv)
        if self._handle_early_arguments(arguments):
            return 0

        parser = self.build_parser()
        args = parser.parse_args(arguments)
        self.args = args
        self.console.quiet = args.quiet
        self.logger.quiet = args.quiet

        if args.command == "completion":
            print(self.generate_completion())
            return 0

        if args.quiet:
            with contextlib.ExitStack() as stack:
                stack.enter_context(contextlib.redirect_stdout(io.StringIO()))
                stack.enter_context(contextlib.redirect_stderr(io.StringIO()))
                # quiet mode suppresses output, not the exit code
                return self._execute(args, parser)
        return self._execute(args, parser)

    def _execute(self, args, parser) -> int:
        if args.command == "lint":
            return self.linter.lint(args.folder, args.fix)
        if args.command == "migrate":
            return self.migrator.migrate_paths(args.paths, args.dry_run)

        source = self._resolve_source(args, parser)
        return self._execute_source_command(args, source, parser)

    @staticmethod
    def _resolve_source(args, parser) -> str:
        source = args.file_option or args.source
        if args.file_option and args.source:
            parser.error("provide FILE either positionally or with --file")
        if not source:
            parser.error(f"{args.command} requires a source FILE")
        return source

    def _execute_source_command(self, args, source: str, parser) -> int:
        handlers = {
            "dump": self._run_dump,
            "tree": self._run_tree,
            "build": self._run_build,
            "generate_doc": self._run_generate_doc,
            "generate_makefile": self._run_generate_makefile,
        }
        handler = handlers.get(args.command)
        if handler is None:
            parser.error(f"unknown command: {args.command}")
        try:
            handler(args, source)
        except (OSError, ValueError, KeyError) as error:
            self.console.error(str(error))
            return 1
        return 0

    def _run_dump(self, args, source: str) -> None:
        output = self.recipe_commands.dump(
            source, args.destination
        )
        self.console.success(f"Dumped functions and recipe to {output}")

    def _run_tree(self, args, source: str) -> None:
        output = self.dependency_tree.generate(source, args.destination)
        if output is not None:
            self.console.success(f"Depends tree written to {output}")

    def _run_build(self, args, source: str) -> None:
        output = self.recipe_commands.build(
            source, args.destination, args.shell
        )
        self.console.success(f"Built script: {output}")

    def _run_generate_doc(self, args, source: str) -> None:
        output = self.documentation_generator.generate(
            source, args.destination, args.private
        )
        self.console.success(f"Documentation generated: {output}")

    def _run_generate_makefile(self, args, source: str) -> None:
        output = self.makefile_generator.generate(source, args.destination)
        self.console.success(f"Makefile generated: {output}")


def main(argv=None) -> int:
    """Run the Shoemaker command-line application."""
    return Shoemaker().run(argv)


if __name__ == "__main__":
    sys.exit(main())
