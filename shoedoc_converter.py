#!/usr/bin/env python3
"""Convert shoedoc annotations between JSON and classic @-tagged formats.

Two conversion directions are supported:

- ``--tags``: JSON shoedoc blocks like

      ## {
      ##   "namespace": "android",
      ##   "summary": "Summary line",
      ##   "description": "Long description that can span multiple lines.\nLorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\ntempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,\nquis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.",
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
      ## Long description that can span multiple lines.
      ## Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
      ## tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
      ## quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo.
      ##
      ## @namespace: android
      ## @requires: adb
      ## @parameter: IP /^([0-9]{1,3}\\\\.){3}[0-9]{1,3}$/

- ``--json`` (default): classic @-tagged blocks like the one above are
  converted back into JSON shoedoc blocks. Blocks are located as maximal
  runs of ``##`` shoedoc lines; a run holding at least one recognized tag
  is converted, while runs holding a JSON block start (``## {``) or no
  recognized tag are left untouched. Lines before the first empty ``##``
  line build the summary; lines between the first empty ``##`` line and
  the first tag build the multi-line description. Unknown tags are warned
  about and dropped, mirroring how the ``--tags`` direction drops unknown
  JSON keys.

Both ``## @tag: value`` and ``## @tag value`` (no colon) spellings are
accepted when parsing classic blocks.

Usage:
    python3 shoedoc_converter.py [--tags] [--dry-run] [-r] PATH...

Positional arguments may be files or directories. Directories are expanded
to their top-level ``*.sh`` files; pass ``-r`` / ``--recursive`` to walk
subdirectories. Files and directories may be mixed freely.

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
    if 'namespace' in data:
        out.append('## @namespace: %s' % data['namespace'])
    if 'requires' in data:
        out.append('## @requires: %s' % ', '.join(data['requires']))
    if 'depends' in data:
        out.append('## @depends: %s' % ', '.join(data['depends']))
    if 'assumes' in data:
        out.append('## @assumes: %s' % ', '.join(data['assumes']))

    for param in data.get('parameters', []):
        name = param.get('name', '')
        constraint = param.get('constraint')
        if constraint is not None:
            escaped = json.dumps(constraint)[1:-1]
            out.append('## @parameter: %s %s' % (name, escaped))
        else:
            out.append('## @parameter: %s' % name)

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

    Recognized tags: ``@namespace``, ``@requires``, ``@depends``,
    ``@assumes`` and ``@parameter``. Lines before the first empty ``##``
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
    parameters = []
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
        if tag == 'namespace':
            data['namespace'] = value
        elif tag in ('requires', 'depends', 'assumes'):
            data[tag] = [v.strip() for v in value.split(',') if v.strip()]
        elif tag == 'parameter':
            if not value:
                warnings.append(
                    'warning: empty @parameter ignored at line %d\n' % lineno
                )
                continue
            name, _sep, rest = value.partition(' ')
            param = {'name': name}
            rest = rest.strip()
            if rest:
                param['constraint'] = _decode_constraint(rest)
            parameters.append(param)
        else:
            warnings.append(
                'warning: unknown tag "@%s" ignored at line %d\n'
                % (tag, lineno)
            )

    if not data and not parameters:
        return None

    for warning in warnings:
        sys.stderr.write(warning)

    if summary_parts:
        data['summary'] = ' '.join(summary_parts)
    if description_parts:
        data['description'] = '\n'.join(description_parts)

    ordered = {}
    for key in ('namespace', 'summary', 'description', 'requires', 'depends',
                'assumes'):
        if key in data:
            ordered[key] = data[key]
    if parameters:
        ordered['parameters'] = parameters

    if not ordered:
        return None
    json_str = json.dumps(ordered, indent=2)
    return ['## ' + line for line in json_str.split('\n')]


def _collect_files(path, recursive):
    """Expand ``path`` into a list of shell script files to process.

    - Regular file: returned as-is (regardless of extension; explicit paths
      are honored so callers can target non-``.sh`` files when needed).
    - Directory: returns top-level ``*.sh`` files, or every ``*.sh`` file in
      the tree when ``recursive`` is True. Symlinked directories are not
      followed. Errors listing a directory are reported to stderr and
      treated as an empty result.
    - Anything else: an error is logged to stderr and ``[]`` is returned.
    """
    if os.path.isfile(path):
        return [path]

    if os.path.isdir(path):
        matches = []
        if recursive:
            for root, _dirs, files in os.walk(path):
                for name in files:
                    if name.endswith('.sh'):
                        matches.append(os.path.join(root, name))
            return matches
        try:
            entries = os.listdir(path)
        except OSError as e:
            sys.stderr.write('error: cannot list %s: %s\n' % (path, e))
            return []
        for name in entries:
            full = os.path.join(path, name)
            if name.endswith('.sh') and os.path.isfile(full):
                matches.append(full)
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
    parser.add_argument('--recursive', '-r', action='store_true',
                        help='Recurse into subdirectories when a folder is given')
    args = parser.parse_args()
    direction = 'tags' if args.tags else 'json'

    exit_code = 0

    expanded = []
    seen = set()
    for raw in args.files:
        if not os.path.exists(raw):
            exit_code = 1
        for path in _collect_files(raw, args.recursive):
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
