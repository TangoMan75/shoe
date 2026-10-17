# Shoedoc Vocabulary

Shoedoc is the documentation system used by TangoMan Shoe framework to describe shell scripts and their functions. Inspired by [Javadoc](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javadoc.html), [JSDoc](https://jsdoc.app) and [PHPDoc](https://docs.phpdoc.org/guide/references/phpdoc/index.html), this metadata can be used to auto-generate documentation, validation, and unit tests.

This document lists every tag the framework currently understands, what it is for, where it belongs, and how to write it.

## Table of contents

- [Shoedoc at a glance](#shoedoc-at-a-glance)
- [Top-level tags](#top-level-tags)
- [Parameter object fields](#parameter-object-fields)
- [Recognized `type` values](#recognized-type-values)
- [Where each tag goes](#where-each-tag-goes)
- [Format conversion](#format-conversion)

---

## Shoedoc at a glance

A Shoedoc block is a run of consecutive `##` comment lines placed directly above a script, a function, or a variable. It opens with a title (a one-line summary), optionally followed by a blank `##` line and a longer description, then the metadata tags, one per line.

The same metadata can be written in two interchangeable formats: the classic `@`-prefixed form and the JSON form. The classic form is one tag per line and easy to hand-write; the JSON form carries the same data as a single object and describes parameters, options and flags more precisely. Both are shown below on the same `hello` function.

### Classic format

Each tag sits on its own line as `@tag: value`, with the colon optional. The tags below describe the argument, option and flag that the function body parses with `getopt`.

```bash
## Hello World!
##
## Greets a specified user a given number of times.
## Accepts an optional recipient name and an optional repetition count.
## Useful as a smoke test for new installations.
##
## @author    "Matthias Morin" <mat@tangoman.io> https://tangoman.io
## @version   1.0.0
## @license   MIT
## @link      https://github.com/TangoMan75/shoe
##
## @shell     bash
## @namespace recipes/shoe
## @requires  getopt echo
## @param     {str} [who] /^[a-zA-Z-]+$/ The recipient's name.
## @option    {int} [-c|--count]        The repetition count.
## @flag      [-p|--prefix]             Prefix output with a line number.
hello() {
    local who
    local count=1
    local prefix=0

    local options
    if ! options=$(getopt -o c:p --long count:,prefix -- "$@"); then
        echo "Usage: hello [who] [-c|--count number] [-p|--prefix]" >&2
        return 1
    fi

    eval set -- "$options"

    while true; do
        case "$1" in
            -c | --count)
                count="$2"
                shift 2
                ;;
            -p | --prefix)
                prefix=1
                shift 1
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Internal error during option parsing." >&2
                return 1
                ;;
        esac
    done

    who="${1:-World}"

    local loop=0
    while [ "${loop}" -lt "${count}" ]; do
        if [ "${prefix}" -eq 1 ]; then
            echo "$((loop + 1)): Hello, ${who} !"
        else
            echo "Hello, ${who} !"
        fi
        loop=$((loop+1))
    done
}
```

### JSON format

A single JSON object between `## {` and `## }` markers. It holds the same metadata, but structures it: parameters, options and flags become arrays of objects, so each entry carries its own type, constraint, default, and so on. The block below is the exact JSON counterpart of the classic block above.

```bash
## {
##   "authors": [
##     {
##       "name": "Matthias Morin",
##       "email": "mat@tangoman.io",
##       "homepage": "https://tangoman.io"
##     }
##   ],
##   "version": "1.0.0",
##   "license": "MIT",
##   "link": "https://github.com/TangoMan75/shoe",
##   "shell": "bash",
##   "namespace": "recipes/shoe",
##   "summary": "Hello World!",
##   "description": "Greets a specified user a given number of times.\nAccepts an optional recipient name and an optional repetition count.\nUseful as a smoke test for new installations.",
##   "requires": [
##     "echo",
##     "getopt"
##   ],
##   "parameters": [
##     {
##       "name": "who",
##       "type": "str",
##       "constraint": "/^[a-zA-Z-]+$/",
##       "description": "The recipient's name."
##     }
##   ],
##   "options": [
##     {
##       "name": "count",
##       "type": "int",
##       "description": "The repetition count."
##     }
##   ],
##   "flags": [
##     {
##       "name": "prefix",
##       "description": "Prefix output with a line number."
##     }
##   ]
## }
```

Both formats are valid Shoedoc. Use the classic form for script-level metadata (author, version, license, link, update), and the JSON form when a function takes parameters, options or flags, since it documents each entry on its own.

---

## Top-level tags

Tags listed here can appear at the script level (above the shebang area or near the top of the file) or at the function level (immediately above the function declaration). Some tags only make sense at one of the two locations.

### `@author`

Identifies the author of the script or function.

```bash
## @author  "Matthias Morin" <mat@tangoman.io> https://tangoman.io
```

The value follows the convention `"Display Name" <email@example.com> [homepage]`. The quoted name, angle-bracketed email pattern and the trailing homepage URL are optional, although at least one value must be present for this to make sense.

In JSON form the tag maps to the `authors` array, one object per author, carrying the `name`, `email` and `homepage` fields:

```json
{
  "authors": [
    {
      "name": "Matthias Morin",
      "email": "mat@tangoman.io",
      "homepage": "https://tangoman.io"
    }
  ]
}
```

### `@version`

Version string of the script. Recommended to follow [Semantic Versioning](https://semver.org/), eg `0.1.0` (major.minor.patch).

```bash
## @version 0.1.0
```

### `@license`

SPDX license identifier or short license name, eg `MIT`, `GPLv3`. Used in generated headers.

```bash
## @license MIT
```

### `@link`

Canonical URL pointing to the project, the documentation, or the source
repository.

```bash
## @link    https://github.com/TangoMan75/shoe
```

### `@copyright`

Identifies the copyright holder of the script or function. Same value convention as `@author`.

```bash
## @copyright  "Matthias Morin" <mat@tangoman.io>
```

### `@update`

Raw URL pointing to the latest version of the script.

```bash
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh
```

### `@shell`

Declares the interpreter the script is meant to run under. Only two values are accepted: `bash` and `sh`.

```bash
## @shell bash
```

In JSON form the tag maps to the `"shell"` property:

```json
{
  "shell": "bash"
}
```

### `@namespace`

Logical grouping for related functions. Used to filter or colourise the generated documentation. At the function level it tells the documentation generator which chapter the function belongs to.

```bash
## {
##   "namespace": "shoedoc"
## }
```

### `@summary`

One-line summary describing the purpose of the function. Rendered as the function title in the generated markdown.

```bash
## @summary: Return given tag values from shoedoc annotation
```

### `@requires`

Array of external commands the function calls. The documentation generator emits these in the "Requires" section of the function entry. Listing them helps reviewers spot when a function adds a new runtime dependency.

Entries are either space-separated on a single line or listed one per line; a comma is not a separator. Both spellings below yield the same two entries.

```bash
## @requires: getopt echo
```

```bash
## @requires: getopt
## @requires: echo
```

Or in JSON form:

```bash
## {
##   "requires": ["echo", "getopt"]
## }
```

### `@depends`

Array of other functions this function calls. Used by the documentation generator to build the "Depends" graph and by callers who want to know what to import.

```bash
## @depends: _echo_error
```

Or:

```bash
## {
##   "depends": ["_echo_error"]
## }
```

### `@assumes`

Array of environment variables or constants the function expects to be defined. Distinct from `depends` because those are other functions, not data.

```bash
## {
##   "assumes": ["LBOUND"]
## }
```

### `@param`

Documents a single function parameter in the classic form. Two spellings are accepted.

The rich spelling follows this grammar, where `{type}`, `[alias|--name]`, `<optional|required>` and the ` - ` separator are each optional:

```bash
## @param  {type} [name]       <optional|required> /constraint/ (default) Parameter summary - Parameter long description
## @option {type} [short|long] <optional|required> /constraint/ (default) Option summary    - Option long description
## @flag          [short|long] <optional|required>                        Flag summary      - Flag long description
```

A separate `{type}` (see [Recognized `type` values](#recognized-type-values)) declares the expected data type. The bracketed token holds the shorthand alias and the long name, separated by a pipe: `[-p|--param]` makes the value available as `-p` and `--param`. A single bracketed token is treated as a shorthand when it starts with a dash (`[-f]`), as a name otherwise. `<optional|required>` states whether the parameter may be omitted. The summary and the long description are separated by ` - `, so a short one-liner can grow into a paragraph. In JSON form this becomes the matching `summary` and `description` fields.

For example:

```bash
## @param {str} [who] <optional> Greeting recipient - The recipient's name.
## @option {int} [-o|--count] <required> Repetition count - How many times to greet.
## @flag   [-f|--force] <optional> Force - Overwrite without asking.
```

The legacy spelling is still accepted: the parameter name followed by an optional constraint regex, with `@param` accepted as a synonym of `@param` (it is used in the `_get_shoedoc_tag` test fixtures).

```bash
## @param IP /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
## @param    WHO
```

### `@option`

Documents a named option that expects a value (`--name` or its `-a` alias). Shares the rich grammar with `@param`, see above, but marks the parameter as passed by name rather than positionally.

```bash
## @option {file} [-i|--input] <required> Input file - Path to the input file.
```

### `@flag`

Documents a boolean switch (`--name` or its `-f` alias). Shares the rich grammar with `@param`, see above, minus the `{type}` field since a flag carries no value; at runtime it sets its variable to `"true"` or `"false"`.

```bash
## @flag [-f|--force] <optional> Force - Overwrite without asking.
```

### `@stdout`

Documents what is dumped to stdout by this function.

```bash
## @stdout: the greeting lines
```

### `@stderr`

Documents what is dumped to stderr by this function.

```bash
## @stderr: error messages and diagnostics
```

### `@stdin`

Documents what is expected from stdin by this function.

```bash
## @stdin: nothing expected
```

---

## Parameter object fields

When the function metadata is written in JSON form, each entry in the `parameters` array (and likewise in the `options` and `flags` arrays, see below) is an object with the following fields.

### `summary`

Short one-line description of the parameter, rendered before the long description in the classic form. Initializes the summary part of the `@param`/`@option`/`@flag` value, before the ` - ` separator.

```json
{
  "summary": "Greeting recipient"
}
```

### `required`

Boolean indicating whether the parameter is mandatory (`true`) or optional (`false`). Maps to the `<required|optional>` marker in the classic form. Distinct from `nullable`, which is about empty values.

```json
{
  "required": true
}
```

### `position`

1-based index of the positional argument. Counts from the left of the parameter list as the shell sees it.

```json
{
  "position": 1,
  "name": "SCRIPT_PATH"
}
```

For optional parameters, the position is still the slot the argument occupies when present, even if the parameter has a default.

### `name`

The parameter name. By TangoMan Shoe convention, parameter names written in uppercase indicate values that will be treated as positional parameters inside the function body (`set -- "$1" "$2" "$3"`).

```json
{
  "name": "DESTINATION"
}
```

### `type`

Expected data type. Constrains how the caller should pass the value and how the documentation generator describes it. See [Recognized `type` values](#recognized-type-values) for the list.

```json
{
  "type": "file"
}
```

### `description`

Human-readable explanation of what the parameter is for. Rendered in the generated documentation under the parameter name.

```json
{
  "description": "The path to the input script."
}
```

### `default`

Default value used when the caller does not pass the argument. When the parameter is optional, this field is what the parameter falls back to.

```json
{
  "default": "World"
}
```

### `nullable`

Boolean indicating whether the parameter is allowed to be empty. The runtime uses this when generating input validation. If `false`, an empty value is treated as a missing mandatory argument.

```json
{
  "nullable": false
}
```

### `flag`

CLI shortcut letter that maps to the parameter. Used by Shoe's command-line parser to wire short options like `-c` to long options like `--count`.

```json
{
  "flag": "-c"
}
```

### `constraint`

Regular expression the parameter value must match. Used in the classic form together with `@param` to validate input at the boundary.

```bash
## @param IP /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
```

In JSON form, the constraint is carried as part of the parameter object during conversion. See `shoedoc_converter.py` for the canonical handling.

---

## Options and flags arrays

When function metadata is written in JSON form, the `parameters` array holds positional parameters. The `options` and `flags` arrays carry the entries parsed from the classic `@option` and `@flag` tags, using the exact same object shape as [Parameter object fields](#parameter-object-fields), minus the `position` field: options and flags are addressed by name, not by position.

```json
{
  "options": [
    {
      "type": "file",
      "flag": "-i",
      "name": "in",
      "required": true,
      "summary": "Input file",
      "description": "Path to the input file."
    }
  ],
  "flags": [
    {
      "flag": "-f",
      "name": "force",
      "required": false,
      "summary": "Force",
      "description": "Overwrite without asking."
    }
  ]
}
```

---

## Recognized `type` values

The `type` field is a string. The framework recognises the following values,
all observed in real recipes:

- `str`: A free-form string. The default for anything textual.
- `int`: An integer count or numeric value.
- `bool`: A boolean flag, rendered as `"true"` or `"false"` per the Shoe boolean convention.
- `url`:
- `regex`:
- `path`:
- `file`: A path to a file. The caller is expected to pass a real file.
- `folder`: A path to a directory. The caller is expected to pass a real folder.
- `json`: A JSON document, passed as a string and parsed at use site.

Any other value is treated as an opaque string. Type is documentation-first, it is not enforced by the runtime.

---

## Where each tag goes

|     Tag      | Script header | Function | Variable |
|--------------|---------------|----------|----------|
| `@author`    | yes           | yes      | no       |
| `@copyright` | yes           | yes      | no       |
| `@version`   | yes           | yes      | no       |
| `@license`   | yes           | no       | no       |
| `@link`      | yes           | yes      | no       |
| `@update`    | yes           | no       | no       |
| `@shell`     | yes           | yes      | no       |
| `@namespace` | no            | yes      | no       |
| `@summary`   | yes           | yes      | no       |
| `@requires`  | no            | yes      | no       |
| `@depends`   | no            | yes      | no       |
| `@assumes`   | no            | yes      | no       |
| `@param` | no            | yes      | no       |
| `@param`     | no            | yes      | no       |
| `@option`    | no            | yes      | no       |
| `@flag`      | no            | yes      | no       |
| `@stdout`    | yes           | yes      | no       |
| `@stderr`    | yes           | yes      | no       |
| `@stdin`     | yes           | yes      | no       |
| `@return`    | no            | yes      | no       |
| `@type`      | no            | no       | yes      |

Variables (constants, options, flags) get a single `## ` line as their description, not a full Shoedoc block.

```bash
## Greeting recipient name /^[a-zA-Z-]+$/
who="World"
```

The trailing `/regex/` after the description is the variable-level constraint analogue of the `constraint` field on function parameters.

---

## Format conversion

`shoedoc_converter.py` converts Shoedoc blocks between the JSON form and the classic `@`-prefixed form, in place, across one or more files. The default direction is classic to JSON; pass `--tags` for the reverse.

```sh
python3 shoedoc_converter.py path/to/script.sh
python3 shoedoc_converter.py --dry-run --recursive recipes/
python3 shoedoc_converter.py --tags path/to/script.sh
```

The converter handles the following JSON keys, in each direction:
- `namespace`
- `summary`
- `description`
- `author`
- `copyright`
- `version`
- `license`
- `link`
- `update`
- `return`
- `stdout`
- `stderr`
- `stdin`
- `requires`
- `depends`
- `assumes`
- `parameters`
- `options`
- `flags`

Entry objects handle the fields:
- `position`
- `name`
- `flag`
- `type`
- `required`
- `summary`
- `description`
- `default`
- `nullable`
- `constraint`

legacy entries carrying only `name` (and optionally `constraint`) render as the classic `@param: NAME /regex/` line, richer entries render as `@param`/`@option`/`@flag` rich lines.
Anything else is left untouched. The classic form is the canonical form, the JSON form is the human-editable source.
