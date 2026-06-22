# Shoedoc Vocabulary

Shoedoc is the documentation system to describe shell scripts and their functions. Inspired by [Javadoc](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javadoc.html), [JSDoc](https://jsdoc.app) and [PHPDoc](https://docs.phpdoc.org/guide/references/phpdoc/index.html), [Composer](https://getcomposer.org/doc/04-schema.md), this metadata can be used to auto-generate documentation and unit tests, enable type safety and self-validation.

This document lists every tag the framework understands, what it is for, where it belongs, and how to write it.

## Table of contents

- [Shoedoc at a glance](#shoedoc-at-a-glance)
- [Script](#script)
- [Constants and variables](#constants-and-variables)
- [Options and flags](#options-and-flags)
- [Function](#function)
- [Entry object fields](#entry-object-fields)
- [Tags reference](#tags-reference)
- [Recognized `type` values](#recognized-type-values)
- [Where each tag goes](#where-each-tag-goes)

---

## Shoedoc at a glance

A Shoedoc block is a run of consecutive `##` comment lines placed directly above the declaration it documents: a script file, a function, or a value assignment. It opens with a title (a one-line summary), optionally followed by a blank `##` line and a longer description, then the metadata tags, one per line.

The same metadata can be written in two interchangeable formats:

- The **classic** `@`-prefixed form: one tag per line, easy to hand-write.
- The **JSON** form: the same data carried by a single object, describing each parameter, option and flag precisely.

Shoedoc documents six kinds of elements:

|                Element                |                        What it describes                         |
|---------------------------------------|------------------------------------------------------------------|
| [Script](#script)                     | File-level metadata (authors, version, license, links…).         |
| [Constants](#constants-and-variables) | Immutable value declarations.                                    |
| [Variables](#constants-and-variables) | Mutable value declarations.                                      |
| [Options](#options-and-flags)         | Named values passed to a function (`--name` or its short alias). |
| [Flags](#options-and-flags)           | Boolean switches passed to a function.                           |
| [Function](#function)                 | Functions that take parameters, options and flags.               |

---

## Script

The Script block documents a shell file. It sits right below the shebang (or at the very top of the file).

### Classic Syntax

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

### JSON Syntax

```bash
#!/usr/bin/env bash

## {
##   "shell": "bash",
##   "summary": "Shoedoc example",
##   "description": "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod\ntempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
##   "authors": [
##     {
##       "name": "Matthias Morin",
##       "email": "mat@tangoman.io"
##     }
##   ],
##   "copyright": "2026 Matthias Morin",
##   "version": "0.1.0",
##   "license": "MIT",
##   "links": [
##     "https://github.com/TangoMan75/shoe"
##   ],
##   "update": "https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.py"
## }
```

### JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "shell": {
      "type": "string",
      "enum": [
        "bash",
        "sh"
      ]
    },
    "summary": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "authors": {
      "type": "array",
      "minItems": 1,
      "description": "List of authors that contributed to the package. This is typically the main maintainers, not the full list.",
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["name"],
        "properties": {
          "name": {
            "type": "string",
            "description": "Full name of the author."
          },
          "email": {
            "type": "string",
            "description": "Email address of the author.",
            "format": "email"
          },
          "homepage": {
            "type": "string",
            "description": "Homepage URL for the author.",
            "format": "uri"
          },
          "role": {
            "type": "string",
            "description": "Author's role in the project."
          }
        },
        "anyOf": [
          {"required": ["name"]},
          {"required": ["email"]},
          {"required": ["homepage"]}
        ]
      }
    },
    "copyright": {
      "type": "string"
    },
    "version": {
      "type": "string",
      "description": "Package version (strict \"MAJOR.MINOR.PATCH\" syntax).",
      "pattern": "^\\d+\\.\\d+\\.\\d+$"
    },
    "license": {
      "type": "string"
    },
    "links": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "update": {
      "type": "string"
    },
    "examples": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "deprecated": {
      "type": "string"
    }
  },
  "required": [
    "shell",
    "summary",
    "authors",
    "copyright",
    "version",
    "license"
  ],
  "additionalProperties": false
}
```

### Field mapping

|                Field                |                Classic tag                 |
|-------------------------------------|--------------------------------------------|
| `shell` or file's shebang directive | `@shell`                                   |
| `summary`                           | block title (first non-empty `##` line)    |
| `description`                       | `##` lines after the first blank separator |
| `authors`                           | `@author` (one per line)                   |
| `copyright`                         | `@copyright`                               |
| `version`                           | `@version`                                 |
| `license`                           | `@license`                                 |
| `links`                             | `@link` (repeatable: one entry per tag)    |
| `update`                            | `@update`                                  |
| `examples`                          | `@example` (one per line)                  |

A script block cannot own a `namespace`, `requires`, `stdout`, `stderr` or `stdin` property: these are function-level concerns. It may own a `copyright` property.

---

## Script level constants

Constants document immutable value declarations, variables document mutable ones.

### Classic Syntax

The name is not repeated in the tag; it comes from the declaration below.

```bash
## @constant {str} Script alias - Used to execute the script when installed on host machine.
SCRIPT_ALIAS="shoemaker"
```

### JSON Syntax

```bash
## {
##     "name": "SCRIPT_ALIAS",
##     "summary": "Alias for this script",
##     "description": "Used to execute the script when installed on host machine.",
##     "type": "str",
## }
SCRIPT_ALIAS="shoemaker"
```

### JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "name": {
      "type": "string"
    },
    "summary": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "private": {
      "type": "boolean"
    },
    "type": {
      "type": "string",
      "enum": [
        "str",
        "int",
        "number",
        "bool",
        "array",
        "url",
        "path",
        "file",
        "folder",
        "json",
        "regex"
      ]
    },
    "deprecated": {
      "type": "string"
    }
  },
  "required": ["name", "summary", "private", "type"],
  "additionalProperties": false
}
```

---

## Script level variables

### Classic Syntax — Compact

```bash
## Default recipient name {str} /^[a-zA-Z-]+$/
default_name="World"
```

### Classic Syntax — Verbose

```bash
## Default recipient name
##
## The name to greet.
## Used when no name is supplied.
##
## @type str
## @constraint /^[a-zA-Z-]+$/
default_name="World"
```

The name is not repeated in the tag; it comes from the declaration above.
A variable **can** own a `constraint` property: it declares the regular expression the runtime validates the variable against.

### JSON Syntax

```bash
## {
##     "name": "default_name",
##     "summary": "Default recipient name",
##     "description": "The name to greet. Used when no name is supplied.",
##     "type": "str",
##     "private": false,
##     "constraint": "/^[a-zA-Z-]+$/",
##     "default": "World"
## }
default_name="World"
```

### JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "name": {
      "type": "string"
    },
    "summary": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "private": {
      "type": "boolean"
    },
    "type": {
      "type": "string",
      "enum": [
        "str",
        "int",
        "number",
        "bool",
        "array",
        "url",
        "path",
        "file",
        "folder",
        "json",
        "regex"
      ]
    },
    "constraint": {
      "type": "string"
    },
    "deprecated": {
      "type": "string"
    }
  },
  "required": ["name", "summary", "private", "type", "constraint"],
  "additionalProperties": false
}
```

---

## Function

The Function block documents a shell function. It sits directly above the function declaration.

### Classic Syntax

```bash
## Hello World!
##
## Greets a specified user a given number of times.
## Accepts an optional recipient name and an optional repetition count.
## Useful as a smoke test for new installations.
##
## @namespace recipes/shoe
## @author "Matthias Morin" <mat@tangoman.io> https://tangoman.io
## @version 1.0.0
## @license MIT
## @link https://github.com/TangoMan75/shoe
##
## @shell bash
## @requires getopt echo
## @param {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
## @option {int} <count> [-c|--count] (default:1) The repetition count.
## @flag <prefix> [-p|--prefix] Prefix output with a line number.
hello() {
    local who=World
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

---

### JSON Syntax

```bash
## {
##   "namespace": "recipes/shoe",
##   "summary": "Hello World!",
##   "description": "Greets a specified user a given number of times.\nAccepts an optional recipient name and an optional repetition count.\nUseful as a smoke test for new installations.",
##   "authors": [
##     {
##       "name": "Matthias Morin",
##       "email": "mat@tangoman.io",
##       "homepage": "https://tangoman.io"
##     }
##   ],
##   "version": "1.0.0",
##   "license": "MIT",
##   "links": [
##     "https://github.com/TangoMan75/shoe"
##   ],
##   "shell": "bash",
##   "requires": [
##     "echo",
##     "getopt",
##     "who"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "who",
##       "description": "The recipient's name.",
##       "type": "str",
##       "constraint": "/^[a-zA-Z-]+$/",
##       "default": "World"
##     }
##   ],
##   "options": [
##     {
##       "name": "count",
##       "description": "The repetition count.",
##       "type": "int",
##       "short": "c",
##       "long": "count",
##       "default": 1
##     }
##   ],
##   "flags": [
##     {
##       "name": "prefix",
##       "description": "Prefix output with a line number.",
##       "short": "p",
##       "long": "prefix"
##     }
##   ]
## }
hello() {
  # truncated ...
}
```

---

### JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "properties": {
    "namespace": {
      "type": "string",
      "description": "Folder that groups related functions, as a relative path without extension.",
      "pattern": "^(?!/|\\\\|\\./|\\.\\./)([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?/)*[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?$"
    },
    "name": {
      "type": "string",
      "minLength": 1
    },
    "summary": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "authors": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "name": {
            "type": "string",
            "description": "Full name of the author."
          },
          "email": {
            "type": "string",
            "description": "Email address of the author.",
            "format": "email"
          },
          "homepage": {
            "type": "string",
            "description": "Homepage URL for the author.",
            "format": "uri"
          }
        },
        "anyOf": [
          {"required": ["name"]},
          {"required": ["email"]},
          {"required": ["homepage"]}
        ]
      }
    },
    "copyright": {
      "type": "string"
    },
    "version": {
      "type": "string",
      "description": "Function version (strict \"MAJOR.MINOR.PATCH\" syntax).",
      "pattern": "^\\d+\\.\\d+\\.\\d+$"
    },
    "license": {
      "type": "string"
    },
    "links": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "update": {
      "type": "string"
    },
    "shell": {
      "type": "string",
      "enum": [
        "bash",
        "sh"
      ]
    },
    "requires": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "description": "External commands the function calls, sorted alphabetically.",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "depends": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "description": "Shoedoc modules the function calls, sorted alphabetically, as relative paths without extension.",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "overrides": {
      "type": "string",
      "description": "The single core module the function deliberately replaces.",
      "pattern": "^src/([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?/)*[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?$"
    },
    "assumes": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "description": "Environment variables or constants the function expects to be defined, sorted alphabetically.",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "private": {
      "type": "boolean"
    },
    "deprecated": {
      "type": "string"
    },
    "examples": {
      "type": "array",
      "items": {
        "type": "string"
      }
    },
    "stdout": {
      "type": "string"
    },
    "stderr": {
      "type": "string"
    },
    "stdin": {
      "type": "string"
    },
    "params": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["name"],
        "properties": {
          "position": {
            "type": "integer",
            "minimum": 1
          },
          "name": {
            "type": "string",
            "description": "One identifier or several pipe-separated aliases for the same positional argument.",
            "pattern": "^[a-zA-Z_][a-zA-Z0-9_]*(\\|[a-zA-Z_][a-zA-Z0-9_]*)*$"
          },
          "summary": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "type": {
            "type": "string",
            "enum": [
              "str",
              "int",
              "number",
              "bool",
              "array",
              "url",
              "path",
              "file",
              "folder",
              "json",
              "regex"
            ]
          },
          "constraint": {
            "type": "string",
            "pattern": "^/.*/[a-z]*$"
          },
          "required": {
            "type": "boolean"
          },
          "default": {
            "type": ["string", "number", "boolean", "null"]
          }
        },
        "allOf": [
          {
            "if": {
              "required": ["required"],
              "properties": {
                "required": {
                  "const": true
                }
              }
            },
            "then": {
              "not": {
                "required": ["default"]
              }
            }
          }
        ]
      }
    },
    "options": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["name"],
        "not": {
          "required": ["required"]
        },
        "properties": {
          "name": {
            "type": "string",
            "pattern": "^[a-zA-Z_][a-zA-Z0-9_]*$"
          },
          "summary": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "type": {
            "type": "string",
            "enum": [
              "str",
              "int",
              "number",
              "bool",
              "array",
              "url",
              "path",
              "file",
              "folder",
              "json",
              "regex"
            ]
          },
          "constraint": {
            "type": "string",
            "pattern": "^/.*/[a-z]*$"
          },
          "short": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9]$"
          },
          "long": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9][a-zA-Z0-9-]*$"
          },
          "default": {
            "type": ["string", "number", "boolean", "null"]
          }
        }
      }
    },
    "flags": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "required": ["name"],
        "properties": {
          "name": {
            "type": "string",
            "pattern": "^[a-zA-Z_][a-zA-Z0-9_]*$"
          },
          "summary": {
            "type": "string"
          },
          "description": {
            "type": "string"
          },
          "short": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9]$"
          },
          "long": {
            "type": "string",
            "pattern": "^[a-zA-Z0-9][a-zA-Z0-9-]*$"
          }
        }
      }
    }
  },
  "required": [
    "namespace",
    "summary"
  ],
  "additionalProperties": false
}
```

The Function block also accepts the `@copyright`, `@depends`, `@assumes`, `@stdout`, `@stderr` and `@stdin` tags; each maps to the JSON key of the same name.

A `.sh` module under `recipes/` that deliberately defines a function with the same name as a core module under `src/` should record the replaced core module in `overrides`. The property names a single module as a relative path without the `.sh` extension; see [`@overrides`](#overrides).

---

## Options and flags

An **option** is a named value passed to a function, either as `--name` or through its short alias (`--count 3`, `-c 3`). A **flag** is a boolean switch that carries no value (`--prefix`, `-p`). Both are declared in a [Function](#function) block, under its `options` and `flags` arrays respectively.

| Field | Option | Flag |
|-------|--------|------|
| `name` | required | required |
| `summary`, `description` | optional | optional |
| `type`, `constraint`, `default` | optional | forbidden |
| `short`, `long` | optional | optional |
| `required` | forbidden | forbidden |

The table records which fields each kind accepts; [Entry object fields](#entry-object-fields) describes what each field means.

An option is optional by design: when the caller omits it, the function falls back to its `default` value, or the value is simply absent. A flag owns no value fields, so it accepts no `type`, `constraint`, `default` or `required`; at runtime it sets its variable to `"true"` or `"false"`, and defaults to `"false"`. In JSON form, the linter enforces this table: an option owning `required`, or a flag owning `type`, `constraint`, `default` or `required`, is rejected.

### JSON Syntax

An option entry:

```json
{
  "name": "count",
  "summary": "Repetition count",
  "description": "How many times the greeting is printed.",
  "type": "int",
  "constraint": "/^[0-9]+$/",
  "short": "c",
  "long": "count",
  "default": 1
}
```

A flag entry:

```json
{
  "name": "prefix",
  "summary": "Prefix output",
  "description": "Prefix each line with its line number.",
  "short": "p",
  "long": "prefix"
}
```

The `short` and `long` fields hold the bare alias and name, without dashes: `"c"` and `"count"` render as `-c` and `--count`. A short alias is a single alphanumeric character; a long name starts with an alphanumeric character and may contain letters, digits and dashes. Both are optional: an entry may declare either, both, or neither. The `default` value is a scalar: string, number, boolean or null.

### Classic Syntax

```bash
## @option {type} <name> [short|long] /constraint/ (default:value) Option summary - Option description
## @flag          <name> [short|long]                             Flag summary   - Flag description
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

## Entry object fields

Each entry in the `params`, `options` and `flags` arrays of a function block — and in the `constants` and `variables` arrays of a script block — is an object with the following fields.

### `name`

The entry name; authoritative, since entries annotate no declaration. By TangoMan Shoe convention, parameter names written in uppercase indicate values that will be treated as positional parameters inside the function body (`set -- "$1" "$2" "$3"`). A `params` entry may include several pipe-separated aliases. Every alias refers to the same argument position. `options`, `flags`, `constants` and `variables` take one identifier.

```json
{
  "name": "DESTINATION"
}
```

```json
{
  "name": "CONTAINER_NAME|CONTAINER_ID",
  "position": 1
}
```

This represents one positional value accepted under either name. The classic
form uses the same spelling:

```bash
## @param {str} <CONTAINER_NAME|CONTAINER_ID> The container name or id.
```

When a `constants` or `variables` entry omits `name`, the name comes from the declaration the block annotates.

### `position`

1-based index of a positional parameter in the `params` array. In the classic form it is implied by the order of the `@param` lines; the JSON form carries it explicitly, and it must match the entry's rank in the array — the order is the source of truth, `position` is checked redundancy. Params only: options, flags, constants and variables are addressed by name, not by position.

```json
{
  "position": 1,
  "name": "SCRIPT_PATH"
}
```

For optional parameters, the position is still the slot the argument occupies when present, even if the parameter has a default.

### `summary`

Short one-line description of the entry, rendered before the long description in the classic form. Initializes the summary part of the `@param`/`@option`/`@flag` value, before the ` - ` separator.

```json
{
  "summary": "Greeting recipient"
}
```

### `description`

Human-readable explanation of what the entry is for. Rendered in the generated documentation under the entry name.

```json
{
  "description": "The path to the input script."
}
```

### `type`

Expected data type. Constrains how the caller should pass the value and how the documentation generator describes it. See [Recognized `type` values](#recognized-type-values) for the list.

```json
{
  "type": "file"
}
```

### `constraint`

Regular expression the entry value must match. Used to validate input at the boundary. Maps to the `/regex/` token in the classic form. A variable **should** own a `constraint` property so the runtime can validate its value.

```json
{
  "constraint": "/^([0-9]{1,3}\\.){3}[0-9]{1,3}$/"
}
```

### `short`

Short alias of an option or flag, without the leading dash, eg `"c"` for `-c`.

```json
{
  "short": "c"
}
```

### `long`

Long name of an option or flag, without the leading dashes, eg `"count"` for `--count`.

```json
{
  "long": "count"
}
```

### `required`

Boolean indicating whether the entry is mandatory (`true`) or optional (`false`). Maps to the `(required)` token in the classic form. When omitted, `optional` is the default. Params only: an option cannot own a `required` property, and a `required` parameter cannot own a `default` value.

```json
{
  "required": true
}
```

### `default`

Default value used when the caller does not pass the entry. An entry that owns a `default` value is implicitly `optional`; a `required` entry cannot own one. Maps to the `(default:value)` token in the classic form.

```json
{
  "default": "World"
}
```

### `deprecated`

Free-form string marking the entry as deprecated. Only `constants` and `variables` entries (and whole blocks) may be deprecated: `params`, `options` and `flags` entries cannot own a `deprecated` property. Maps to the `@deprecated` tag in the classic form.

```json
{
  "deprecated": "Use --destination instead."
}
```

---

## Tags reference

### `@author`

Identifies the author of the script or function.

```bash
## @author  "Matthias Morin" <mat@tangoman.io> https://tangoman.io
```

The value follows the convention `"Display Name" <email@example.com> [homepage]`. The quoted name, angle-bracketed email pattern and the trailing homepage URL are optional, although at least one value must be present for this to make sense. The tag may be repeated.

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

Canonical URL pointing to the project, the documentation, or the source repository. A script may own several links: repeat the tag, one entry per occurrence. The tag maps to the `"links"` array in JSON form.

```bash
## @link    https://github.com/TangoMan75/shoe
## @link    https://tangoman.io
```

In JSON form the one-liner above maps to:

```json
{
  "links": [
    "https://github.com/TangoMan75/shoe",
    "https://tangoman.io"
  ]
}
```

### `@update`

Raw URL pointing to the latest version of the script.

```bash
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.py
```

### `@shell`

Declares the interpreter the script or function is meant to run under. Only two values are accepted: `bash` and `sh`.

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

Logical grouping for related functions. Used to filter or colourise the generated documentation. At the function level it tells the documentation generator which chapter the function belongs to. A script block cannot own a `namespace`: namespaces group functions, not files.

```bash
## @namespace recipes/shoe
```

In JSON form the tag maps to the `"namespace"` property:

```json
{
  "namespace": "recipes/shoe"
}
```

### `@summary`

One-line summary describing the purpose of the element. Rendered as the element title in the generated markdown. It is usually written as the first line of the block rather than as an explicit tag.

```bash
## @summary  Return given tag values from shoedoc annotation
```

### `@example`

Provides a usage example. Repeatable; each occurrence adds one example to the generated documentation.

```bash
## @example hello World
## @example hello World -c 3
```

In JSON form the tag maps to the `"examples"` array:

```json
{
  "examples": ["hello World", "hello World -c 3"]
}
```

### `@requires`

Array of external commands the element calls. The documentation generator emits these in the "Requires" section of the entry. Listing them helps reviewers spot when a function adds a new runtime dependency. A script block cannot own a `requires` property.

Entries are either space-separated on a single line or listed one per line; a comma is not a separator. Both spellings below yield the same two entries.

```bash
## @requires  getopt echo
```

```bash
## @requires  getopt
## @requires  echo
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
## @depends  _echo_error
```

Or:

```bash
## {
##   "depends": ["_echo_error"]
## }
```

### `@overrides`

The core module a function deliberately replaces. A function can override one module only, so the value is a single relative path. A `.sh` module under `recipes/` **should** own this property when it defines a function with the same name as a core module under `src/`: the build leaves the superseded core module out when another component reaches it through its transitive `depends`, so the overriding module is the only definition in the built script.

The path points to a module under `src/`, written without the `.sh` extension, and the target must exist. The linter also verifies that the overridden function's name appears in the file body.

```bash
## @overrides  src/shell/hooks/_before
```

Or in JSON form:

```bash
## {
##   "overrides": "src/shell/hooks/_before"
## }
```

For example, the annotation that makes `recipes/agnostic-companion/_before.sh` override the core `_before` hook defined in `src/shell/hooks/_before.sh` looks like this:

```bash
## {
##   "namespace": "recipes/agnostic-companion",
##   "summary": "Run following code before each execution",
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    # ...
}
```

### `@assumes`

Array of environment variables or constants the element expects to be defined. Distinct from `depends` because those are other functions, not data.

```bash
## {
##   "assumes": ["LBOUND"]
## }
```

### `@private`

Marks a function or value as private, ie not part of the public API. The documentation generator may hide private entries from the generated markdown.

```bash
## @private
```

In JSON form the tag maps to the `"private": true` property:

```json
{
  "private": true
}
```

### `@public`

Marks a function or value as public, ie part of the exposed API. This is the default when neither `@private` nor `@public` is present.

```bash
## @public
```

In JSON form the tag maps to the `"private": false` property:

```json
{
  "private": false
}
```

### `@deprecated`

Marks a script, function, value, constant or variable as deprecated. The value is a free-form string, typically the reason for deprecation or the version that superseded the element. `params`, `options` and `flags` entries cannot be deprecated.

```bash
## @deprecated Use bar instead.
```

In JSON form the tag maps to the `"deprecated"` property:

```json
{
  "deprecated": "Use bar instead."
}
```

### `@type`

Expected data type of a value or entry. See [Recognized `type` values](#recognized-type-values) for the list.

```bash
## @type {file}
```

In JSON form the tag maps to the `"type"` property:

```json
{
  "type": "file"
}
```

### `@constant`

Documents a constant declaration. The name is not repeated in the tag; it comes from the declaration the block annotates.

```bash
## @constant {str} Default recipient name - Used when no name is supplied.
DEFAULT_NAME="World"
```

In JSON form the tag maps to a `constants` entry of the script block:

```json
{
  "constants": [
    {
      "type": "str",
      "summary": "Default recipient name",
      "description": "Used when no name is supplied."
    }
  ]
}
```

### `@variable`

Documents a variable declaration. The name is not repeated in the tag; it comes from the declaration the block annotates. A variable **should** carry a `/constraint/` so the runtime can validate its value.

```bash
## @variable {str} /^[a-zA-Z-]+$/ Greeting recipient name - The name to greet.
who="World"
```

In JSON form the tag maps to a `variables` entry of the script block:

```json
{
  "variables": [
    {
      "type": "str",
      "constraint": "/^[a-zA-Z-]+$/",
      "summary": "Greeting recipient name",
      "description": "The name to greet."
    }
  ]
}
```

### `@required`

Entry-scoped: marks a `@param` entry as mandatory. In the classic entry grammar it is written as the `(required)` token. It is mutually exclusive with `optional` and with `default`, and only `params` entries can own it: an option cannot own a `required` property, and a flag owns no value at all.

```bash
## @param {file} <input> (required) Path to the input file.
```

In JSON form it maps to the `"required": true` property:

```json
{
  "required": true
}
```

### `@constraint`

Entry-scoped: regular expression an entry value must match. In the classic entry grammar it is written as a bare `/regex/` token.

```bash
## @param {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
```

In JSON form it maps to the `"constraint"` property:

```json
{
  "constraint": "/^[a-zA-Z-]+$/"
}
```

### `@param`

Documents a single positional parameter of a function. Position is implied by the order of the `@param` lines (or the order of the `params` array in JSON form). Shares the rich grammar with `@option`, minus the `[short|long]` alias pair.

```bash
## @param  {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
```

### `@option`

Documents a named option that expects a value (`--name` or its short alias). Shares the rich grammar with `@param`, plus the `[short|long]` alias pair. An option cannot own `(required)`: it falls back to its default value.

```bash
## @option {file} <input> [-i|--input] (default:"input.txt") Path to the input file.
```

### `@flag`

Documents a boolean switch (`--name` or its short alias). Shares the rich grammar with `@param`, minus the `{type}` field since a flag carries no value; at runtime it sets its variable to `"true"` or `"false"`. A flag cannot own `(default:value)` either: switches default to `false`.

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
- `bool`: A boolean flag, rendered as `"true"` or `"false"` per the Shoe boolean convention.
- `array`: A list of values.
- `url`: A URL.
- `regex`: A regular expression.
- `path`: A filesystem path, file or folder.
- `file`: A path to a file. The caller is expected to pass a real file.
- `folder`: A path to a directory. The caller is expected to pass a real folder.
- `json`: A JSON document, passed as a string and parsed at use site.

Any other value is rejected by the Shoedoc linter. Type is documentation-first: it is not enforced by the shell runtime.

---

## Where each tag goes

|      Tag      | Script | Constant | Variable | Function | Entry |
|---------------|--------|----------|----------|----------|-------|
| `@author`     | yes    | no       | no       | yes      | no    |
| `@copyright`  | yes    | no       | no       | yes      | no    |
| `@version`    | yes    | no       | no       | yes      | no    |
| `@license`    | yes    | no       | no       | yes      | no    |
| `@link`       | yes    | no       | no       | yes      | no    |
| `@update`     | yes    | no       | no       | no       | no    |
| `@shell`      | yes    | no       | no       | yes      | no    |
| `@namespace`  | no     | no       | no       | yes      | no    |
| `@summary`    | yes    | no       | no       | yes      | no    |
| `@example`    | yes    | no       | no       | yes      | no    |
| `@requires`   | no     | no       | no       | yes      | no    |
| `@depends`    | no     | no       | no       | yes      | no    |
| `@overrides`  | yes    | no       | no       | yes      | no    |
| `@assumes`    | no     | no       | no       | yes      | no    |
| `@private`    | no     | yes      | yes      | yes      | no    |
| `@public`     | no     | yes      | yes      | yes      | no    |
| `@deprecated` | yes    | yes      | yes      | yes      | no    |
| `@type`       | no     | yes      | yes      | no       | yes   |
| `@constant`   | no     | yes      | no       | no       | no    |
| `@variable`   | no     | no       | yes      | no       | no    |
| `@required`   | no     | no       | no       | no       | yes   |
| `@constraint` | no     | no       | yes      | no       | yes   |
| `@param`      | no     | no       | no       | yes      | no    |
| `@option`     | no     | no       | no       | yes      | no    |
| `@flag`       | no     | no       | no       | yes      | no    |
| `@stdout`     | no     | no       | no       | yes      | no    |
| `@stderr`     | no     | no       | no       | yes      | no    |
| `@stdin`      | no     | no       | no       | yes      | no    |

"Entry" covers the objects held by the `params`, `options` and `flags` arrays of a function block. Constants and variables additionally accept a bare `##` description line instead of tags; `@summary` and `@description` are then written as free text rather than tags.
