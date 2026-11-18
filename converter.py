#!/usr/bin/env python3
"""Convert Shoedoc annotations between classic tags and JSON envelopes.

Classic ``## @param`` blocks become ``## { ... }`` JSON envelopes with
``--json``; JSON envelopes become classic tags with ``--tags`` (default).
"""

import argparse
import json
import re
import sys
from pathlib import Path
from types import MappingProxyType
from typing import NamedTuple


class ShellFunctionSyntax:
    """Recognize the shell function lines that carry annotations."""

    DEFINITION_RE = re.compile(
        r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)\s*\{"
    )
    HEADER_RE = re.compile(
        r"^(?:function\s+)?([a-zA-Z_][a-zA-Z0-9_-]*)\s*\(\)"
    )


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

    # Properties a script-level block cannot own: namespace, requires and
    # the std streams are function concerns.
    SCRIPT_FORBIDDEN_PROPERTIES = (
        "namespace", "requires", "stdout", "stderr", "stdin",
    )

    # Properties emitted by a classic @-tag block.
    CONVERT_STRING_KEYS = (
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
        body_end = ShoedocFixer._envelope_body_end(new_lines)
        for index in range(body_end):
            current = new_lines[index].rstrip()
            match = ShoedocFixer.EMPTY_DEPENDS_RE.match(current)
            if not match:
                continue
            indent = match.group(1)
            entries, terminator = ShoedocFixer._scan_depends_entries(
                new_lines, index, body_end
            )
            if not entries and terminator is None:
                continue
            if not entries:
                if terminator != index + 1:
                    continue
                removed, body_end = ShoedocFixer._remove_stray_terminators(
                    new_lines, index, indent, terminator, body_end, fixes
                )
                if removed:
                    break
                continue
            fixes.append("merged orphan depends array lines")
            new_lines[index] = '  "depends": ['
            ShoedocFixer._rewrite_entry_lines(new_lines, entries)
            if terminator is not None:
                ShoedocFixer._rewrite_terminator(
                    new_lines, terminator, body_end, fixes
                )
            break
        return new_lines

    @staticmethod
    def _envelope_body_end(lines: list) -> int:
        """Return the index of the envelope's closing brace, or its length."""
        return next(
            (
                index for index in range(1, len(lines))
                if lines[index].strip() == "}"
            ),
            len(lines),
        )

    @staticmethod
    def _scan_depends_entries(lines: list, index: int, body_end: int) -> tuple:
        """Return the orphan entry line indexes and the terminator line."""
        entries = []
        terminator = None
        for cursor in range(index + 1, body_end):
            entry_line = lines[cursor].strip()
            if ShoedocFixer.ENTRY_ONLY_RE.match(entry_line):
                entries.append(cursor)
                continue
            if ShoedocFixer.ARRAY_CLOSE_RE.match(entry_line):
                terminator = cursor
            break
        return entries, terminator

    @staticmethod
    def _remove_stray_terminators(
        lines: list,
        index: int,
        indent: str,
        terminator: int,
        body_end: int,
        fixes: list,
    ) -> tuple:
        """Drop the array terminators that directly follow the header."""
        removed = False
        cursor = terminator
        while (
            cursor < body_end
            and ShoedocFixer.ARRAY_CLOSE_RE.match(lines[cursor].strip())
        ):
            del lines[cursor]
            body_end -= 1
            removed = True
        if not removed:
            return False, body_end
        next_line = lines[cursor].strip() if cursor < len(lines) else ""
        if next_line.startswith("}"):
            lines[index] = f'{indent}"depends": []'
        fixes.append("removed stray depends array terminator")
        return True, body_end

    @staticmethod
    def _rewrite_entry_lines(lines: list, entries: list) -> None:
        for position, cursor in enumerate(entries):
            entry = lines[cursor].strip()
            if not entry.endswith(","):
                entry += ","
            if position == len(entries) - 1:
                entry = entry[:-1]
            lines[cursor] = "    " + entry

    @staticmethod
    def _rewrite_terminator(
        lines: list, terminator: int, body_end: int, fixes: list
    ) -> None:
        next_line = (
            lines[terminator + 1].strip()
            if terminator + 1 < len(lines)
            else ""
        )
        lines[terminator] = "  ]" + (
            "," if not next_line.startswith("}") else ""
        )
        for cursor in range(terminator + 1, body_end):
            if ShoedocFixer.ARRAY_CLOSE_RE.match(lines[cursor].strip()):
                del lines[cursor]
                fixes.append("removed stray depends array terminator")
                break

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
        if not self.ordering.keys_ordered(parsed):
            fixes.append("ordered properties")
        parsed, result = self._prepare_namespace(
            parsed, wrong_namespace, namespace_value, fixes
        )
        result = self._fix_properties(parsed, body, adds, result, fixes)
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

    def _fix_properties(self, parsed, body, adds, result, fixes) -> dict:
        for key, value in parsed.items():
            if key == "namespace" and key in result:
                continue
            if (
                key in ShoedocSchema.ARRAY_KEYS
                and isinstance(value, list)
                and all(isinstance(entry, str) for entry in value)
            ):
                cleaned = self._fix_string_array(
                    key, value, body, adds, fixes
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

    def _fix_string_array(self, key, value, body, adds, fixes):
        if not value:
            fixes.append(f"removed empty '{key}' array")
            return None
        cleaned, array_fixes = self.fix_string_array_entries(
            value, key, body
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
        for key in ("requires", "depends"):
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
        for key in ("requires", "depends"):
            if key in result:
                ordered.append((key, result.pop(key)))
            elif key in additions_by_key:
                ordered.append((key, additions_by_key[key]))
        return {**dict(ordered), **result}

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
        elif tag in ShoedocSchema.CONVERT_STRING_KEYS:
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
            entry.pop("required")
            self.warnings.append(
                "warning: @option '(required)' ignored at line %d\n"
                % line_number
            )
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
        if not self.data and not any(self.entries.values()):
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
    """Parse JSON envelopes and classic Shoedoc tag blocks."""

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
            match = ShellFunctionSyntax.DEFINITION_RE.match(
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
        opens = 0
        depth = 0
        for stripped in stripped_lines:
            if stripped == "{":
                opens += 1
                depth += 1
            elif stripped == "}" and depth > 0:
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
        """Return True for a '##' comment line: two pound signs followed by
        whitespace or the end of the line. Section dividers such as
        ``##########`` and ``### Title`` are not shoedoc lines."""
        line = line.rstrip("\r\n")
        return line.startswith("##") and (
            len(line) == 2 or line[2] in (" ", "\t")
        )

    @classmethod
    def is_json_block_start(cls, line: str) -> bool:
        """Return True for the opening line of a JSON envelope."""
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
            if not ShoedocParser.is_shoedoc_line(line):
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
                if ShellFunctionSyntax.HEADER_RE.match(
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
            json_start = next(
                (
                    cursor for cursor in range(start, index)
                    if cls.is_json_block_start(file_lines[cursor])
                ),
                None,
            )
            annotation_end = index
            if json_start is not None:
                _json_text, json_end = cls.extract_json_block(
                    file_lines, json_start
                )
                if json_end >= json_start:
                    annotation_end = json_end + 1
                return list(range(start, annotation_end))
            # Classic blocks belong to the script only when a blank line
            # separates them from the code that follows, like
            # _get_script_shoedoc.sh does: otherwise they annotate the
            # function definition right below.
            if index < len(file_lines) and file_lines[index].strip():
                return []
            return list(range(start, annotation_end))
        return []

    def parse_script_metadata(self, file_lines: list) -> dict:
        """Read the first script-level Shoedoc annotation of the file."""
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
        """Serialize the object as classic comment lines."""
        text = json.dumps(
            self.ordering.order_keys(parsed),
            indent=2,
            ensure_ascii=ensure_ascii,
        )
        return ["## " + line for line in text.split("\n")]

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
    def json_to_classic(cls, data) -> list:
        """Serialize a parsed object as classic @-tag lines."""
        out = []
        if "summary" in data:
            out.append("## %s" % data["summary"])
        if "description" in data:
            if "summary" in data:
                out.append("##")
            out.extend("## %s" % line for line in data["description"].split("\n"))
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


class ShoedocConverter:
    """Convert classic tag blocks and JSON Shoedoc envelopes."""

    def __init__(self, parser=None, serializer=None, collector=None):
        self.parser = ShoedocParser() if parser is None else parser
        self.serializer = (
            ShoedocSerializer() if serializer is None else serializer
        )
        self.collector = (
            ScriptPathCollector() if collector is None else collector
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
        return ScriptPathCollector().collect(path)

    def convert_paths(
        self, paths: list, direction="tags", dry_run=False
    ) -> int:
        files, exit_code = self._expand_paths(paths)
        for file_path in files:
            if self._convert_file(file_path, direction, dry_run):
                exit_code = 1
        return exit_code

    def _expand_paths(self, paths: list) -> tuple:
        """Expand the command-line paths into unique .sh file paths."""
        files, errors = self.collector.unique(paths)
        for error in errors:
            sys.stderr.write(error + "\n")
        return files, 1 if errors else 0

    def _convert_file(self, file_path: str, direction: str, dry_run: bool) -> int:
        """Convert one file; return 1 when it could not be processed."""
        try:
            content = Path(file_path).read_text(
                encoding="utf-8", errors="replace"
            )
        except OSError as error:
            sys.stderr.write(
                "error: cannot read %s: %s\n" % (file_path, error)
            )
            return 1
        new_content, converted, had_error = self.convert_content(
            content, direction
        )
        exit_code = 1 if had_error else 0
        if converted == 0:
            return exit_code
        if dry_run:
            sys.stdout.write("==> %s <==\n" % file_path)
            sys.stdout.write(new_content)
            if not new_content.endswith("\n"):
                sys.stdout.write("\n")
            return exit_code
        if new_content != content:
            try:
                Path(file_path).write_text(new_content, encoding="utf-8")
            except OSError as error:
                sys.stderr.write(
                    "error: cannot write %s: %s\n" % (file_path, error)
                )
                return 1
        sys.stderr.write(
            "Converted: %s (%d block(s))\n" % (file_path, converted)
        )
        return exit_code


class ScriptPathCollector:
    """Expand command-line inputs into unique shell script paths."""

    SUFFIX = ".sh"

    def collect(self, path):
        """Return ``(files, errors)`` for one file or directory path."""
        source = Path(path).expanduser()
        if source.is_file():
            if source.suffix != self.SUFFIX:
                return [], [f'error: expected a .sh file: "{source}"']
            return [str(source)], []
        if source.is_dir():
            return [
                str(candidate)
                for candidate in sorted(source.rglob(f"*{self.SUFFIX}"))
                if candidate.is_file()
            ], []
        return [], [f'error: not a file or directory: "{source}"']

    def unique(self, paths):
        """Expand command-line paths into unique shell script paths."""
        files = []
        seen = set()
        errors = []
        for raw_path in paths:
            collected, path_errors = self.collect(raw_path)
            errors.extend(path_errors)
            for file_path in collected:
                if file_path in seen:
                    continue
                seen.add(file_path)
                files.append(file_path)
        return files, errors


class ConverterCli:
    """Command-line interface for the standalone Shoedoc converter."""

    DESCRIPTION = "Convert Shoedoc annotations between classic tags and JSON."

    def __init__(self, *, converter=None):
        self.converter = (
            ShoedocConverter() if converter is None else converter
        )

    def build_parser(self):
        """Build the command-line parser."""
        parser = argparse.ArgumentParser(
            prog="converter.py", description=self.DESCRIPTION
        )
        parser.add_argument(
            "paths", nargs="+", metavar="PATH",
            help="Shell script files or directories to convert",
        )
        direction = parser.add_mutually_exclusive_group()
        direction.add_argument(
            "--json", "--to-json", dest="direction",
            action="store_const", const="json",
            help="Convert classic @-tags to JSON envelopes",
        )
        direction.add_argument(
            "--tags", "--to-tags", dest="direction",
            action="store_const", const="tags",
            help="Convert JSON envelopes to classic @-tags (default)",
        )
        parser.add_argument(
            "--dry-run", action="store_true",
            help="Print converted content without overwriting files",
        )
        parser.set_defaults(direction="tags")
        return parser

    def run(self, argv=None):
        """Parse the command line and convert the requested paths."""
        args = self.build_parser().parse_args(argv)
        return self.converter.convert_paths(
            args.paths, args.direction, args.dry_run
        )


if __name__ == "__main__":
    raise SystemExit(ConverterCli().run())
