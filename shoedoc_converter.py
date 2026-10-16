#!/usr/bin/env python3
"""Convert shoedoc annotations between JSON and classic @-tagged formats.

Two conversion directions are supported:

- ``--tags``: JSON shoedoc blocks like

      ## {
      ##   "namespace": "android",
      ##   "summary": "Summary line",
      ##   "author": "\"Name\" <email>",
      ##   "requires": ["adb"],
      ##   "parameters": [
      ##     {
      ##       "name": "IP",
      ##       "constraint": "/^([0-9]{1,3}\\\\.){3}[0-9]{1,3}$/"
      ##     }
      ##   ]
      ## }

  become classic @-tagged lines:

      ## Summary line
      ##
      ## @author: "Name" <email>
      ## @namespace: android
      ## @requires: adb
      ## @parameter: IP /^([0-9]{1,3}\\\\.){3}[0-9]{1,3}$/

  Rich parameter, option and flag objects become:

      ## @parameter {str} [WHO|who] <required> Summary - Long description
      ## @option {int} [-o|option] <optional> Option summary
      ## @flag [-f|flag] <optional> Flag summary

- ``--json`` (default): classic @-tagged blocks like the one above are
  converted back into JSON shoedoc blocks. Blocks are located as maximal
  runs of ``##`` shoedoc lines; a run holding at least one recognized tag
  is converted, while runs holding a JSON block start (``## {``) or no
  recognized tag are left untouched. Lines before the first empty ``##``
  line build the summary; lines between the first empty ``##`` line and
  the first tag build the multi-line description. Unknown tags are warned
  about and dropped, mirroring how the ``--tags`` direction drops unknown
  JSON keys.

Recognized classic tags are: ``@namespace``, ``@summary``, ``@requires``,
``@depends``, ``@assumes``, ``@author``, ``@copyright``, ``@version``,
``@license``, ``@link``, ``@update``, ``@arguments``, ``@return``,
``@stdout``, ``@stderr``, ``@stdin``, ``@parameter``/``@param``,
``@option`` and ``@flag``. The ``@param``/``@option``/``@flag`` values
follow the rich grammar

    @parameter {type} [alias|name] <optional|required> Summary - Long value
    @option   {type} [alias|name] <optional|required> Summary - Long value
    @flag            [alias|name] <optional|required> Summary - Long value

where ``{type}``, ``[alias|name]``, ``<optional|required>`` and the
`` - `` separator are each optional; the legacy ``NAME`` and
``NAME /regex/`` spellings are still accepted (``@parameter`` too).

Both ``## @tag: value`` and ``## @tag value`` (no colon) spellings are
accepted when parsing classic blocks.

Usage:
    python3 shoedoc_converter.py [--tags] [--dry-run] PATH...

Positional arguments may be files or directories. Directories are expanded
recursively to every ``*.sh`` file in the tree. Files and directories may
be mixed freely.

By default, files are edited in place. Use ``--dry-run`` to preview
converted content on stdout without modifying files. In dry-run mode, each
file's output is preceded by a ``==> PATH <==`` header.
"""

import argparse
import json
import os
import re
import sys

_TAG_RE = re.compile(r'^@([A-Za-z_][A-Za-z0-9_]*):?\s*(.*)$')

# Classic tags rendered as comma-separated arrays.
_ARRAY_KEYS = ('requires', 'depends', 'assumes')

# Classic tags parsed as ``@tag: value`` lines.
_STRING_KEYS = (
    'namespace', 'summary', 'author', 'copyright', 'version', 'license',
    'link', 'update', 'arguments', 'return', 'stdout', 'stderr', 'stdin',
) + _ARRAY_KEYS

# Classic tags rendered as ``@tag: value`` lines, in emission order.
# ``summary`` is not included: it is rendered as the block title instead.
_EMIT_KEYS = tuple(k for k in _STRING_KEYS if k != 'summary')

# Entry array keys parsed from the rich @param/@option/@flag tags.
_ENTRY_ARRAY_KEYS = ('parameters', 'options', 'flags')

# Keys recognised inside a JSON shoedoc block, in emission order.
_ORDERED_KEYS = _STRING_KEYS + _ENTRY_ARRAY_KEYS


def _parse_entry_value(raw):
    """Parse the value of a ``@param``/``@option``/``@flag`` tag.

    Grammar, with ``{type}``, ``[alias|name]``, ``<optional|required>``
    and the `` - `` separator each optional:

        {type} [alias|name] <optional|required> Summary - Long description

    The legacy ``NAME`` and ``NAME /regex/`` spellings are accepted too.
    A single ``[a]`` bracket is a name unless it starts with a dash.

    Returns the entry object for the ``parameters``/``options``/``flags``
    arrays (``name``, ``flag``, ``type``, ``required``, ``summary``,
    ``description``, ``constraint``).
    """
    entry = {}
    value = raw.strip()

    if value.startswith('{') and '}' in value:
        head, _sep, tail = value.partition('}')
        entry['type'] = head[1:].strip()
        value = tail.strip()

    if value.startswith('[') and ']' in value:
        head, _sep, tail = value.partition(']')
        parts = [p.strip() for p in head[1:].split('|') if p.strip()]
        if len(parts) == 1 and parts[0].startswith('-'):
            entry['flag'] = parts[0]
        elif len(parts) == 1:
            entry['name'] = parts[0]
        elif len(parts) > 1:
            entry['flag'] = parts[0]
            entry['name'] = parts[-1]
        value = tail.strip()

    if value.startswith('<') and '>' in value:
        head, _sep, tail = value.partition('>')
        marker = head[1:].strip().lower()
        if marker in ('optional', 'required'):
            entry['required'] = marker == 'required'
        value = tail.strip()

    first, _sep, rest = value.partition(' ')
    rest = rest.strip()
    if entry.get('name') is None and entry.get('flag') is None:
        # Legacy spelling: NAME [constraint]
        if not first:
            return entry
        entry['name'] = first
        if rest.startswith('/'):
            entry['constraint'] = _decode_constraint(rest)
            return entry
        value = rest
    elif first.startswith('/'):
        entry['constraint'] = _decode_constraint(first)
        value = rest

    value = value.strip()
    if value:
        if ' - ' in value:
            summary, _sep, description = value.partition(' - ')
            entry['summary'] = summary.strip()
            entry['description'] = description.strip()
        else:
            entry['description'] = value

    return entry


def _format_entry_tag(array_key, entry):
    """Render a ``parameters``/``options``/``flags`` entry as a classic tag.

    Legacy parameter entries (``name`` and optional ``constraint`` only)
    keep the ``@parameter: NAME /regex/`` spelling; richer entries use the
    ``@parameter``/``@option``/``@flag`` rich grammar.
    """
    legacy = set(entry) <= {'name', 'constraint'}
    if array_key == 'parameters' and legacy:
        name = entry.get('name', '')
        constraint = entry.get('constraint')
        if constraint is not None:
            escaped = json.dumps(constraint)[1:-1]
            return '## @parameter: %s %s' % (name, escaped)
        return '## @parameter: %s' % name

    kind = 'parameter' if array_key == 'parameters' else array_key.rstrip('s')
    tag = '@%s' % kind
    if entry.get('type') is not None:
        tag += ' {%s}' % entry['type']
    name = entry.get('name')
    flag = entry.get('flag')
    if name is not None and flag is not None:
        tag += ' [%s|%s]' % (flag, name)
    elif flag is not None:
        tag += ' [%s]' % flag
    elif name is not None:
        tag += ' [%s]' % name
    if entry.get('required') is True:
        tag += ' <required>'
    elif entry.get('required') is False:
        tag += ' <optional>'
    if entry.get('constraint') is not None:
        tag += ' %s' % json.dumps(entry['constraint'])[1:-1]
    summary = entry.get('summary')
    description = entry.get('description')
    if summary is not None and description is not None:
        tag += ' %s - %s' % (summary, description)
    elif summary is not None:
        tag += ' %s' % summary
    elif description is not None:
        tag += ' %s' % description
    return '## %s' % tag


def _extract_json_block(lines, start_idx):
    """Extract JSON text from a ``## {`` ... ``## }`` block.

    Tracks brace nesting so inner ``{`` / ``}`` (from parameter objects) don't
    prematurely close the block.

    Returns ``(json_str, end_idx)`` where ``end_idx`` is the line index of the
    closing ``## }``, or ``(None, start_idx)`` if no closing brace is found.
    """
    json_lines = []
    depth = 0
    idx = start_idx
    while idx < len(lines):
        line = lines[idx]
        if not line.startswith('##'):
            return None, start_idx
        stripped = line[2:].strip()
        json_lines.append(stripped)

        for ch in stripped:
            if ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1

        if depth == 0:
            return '\n'.join(json_lines), idx
        idx += 1
    return None, start_idx


def _convert_shoedoc_json(json_str):
    """Convert a JSON shoedoc string to a list of ``##``-prefixed classic lines.

    Returns ``None`` if the JSON is invalid.
    """
    try:
        data = json.loads(json_str)
    except json.JSONDecodeError:
        return None

    out = []

    if 'summary' in data:
        out.append('## %s' % data['summary'])
    if 'description' in data:
        if 'summary' in data:
            out.append('##')
        for line in data['description'].split('\n'):
            out.append('## %s' % line)
    if 'summary' in data or 'description' in data:
        out.append('##')

    for key in _ORDERED_KEYS:
        if key in _ARRAY_KEYS:
            if key in data:
                out.append('## @%s: %s' % (key, ', '.join(data[key])))
        elif key in ('parameters', 'options', 'flags'):
            for entry in data.get(key, []):
                out.append(_format_entry_tag(key, entry))
        elif key in data and key != 'summary':
            out.append('## @%s: %s' % (key, data[key]))

    return out


def _is_shoedoc_line(line):
    """Return True when ``line`` looks like a ``##`` shoedoc line.

    Only bare ``##`` and ``## `` prefixed lines count, so plain ``#``
    comments and ``###`` banners neither join nor break blocks.
    """
    if not line.startswith('##'):
        return False
    return len(line) == 2 or line[2] in (' ', '\t')


def _is_json_block_start(line):
    """Return True when ``line`` opens a JSON shoedoc block (``## {``)."""
    return _is_shoedoc_line(line) and line[2:].strip() == '{'


def _decode_constraint(raw):
    """Decode a classic ``@parameter`` constraint back to its original text.

    Constraints written by ``--tags`` are JSON-escaped bodies (see
    ``_convert_shoedoc_json``); re-parsing the quoted body undoes that.
    Raw hand-written constraints are returned unchanged when the decode
    fails.
    """
    try:
        return json.loads('"%s"' % raw)
    except ValueError:
        return raw


def _convert_shoedoc_tags(chunk_lines, base_idx):
    """Convert a classic @-tagged shoedoc chunk to a JSON-style block.

    ``chunk_lines`` is a maximal run of consecutive ``##`` shoedoc lines
    starting at ``base_idx`` (0-based; line numbers reported to the user
    are 1-based).

    Recognized tags: ``@namespace``, ``@summary``, ``@requires``,
    ``@depends``, ``@assumes``, ``@author``, ``@copyright``, ``@version``,
    ``@license``, ``@link``, ``@update``, ``@arguments``, ``@return``,
    ``@stdout``, ``@stderr``, ``@stdin``, ``@parameter``/``@param``,
    ``@option`` and ``@flag``. Lines before the first empty ``##``
    line build the summary; lines between the first empty ``##`` line and
    the first tag build the multi-line description. The chunk is converted
    only when it holds at least one recognized tag; otherwise None is
    returned so ordinary ``##`` comment sections are left untouched.
    Unknown tags and non-tag lines after the first tag are warned about
    and dropped when conversion happens.

    Returns a list of ``##``-prefixed JSON lines, or None when the chunk
    holds no convertible content.
    """
    data = {}
    entries = {'parameters': [], 'options': [], 'flags': []}
    summary_parts = []
    description_parts = []
    warnings = []
    seen_tag = False
    seen_separator = False

    for offset, line in enumerate(chunk_lines):
        lineno = base_idx + offset + 1
        body = line[2:].strip()
        if not body:
            if not seen_tag:
                seen_separator = True
            continue
        match = _TAG_RE.match(body)
        if match is None:
            if seen_tag:
                warnings.append(
                    'warning: non-tag comment ignored at line %d\n' % lineno
                )
            elif seen_separator:
                description_parts.append(body)
            else:
                summary_parts.append(body)
            continue
        seen_tag = True
        tag = match.group(1)
        value = match.group(2).strip()
        if tag in ('param', 'parameter', 'option', 'flag'):
            array_key = 'parameters' if tag in ('param', 'parameter') \
                else '%ss' % tag
            if not value:
                warnings.append(
                    'warning: empty @%s ignored at line %d\n' % (tag, lineno)
                )
                continue
            entry = _parse_entry_value(value)
            if 'name' not in entry and 'flag' not in entry:
                warnings.append(
                    'warning: empty @%s ignored at line %d\n' % (tag, lineno)
                )
                continue
            entries[array_key].append(entry)
        elif tag in _ARRAY_KEYS:
            data[tag] = [v.strip() for v in value.split(',') if v.strip()]
        elif tag in _STRING_KEYS:
            data[tag] = value
        else:
            warnings.append(
                'warning: unknown tag "@%s" ignored at line %d\n'
                % (tag, lineno)
            )

    if not data and not any(entries.values()):
        return None

    for warning in warnings:
        sys.stderr.write(warning)

    if summary_parts:
        if 'summary' not in data:
            data['summary'] = ' '.join(summary_parts)
    if description_parts:
        data['description'] = '\n'.join(description_parts)

    ordered = {}
    for key in _ORDERED_KEYS:
        if key in entries:
            if entries[key]:
                ordered[key] = entries[key]
        elif key in data:
            ordered[key] = data[key]

    if not ordered:
        return None
    json_str = json.dumps(ordered, indent=2)
    return ['## ' + line for line in json_str.split('\n')]


def _collect_files(path):
    """Expand ``path`` into a list of shell script files to process.

    - Regular file: returned as-is (regardless of extension; explicit paths
      are honored so callers can target non-``.sh`` files when needed).
    - Directory: returns every ``*.sh`` file in the tree, recursively.
      Symlinked directories are not followed. Errors listing a directory are
      reported to stderr and treated as an empty result.
    - Anything else: an error is logged to stderr and ``[]`` is returned.
    """
    if os.path.isfile(path):
        return [path]

    if os.path.isdir(path):
        matches = []
        for root, _dirs, files in os.walk(path):
            for name in files:
                if name.endswith('.sh'):
                    matches.append(os.path.join(root, name))
        return matches

    sys.stderr.write('error: not a file or directory: %s\n' % path)
    return []


def convert_content(content, direction):
    """Convert all shoedoc blocks in ``content``.

    ``direction`` selects the conversion to perform: ``'tags'`` converts
    JSON blocks into classic @-tags, ``'json'`` converts classic @-tagged
    blocks into JSON blocks.

    Returns ``(new_content, num_converted, had_error)``.
    """
    lines = content.split('\n')
    output = []
    i = 0
    num_converted = 0
    had_error = False

    while i < len(lines):
        line = lines[i]

        if direction == 'tags' \
                and line.startswith('##') and line[2:].strip() == '{':
            json_str, end_idx = _extract_json_block(lines, i)

            if json_str is None:
                output.append(line)
                i += 1
                continue

            classic_lines = _convert_shoedoc_json(json_str)
            if classic_lines is None:
                sys.stderr.write(
                    'error: invalid JSON in shoedoc block at line %d\n'
                    % (i + 1)
                )
                had_error = True
                for j in range(i, end_idx + 1):
                    output.append(lines[j])
            else:
                output.extend(classic_lines)
                num_converted += 1

            i = end_idx + 1
        elif direction == 'json' and _is_shoedoc_line(line):
            end = i
            while end < len(lines) and _is_shoedoc_line(lines[end]):
                end += 1
            chunk = lines[i:end]

            if any(_is_json_block_start(item) for item in chunk):
                output.extend(chunk)
            else:
                json_lines = _convert_shoedoc_tags(chunk, i)
                if json_lines is None:
                    output.extend(chunk)
                else:
                    output.extend(json_lines)
                    num_converted += 1
            i = end
        else:
            output.append(line)
            i += 1

    return '\n'.join(output), num_converted, had_error


def main():
    parser = argparse.ArgumentParser(
        description=(
            'Convert shoedoc annotations between JSON and classic'
            ' @-tagged formats.'
        )
    )
    parser.add_argument('files', nargs='+', metavar='PATH',
                        help='Shell script files or directories to convert')
    group = parser.add_mutually_exclusive_group()
    group.add_argument('--tags', action='store_true',
                       help='Convert JSON shoedoc blocks to classic @-tags')
    group.add_argument('--json', action='store_true', default=True,
                       help='Convert classic @-tags to JSON blocks (default)')
    parser.add_argument('--dry-run', action='store_true',
                        help='Print converted content to stdout instead of overwriting files')
    args = parser.parse_args()
    direction = 'tags' if args.tags else 'json'

    exit_code = 0

    expanded = []
    seen = set()
    for raw in args.files:
        if not os.path.exists(raw):
            exit_code = 1
        for path in _collect_files(raw):
            if path in seen:
                continue
            seen.add(path)
            expanded.append(path)

    for file_path in expanded:
        try:
            with open(file_path, 'r') as f:
                content = f.read()
        except IOError as e:
            sys.stderr.write('error: cannot read %s: %s\n' % (file_path, e))
            exit_code = 1
            continue

        new_content, num_converted, had_error = convert_content(
            content, direction
        )

        if had_error:
            exit_code = 1

        if num_converted == 0:
            continue

        if args.dry_run:
            sys.stdout.write('==> %s <==\n' % file_path)
            sys.stdout.write(new_content)
            if not new_content.endswith('\n'):
                sys.stdout.write('\n')
        else:
            if new_content != content:
                with open(file_path, 'w') as f:
                    f.write(new_content)
            sys.stderr.write('Converted: %s (%d block(s))\n' % (file_path, num_converted))

    sys.exit(exit_code)


if __name__ == '__main__':
    main()
