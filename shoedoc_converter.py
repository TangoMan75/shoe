#!/usr/bin/env python3
"""Convert JSON-style shoedoc annotations to classic @-tagged format.

Converts function annotation blocks like:

    ## Summary line
    ##
    ## {
    ##   "namespace": "android",
    ##   "requires": ["adb"],
    ##   "parameters": [
    ##     {
    ##       "name": "IP",
    ##       "constraint": "/^([0-9]{1,3}\\\\.){3}[0-9]{1,3}$/"
    ##     }
    ##   ]
    ## }

Into:

    ## Summary line
    ##
    ## @namespace: android
    ## @requires: adb
    ## @parameter: IP /^([0-9]{1,3}\\\\.){3}[0-9]{1,3}$/

Usage:
    python3 shoedoc_converter.py [--dry-run] [-r] PATH...

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
import sys


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

    if 'namespace' in data:
        out.append('## @namespace: %s' % data['namespace'])
    if 'summary' in data:
        out.append('## @summary: %s' % data['summary'])
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


def convert_content(content):
    """Convert all JSON shoedoc blocks in ``content``.

    Returns ``(new_content, num_converted, had_error)``.
    """
    lines = content.split('\n')
    output = []
    i = 0
    num_converted = 0
    had_error = False

    while i < len(lines):
        line = lines[i]

        if line.startswith('##') and line[2:].strip() == '{':
            json_str, end_idx = _extract_json_block(lines, i)

            if json_str is None:
                output.append(line)
                i += 1
                continue

            classic_lines = _convert_shoedoc_json(json_str)
            if classic_lines is None:
                sys.stderr.write(
                    'error: invalid JSON in shoedoc block at line %d\n' % (i + 1)
                )
                had_error = True
                for j in range(i, end_idx + 1):
                    output.append(lines[j])
            else:
                output.extend(classic_lines)
                num_converted += 1

            i = end_idx + 1
        else:
            output.append(line)
            i += 1

    return '\n'.join(output), num_converted, had_error


def main():
    parser = argparse.ArgumentParser(
        description='Convert JSON-style shoedoc annotations to classic @-tagged format.'
    )
    parser.add_argument('files', nargs='+', metavar='PATH',
                        help='Shell script files or directories to convert')
    parser.add_argument('--dry-run', action='store_true',
                        help='Print converted content to stdout instead of overwriting files')
    parser.add_argument('--recursive', '-r', action='store_true',
                        help='Recurse into subdirectories when a folder is given')
    args = parser.parse_args()

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

        new_content, num_converted, had_error = convert_content(content)

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
