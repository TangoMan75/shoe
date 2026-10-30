# Shoedoc Vocabulary

Shoedoc is the documentation system to describe shell scripts and their functions. Inspired by [Javadoc](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/javadoc.html), [JSDoc](https://jsdoc.app) and [PHPDoc](https://docs.phpdoc.org/guide/references/phpdoc/index.html), [Composer](https://getcomposer.org/doc/04-schema.md), this metadata can be used to auto-generate documentation and unit tests, enable type safety and self-validation.

This document lists every tag the framework understands, what it is for, where it belongs, and how to write it.

## Table of contents

- [Shoedoc at a glance](#shoedoc-at-a-glance)
- [Script](#script)
- [Script level constants](#script-level-constants)
- [Script level variables](#script-level-variables)
- [Source comments](#source-comments)
- [Function](#function)
- [Options and flags](#options-and-flags)
- [Entry object fields](#entry-object-fields)
- [Tags reference](#tags-reference)
- [Recognized `type` values](#recognized-type-values)
- [Where each tag goes](#where-each-tag-goes)

---

## Shoedoc at a glance

A Shoedoc block is a run of consecutive `##` comment lines placed directly above the declaration it documents, or just below the shebang for a script file. It opens with a title (a one-line summary), optionally followed by a blank `##` line and a longer description, then the metadata.

Block and entry metadata can be written in two formats, with a few classic-only limitations noted below:

- The **classic** `@`-prefixed form: one tag per line, easy to hand-write.
- The **JSON** form: the same data carried by a single object, describing each parameter, option and flag precisely.

Shoedoc documents six kinds of elements:

|                Element                |                        What it describes                         |
|---------------------------------------|------------------------------------------------------------------|
| [Script](#script)                     | File-level metadata (authors, version, license, links…).         |
| [Constants](#script-level-constants) | Immutable value declarations.                                    |
| [Variables](#script-level-variables) | Mutable value declarations.                                      |
| [Function](#function)                 | Functions that take parameters, options and flags.               |
| [Options](#options-and-flags)         | Named values passed to a function (`--name` or its short alias). |
| [Flags](#options-and-flags)           | Boolean switches passed to a function.                           |

### What this document describes

Shoedoc distinguishes three layers:

| Layer | What it is | Where it is documented |
|-------|------------|------------------------|
| Block metadata | Properties of a script or function block. | [Script](#script), [Function](#function) |
| Entry objects | Objects in the `params`, `options`, `flags`, `constants` and `variables` arrays. | [Entry object fields](#entry-object-fields) |
| Source comments | Bare `##` lines above assignments, read by `generate_doc`. | [Source comments](#source-comments) |

The JSON and classic forms describe the first two layers. Source comments are a separate documentation convention and are not Shoedoc tags. The JSON Schemas below describe the recommended shape; the linter validates the properties that are present and is more lenient about missing optional metadata.

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
      "description": "List of authors that contributed to the package. This is typically the main maintainers, not the full list.",
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
      "description": "Version string. Recommended to follow Semantic Versioning (MAJOR.MINOR.PATCH)."
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
    "depends": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "description": "Shoedoc modules the script calls, sorted alphabetically, as relative paths without extension.",
      "items": {
        "type": "string",
        "minLength": 1
      }
    },
    "overrides": {
      "type": "string",
      "description": "The single core module the script deliberately replaces.",
      "pattern": "^src/([a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?/)*[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)?$"
    },
    "assumes": {
      "type": "array",
      "minItems": 1,
      "uniqueItems": true,
      "description": "Environment variables or constants the script expects to be defined, sorted alphabetically.",
      "items": {
        "type": "string",
        "minLength": 1
      }
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
    "constants": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "name": {"type": "string"},
          "summary": {"type": "string"},
          "description": {"type": "string"},
          "private": {"type": "boolean"},
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
          "deprecated": {"type": "string"}
        }
      }
    },
    "variables": {
      "type": "array",
      "minItems": 1,
      "items": {
        "type": "object",
        "additionalProperties": false,
        "properties": {
          "name": {"type": "string"},
          "summary": {"type": "string"},
          "description": {"type": "string"},
          "private": {"type": "boolean"},
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
          "constraint": {"type": "string"},
          "deprecated": {"type": "string"}
        }
      }
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
| `name`                              | — (JSON only)                              |
| `summary`                           | block title (`##` lines before first blank separator) |
| `description`                       | `##` lines after the first blank separator |
| `authors`                           | `@author` (one per line)                   |
| `copyright`                         | `@copyright`                               |
| `version`                           | `@version`                                 |
| `license`                           | `@license`                                 |
| `links`                             | `@link` (repeatable: one entry per tag)    |
| `update`                            | `@update`                                  |
| `depends`                           | `@depends`                                 |
| `overrides`                         | `@overrides`                               |
| `assumes`                           | `@assumes`                                 |
| `type`                              | `@type`                                    |
| `examples`                          | `@example` (one per line)                  |
| `deprecated`                        | `@deprecated`                              |

A script block cannot own function-only properties: `namespace`, `requires`, `params`, `options`, `flags`, `stdout`, `stderr` and `stdin`. It may own `depends`, `overrides` and `assumes` at script scope, where they describe the script as a whole. `copyright` is part of the script metadata.

---

## Script level constants

Constants document immutable value declarations. They are entry objects in the `constants` array of a script block; the classic form uses the `@constant` tag.

### Classic Syntax

The name may be omitted from the tag. Include `name` in JSON when the entry must be identified.

```bash
## @constant {str} Script alias - Used to execute the script when installed on host machine.
SCRIPT_ALIAS="shoemaker"
```

### JSON Syntax

A constants entry lives in the `constants` array of a script block. The example shows only that array; combine it with the script metadata from [Script](#script).

```bash
## {
##   "constants": [
##     {
##       "name": "SCRIPT_ALIAS",
##       "summary": "Alias for this script",
##       "description": "Used to execute the script when installed on host machine.",
##       "type": "str",
##       "private": false
##     }
##   ]
## }
SCRIPT_ALIAS="shoemaker"
```

### Entry JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "description": "Constants entry. The linter accepts any subset of these fields; name and type are recommended.",
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
  "additionalProperties": false
}
```

---

## Script level variables

Variables document mutable value declarations. They are entry objects in the `variables` array of a script block; the classic form uses the `@variable` tag.

### Classic Syntax

The name may be omitted from the tag. The `{type}` and optional `/constraint/` tokens belong to the entry value.

```bash
## @variable {str} /^[a-zA-Z-]+$/ Default recipient name - The name to greet.
default_name="World"
```

### JSON Syntax

A variables entry lives in the `variables` array of a script block. The example shows only that array; combine it with the script metadata from [Script](#script).

```bash
## {
##   "variables": [
##     {
##       "name": "default_name",
##       "summary": "Default recipient name",
##       "description": "The name to greet.",
##       "type": "str",
##       "private": false,
##       "constraint": "/^[a-zA-Z-]+$/"
##     }
##   ]
## }
default_name="World"
```

### Entry JSON Schema

```json
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "type": "object",
  "description": "Variables entry. The linter accepts any subset of these fields; name and type are recommended.",
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
  "additionalProperties": false
}
```

---

## Source comments

`generate_doc` also documents script-level assignments from a bare `##` line immediately above the assignment. This is a separate convention, not a Shoedoc block: it carries no `{type}`, `@constraint` or `@variable` tag.

```bash
## Default recipient name
default_name="World"
```

The shell generator also recognises a trailing `/regex/` on an option description:

```bash
## Greeting recipient name /^[a-zA-Z-]+$/
who="World"
```

The Python generator currently uses the whole line as the description. Keep constraints in Shoedoc entries when you need them validated by the linter.

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
## @requires echo getopt
## @param {str} <who> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
## @option {int} <count> [-c|--count] (default:1) The repetition count.
## @flag <prefix> [-p|--prefix] Prefix output with a line number.
hello() {
    local who=World
    local count=1
    local prefix='false'

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
                prefix='true'
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
        if [ "${prefix}" = 'true' ]; then
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
##     "getopt"
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
      "description": "Function version. Recommended to follow Semantic Versioning (MAJOR.MINOR.PATCH)."
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

The Function block also accepts the generic block tags listed in [Where each tag goes](#where-each-tag-goes); each maps to the JSON key of the same name.

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
| `position` | optional | forbidden | forbidden | forbidden | forbidden |
| `private` | forbidden | forbidden | forbidden | optional | optional |
| `deprecated` | forbidden | forbidden | forbidden | optional | optional |

### `name`

The entry name; authoritative, since entries annotate no declaration. A `params` entry may include several pipe-separated aliases. Every alias refers to the same argument position. `options`, `flags`, `constants` and `variables` take one identifier. The linter accepts a missing `name` for `constants` and `variables`; include it when the entry must be identified.

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

When a `constants` or `variables` entry omits `name`, it simply has no `name` field. The generated documentation derives script-level assignment names from the declarations, not from the entry.

### `position`

1-based index of a positional parameter in the `params` array. In the classic form it is implied by the order of the `@param` lines. In JSON form it is optional: when omitted, the entry's rank in the array supplies it; when present, it must match that rank. Params only: options, flags, constants and variables are addressed by name, not by position.

```json
{
  "position": 1,
  "name": "SCRIPT_PATH"
}
```

For optional parameters, the position is still the slot the argument occupies when present, even if the parameter has a default.

### `summary`

Short one-line description of the entry, rendered before the long description in the classic form. Initializes the summary part of the `@param`/`@option`/`@flag` value, before the ` - ` separator. A summary without a description does not round-trip through the classic form: without the separator, the text is parsed as the description.

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

Regular expression the entry value must match. Used to validate input at the boundary. Maps to the `/regex/` token in the classic form. A variable **can** own a `constraint` property so the runtime can validate its value; include it when validation is required.

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

Boolean indicating whether the entry is mandatory (`true`) or optional (`false`). Maps to the `(required)` token in the classic form. When omitted, `optional` is the default. Params only: an option cannot own a `required` property, and `required: true` cannot coexist with a `default` value. `required: false` may coexist with a default.

```json
{
  "required": true
}
```

### `default`

Default value used when the caller does not pass the entry. Params and options only: flags cannot own a default. An entry that owns a `default` value is implicitly `optional`; a `required: true` entry cannot own one. Maps to the `(default:value)` token in the classic form.

```json
{
  "default": "World"
}
```

### `private`

Boolean marking a `constants` or `variables` entry as private. JSON only for individual entries: the classic `@private` tag applies to the whole block, not to one entry.

```json
{
  "private": true
}
```

### `deprecated`

Free-form string marking the entry as deprecated. Only `constants` and `variables` entries (and whole blocks) may be deprecated: `params`, `options` and `flags` entries cannot own a `deprecated` property. In classic form, `@deprecated` applies to the whole block; entry-level deprecation is JSON-only.

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

Canonical URL pointing to the project, the documentation, or the source repository. A script or function may own several links: repeat the tag, one entry per occurrence. The tag maps to the `"links"` array in JSON form.

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

Raw URL pointing to the latest version of the script or function.

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
## @requires  echo getopt
```

```bash
## @requires  echo
## @requires  getopt
```

The classic form splits on whitespace, so a grouped command with arguments (for example `git status`) can only be represented in JSON.

Or in JSON form:

```bash
## {
##   "requires": ["echo", "getopt"]
## }
```

### `@depends`

Array of other functions this block calls. Used by the documentation generator to build the "Depends" graph and by callers who want to know what to import. A script or function may own this property.

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

The core module a script or function deliberately replaces. A block can override one module only, so the value is a single relative path. A `.sh` module under `recipes/` **should** own this property when it defines a function with the same name as a core module under `src/`: the build leaves the superseded core module out when another component reaches it through its transitive `depends`, so the overriding module is the only definition in the built script.

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

Marks a function or value as private, ie not part of the public API. The documentation generator may hide private entries from the generated markdown. In classic form the tag applies to the whole block; JSON `constants` and `variables` entries may carry `private` individually.

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

Marks a function or value as public, ie part of the exposed API. This is the default when neither `@private` nor `@public` is present. In classic form the tag applies to the whole block; JSON `constants` and `variables` entries may carry `private: false` individually.

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

Marks a script, function, value, constant or variable as deprecated. The value is a free-form string, typically the reason for deprecation or the version that superseded the element. `params`, `options` and `flags` entries cannot be deprecated. In classic form the tag applies to the whole block; entry-level deprecation of a constant or variable is JSON-only.

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

Block-level type metadata. The tag is written with braces and maps to the top-level `"type"` property of a script or function block. See [Recognized `type` values](#recognized-type-values) for the list.

```bash
## @type {file}
```

In JSON form the tag maps to the `"type"` property:

```json
{
  "type": "file"
}
```

Entry types are written with the `{type}` token inside `@param`, `@option`, `@constant` and `@variable`, not with a standalone `@type` tag; see [Entry object fields](#entry-object-fields).

### `@constant`

Documents a constant declaration. In classic form the name may be omitted from the tag; in JSON form include `name` when the entry must be identified.

```bash
## @constant {str} Default recipient name - Used when no name is supplied.
DEFAULT_NAME="World"
```

In JSON form the tag maps to a `constants` entry of the script block. Only the array is shown; combine it with the script metadata from [Script](#script).

```json
{
  "constants": [
    {
      "name": "DEFAULT_NAME",
      "type": "str",
      "summary": "Default recipient name",
      "description": "Used when no name is supplied.",
      "private": false
    }
  ]
}
```

### `@variable`

Documents a variable declaration. In classic form the name may be omitted from the tag; in JSON form include `name` when the entry must be identified. A variable **can** carry a `/constraint/` so the runtime can validate its value.

```bash
## @variable {str} /^[a-zA-Z-]+$/ Greeting recipient name - The name to greet.
who="World"
```

In JSON form the tag maps to a `variables` entry of the script block. Only the array is shown; combine it with the script metadata from [Script](#script).

```json
{
  "variables": [
    {
      "name": "who",
      "type": "str",
      "constraint": "/^[a-zA-Z-]+$/",
      "summary": "Greeting recipient name",
      "description": "The name to greet.",
      "private": false
    }
  ]
}
```

### `@required` / `(required)`

Entry-scoped token, not a standalone tag. In classic entry grammar it is written as the `(required)` token inside a `@param` value. Only `params` entries can own it: an option cannot own a `required` property, and a flag owns no value at all. `required: true` is mutually exclusive with `default`; `required: false` may coexist with a default.

```bash
## @param {file} <input> (required) Path to the input file.
```

In JSON form it maps to the `"required": true` property:

```json
{
  "required": true
}
```

### `@constraint` / `/regex/`

Entry-scoped token, not a standalone tag. In classic entry grammar it is written as a bare `/regex/` token inside a `@param`, `@option` or `@variable` value.

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
| `@author` | yes | yes | |
| `@copyright` | yes | yes | |
| `@version` | yes | yes | |
| `@license` | yes | yes | |
| `@link` | yes | yes | Repeatable. |
| `@update` | yes | yes | |
| `@shell` | yes | yes | |
| `@namespace` | no | yes | Function-only. |
| `@summary` | yes | yes | |
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
| `short` / `long` | no | yes | yes | no | no |
| `(default:value)` | yes | yes | no | no | no |

`@private` and `@deprecated` are block tags. JSON entries for constants and variables may also carry `private` and `deprecated`, but classic `@private` and `@deprecated` apply to the whole block.

`@constant` and `@variable` create entries in a block's `constants` and `variables` arrays. They are documented at script scope; the parser also accepts them in function blocks, where they have no function-level effect. `@param`, `@option` and `@flag` are documented at function scope; the parser also accepts them in script blocks, where they have no script-level effect. A bare `##` description line above an assignment is a `generate_doc` source-comment convention, not a Shoedoc tag; see [Source comments](#source-comments).
