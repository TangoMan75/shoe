# Shoedoc Vocabulary

Shoedoc is the documentation system used by TangoMan Shoe to describe shell
scripts and their functions. Inspired by JSDoc and PHPDoc DocBlocks, every
shred of metadata that `help`, `generate_doc`, and the recipe templates rely
on is declared with Shoedoc tags.

This document lists every tag the framework currently understands, what it is
for, where it belongs, and how to write it.

## Table of contents

- [Shoedoc at a glance](#shoedoc-at-a-glance)
- [Two formats](#two-formats)
- [Top-level tags](#top-level-tags)
- [Parameter object fields](#parameter-object-fields)
- [Recognized `type` values](#recognized-type-values)
- [Where each tag goes](#where-each-tag-goes)
- [Format conversion](#format-conversion)

---

## Shoedoc at a glance

A Shoedoc block is a series of consecutive comment lines prefixed with two pond
signs (`##`) sitting directly above a script, a function, or a variable.

The first line is the title (a one-line summary of what follows). The next
lines are the description. After the description come the metadata tags, each
on its own line.

```bash
## Greets a specified recipient a given number of times
##
## Accepts an optional recipient name and an optional repetition count.
## Useful as a smoke test for new installations.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 1.0.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
function hello() { ... }
```

The block above is the classic `@`-prefixed form. It is the format that the
runtime parsers actually consume (`_get_shoedoc`, `_get_shoedoc_tag`,
`_get_shoedoc_title`, `_get_shoedoc_description`).

There is also a JSON form that describes the same metadata. It is documented
in `AGENTS.md` under section 11 (Function Annotation) and is the form shown in
the examples there. Both forms can be converted into each other with
`shoedoc_converter.py`.

## Two formats

### Classic format (`@`-prefixed)

Plain `key: value` lines, one tag per line, easy to read and easy to write.

```bash
## Builds the project
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh
```

This is the format used everywhere in the runtime, the generated Makefiles,
and every recipe.

### JSON format

A single JSON object embedded between `## {` and `## }` markers, used for
structured metadata, primarily on functions. It carries richer information
about parameters (type, default, nullable, flag, position).

```bash
## Greets a specified recipient a given number of times
##
## {
##   "namespace": "test",
##   "summary": "Greets a specified user a given number of times.",
##   "requires": ["printf"],
##   "depends": ["_echo_error"],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "WHO",
##       "type": "str",
##       "description": "The recipient's name.",
##       "default": "World",
##       "nullable": false
##     }
##   ]
## }
```

Both forms are valid Shoedoc. The classic form is preferred for script-level
metadata (author, version, license, link, update). The JSON form is preferred
when documenting functions with rich parameter information, because it gives
each parameter its own type, default value, and so on.

---

## Top-level tags

Tags listed here can appear at the script level (above the shebang area or
near the top of the file) or at the function level (immediately above the
function declaration). Some tags only make sense at one of the two locations.

### `@author`

Identifies the author of the script or function. Used by `generate_doc` to
populate the script header banner.

```bash
## @author  "Matthias Morin" <mat@tangoman.io>
```

The value follows the convention `"Display Name" <email@example.com>`. The
quoted name plus angle-bracketed email pattern is enforced by the Makefile
template generator.

### `@version`

Version string of the script. Recommended to follow [Semantic Versioning](https://semver.org/).

```bash
## @version 0.1.0
```

### `@license`

SPDX license identifier or short license name. Used in generated headers.

```bash
## @license MIT
```

### `@link`

Canonical URL pointing to the project, the documentation, or the source
repository.

```bash
## @link    https://github.com/TangoMan75/shoe
```

### `@update`

Raw URL pointing to the latest version of the script. Read at runtime by
`self_update` to fetch a newer copy.

```bash
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh
```

### `@namespace`

Logical grouping for related functions. Used to filter or colourise the
generated documentation. At the function level it tells the documentation
generator which chapter the function belongs to.

```bash
## {
##   "namespace": "shoedoc"
## }
```

### `@summary`

One-line summary describing the purpose of the function. Rendered as the
function title in the generated markdown.

```bash
## @summary: Return given tag values from shoedoc annotation
```

### `@requires`

Array of external commands the function calls. The documentation generator
emits these in the "Requires" section of the function entry. Listing them
helps reviewers spot when a function adds a new runtime dependency.

```bash
## @requires: awk
## @requires: printf
```

Or in JSON form:

```bash
## {
##   "requires": ["awk", "printf"]
## }
```

### `@depends`

Array of other functions this function calls. Used by the documentation
generator to build the "Depends" graph and by callers who want to know what
to import.

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

Array of environment variables or constants the function expects to be
defined. Distinct from `depends` because those are other functions, not data.

```bash
## {
##   "assumes": ["LBOUND"]
## }
```

### `@parameter` / `@param`

Documents a single function parameter in the classic form. The value is the
parameter name followed by an optional constraint regex and an optional
description.

```bash
## @parameter IP /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
## @param    WHO
```

The `@param` spelling is accepted as a synonym and is used in the
`_get_shoedoc_tag` test fixtures.

### `@return`

Documents the value a function returns. Used in the classic form only.

```bash
## @return output The output value
```

---

## Parameter object fields

When the function metadata is written in JSON form, each entry in the
`parameters` array is an object with the following fields.

### `position`

1-based index of the positional argument. Counts from the left of the
parameter list as the shell sees it.

```json
{
  "position": 1,
  "name": "SCRIPT_PATH"
}
```

For optional parameters, the position is still the slot the argument occupies
when present, even if the parameter has a default.

### `name`

The parameter name. By TangoMan Shoe convention, parameter names written in
uppercase indicate values that will be treated as positional parameters inside
the function body (`set -- "$1" "$2" "$3"`).

```json
{
  "name": "DESTINATION"
}
```

### `type`

Expected data type. Constrains how the caller should pass the value and how
the documentation generator describes it. See [Recognized `type` values](#recognized-type-values)
for the list.

```json
{
  "type": "file"
}
```

### `description`

Human-readable explanation of what the parameter is for. Rendered in the
generated documentation under the parameter name.

```json
{
  "description": "The path to the input script."
}
```

### `default`

Default value used when the caller does not pass the argument. When the
parameter is optional, this field is what the parameter falls back to.

```json
{
  "default": "World"
}
```

### `nullable`

Boolean indicating whether the parameter is allowed to be empty. The runtime
uses this when generating input validation. If `false`, an empty value is
treated as a missing mandatory argument.

```json
{
  "nullable": false
}
```

### `flag`

CLI shortcut letter that maps to the parameter. Used by Shoe's command-line
parser to wire short options like `-c` to long options like `--count`.

```json
{
  "flag": "-c"
}
```

### `constraint`

Regular expression the parameter value must match. Used in the classic form
together with `@parameter` to validate input at the boundary.

```bash
## @parameter IP /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
```

In JSON form, the constraint is carried as part of the parameter object
during conversion. See `shoedoc_converter.py` for the canonical handling.

---

## Recognized `type` values

The `type` field is a string. The framework recognises the following values,
all observed in real recipes:

- `str`: A free-form string. The default for anything textual.
- `int`: An integer count or numeric value.
- `bool`: A boolean flag, rendered as `"true"` or `"false"` per the Shoe
  boolean convention.
- `file`: A path to a file. The caller is expected to pass a real file.
- `folder`: A path to a directory. The caller is expected to pass a real
  folder.
- `json`: A JSON document, passed as a string and parsed at use site.

Any other value is treated as an opaque string. Type is documentation-first,
it is not enforced by the runtime.

---

## Where each tag goes

| Tag            | Script header | Function | Variable |
| -------------- | :-----------: | :------: | :------: |
| `@author`      | yes           | yes      | no       |
| `@version`     | yes           | yes      | no       |
| `@license`     | yes           | no       | no       |
| `@link`        | yes           | yes      | no       |
| `@update`      | yes           | no       | no       |
| `@namespace`   | no            | yes      | no       |
| `@summary`     | no            | yes      | no       |
| `@requires`    | no            | yes      | no       |
| `@depends`     | no            | yes      | no       |
| `@assumes`     | no            | yes      | no       |
| `@parameter`   | no            | yes      | no       |
| `@param`       | no            | yes      | no       |
| `@return`      | no            | yes      | no       |

Variables (constants, options, flags) get a single `## ` line as their
description, not a full Shoedoc block.

```bash
## Greeting recipient name /^[a-zA-Z-]+$/
who="World"
```

The trailing `/regex/` after the description is the variable-level constraint
analogue of the `constraint` field on function parameters.

---

## Format conversion

`shoedoc_converter.py` converts JSON Shoedoc blocks to classic `@`-prefixed
form, in place, across one or more files.

```sh
python3 shoedoc_converter.py path/to/script.sh
python3 shoedoc_converter.py --dry-run --recursive recipes/
```

The converter handles the following JSON keys: `namespace`, `summary`,
`requires`, `depends`, `assumes`, and `parameters` (with `name` and
`constraint`). Anything else is left untouched. The classic form is the
canonical form, the JSON form is the human-editable source.

---

## See also

- `AGENTS.md` section 11 (Function Annotation) for the JSON format reference
  and POSIX/Bash examples.
- `shoedoc_converter.py` for the conversion rules between the two formats.
- `README.md` section "Annotations" for the script-level DocBlock template.
