# Shoedoc Vocabulary

Shoedoc is the documentation system to describe shell scripts and their functions. Inspired by [Javadoc](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javadoc.html), [JSDoc](https://jsdoc.app) and [PHPDoc](https://docs.phpdoc.org/guide/references/phpdoc/index.html), [Composer](https://getcomposer.org/doc/04-schema.md), this metadata can be used to auto-generate documentation and unit tests, enable type safety and self-validation.

This document lists every tag the framework understands, what it is for, where it belongs, and how to write it. Shoedoc is written exclusively with classic `@`-prefixed tags: one tag per `##` comment line. Legacy JSON annotation envelopes are no longer parsed; the linter flags them so they can be rewritten as classic tags.

## Table of contents

- [Shoedoc at a glance](#shoedoc-at-a-glance)
- [Script](#script)
- [Script level constants](#script-level-constants)
- [Script level variables](#script-level-variables)
- [Script level options and flags](#script-level-options-and-flags)
- [Source comments](#source-comments)
- [Function](#function)
- [Options and flags](#options-and-flags)
- [Entry fields](#entry-fields)
- [Tags reference](#tags-reference)
- [Recognized `type` values](#recognized-type-values)
- [Where each tag goes](#where-each-tag-goes)

---

## Shoedoc at a glance

A Shoedoc block is a run of consecutive `##` comment lines placed directly above the declaration it documents, or just below the shebang (or license header) for a script file. It opens with a title (a one-line summary), optionally followed by a blank `##` line and a longer description, then the metadata.

```bash
## Hello World!
##
## Greets a specified user a given number of times.
##
## @namespace recipes/hello
## @requires echo
## @param {str} <WHO> (default:"World") The recipient's name.
hello() {
    echo "Hello, ${1:-World} !"
}
```

Shoedoc documents six kinds of elements:

|                Element                |                        What it describes                         |
|---------------------------------------|------------------------------------------------------------------|
| [Script](#script)                     | File-level metadata (authors, version, license, links…).         |
| [Constants](#script-level-constants)  | Immutable value declarations.                                    |
| [Variables](#script-level-variables)  | Mutable value declarations.                                      |
| [Function](#function)                 | Functions that take parameters, options and flags.               |
| [Options](#options-and-flags)         | Named values passed to a function (`--name` or its short alias). |
| [Flags](#options-and-flags)           | Boolean switches passed to a function.                           |

### What this document describes

Shoedoc distinguishes three layers:

|        Layer        |                            What it is                           |            Where it is documented            |
|---------------------|-----------------------------------------------------------------|----------------------------------------------|
| Block metadata      | Properties of a script or function block.                       | [Script](#script), [Function](#function)     |
| Entry metadata      | `@param`, `@option`, `@flag`, `@constant` and `@variable` tags. | [Entry fields](#entry-fields)                |
| Assignment metadata | `##` blocks above assignments, with title, description and tags. | [Constants](#script-level-constants), [Variables](#script-level-variables), [Options and flags](#script-level-options-and-flags) |

A bare `##` line above an assignment is the short form of an assignment annotation; see [Source comments](#source-comments).

---

## Script

The Script block documents a shell file. It sits right below the shebang, or after the license header and startup statements such as `set -e`. A blank line must separate the script block from the code that follows; otherwise the block is attached to the function defined right below it.

```bash
#!/usr/bin/env bash

## Shoedoc example
##
## Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
## tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @copyright 2026 Matthias Morin
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.py
```

A script block can own the following properties only: `summary`, `description`, `authors`, `copyright`, `version`, `license`, `links`, `update`, `deprecated`

### Field mapping

|           Property          |                        Classic tag                        |
|-----------------------------|-----------------------------------------------------------|
| `summary`                   | block title (`##` lines before the first blank separator) |
| `description`               | `##` lines after the first blank separator                |
| `authors`                   | `@author` (one per line)                                  |
| `copyright`                 | `@copyright`                                              |
| `version`                   | `@version`                                                |
| `license`                   | `@license`                                                |
| `links`                     | `@link` (repeatable: one entry per tag)                   |
| `update`                    | `@update`                                                 |
| `deprecated`                | `@deprecated`                                             |

---

## Script level constants

Constants document immutable value declarations. Two forms are valid.

The classic form uses the `@constant` tag directly above the assignment:

```bash
## @constant {str} Script alias - Used to execute the script when installed on host machine.
SCRIPT_ALIAS="shoemaker"
```

The extended form uses a full Shoedoc block above the assignment:

```bash
## Script alias
##
## Used to execute the script when installed on host machine.
##
## @type str
SCRIPT_ALIAS="shoemaker"
```

The name is optional in the classic tag: when omitted, the documented name comes from the assignment. A constant accepts `{type}` and the summary/description text. It cannot own a `/constraint/`, a `(default:value)` or a `(required)` marker. In the extended form, the block title is the summary, the lines after the first blank `##` are the description, and the block tags `@type`, `@private`, `@public` and `@deprecated` are accepted.

---

## Script level variables

Variables document mutable value declarations. Two forms are valid.

The classic form uses the `@variable` tag directly above the assignment:

```bash
## @variable {str} /^[a-zA-Z-]+$/ Default recipient name - The name to greet.
default_name="World"
```

The extended form uses a full Shoedoc block above the assignment:

```bash
## Default recipient name
##
## The name to greet.
##
## @type str
## @constraint /^[a-zA-Z-]+$/
default_name="World"
```

The name is optional in the classic tag: when omitted, the documented name comes from the assignment. A variable **can** carry a `/constraint/` so the runtime can validate its value; in the extended form use the `@constraint` tag for the same purpose. Entry-level privacy and deprecation are not separate tags: use the block-level `@private` and `@deprecated` tags when the whole block is private or deprecated.

---

## Script level options and flags

Options and flags can also be declared as script-level assignments. A variable assigned a value other than `"false"` is an option; a variable assigned `"false"` is a flag. Both accept the same three documentation forms as constants and variables: a bare source comment, a classic entry tag, or an extended Shoedoc block.

```bash
## Bookmark store file
##
## Path to the file that stores bookmarks.
##
## @type file
## @constraint /^.+\.tsv$/
store="store.tsv"

## Print additional details
##
## @deprecated Use --trace instead.
verbose=false
```

For an option, `@type` and `@constraint` describe the value and the default comes from the assignment. For a flag, `@type`, `@constraint` and `(default:value)` are forbidden: a flag is always a boolean switch. The block-level `@private`, `@public` and `@deprecated` tags apply to the whole declaration.

---

## Source comments

A single bare `##` line immediately above an assignment is the short form of an assignment annotation:

```bash
## Default recipient name
default_name="World"
```

The shell generator also recognises a trailing `/regex/` on an option or variable description:

```bash
## Greeting recipient name /^[a-zA-Z-]+$/
who="World"
```

A bare source comment carries no tags. Use an extended Shoedoc block when you need `@type`, `@constraint`, `@private`, `@public` or `@deprecated`; see [Script level variables](#script-level-variables) and [Script level options and flags](#script-level-options-and-flags).

---

## Function

The Function block documents a shell function. It sits directly above the function declaration.

```bash
## Hello World!
##
## Greets a specified user a given number of times.
## Accepts an optional recipient name and an optional repetition count.
##
## @namespace recipes/shoe
## @author "Matthias Morin" <mat@tangoman.io> https://tangoman.io
## @version 1.0.0
## @license MIT
## @link https://github.com/TangoMan75/shoe
## @shell bash
## @requires echo getopt
## @param {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
## @option {int} <count> [-c|--count] (default:1) The repetition count.
## @flag <prefix> [-p|--prefix] Prefix output with a line number.
hello() {
    local who=World
    local count=1
    local prefix='false'
    # ...
}
```

The Function block also accepts the generic block tags listed in [Where each tag goes](#where-each-tag-goes).

A `.sh` module under `recipes/` that deliberately defines a function with the same name as a core module under `src/` should record the replaced core module in `@overrides`. The tag names a single module as a relative path without the `.sh` extension; see [`@overrides`](#overrides).

### Minimal function block

A function block must at least carry a summary and a `@namespace`; the linter reports a missing namespace as a warning, and `--fix` inserts one inferred from the file location.

```bash
## Print a greeting
##
## @namespace src/shell/greeting
greet() {
    printf 'Hello, %s !\n' "$1"
}
```

---

## Options and flags

An **option** is a named value passed to a function, either as `--name` or through its short alias (`--count 3`, `-c 3`). A **flag** is a boolean switch that carries no value (`--prefix`, `-p`). Both are declared in a [Function](#function) block with `@option` and `@flag`. Script-level options and flags are declared as assignments and documented with [assignment blocks](#script-level-options-and-flags).

| Field | Option | Flag |
|-------|--------|------|
| `name` | required | required |
| `summary`, `description` | optional | optional |
| `type`, `constraint`, `default` | optional | forbidden |
| `short`, `long` | optional | optional |
| `required` | forbidden | forbidden |

An option is optional by design: when the caller omits it, the function falls back to its `default` value, or the value is simply absent. A flag owns no value fields, so it accepts no `{type}`, `/constraint/` or `(default:value)`; at runtime it sets its variable to `"true"` or `"false"`, and defaults to `"false"`.

### Classic syntax

```bash
## @option {type} <name> [short|long] /constraint/ (default:value) Option summary - Option description
## @flag          <name> [short|long]                           Flag summary   - Flag description
```

Apart from `<name>`, every token in these lines is optional. For example:

```bash
## @option {int} <count> [-c|--count] (default:1) Repetition count - How many times the greeting is printed.
## @flag  <prefix> [-p|--prefix] Prefix output - Prefix each line with its line number.
```

- `{type}` declares the expected data type (see [Recognized `type` values](#recognized-type-values)). Options only.
- `<name>` is the entry name; it is authoritative, since entries annotate no declaration.
- `[short|long]` holds the dashed aliases separated by a pipe: `[-c|--count]` exposes `-c` and `--count`. A single alias (`[-c]` or `[--count]`) is also valid.
- `/constraint/` is a regular expression the value must match. Options only.
- `(default:value)` gives an option its fallback value. Options only. `(required)` is never valid here: a required entry is a parameter.
- The summary and the description are separated by ` - `. Without the separator, the whole text becomes the description.

---

## Entry fields

`@param`, `@option`, `@flag`, `@constant` and `@variable` share one rich value grammar. Each field below is a token inside the tag value, not a standalone tag.

| Field | Params | Options | Flags | Constants | Variables |
|-------|--------|---------|-------|-----------|-----------|
| `name` | required | required | required | optional | optional |
| `summary` | optional | optional | optional | optional | optional |
| `description` | optional | optional | optional | optional | optional |
| `type` | optional | optional | forbidden | optional | optional |
| `constraint` | optional | optional | forbidden | forbidden | optional |
| `required` | optional | forbidden | forbidden | forbidden | forbidden |
| `default` | optional | optional | forbidden | forbidden | forbidden |
| `short` | forbidden | optional | optional | forbidden | forbidden |
| `long` | forbidden | optional | optional | forbidden | forbidden |
| `private` | forbidden | forbidden | forbidden | block tag | block tag |
| `deprecated` | forbidden | forbidden | forbidden | block tag | block tag |

### `name`

The entry name; authoritative, since entries annotate no declaration. A `params` entry may include several pipe-separated aliases. Every alias refers to the same argument position. `options`, `flags`, `constants` and `variables` take one identifier.

```bash
## @param {str} <CONTAINER_NAME|CONTAINER_ID> The container name or id.
```

When a `@constant` or `@variable` omits its name, it simply has no `name` field. The generated documentation derives script-level assignment names from the declarations, not from the entry.

### Position

The 1-based index of a positional parameter is implied by the order of the `@param` lines. Options, flags, constants and variables are addressed by name, not by position. There is no `position` token in the classic form.

### Summary and description

The optional summary is the text before the ` - ` separator; the description is the text after it. Without the separator, the whole text becomes the description. In generated documentation the summary is rendered before the long description.

```bash
## @param {file} <path> Input script - The shell script to inspect.
```

### `type`

Expected data type, written between braces immediately after the tag name. It constrains how the caller should pass the value and how the documentation generator describes it. See [Recognized `type` values](#recognized-type-values).

```bash
## @param {file} <path> The path to the input script.
```

### `constraint`

Regular expression the entry value must match, written as a bare `/regex/flags` token. Used to validate input at the boundary. A variable **can** own a constraint so the runtime can validate its value. In an [assignment block](#script-level-variables), the same value is written with the standalone `@constraint` tag.

```bash
## @param {str} <who> /^[a-zA-Z-]+$/ The recipient's name.
```

### `short` and `long`

Short and long aliases of an option or flag, written dashed and pipe-separated inside square brackets. A short alias is a single alphanumeric character; a long name starts with an alphanumeric character and may contain letters, digits and dashes. Both are optional: an entry may declare either, both, or neither.

```bash
## @option {int} <count> [-c|--count] (default:1) Repetition count.
```

### `required`

Only parameters can be required, written as the `(required)` token. When omitted, a parameter is optional. A required parameter cannot own a `(default:value)` marker.

```bash
## @param {file} <input> (required) Path to the input file.
```

### `default`

Default value used when the caller does not pass the entry, written as `(default:value)`. Params and options only: flags cannot own a default. An entry that owns a default value is implicitly optional. The value is parsed as JSON when possible (strings, numbers, booleans, null) and kept as text otherwise; quote string values that must stay strings.

```bash
## @param {str} <who> (default:"World") The recipient's name.
## @option {int} <count> [-c|--count] (default:1) The repetition count.
```

### `private` and `deprecated`

Classic Shoedoc applies `@private`, `@public` and `@deprecated` to the whole block. Individual constants and variables cannot carry an entry-level privacy or deprecation marker.

---

## Tags reference

### `@author`

Identifies the author of the script or function.

```bash
## @author  "Matthias Morin" <mat@tangoman.io> https://tangoman.io
```

The value follows the convention `"Display Name" <email@example.com> [homepage]`. The quoted name, angle-bracketed email pattern and the trailing homepage URL are optional, although at least one value must be present for this to make sense. The tag may be repeated.

### `@copyright`

Identifies the copyright holder of the script or function. Same value convention as `@author`.

```bash
## @copyright  "Matthias Morin" <mat@tangoman.io>
```

### `@version`

Version string of the script or function. Recommended to follow [Semantic Versioning](https://semver.org/), eg `0.1.0` (major.minor.patch).

```bash
## @version 0.1.0
```

### `@license`

SPDX license identifier or short license name, eg `MIT`, `GPLv3`. Used in generated headers.

```bash
## @license MIT
```

### `@link`

Canonical URL pointing to the project, the documentation, or the source repository. A script or function may own several links: repeat the tag, one entry per occurrence. Duplicate links are rejected by the linter.

```bash
## @link    https://github.com/TangoMan75/shoe
## @link    https://tangoman.io
```

### `@update`

Raw URL pointing to the latest version of the script or function.

```bash
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.py
```

### `@shell`

Declares the interpreter the script or function is meant to run under. Only two values are accepted: `bash` and `sh`.

```bash
## @shell bash
```

### `@namespace`

Logical grouping for related functions. Used to filter or colourise the generated documentation. At the function level it tells the documentation generator which chapter the function belongs to. A script block cannot own a `namespace`: namespaces group functions, not files.

```bash
## @namespace recipes/shoe
```

The value is a relative folder path. The linter checks that the folder exists and `--fix` infers the current folder when the tag is missing.

### `@summary`

One-line summary describing the purpose of the element. Rendered as the element title in the generated markdown. It is usually written as the first line of the block rather than as an explicit tag.

```bash
## @summary  Return given tag values from shoedoc annotation
```

When both a title line and `@summary` are present, the explicit tag wins.

### `@example`

Provides a usage example. Repeatable; each occurrence adds one example to the generated documentation.

```bash
## @example hello World
## @example hello World -c 3
```

### `@requires`

External commands the element calls. The documentation generator emits these in the "Requires" section of the entry. Listing them helps reviewers spot when a function adds a new runtime dependency. A script block cannot own `requires`.

Entries are space-separated on a single line, or split over repeated tags; a comma is not a separator. The linter requires the list to be sorted alphabetically and free of duplicates, and rejects entries that do not appear in the file body.

```bash
## @requires  echo getopt
```

```bash
## @requires  echo
## @requires  getopt
```

The classic form splits on whitespace: a command with arguments (`git status`) is not representable as a single `@requires` entry.

### `@depends`

Other functions this block calls. Used by the documentation generator to build the "Depends" graph and by the build command to include the dependency closure. A script or function may own this tag.

```bash
## @depends  src/shell/colors/_echo_error
```

Entries are relative module paths without the `.sh` extension, space-separated on one line or split over repeated tags. The linter requires them sorted, unique, and pointing to existing files.

### `@overrides`

The core module a script or function deliberately replaces. A block can override one module only, so the value is a single relative path.

A `.sh` module under `recipes/` **should** own this tag when it defines a function with the same name as a core module under `src/`: the build leaves the superseded core module out when another component reaches it through its transitive `depends`, so the overriding module is the only definition in the built script.

The path points to a module under `src/`, written without the `.sh` extension, and the target must exist. The linter also verifies that the overridden function's name appears in the file body.

```bash
## @overrides  src/shell/hooks/_before
```

For example, the annotation that makes `recipes/agnostic-companion/_before.sh` override the core `_before` hook defined in `src/shell/hooks/_before.sh` looks like this:

```bash
## Run following code before each execution
##
## @namespace recipes/agnostic-companion
## @overrides src/shell/hooks/_before
_before() {
    # ...
}
```

### `@assumes`

Environment variables or constants the element expects to be defined. Distinct from `depends` because those are other functions, not data. Entries are space-separated, sorted and unique.

```bash
## @assumes LBOUND
```

The linter requires every variable the block reads before defining it to be listed, and rejects entries the block never reads. A variable assigned before its first read belongs to the block and does not need to be listed.

### `@private`

Marks a function or value as private, ie not part of the public API. The documentation generator may hide private entries from the generated markdown. The tag applies to the whole block.

```bash
## @private
```

### `@public`

Marks a function or value as public, ie part of the exposed API. This is the default when neither `@private` nor `@public` is present. The tag applies to the whole block.

```bash
## @public
```

### `@deprecated`

Marks a script, function, value, constant or variable as deprecated. The value is a free-form string, typically the reason for deprecation or the version that superseded the element. `params`, `options` and `flags` entries cannot be deprecated. The tag applies to the whole block.

```bash
## @deprecated Use bar instead.
```

### `@type`

Block-level type metadata. The tag accepts the value with or without braces and follows the same value set as entry types. See [Recognized `type` values](#recognized-type-values).

```bash
## @type {file}
```

The standalone tag is valid on Script, Function and assignment blocks. Entry types are written with the `{type}` token inside `@param`, `@option`, `@constant` and `@variable`; see [Entry fields](#entry-fields).

### `@constraint`

Documents the regular expression a script-level variable or option value must match. It is the extended-block equivalent of the `/constraint/` token and is only valid in the assignment block directly above the declaration.

```bash
## Default recipient name
##
## The name to greet.
##
## @type str
## @constraint /^[a-zA-Z-]+$/
default_name="World"
```

A constant cannot own a constraint; a flag owns no value and therefore cannot own one either.

### `@constant`

Documents a constant declaration. The name is derived from the assignment when the tag omits it. The extended form uses a block title and `@type`; see [Script level constants](#script-level-constants).

```bash
## @constant {str} Default recipient name - Used when no name is supplied.
DEFAULT_NAME="World"
```

### `@variable`

Documents a variable declaration. The name is derived from the assignment when the tag omits it. A variable **can** carry a `/constraint/` so the runtime can validate its value. The extended form uses a block title, `@type` and `@constraint`; see [Script level variables](#script-level-variables).

```bash
## @variable {str} /^[a-zA-Z-]+$/ Greeting recipient name - The name to greet.
who="World"
```

### `@param`

Documents a single positional parameter of a function. Position is implied by the order of the `@param` lines.

```bash
## @param  {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
```

### `@option`

Documents a named option that expects a value (`--name` or its short alias). Shares the rich grammar with `@param`, plus the `[short|long]` alias pair. An option cannot own `(required)`: it falls back to its default value.

```bash
## @option {file} <input> [-i|--input] (default:"input.txt") Path to the input file.
```

### `@flag`

Documents a boolean switch (`--name` or its short alias). Shares the rich grammar with `@param`, minus the `{type}` field since a flag carries no value; at runtime it sets its variable to `"true"` or `"false"`. A flag cannot own `(default:value)` either: switches default to `"false"`.

```bash
## @flag <force> [-f|--force] Overwrite without asking.
```

### `@stdout`

Documents what is dumped to stdout by this element. Functions only: a script block cannot own a `stdout` property.

```bash
## @stdout  the greeting lines
```

### `@stderr`

Documents what is dumped to stderr by this element. Functions only: a script block cannot own a `stderr` property.

```bash
## @stderr  error messages and diagnostics
```

### `@stdin`

Documents what is expected from stdin by this element. Functions only: a script block cannot own a `stdin` property.

```bash
## @stdin  nothing expected
```

---

## Recognized `type` values

The `type` field is a string. The framework recognises the following values:

- `str`: A free-form string. The default for anything textual.
- `int`: An integer count or identifier.
- `number`: A numeric value that may carry a decimal part.
- `bool`: A boolean value, rendered as `"true"` or `"false"` per the Shoe boolean convention.
- `array`: A list of values.
- `url`: A URL.
- `path`: A filesystem path, file or folder.
- `file`: A path to a file. The caller is expected to pass a real file.
- `folder`: A path to a directory. The caller is expected to pass a real folder.
- `json`: A JSON document, passed as a string and parsed at use site.
- `regex`: A regular expression.

Any other value is rejected by the Shoedoc linter. Type is documentation-first: it is not enforced by the shell runtime.

---

## Where each tag goes

### Block tags

| Tag | Script | Function | Notes |
|-----|--------|----------|-------|
| `@author` | yes | yes | Repeatable. |
| `@copyright` | yes | yes | |
| `@version` | yes | yes | |
| `@license` | yes | yes | |
| `@link` | yes | yes | Repeatable. |
| `@update` | yes | yes | |
| `@shell` | yes | yes | |
| `@namespace` | no | yes | Function-only. |
| `@summary` | yes | yes | Usually the block title. |
| `@example` | yes | yes | Repeatable. |
| `@requires` | no | yes | Function-only. |
| `@depends` | yes | yes | Script-level entries describe the script as a whole. |
| `@overrides` | yes | yes | Script-level entries describe the script as a whole. |
| `@assumes` | yes | yes | |
| `@private` | no* | yes | *The linter accepts it on script blocks but it has no documented effect. |
| `@public` | no* | yes | Same caveat as `@private`. |
| `@deprecated` | yes | yes | |
| `@type` | yes | yes | Block-level type metadata. |
| `@stdout` | no | yes | Function-only. |
| `@stderr` | no | yes | Function-only. |
| `@stdin` | no | yes | Function-only. |

### Assignment block tags

A `##` block directly above a script-level constant, variable, option or flag declaration is an assignment block. It accepts the following tags in addition to its title and description:

| Tag | Constants | Variables | Options | Flags | Notes |
|-----|-----------|-----------|---------|-------|-------|
| `@type` | yes | yes | yes | no | Same values as the `{type}` token. |
| `@constraint` | no | yes | yes | no | Same syntax as the `/constraint/` token. |
| `@private` | yes | yes | yes | yes | Hides the declaration from public documentation. |
| `@public` | yes | yes | yes | yes | Default when neither `@private` nor `@public` is present. |
| `@deprecated` | yes | yes | yes | yes | Free-form reason. |
| `@summary` | yes | yes | yes | yes | Usually the block title. |

### Entry tags and tokens

| Tag or token | Params | Options | Flags | Constants | Variables |
|--------------|--------|---------|-------|-----------|-----------|
| `@param` | yes | no | no | no | no |
| `@option` | no | yes | no | no | no |
| `@flag` | no | no | yes | no | no |
| `@constant` | no | no | no | yes | no |
| `@variable` | no | no | no | no | yes |
| `{type}` | yes | yes | no | yes | yes |
| `/constraint/` | yes | yes | no | no | yes |
| `(required)` | yes | no | no | no | no |
| `[short\|long]` | no | yes | yes | no | no |
| `(default:value)` | yes | yes | no | no | no |

`@private` and `@deprecated` are block tags, not entry tags. `@constant` and `@variable` are documented at script scope; the parser also accepts them in function blocks, where they have no function-level effect. `@param`, `@option` and `@flag` are documented at function scope; a script block cannot own them. Script-level assignments accept a bare source comment, a classic `@constant`/`@variable` entry tag, or an extended assignment block; see [Source comments](#source-comments).
