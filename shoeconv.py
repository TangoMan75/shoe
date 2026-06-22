#!/usr/bin/env python3
"""Convert Shoedoc annotations read from stdin into JSON on stdout."""

import argparse
import json
import re
import sys

TAG_RE = re.compile(r"^@([A-Za-z][A-Za-z0-9_]*):?\s*(.*)$")
AUTHOR_RE = re.compile(
    r'^\s*(?:"(?P<quoted>[^"]*)"|(?P<bare>[^<]*?))?\s*'
    r"(?:<(?P<email>[^>]*)>)?\s*(?P<homepage>https?://\S+)?\s*$"
)

ENTRY_ARRAYS = ("constants", "variables", "params", "options", "flags")
ORDERED_KEYS = (
    "name", "namespace", "summary", "description", "authors", "copyright",
    "version", "license", "links", "update", "shell", "requires", "depends",
    "assumes", "private", "type", "deprecated", "examples", "stdout",
    "stderr", "stdin", "constants", "variables", "params", "options",
    "flags",
)


def is_shoedoc_line(line):
    """Return True for a bare "##" line or a "## " tagged comment line."""
    return line.startswith("##") and (
        len(line) == 2 or line[2] in (" ", "\t")
    )


def strip_prefix(line):
    """Remove the leading "##" marker and one optional following space."""
    if line.startswith("## "):
        return line[3:]
    if line.startswith("##"):
        return line[2:]
    return line


def annotation_runs(text):
    """Split the input into maximal runs of consecutive "##" lines."""
    runs = []
    current = []
    for line in text.splitlines():
        if is_shoedoc_line(line):
            current.append(line)
        elif current:
            runs.append(current)
            current = []
    if current:
        runs.append(current)
    return runs


def json_envelopes(lines):
    """Return every JSON object found in the annotation lines."""
    text = "\n".join(strip_prefix(line) for line in lines)
    decoder = json.JSONDecoder()
    objects = []
    position = 0
    while True:
        start = text.find("{", position)
        if start < 0:
            break
        try:
            value, position = decoder.raw_decode(text, start)
        except ValueError:
            position = start + 1
            continue
        if isinstance(value, dict):
            objects.append(value)
        else:
            position = start + 1
    return objects


def parse_default(text):
    try:
        return json.loads(text.strip())
    except ValueError:
        return text.strip()


def parse_author(value):
    match = AUTHOR_RE.match(value)
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
    return author or {"name": value.strip()}


def parse_entry(value):
    """Parse the rich "@param"/"@option"/"@flag"/"@constant" grammar."""
    entry = {}
    value = value.strip()
    if value.startswith("{") and "}" in value:
        head, _separator, value = value.partition("}")
        entry["type"] = head[1:].strip()
        value = value.strip()
    if value.startswith("<") and ">" in value:
        head, _separator, value = value.partition(">")
        entry["name"] = head[1:].strip()
        value = value.strip()
    if value.startswith("[") and "]" in value:
        head, _separator, value = value.partition("]")
        aliases = [item.strip() for item in head[1:].split("|") if item.strip()]
        if len(aliases) >= 2:
            entry["short"] = aliases[0].lstrip("-")
            entry["long"] = aliases[1].lstrip("-")
        elif aliases:
            alias = aliases[0]
            if alias.startswith("--"):
                entry["long"] = alias[2:]
            elif alias.startswith("-"):
                entry["short"] = alias[1:]
            else:
                entry["long"] = alias
        value = value.strip()
    first, _separator, rest = value.partition(" ")
    if first.startswith("/"):
        try:
            entry["constraint"] = json.loads('"%s"' % first)
        except ValueError:
            entry["constraint"] = first
        value = rest.strip()
    if value.startswith("(") and ")" in value:
        head, _separator, value = value.partition(")")
        marker = head[1:].strip()
        if marker == "required":
            entry["required"] = True
        elif marker == "optional":
            entry["required"] = False
        elif marker.startswith("default:"):
            entry["default"] = parse_default(marker[len("default:"):])
        value = value.strip()
    if value:
        if " - " in value:
            summary, _separator, description = value.partition(" - ")
            entry["summary"] = summary.strip()
            entry["description"] = description.strip()
        else:
            entry["description"] = value
    return entry


def parse_classic(lines):
    """Convert a classic @-tagged Shoedoc run into a JSON object."""
    data = {}
    entries = {key: [] for key in ENTRY_ARRAYS}
    summary = []
    description = []
    seen_tag = False
    seen_blank = False

    for line in lines:
        body = strip_prefix(line).strip()
        if not body:
            if not seen_tag:
                seen_blank = True
            continue
        match = TAG_RE.match(body)
        if match is None:
            if seen_tag:
                continue
            (description if seen_blank else summary).append(body)
            continue

        seen_tag = True
        tag = match.group(1)
        value = match.group(2).strip()
        if tag in ("param", "option", "flag", "constant", "variable"):
            key = {
                "param": "params",
                "variable": "variables",
            }.get(tag, tag + "s")
            entry = parse_entry(value)
            if entry and ("name" in entry or key in ("constants", "variables")):
                entries[key].append(entry)
        elif tag == "author":
            data.setdefault("authors", []).append(parse_author(value))
        elif tag == "link":
            data.setdefault("links", []).append(value)
        elif tag == "example":
            data.setdefault("examples", []).append(value)
        elif tag == "private":
            data["private"] = True
        elif tag == "public":
            data["private"] = False
        elif tag == "type":
            data["type"] = value.strip("{}").strip()
        elif tag in ("requires", "depends", "assumes"):
            data.setdefault(tag, []).extend(value.split())
        elif tag in (
            "namespace", "summary", "description", "copyright", "version",
            "license", "update", "shell", "deprecated", "stdout", "stderr",
            "stdin",
        ):
            data[tag] = value

    for index, entry in enumerate(entries["params"]):
        entry.setdefault("position", index + 1)
    if summary and "summary" not in data:
        data["summary"] = " ".join(summary)
    if description and "description" not in data:
        data["description"] = "\n".join(description)

    result = {}
    for key in ORDERED_KEYS:
        if key in entries:
            if entries[key]:
                result[key] = entries[key]
        elif key in data:
            result[key] = data[key]
    return result


def convert(text):
    """Convert the Shoedoc text to a single object or a list of objects."""
    objects = []
    runs = annotation_runs(text)
    if not runs:
        lines = text.splitlines()
        envelopes = json_envelopes(lines)
        if envelopes:
            objects.extend(envelopes)
        elif any(TAG_RE.match(line.strip()) for line in lines):
            parsed = parse_classic(lines)
            if parsed:
                objects.append(parsed)
    for run in runs:
        envelopes = json_envelopes(run)
        if envelopes:
            objects.extend(envelopes)
            continue
        parsed = parse_classic(run)
        if parsed:
            objects.append(parsed)
    if not objects:
        raise ValueError("no Shoedoc annotation found")
    if len(objects) == 1:
        return objects[0]
    return objects


def build_parser():
    parser = argparse.ArgumentParser(
        description="Convert Shoedoc annotations from stdin to JSON.",
    )
    parser.add_argument(
        "--compact", action="store_true",
        help="Print JSON on a single line instead of indenting it.",
    )
    parser.add_argument(
        "--indent", type=int, default=2,
        help="Indentation width for pretty output (default: 2).",
    )
    return parser


def main(argv=None):
    args = build_parser().parse_args(argv)
    try:
        result = convert(sys.stdin.read())
    except ValueError as error:
        print("error: %s" % error, file=sys.stderr)
        return 1
    if args.compact:
        json.dump(result, sys.stdout, ensure_ascii=False, separators=(",", ":"))
    else:
        json.dump(result, sys.stdout, ensure_ascii=False, indent=args.indent)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
