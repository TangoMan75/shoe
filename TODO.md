TODO
====

## Log

```bash
_log() {
    # Synopsis: _log <FILE_PATH> <STRING> [VERBOSE]
    #   FILE_PATH: The log file path.
    #   STRING:    The log string.
    #   VERBOSE:   (optional) print log in the terminal

    printf '%s' "$2" | tee > "$1"
}
```

## Exec

```bash
_exec() {
    # Synopsis: _exec <COMMAND> [VERBOSE]
    #   COMMAND: The command to execute.
    #   VERBOSE: (optional) print log in the terminal.

    printf '%s' "$2" | tee > "$1"
}
```

## Simple annotation system example

> inspiration

- https://jsdoc.app
- https://developer.adobe.com/commerce/php/coding-standards/js-docblock
- https://www.oscprofessionals.com/blog/javascript-docblock-standard-for-magento-module-development
- https://gomakethings.com/documenting-javascript
- https://getcomposer.org/doc/04-schema.md
- https://docs.phpdoc.org/guide/getting-started/what-is-a-docblock.html
- https://docs.phpdoc.org/guide/references/phpdoc/tags/index.html

```
# Script

## Short script description
##
## Long script description
##
## @name        Foobar
## @alias       foobar
## @author      "Matthias Morin" <mat@tangoman.io>
## @copyrights  © 2025 "Matthias Morin" <mat@tangoman.io>
## @version     1.0.0
## @license     MIT
## @repository  https://github.com/TangoMan75/shoe
## @link        https://tangoman.io
## @update      https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh
## @description This script automates foobars in the foobar pipeline
## @usage       foobar <FILE> [OPTION]
## @requires    awk, sed, function, ...
## @env         ENVIRONMENT_VARIABLE, HOME, USER, ...
## @param       n|name    <type> <parameter description>
## @option      -o|option <type> <option description>
## @flag        -f|flag   <type> <flag description>
## @return                <type> <return description>
## @category    foobar
## @tags        foobar1, foobar2, foobar3

# Option

## Short option description / Constraint
##
## Long option description
##
## @shortname   p
## @description The pifpouf name
## @scope       (private|public)
## @type        (str|int|file|folder|path|hex|regex|date|json)
## @constraint  /^[A-Za-z]+$/
## @nullable    (true|false)
## @min_length  3
## @max_length  8
pifpouf='baz'

# Constant

## Short constant description
##
## Long constant description
FOOBAR=foobar

# Flag

## Short flag description
##
## Long flag description
##
## @shortname   f
## @description The foobar flag
## @scope       (private|public)
foobar=false

## Short function description
##
## Long function description / Synopsis
##
## @shortname   f
## @description This function automates foos in the foo pipeline
## @summary     This function automates foos
## @default
## @scope       (private|public)
## @usage       foo <FILE> [OPTION]
## @decorator   _wrapper
## @requires    awk
## @requires    sed
## @assumes     _other_function
## @env         ENVIRONMENT_VARIABLE
## @env         HOME
## @env         USER
## @arg         $1 <name> <type> <description>
## @option      $1 <name> <type> <description> <default=foobar>
## @param       $1 <name> <type> <description>
## @param       {"name":"foobar1","position":1,"type":"int","description":"Lorem ipsum dolor sit amet, consectetur adipiscing elit.","optional":true,"default":5555}
## @param       {"name":"foobar2","position":2,"type":"str","description":"Maecenas ac ligula commodo, lobortis turpis efficitur, semper ipsum.","required":true}
## @return      <type> <description>
## @category    foo
## @method
## @public
## @private
## @desc
## @chainable
## @deprecated
## @param
## @returns
foo() { if [ "$1" -eq 1 ]; then echo "foo"; else echo "bar"; fi; }

## Short function description
##
## Long function description / Synopsis
##
## @shortname   b
## @description This script automates bars in the bar pipeline
## @scope       (private|public)
## @usage       bar <FILE> [OPTION]
## @requires    awk
## @requires    sed
## @requires    _other_function
## @env         ENVIRONMENT_VARIABLE
## @env         HOME
## @env         USER
## @arg         $1 <type> <description>
## @return      <type> <description>
## @category    bar
bar()
{
    _inner_function() {
      echo "$1"
    }

    if [ "$1" -eq 1 ]; then
        _inner_function "bar"
    else
        _inner_function "baz"
    fi
}

## Short function description
##
## Long function description / Synopsis
##
## @shortname   p
## @description This script automates pifpoufs in the pifpouf pipeline
## @scope       (private|public)
## @usage       pifpouf <FILE> [OPTION]
## @requires    awk
## @requires    sed
## @requires    _other_function
## @env         ENVIRONMENT_VARIABLE
## @env         HOME
## @env         USER
## @arg         $1 <int>  <description>
## @arg         $2 <str>  <description>
## @arg         $3 <bool> <description>
## @return      <type> <description>
## @category    pifpouf
pifpouf() {
    if [ "$1" -eq 1 ]; then
        echo "pif"
    fi
    if [ "$2" = "pouf" ]; then
        echo "pouf"
    fi
    if [ "$3" = true ]; then
        echo "true"
    fi
}

# Short private function description
#
# Long private function description / Synopsis
#
# @shortname   p
# @description This script automates pifpoufs in the pifpouf pipeline
# @scope       (private|public)
# @usage       private <FILE> [OPTION]
# @requires    awk
# @requires    sed
# @requires    _other_function
# @env         ENVIRONMENT_VARIABLE
# @env         HOME
# @env         USER
# @arg         $1 <int>  <description>
# @arg         $2 <str>  <description>
# @arg         $3 <bool> <description>
# @return      <type> <description>
# @category    private
private() {
    if [ "$1" -eq 1 ]; then
        echo "private"
    else
        echo "public"
    fi
}
```

## Advanced annotation system

eg:

```
foobar hello --who TangoMan --version
```

|    name    |           description           |
|------------|---------------------------------|
| Command    | can own arguments               |
| Command    | can own flags                   |
| Command    | can own global alias            |
| Command    | can own parameters              |
| Command    | must auto generate help         |
|------------|---------------------------------|
| Arguments  | always optional                 |
| Arguments  | can own flags                   |
| Arguments  | can own parameters              |
|------------|---------------------------------|
| Parameters | scope limited to function       |
| Parameters | can own constraint              |
| Parameters | must own value or default value |
|------------|---------------------------------|
| Options    | can own a scope                 |
| Options    | can own shortname               |
| Options    | can own constraint              |
| Options    | must own value or default value |
|------------|---------------------------------|
| Flags      | can own a scope                 |
| Flags      | must always default to `false`  |
| Flags      | no validation                   |

### Execution Tree

```json
{
  "alias": "foo",
  "name": "foobar",                                                                           // optional, computed
  "summary": "A script annotation example.",                                                  // optional, computed
  "description": "\"foobar\" script demonstrates shoe annotation usage.",                     // optional, computed
  "author": "\"Matthias Morin\" <mat@tangoman.io>",                                           // optional, computed
  "copyrights": "© 2025 \"Matthias Morin\" <mat@tangoman.io>",                                // optional, computed
  "version": "1.0.0",                                                                         // optional, computed
  "license": "MIT",                                                                           // optional, computed
  "repository": "https://github.com/TangoMan75/shoe",                                         // optional, computed
  "link": "https://tangoman.io",                                                              // optional, computed
  "update": "https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh", // optional, computed
  "category": "foobar",                                                                       // optional, computed
  "tags": [                                                                                   // optional, computed
    "foo",
    "bar"
  ],
  "constants": [
    {
      "name": "CONSTANT_EXAMPLE",                                                        // optional, computed
      "value": "foobar",                                                                 // optional, computed
      "summary": "A constant example.",                                                  // optional, computed
      "description": "\"CONSTANT_EXAMPLE\" constant demonstrates shoe annotation usage." // optional, computed
    }
  ],
  "options": [
    {
      "name": "option_example",                                                         // optional, computed
      "summary": "An option example.",                                                  // optional, computed
      "description": "\"option_example\" option demonstrates shoe annotation usage.",   // optional, computed
      "short": "o",
      "default": "default_example_value",
      "constraint": "/[A-Za-z]/"
    }
  ],
  "flags": [
    {
      "name": "flag_example",                                                           // optional, computed
      "summary": "A flag example.",                                                     // optional, computed
      "description": "\"flag_example\" flag demonstrates shoe annotation usage.",       // optional, computed
      "short": "f"
    }
  ],
  "commands": [
    {
      "name": "command_example",                                                        // optional, computed
      "summary": "A command example.",                                                  // optional, computed
      "description": "\"command_example\" command demonstrates shoe annotation usage.", // optional, computed
      "short": "a",
      "requires": [
        "awk",
        "sed"
      ],
      "depends": [
        "_private_function_1",
        "_private_function_2"
      ],
      "assumes": [
        "ENVIRONEMENT_VARIABLE_1",
        "ENVIRONEMENT_VARIABLE_2"
      ],
      "return": "The return value.",
      "decorator": "_wrapper_function",
      "deprecated": "This command is replaced by new_command.",
      "parameters": [
        {
          "name": "required_parameter_example",
          "position": 1,
          "type": "str", // (str|int|file|folder|path|hex|regex|date|json)
          "summary": "A required parameter example.",
          "description": "\"required_parameter_example\" parameter demonstrates shoe annotation usage.",
          "nullable": false,
          "constraint": "/[A-Za-z]+/"
        },
        {
          "name": "optional_parameter_example",
          "position": 2,
          "type": "int",
          "summary": "A optional parameter example.",
          "description": "\"optional_parameter_example\" parameter demonstrates shoe annotation usage.",
          "default": 7,
          "nullable": true,
          "constraint": "/[0-9]/"
        }
      ]
    }
  ]
}
```

## Command

### @requires

- type: array

The _@requires_ tag lists packages required by the documented function.

### @assumes

- type: array

The _@assumes_ tag lists environment or global variables the documented function assumes are set.

### @depends

- type: array

The _@depends_ tag lists functions called by the documented function.

### @deprecated

- type: string

The _@deprecated_ tag declares that the associated function will be removed in a future version as it has become obsolete or its usage is otherwise not recommended.

### Parameters

#### @position

- type: int

The _@position_ tag documents the position which the parameter must be provided, starts from 1.

#### @name

- type: str

The _@name_ tag declares the name of the documented argument.

#### @type

- type: str

The _@type_ tag declares the type of the documented argument.

Valid types can be :

- str: A string
- int: An interger
- file: A file path
- folder: A folder path
- path: Any path
- hex: A string representing a hexadecimal value
- regex: A regular expresion
- date: A date
- json: A json object
- mixed: Any type
- void: Nothing

#### @constraint

- type: regex

The _@constraint_ tag declares the regex pattern matching the documented argument constraint.

#### @default

- type: mixed

The _@default_ tag declares the default value of the documented argument.

#### @description

- type: str

The _@description_ tag provides a general description for the documented argument.

#### @summary

- type: str

The _@summary_ tag provides a shorter version of the full description for the documented argument.

#### @nullable

- type: bool

The _@nullable_ tag indicates that the value of the documented argument can be null.

