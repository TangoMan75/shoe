#!/usr/bin/env python3
"""Validate the shoedoc annotations of every .sh file in a folder.

The annotation capture mirrors src/shell/shoedoc/_get_function_shoedoc.sh:
first the function's annotation lines are captured (every run of
consecutive leading "##" lines attached to the function definition that
follows them), and only THEN the leading double pound signs are removed,
so that the annotation can simply be parsed like a normal script with
`import json` / `json.loads`.

The pipeline per annotated function is:
  1. capture the consecutive "##" annotation lines preceding the
     function definition (skipping blank lines),
  2. strip the leading "##" (and one space) off every line,
  3. isolate the JSON envelope formed by the "{}" bracketed lines,
  4. parse the envelope as plain JSON and validate it.

The parsed block is validated:

  - the block must be valid JSON (a dangling comma before `## }` is invalid),
  - every property must be known: namespace, summary, description, author,
    copyright, version, license, link, update, arguments, return, stdout,
    stderr, stdin, returns, requires, depends, assumes, parameters,
    options, flags,
  - "namespace": string, valid relative path (no leading/trailing slash,
    no drive letter, no backslashes, no "..", no "./"),
  - "requires": array of non-empty strings (external commands), sorted
    alphabetically and deduplicated, not empty,
    statically detected external commands (executables on PATH) not listed
    are added by --fix whenever the block is repaired, and always included
    in generated blocks,
  - "depends": array of relative paths to .sh files (no .sh extension,
    no leading/trailing slash, no backslashes, no "..", no "./"), sorted
    alphabetically and deduplicated, not empty, must list every statically
    detected call to a function defined in a .sh file under the "src"
    folder relative to the working directory (files outside "src" and files
    under a "build" folder are excluded from the call registry; existing
    entries pointing outside "src" are preserved); missing entries are
    reported as warnings and added by --fix,
  - "assumes": array of shell variable names (UPPERCASE, underscore or
    internal __var__ style), sorted alphabetically and deduplicated,
    not empty,
    every "requires" / "depends" / "assumes" entry must be referenced in
    the file body (outside the annotation lines): "requires" by its command
    name, "depends" by its base function name, "assumes" by variable name,
  - "parameters", "options" and "flags": arrays of objects, each with:
      "position": optional positive int (parameters only),
      "name": string (variable name: letters, digits, underscores),
      "flag": optional "-x" or "--alias" string,
      "type": optional one of str, dir, folder, file, path, int, bool,
       const, json, array, flag,
      "description": optional string,
      "summary": optional string,
      "required": optional bool,
      "default": optional string, int or bool,
      "nullable": optional bool,
      "constraint": optional regex string "/.../flags",
    at least "name" or "flag" must be present, not empty,
  - the string properties (summary, description, author, copyright,
    version, license, link, update, arguments, return, stdout, stderr,
    stdin, returns) must be strings ("description" may be empty),
  - unknown properties are invalid.

Annotated functions whose captured annotation lines form no balanced
"## {" ... "## }" envelope are reported as warnings. A block opened by
"## {" but ended by the next non-annotation line or the end of file
without a "## }" is reported as a malformed-shoedoc warning. A bare
annotation run without any "## {" line (e.g. a summary only) is reported
as "no '## {' ... '## }' JSON block around the annotation lines".

Files with no annotation lines attached to any function are ignored.

Exit codes: 0 = all blocks valid, 1 = some blocks are invalid,
2 = usage error.

Usage: python3 shoeshine.py <folder> [--fix]
  The "namespace" folders and "depends" files must exist relative to the
  working directory.
  --fix: automatically repair invalid blocks and rewrite the files when the
         repair succeeds. Repairs are limited to:
           - dangling commas before "## }" / "## ]" (strict JSON validity),
           - orphan depends entry lines / stray array terminator(s) after a
             "depends": [], header,
          - missing "namespace" property, inserted as the file's parent
            directory relative to the working directory; an existing
            "namespace" value whose folder does not exist relative to the
            working directory is replaced by the file's parent directory,
           - "requires" / "depends" / "assumes" entries sorted
             alphabetically and deduplicated,
            - empty "requires" / "depends" / "assumes" arrays removed,
            - empty "parameters" property removed,
            - unused "requires" / "depends" / "assumes" entries removed
              (entries not referenced anywhere in the file body),
             - missing "depends" entries added (functions statically detected
               as called by the annotated function but defined in a .sh file
               under the "src" folder relative to the working directory),
            - missing "requires" entries added (external commands statically
              detected as called by the annotated function and resolvable
              on PATH),
             - missing "## {" ... "## }" envelope generated for annotation
               runs with no JSON block at all: the bare annotation text
               lines (e.g. "## Example summary") are removed and replaced
               by a block carrying "summary" (the bare lines' text),
               "namespace" (the file's parent directory) and the statically
               detected "requires" / "depends" entries,
             - bare text lines preceding the "## {" line (e.g. a legacy
               "## Summary line" / "##" title) folded into the envelope as
               a "summary" property (the bare lines' text) whenever the
               block defines no "summary", the bare lines being removed.
           Blocks that cannot be repaired automatically keep their errors.
"""

import json
import os
import re
import shutil
import sys
from collections import namedtuple
from pathlib import Path

REL_PATH_RE = re.compile(r"^(?!/|\\|\./|\.\./)([a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?/)*[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)?$")
VAR_NAME_RE = re.compile(r"^[a-zA-Z_][a-zA-Z0-9_]*$")
CONSTANT_RE = re.compile(r"^_{0,2}[A-Z0-9]+(?:_[A-Z0-9]+)*_{0,2}$")
GROUP_COMMAND_RE = re.compile(r"^[a-zA-Z0-9_][a-zA-Z0-9_./+-]*( [a-zA-Z0-9_.+-]+)?$")
COMMAND_RE = re.compile(r"^[a-zA-Z0-9_][a-zA-Z0-9_.+-]*$")
FLAG_RE = re.compile(r"^(-|)[a-zA-Z]$|^--[a-zA-Z][a-zA-Z-]*$")
CONSTRAINT_RE = re.compile(r"^/.*/[a-z]*$")
VALID_TYPES = {
    "str", "dir", "folder", "file", "path", "int", "bool", "const", "json",
    "array", "flag",
}

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

# Top-level string properties, validated as strings (may be empty).
STRING_PROPERTIES = (
    "summary", "description", "author", "copyright", "version", "license",
    "link", "update", "arguments", "return", "stdout", "stderr", "stdin",
)

# Top-level entry-array properties, sharing the same object shape.
ENTRY_ARRAY_KEYS = ("parameters", "options", "flags")


def _strip_eol(line: str) -> str:
    """Strip the trailing newline (and carriage return for CRLF files)."""
    return line.rstrip("\r\n")


# ---------------------------------------------------------------------------
# Step 1: capture the function's annotation lines (function first)
# ---------------------------------------------------------------------------


AnnotationRecord = namedtuple(
    "AnnotationRecord",
    ["function_line_index", "function_name", "line_indexes", "lines"],
)


def capture_function_annotations(file_lines: list) -> list:
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
        match = FUNCTION_RE.match(_strip_eol(line))
        if not match:
            continue
        run_indexes = []
        cursor = index - 1
        while cursor >= 0:
            stripped = _strip_eol(file_lines[cursor])
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
                [_strip_eol(file_lines[i]) for i in run_indexes],
            ))
    return records


# ---------------------------------------------------------------------------
# Step 2: remove the leading double pound signs
# ---------------------------------------------------------------------------


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


def strip_shoedoc_prefixes(annotation_lines: list) -> list:
    """Apply strip_shoedoc_prefix to every annotation line."""
    return [strip_shoedoc_prefix(line) for line in annotation_lines]


def locate_envelope(stripped_lines: list) -> tuple:
    """Locate the JSON envelope in the annotation lines whose '##' prefixes
    were stripped: the first bare '{' line and the last bare '}' line.
    Returns (first_open_index, last_close_index); missing bounds are None."""
    first_open = None
    last_close = None
    for index, stripped in enumerate(stripped_lines):
        if stripped == "{":
            if first_open is None:
                first_open = index
        elif stripped == "}":
            last_close = index
    return first_open, last_close


def envelope_json_text(stripped_lines: list, first_open: int, last_close: int) -> str:
    """Join the envelope lines (between '{' and '}') into one plain JSON
    string ready for `json.loads`."""
    return "\n".join(stripped_lines[first_open:last_close + 1])


def envelope_state(stripped_lines: list) -> str:
    """Classify the stripped annotation: 'bare' (no '{' line at all),
    'unclosed' ('## {' without matching '## }'), or 'envelope' (a balanced
    '{' ... '}' envelope is present)."""
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
    first_open, last_close = locate_envelope(stripped_lines)
    if first_open is None or last_close is None or first_open > last_close:
        return "bare"
    return "envelope"


def parse_shoedoc(json_text: str):
    """Parse the shoedoc annotation like a normal script: `json.loads`."""
    return json.loads(json_text)


def missing_shoedoc_blocks(file_lines: list) -> list:
    """Find the function definitions whose captured annotation lines (the
    consecutive "##" lines above them, blank lines skipped) form no
    balanced "## {" ... "## }" envelope. Returns a list of
    (function_line_index, function_name, annotation_start_index) tuples."""
    return [
        (record.function_line_index, record.function_name,
         record.line_indexes[0])
        for record in capture_function_annotations(file_lines)
        if envelope_state(strip_shoedoc_prefixes(record.lines)) != "envelope"
    ]


# ---------------------------------------------------------------------------
# Shell code sanitizing (used for call detection and body references)
# ---------------------------------------------------------------------------


def sanitize(text: str, heredoc=None):
    """Blank out comments, quoted strings and heredoc bodies to avoid false
    call detection. Command substitutions (backticks and $( ... )) inside
    quoted strings or heredocs are preserved: they are actually executed.
    Returns (sanitized_text, trailing_heredoc_delimiter)."""
    chars = list(text)
    heredoc = _sanitize_scan(text, chars, 0, len(text), heredoc)
    return "".join(chars), heredoc


def _blank(chars, start, stop):
    """Replace the given character range with spaces."""
    for index in range(start, min(stop, len(chars))):
        chars[index] = " "


def _sanitize_scan(text, chars, start, stop, heredoc=None, depth=0):
    """Walk a character range in 'code' context and blank, in place:
      - comments (#...),
      - single-quoted strings,
      - double-quoted strings (recursing into command substitutions),
      - parameter expansions (${...} ... ${}),
      - heredoc bodies, whose payload is bounded on each line by a
        delimiter line equal to `heredoc` (recursing into command
        substitutions).
    Ranges nested deeper than SANITIZE_DEPTH_LIMIT command substitutions
    are blanked instead of recursed, so pathological input cannot overflow
    the Python recursion stack.
    Returns the heredoc delimiter still open at the end of the range."""
    if depth > SANITIZE_DEPTH_LIMIT:
        _blank(chars, start, stop)
        return heredoc
    index = start
    while index < stop:
        char = text[index]
        if heredoc is not None:
            # heredoc body line: blank it, unless it terminates the heredoc
            delimiter, quoted = heredoc
            line_end = text.find("\n", index, stop)
            if line_end == -1:
                if not quoted:
                    _sanitize_payload(text, chars, index, stop, depth + 1)
                else:
                    _blank(chars, index, stop)
                return heredoc
            if text[index:line_end].rstrip(" \t") == delimiter:
                heredoc = None
            elif not quoted:
                _sanitize_payload(text, chars, index, line_end, depth + 1)
            else:
                _blank(chars, index, line_end)
            index = line_end + 1
            continue
        if (
            char == "#"
            and (index == start or text[index - 1] in " \t;|&(\n")
        ):
            line_end = text.find("\n", index, stop)
            if line_end == -1:
                _blank(chars, index, stop)
                return heredoc
            _blank(chars, index, line_end)
            index = line_end
            continue
        if char == "'":
            close = text.find("'", index + 1, stop)
            end = stop if close == -1 else close + 1
            _blank(chars, index, end)
            index = end
            # skip a trailing escaped quote ("...'\'...'"), otherwise the
            # unmatched apostrophe would open a string spanning lines
            if (
                close != -1 and index + 1 < stop
                and text[index] == "\\" and text[index + 1] == "'"
            ):
                _blank(chars, index, index + 2)
                index += 2
            continue
        if char == '"':
            end = _sanitize_dquote(text, chars, index, stop, depth + 1)
            index = end
            continue
        if char == "`":
            close = text.find("`", index + 1, stop)
            end = stop if close == -1 else close + 1
            if close != -1:
                _sanitize_scan(text, chars, index + 1, close,
                               None, depth + 1)
            index = end
            continue
        if char == "$" and index + 1 < stop and text[index + 1] == "{":
            close = text.find("}", index + 1, stop)
            index = stop if close == -1 else close + 1
            continue
        if (
            char == "$" and index + 1 < stop and text[index + 1] == "("
        ):
            close = _matching_delim(text, index + 1, stop, "(", ")")
            inner_end = stop if close == -1 else close
            _sanitize_scan(text, chars, index + 2, inner_end,
                           None, depth + 1)
            index = stop if close == -1 else close + 1
            continue
        if char == "<" and index + 1 < stop and text[index + 1] == "<":
            if index + 2 < stop and text[index + 2] == "<":
                # here-string: not a heredoc
                index += 2
                continue
            delimiter, quoted, index = _sanitize_heredoc_prefix(
                text, chars, index, stop
            )
            if delimiter is not None:
                heredoc = (delimiter, quoted)
            continue
        index += 1
    return heredoc


def _sanitize_dquote(text, chars, start, stop, depth=0):
    """Blank a double-quoted string in place (including the quotes); the
    command substitutions it contains are recursed instead of blanked.
    Ranges nested deeper than SANITIZE_DEPTH_LIMIT are blanked outright.
    Returns the index just past the closing quote (or `stop`)."""
    if depth > SANITIZE_DEPTH_LIMIT:
        _blank(chars, start, stop)
        return stop
    chars[start] = " "
    index = start + 1
    while index < stop:
        char = text[index]
        if char == "\\" and index + 1 < stop:
            _blank(chars, index, index + 2)
            index += 2
            continue
        if char == "`":
            close = text.find("`", index + 1, stop)
            end = stop if close == -1 else close + 1
            if close != -1:
                chars[close] = " "
                _sanitize_scan(text, chars, index + 1, close,
                               None, depth + 1)
            chars[index] = " "
            index = end
            continue
        if char == "$" and index + 1 < stop and text[index + 1] == "(":
            close = _matching_delim(text, index + 1, stop, "(", ")")
            inner_end = stop if close == -1 else close
            _sanitize_scan(text, chars, index + 2, inner_end,
                           None, depth + 1)
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


def _matching_delim(text, open_index, stop, open_char, close_char):
    """Index of the matching `close_char` for the `open_char` at open_index
    (single/double-quoted strings and backslashes inside are skipped), or
    -1."""
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


def _sanitize_heredoc_prefix(text, chars, index, stop):
    """Blank the `<< [out] delimiter` prefix of a heredoc redirection and
    return (delimiter, quoted, index_of_end_of_line); (None, False, ...)
    when no delimiter follows the redirection."""
    cursor = index + 2
    _blank(chars, index, cursor)
    if cursor < stop and text[cursor] == "-":
        cursor += 1
    while cursor < stop and text[cursor] in " \t":
        _blank(chars, cursor, cursor + 1)
        cursor += 1
    delimiter = None
    quoted = False
    if cursor < stop and text[cursor] in "'\"":
        quote = text[cursor]
        close = text.find(quote, cursor + 1, stop)
        end = stop if close == -1 else close
        _blank(chars, cursor, cursor + 1)
        delimiter_start = cursor + 1
        stripped = text[delimiter_start:end]
        _blank(chars, delimiter_start, end)
        if close != -1:
            _blank(chars, close, close + 1)
        if stripped:
            delimiter = stripped
            quoted = True
    else:
        word_start = cursor
        while cursor < stop and (
            text[cursor].isalnum() or text[cursor] == "_"
        ):
            _blank(chars, cursor, cursor + 1)
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


def _sanitize_payload(text, chars, start, stop, depth=0):
    """Blank a quoted / heredoc payload in place, except command
    substitutions (backticks and $( ... )), which are recursed instead.
    Ranges nested deeper than SANITIZE_DEPTH_LIMIT are blanked outright."""
    if depth > SANITIZE_DEPTH_LIMIT:
        _blank(chars, start, stop)
        return stop
    index = start
    while index < stop:
        char = text[index]
        if char == "\\" and index + 1 < stop:
            _blank(chars, index, index + 2)
            index += 2
            continue
        if char == "`":
            close = text.find("`", index + 1, stop)
            end = stop if close == -1 else close + 1
            if close != -1:
                chars[close] = " "
                _sanitize_scan(text, chars, index + 1, close,
                               None, depth + 1)
            chars[index] = " "
            index = end
            continue
        if char == "$" and index + 1 < stop and text[index + 1] == "(":
            close = _matching_delim(text, index + 1, stop, "(", ")")
            inner_end = stop if close == -1 else close
            _sanitize_scan(text, chars, index + 2, inner_end,
                           None, depth + 1)
            index = stop if close == -1 else close + 1
            continue
        if char == "$" and index + 1 < stop and text[index + 1] == "{":
            close = text.find("}", index + 1, stop)
            index = stop if close == -1 else close + 1
            continue
        chars[index] = " "
        index += 1
    return stop


# ---------------------------------------------------------------------------
# Call registry and dependency detection
# ---------------------------------------------------------------------------


def build_registry() -> dict:
    """Map each top-level function name to its defining file, as a relative
    path from the working directory (without the .sh extension). The
    registry is built from the working directory - not from the scanned
    folder - so that functions defined under "src" are resolved even when
    --fix runs on a subfolder. Files under a "build" folder and files
    outside the "src" folder are excluded: --fix must only ever add "src"
    dependencies."""
    registry = {}
    for path in sorted(Path.cwd().rglob("*.sh")):
        if "build" in path.parts:
            continue
        entry = os.path.relpath(path.with_suffix(""), Path.cwd())
        if entry != "src" and not entry.startswith("src" + os.sep):
            continue
        content = path.read_text()
        for line in content.splitlines():
            match = FUNCTION_RE.match(line)
            if match:
                registry.setdefault(
                    match.group(1),
                    entry,
                )
    return registry


def find_calls(function_body: str, registry: dict, defined: set) -> set:
    """Calls to registry entries, excluding locally defined functions.
    Calls inside quotes, comments or heredocs are ignored, except when
    performed through a command substitution (backticks or $( ... ))."""
    calls = set()
    sanitized, _ = sanitize(function_body)
    for match in CALL_RE.finditer(sanitized):
        name = match.group(1)
        if name in registry and name not in defined:
            calls.add(name)
    return calls


def find_external_commands(function_body: str, defined: set,
                           registry: dict) -> set:
    """External commands called by the function body, excluding locally
    defined functions and registry (src) functions: a command is detected
    when an executable with this name exists on PATH. The identifier right
    after for / while is a loop variable, not a command. Calls inside
    quotes, comments or heredocs are ignored, except when performed through
    a command substitution (backticks or $( ... ))."""
    commands = set()
    sanitized, _ = sanitize(function_body)
    previous = ""
    for match in CALL_RE.finditer(sanitized):
        name = match.group(1)
        loop = previous in ("for", "while")
        previous = name
        if name in defined or name in registry or loop:
            continue
        if shutil.which(name):
            commands.add(name)
    return commands


def find_missing_array_entries(parsed, key, computed) -> set:
    """Entries of `computed` (calls / external commands) that are not
    listed in the parsed block's given array (requires / depends)."""
    if not computed:
        return set()
    existing = parsed.get(key)
    existing_set = set(existing) if isinstance(existing, list) else set()
    return computed - existing_set


def missing_depends(parsed, function_body, registry, defined) -> set:
    """Return the registry paths of statically detected function calls that
    are not listed in the parsed block's "depends" array."""
    if not function_body or not isinstance(parsed, dict):
        return set()
    computed = find_calls(function_body, registry, defined)
    return {
        registry[call] for call in find_missing_array_entries(
            parsed, "depends", computed
        )
    }


def missing_requires(parsed, function_body, registry, defined) -> set:
    """Return the executable names of statically detected external commands
    that are not listed in the parsed block's "requires" array."""
    if not function_body or not isinstance(parsed, dict):
        return set()
    computed = find_external_commands(
        function_body, defined, registry
    )
    return find_missing_array_entries(parsed, "requires", computed)


def find_defined_functions(file_lines: list) -> set:
    """All functions defined in the file, including nested definitions."""
    return {
        match.group(1)
        for line in file_lines
        if (match := FUNCTION_RE.match(line.rstrip("\n")))
    }


def function_body_below(file_lines: list, from_index: int):
    """Return the raw source of the function defined after the given line
    index (blank lines allowed between the shoedoc block and the function),
    or None."""
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
        # braces inside quoted strings or comments are plain characters
        # and must not affect depth
        counted, heredoc = sanitize(line, heredoc)
        depth += counted.count("{") - counted.count("}")
        if depth > 0:
            started = True
        elif started and depth <= 0:
            break
        index += 1
    return "".join(body)


def missing_depends(parsed, function_body, registry, defined) -> set:
    """Return the registry paths of statically detected function calls that
    are not listed in the parsed block's "depends" array."""
    if not function_body or not isinstance(parsed, dict):
        return set()
    expected = {
        registry[call] for call in find_calls(function_body, registry, defined)
    }
    if not expected:
        return set()
    existing = parsed.get("depends")
    existing_set = set(existing) if isinstance(existing, list) else set()
    return expected - existing_set


# ---------------------------------------------------------------------------
# Validation of the parsed shoedoc
# ---------------------------------------------------------------------------


def validate_rel_path(value, key):
    """Return the list of error strings for a relative-path property."""
    errors = []
    if not REL_PATH_RE.match(value):
        errors.append(f"not a valid relative path: {value!r}")
    if not value:
        errors.append(f"{key} must not be empty")
    return errors


def check_object_of_named_keys(value, what, errors):
    if not isinstance(value, list):
        errors.append(f"{what} must be an array of objects")
        return
    for object in value:
        if not isinstance(object, dict):
            errors.append(f"{what} must contain objects")
            continue
        if "name" not in object and "flag" not in object:
            errors.append(
                f"{what}: {json.dumps(object)}: neither 'name' nor 'flag' set"
            )
        name = object.get("name")
        if name is not None and not isinstance(name, str):
            errors.append(f"{what}: 'name' must be a string")
        elif name is not None and not all(
            VAR_NAME_RE.match(part) for part in name.split("|")
        ):
            errors.append(f"{what}: invalid 'name': {name!r}")
        flag = object.get("flag")
        if flag is not None and not isinstance(flag, str):
            errors.append(f"{what}: 'flag' must be a string")
        elif flag is not None and not FLAG_RE.match(flag):
            errors.append(f"{what}: invalid 'flag': {flag!r}")
        type_ = object.get("type")
        if type_ is not None and type_ not in VALID_TYPES:
            errors.append(f"{what}: invalid 'type': {type_!r} (expected one of "
                          f"{'|'.join(sorted(VALID_TYPES))})")
        position = object.get("position")
        if position is not None and (
            not isinstance(position, int) or isinstance(position, bool)
            or position < 1
        ):
            errors.append(f"{what}: 'position' must be a positive integer")
        description = object.get("description")
        if description is not None and not isinstance(description, str):
            errors.append(f"{what}: 'description' must be a string")
        summary = object.get("summary")
        if summary is not None and not isinstance(summary, str):
            errors.append(f"{what}: 'summary' must be a string")
        required = object.get("required")
        if required is not None and not isinstance(required, bool):
            errors.append(f"{what}: 'required' must be a boolean")
        if "default" in object and not isinstance(
            object["default"], (str, int, float, bool, type(None))
        ):
            errors.append(f"{what}: 'default' must be a scalar or null")
        nullable = object.get("nullable")
        if nullable is not None and not isinstance(nullable, bool):
            errors.append(f"{what}: 'nullable' must be a boolean")
        constraint = object.get("constraint")
        if constraint is not None:
            if not isinstance(constraint, str):
                errors.append(f"{what}: 'constraint' must be a string")
            elif not CONSTRAINT_RE.match(constraint):
                errors.append(f"{what}: invalid 'constraint': {constraint!r} "
                              f"(expected '/regex/flags')")
        unknown = set(object) - {
            "position", "name", "flag", "type", "description", "summary",
            "required", "default", "nullable", "constraint",
        }
        if unknown:
            errors.append(f"{what}: unknown key(s): {', '.join(sorted(unknown))}")


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


def check_string_array_usage(values, key, body, errors):
    """Check that every entry of a requires/depends/assumes array is
    referenced in the file body."""
    for item in values:
        if not isinstance(item, str) or not item:
            continue
        token = re.escape(entry_token(item, key))
        if not re.search(rf"\b{token}\b", body):
            errors.append(f"'{key}' unused entry: {item!r}")


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


def validate_property(key, value, errors):
    if key == "namespace":
        if not isinstance(value, str):
            errors.append("'namespace' must be a string")
        else:
            for error in validate_rel_path(value, key):
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
            validate_string_array(value, "requires", errors)
    elif key == "depends":
        if not isinstance(value, list) or not all(
            isinstance(item, str) for item in value
        ):
            errors.append("'depends' must be an array of strings")
        else:
            for item in value:
                for error in validate_rel_path(item, "depends"):
                    errors.append(f"'depends': {error}")
            for item in value:
                if not Path(f"{item}.sh").is_file():
                    errors.append(f"'depends' file not found: {item!r}.sh")
            validate_string_array(value, "depends", errors)
    elif key == "assumes":
        if not isinstance(value, list) or not all(
            isinstance(item, str) for item in value
        ):
            errors.append("'assumes' must be an array of strings")
        else:
            for item in value:
                if not CONSTANT_RE.match(item) and not VAR_NAME_RE.match(item):
                    errors.append(f"'assumes' invalid variable: {item!r}")
            validate_string_array(value, "assumes", errors)
    elif key == "summary":
        if not isinstance(value, str):
            errors.append("'summary' must be a string")
    elif key == "returns":
        if not isinstance(value, str) or not VAR_NAME_RE.match(value):
            errors.append("'returns' must be a valid type name")
    elif key in STRING_PROPERTIES:
        if not isinstance(value, str):
            errors.append(f"'{key}' must be a string")
        elif not value.strip():
            errors.append(f"'{key}' must not be empty")
    elif key in ENTRY_ARRAY_KEYS:
        if not isinstance(value, list):
            errors.append(f"'{key}' must be an array")
        elif not value:
            errors.append(f"'{key}' must not be empty")
        else:
            check_object_of_named_keys(value, f"'{key}'", errors)
    else:
        errors.append(f"unknown property: '{key}'")


def validate_shoedoc(parsed, source, body=""):
    """Return (errors, warnings) lists for one parsed shoedoc object."""
    if not isinstance(parsed, dict):
        return [f"{source}: shoedoc block is not a JSON object"], []
    errors = []
    for key, value in parsed.items():
        validate_property(key, value, errors)
    if body:
        for key in ARRAY_KEYS:
            value = parsed.get(key)
            if isinstance(value, list) and all(
                isinstance(item, str) for item in value
            ):
                check_string_array_usage(value, key, body, errors)
    warnings = []
    if "namespace" not in parsed:
        warnings.append("missing 'namespace' property")
    return (
        [f"{source}: {error}" for error in errors],
        [
            f"{source}: {warning}"
            if not warning.startswith(source)
            else warning
            for warning in warnings
        ],
    )


# ---------------------------------------------------------------------------
# --fix: repair the stripped envelope text, then rewrite the object
# ---------------------------------------------------------------------------

DANGLING_COMMA_RE = re.compile(r",\s*$")
EMPTY_DEPENDS_RE = re.compile(r'^(\s*)"depends":\s*\[\]\s*,?\s*$')
ENTRY_ONLY_RE = re.compile(r'^\s*"([^"]+)",?\s*$')
ARRAY_CLOSE_RE = re.compile(r"^\s*\]\s*,?\s*$")


def remove_dangling_commas(lines: list, fixes: list) -> list:
    """Remove dangling commas before '}' / ']' lines so that the stripped
    envelope can be parsed like a normal JSON document."""
    new_lines = list(lines)
    for index in range(len(new_lines) - 1):
        current = new_lines[index].rstrip()
        next_line = new_lines[index + 1].lstrip()
        if (
            DANGLING_COMMA_RE.search(current)
            and (next_line.startswith("}") or next_line.startswith("]"))
        ):
            new_lines[index] = DANGLING_COMMA_RE.sub("", current)
            fixes.append("removed dangling comma")
    return new_lines


def merge_orphan_depends_lines(lines: list, fixes: list) -> list:
    """Merge orphan depends entry lines / stray array terminator(s) that
    follow a stripped "depends": [], header back into the array."""
    new_lines = list(lines)
    body_end = next(
        (index for index in range(1, len(new_lines))
         if new_lines[index].strip() == "}"),
        len(new_lines),
    )
    for index in range(body_end):
        current = new_lines[index].rstrip()
        if not (match := EMPTY_DEPENDS_RE.match(current)):
            continue
        indent = match.group(1)
        entries = []
        terminator = None
        for cursor in range(index + 1, body_end):
            entry_line = new_lines[cursor].strip()
            if ENTRY_ONLY_RE.match(entry_line):
                entries.append(cursor)
                continue
            if ARRAY_CLOSE_RE.match(entry_line):
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
                and ARRAY_CLOSE_RE.match(new_lines[cursor].strip())
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
                if ARRAY_CLOSE_RE.match(new_lines[cursor].strip()):
                    del new_lines[cursor]
                    fixes.append("removed stray depends array terminator")
                    break
        break
    return new_lines


def fix_string_array_entries(entries, key, body):
    """Deduplicate and sort the entries of a requires/depends/assumes
    array, dropping the unused ones. Returns (cleaned_entries, fixes)."""
    fixes = []
    deduplicated = list(dict.fromkeys(entries))
    if len(deduplicated) < len(entries):
        fixes.append(f"removed duplicated '{key}' entries")
    dropped_unused = [
        entry for entry in deduplicated
        if not re.search(rf"\b{re.escape(entry_token(entry, key))}\b", body)
    ]
    if dropped_unused:
        fixes.append(f"removed unused '{key}' entries")
    cleaned = sorted(
        entry for entry in deduplicated if entry not in dropped_unused
    )
    return cleaned, fixes


def fix_dictionary(parsed, body, adds, namespace_value, wrong_namespace):
    """Apply the whole-fix pipeline to the parsed shoedoc object; returns
    (new_object, fixes). `adds` maps array keys (requires / depends) to the
    entries to merge; a missing array property is created right after the
    namespace, in canonical order."""
    if not isinstance(parsed, dict):
        return None, []
    fixes = []
    result = {}

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
            cleaned, array_fixes = fix_string_array_entries(value, key, body)
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
                entry for entry in dict.fromkeys(value) if entry in cleaned
            ]
            if cleaned != original:
                fixes.append(f"sorted '{key}' entries")
            result[key] = cleaned
        elif key in ENTRY_ARRAY_KEYS and isinstance(value, list) and (
            not value
        ):
            fixes.append(f"removed empty '{key}' property")
            continue
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

    return result, fixes


def fold_summary_property(parsed, summary_text) -> dict:
    """Fold the bare annotation lines' text into the parsed shoedoc object
    as a "summary" property, placed right after "namespace" when present,
    first otherwise."""
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


def shoedoc_envelope_lines(parsed) -> list:
    """Serialize the fixed object back into shoedoc lines: a leading '## '
    per line of the JSON rendering, exactly like a normal annotation."""
    text = json.dumps(parsed, indent=2, ensure_ascii=False)
    return [f"## {line}\n" for line in text.splitlines()]


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------


def main() -> int:
    fix = "--fix" in sys.argv[1:]
    arguments = [
        argument for argument in sys.argv[1:]
        if argument != "--fix"
    ]
    if len(arguments) != 1:
        print(f"usage: {sys.argv[0]} <folder> [--fix]",
              file=sys.stderr)
        return 2
    folder = Path(arguments[0])
    if not folder.is_dir():
        print(f"error: not a directory: {folder}", file=sys.stderr)
        return 2

    registry = build_registry()
    count = warnings_count = blocks = 0
    failed = False
    for path in sorted(folder.rglob("*.sh")):
        if "build" in path.parts:
            # build artifacts are not scanned
            continue
        content = path.read_text()
        file_lines = content.splitlines(keepends=True)

        # -- Step 1: capture the functions' annotations first
        annotations = capture_function_annotations(file_lines)
        if not annotations:
            continue

        annotation_spans = {
            index
            for record in annotations
            for index in record.line_indexes
        }
        body = sanitize("".join(
            line for index, line in enumerate(file_lines)
            if index not in annotation_spans
        ))[0]
        defined = find_defined_functions(file_lines)
        replacements = []

        for record in annotations:
            function_line_index = record.function_line_index
            function_name = record.function_name
            run_indexes = record.line_indexes
            # -- Step 2: remove the leading double pound signs
            stripped = strip_shoedoc_prefixes(record.lines)
            state = envelope_state(stripped)
            if state == "bare":
                if not fix:
                    warnings_count += 1
                    print(
                        f"warning: {path}:{function_line_index + 1}: "
                        f"invalid shoedoc: no '## {{' ... '## }}' JSON block "
                        f"around the annotation lines of function "
                        f"'{function_name}'"
                    )
                    continue
                summary_texts = [
                    stripped.strip()
                    for stripped in (
                        strip_shoedoc_prefix(line) for line in record.lines
                    )
                ]
                summary_texts = [text for text in summary_texts if text]
                namespace_value = os.path.relpath(path.parent, Path.cwd())
                function_source = function_body_below(
                    file_lines, function_line_index
                )
                expected_calls = {
                    registry[call]
                    for call in find_calls(
                        function_source or "", registry, defined
                    )
                }
                expected_commands = find_external_commands(
                    function_source or "", defined, registry
                )
                generated = {"namespace": namespace_value}
                if summary_texts:
                    generated["summary"] = "\n".join(summary_texts)
                if expected_commands:
                    generated["requires"] = sorted(expected_commands)
                if expected_calls:
                    generated["depends"] = sorted(expected_calls)
                insertion_source = f"{path}:{function_line_index + 1}"
                post_errors, _ = validate_shoedoc(
                    generated, insertion_source, body
                )
                if post_errors:
                    warnings_count += 1
                    print(
                        f"warning: {path}:{function_line_index + 1}: "
                        f"invalid shoedoc: no '## {{' ... '## }}' JSON block "
                        f"around the annotation lines of function "
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
                    shoedoc_envelope_lines(generated),
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
            first_open, last_close = locate_envelope(stripped)
            envelope_start = run_indexes[first_open]
            envelope_end = run_indexes[last_close]
            bare_summary_texts = [
                text
                for text in (line.strip() for line in stripped[:first_open])
                if text
            ]
            source = f"{path}:{envelope_start + 1}"
            json_text = envelope_json_text(
                stripped, first_open, last_close
            )
            try:
                parsed = parse_shoedoc(json_text)
            except json.JSONDecodeError as error:
                parsed = None
                errors = [f"{source}: invalid shoedoc JSON: {error}"]
                warnings = []
            else:
                errors, warnings = validate_shoedoc(parsed, source, body)
            function_source = function_body_below(
                file_lines, envelope_end + 1
            )
            missing = missing_depends(
                parsed, function_source, registry, defined
            )
            if missing:
                for entry in sorted(missing):
                    warnings.append(
                        f'{source}: \'depends\' missing entry: "{entry}"'
                    )
            requires_missing = missing_requires(
                parsed, function_source, registry, defined
            ) if fix else set()
            missing_namespace = parsed is not None and any(
                warning.endswith("missing 'namespace' property")
                for warning in warnings
            ) and fix
            namespace_value = os.path.relpath(path.parent, Path.cwd())
            wrong_namespace = None
            if fix and isinstance(parsed, dict):
                value = parsed.get("namespace")
                if (
                    isinstance(value, str)
                    and not Path(value).is_dir()
                ):
                    wrong_namespace = namespace_value
            if errors:
                failed = True
                count += len(errors)
                for error in errors:
                    print(f"error: {error}")
            if fix and (
                errors or missing_namespace
                or wrong_namespace is not None
                or missing
                or requires_missing
                or (
                    bare_summary_texts
                    and isinstance(parsed, dict)
                    and "summary" not in parsed
                )
            ):
                # -- Repair: try to parse the stripped envelope leniently
                fixes = []
                envelope_stripped = stripped[first_open:last_close + 1]
                repaired = remove_dangling_commas(envelope_stripped, fixes)
                repaired = merge_orphan_depends_lines(repaired, fixes)
                repaired = remove_dangling_commas(repaired, fixes)
                try:
                    fixed_parsed = parse_shoedoc("\n".join(repaired))
                except json.JSONDecodeError:
                    fixed_parsed = None
                if fixed_parsed is not None:
                    fixed_parsed, fix_fixes = fix_dictionary(
                        fixed_parsed, body,
                        {
                            "depends": missing if missing else (),
                            "requires": (
                                requires_missing if requires_missing else ()
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
                        fixed_parsed = fold_summary_property(
                            fixed_parsed, "\n".join(bare_summary_texts)
                        )
                        fixes.append(
                            "folded summary lines into 'summary'"
                        )
                        folded = True
                    post_errors, post_warnings = validate_shoedoc(
                        fixed_parsed, source, body
                    )
                    if not post_errors and not missing_depends(
                        fixed_parsed, function_source, registry, defined
                    ) and not missing_requires(
                        fixed_parsed, function_source, registry, defined
                    ):
                        new_block = shoedoc_envelope_lines(fixed_parsed)
                        replace_start = (
                            run_indexes[0] if folded else envelope_start
                        )
                        replace_len = envelope_end - replace_start + 1
                        replacements.append(
                            (replace_start, replace_len, new_block)
                        )
                        print(
                            f"fixed: {source} "
                            f"({', '.join(sorted(fixes))})"
                        )
                        warnings = post_warnings
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
        f"{blocks} block(s) checked, no error, {warnings_count} warning(s)"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
