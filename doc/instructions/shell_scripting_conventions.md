# POSIX Shell Scripting Conventions and Guidelines

This document outlines conventions and best practices for writing POSIX-compliant shell scripts.

## Function Naming

- Use **snake_case** for all function names (e.g., `hello_world`). Do not use dashes in function names.
- **Private functions:** Prefix internal or "private" functions with a single underscore (`_`). For example: `_private_function`. These functions are not intended to be called directly from outside the script.

## Variables

- In private functions, minimize the use of variables. Prefer using positional parameters by resetting them with `set -- "$1" "$2" ...`.

## Variable Naming

- Use **snake_case** for variable names (e.g., `variable_name`).
- **Private variables:** Enclose internal or temporary variable names with double underscores (e.g., `__internal_variable__`).

## Variable expansion

- **Brace-delimiting:** When expanding variables, use braces (`${var}`) instead of simple quotes (`$var`), e.g., prefer `"${var}"` over `"$var"`.
- **Exceptions:** Do not use braces for single-character variables, shell special variables, or positional parameters.

```shell
# Correct usage for positional parameters and special variables:
echo "Positional parameters: $1" "$5" "$3"
echo "Special variables: $!, $-, $_, $?, $#, $*, $@, $$ …"

# Braces are required for variables with more than one character or for parameters above $9:
echo "many parameters: ${10}"
```

## Quoting

- Always double-quote variables and command substitutions to prevent word splitting and globbing, especially when values may contain spaces or special characters. For example: `"$1"`, `"${__example_variable__}"`.

## Strings

- Use single quotes for string literals unless variable interpolation is needed.

## Output

- Use dedicated functions for colored output: `echo_primary`, `echo_secondary`, `echo_success`, `echo_danger`, `echo_warning`, and `echo_info`.
    - These `echo_...` functions do **not** add a trailing newline. Add `\n` to the end of the string if a newline is needed.
- For prominent or title messages, use `alert_...` functions: `alert_primary`, `alert_secondary`, `alert_success`, `alert_danger`, `alert_warning`, and `alert_info`.
    - These `alert_...` functions automatically add a trailing newline. Do **not** add `\n` to the end of these strings.

## Function Documentation (Shoedoc)

- Document functions using the **shoedoc** format: a JSON-formatted comment block at the top of each function, describing its parameters and dependencies.

### Shoedoc Annotation Format

The **shoedoc** annotation is a JSON object placed in a comment block above the function. It provides structured metadata about the function's purpose, requirements, and parameters.

#### Shoedoc JSON Fields

- **`namespace`**: Logical grouping for related functions.
- **`summary`**: Short description of the function's purpose.
- **`requires`**: Array of external commands required (e.g., `["awk", "sed"]`).
- **`depends`**: Array of other functions this function relies on.
- **`assumes`**: Array of environment variables or constants the function expects to be defined (e.g., `["PRIMARY", "SUCCESS", "WARNING"]`).
- **`parameters`**: Array of parameter objects, each describing a function argument:
    - **`position`**: Argument position (e.g., `1` for the first argument).
    - **`name`**: Parameter name (e.g., `FILE_PATH`).
    - **`type`**: Expected data type (e.g., `file`, `str`).
    - **`description`**: Brief explanation of the parameter.
    - **`default`**: Default value if not provided.
    - **`nullable`**: Boolean indicating if the parameter can be empty.

#### Example

```shell
## Greets a specified recipient a given number of times
##
## {
##   "namespace": "test",
##   "summary": "Greets a specified recipient a given number of times.",
##   "requires": [
##     "printf"
##   ],
##   "depends": [
##     "echo_info"
##   ],
##   "assumes": [
##     "COUNT"
##   ],
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
hello() {
    loop=0
    while [ "${loop}" -lt "${COUNT}" ]; do
        printf 'Hello, %s !\n' "$1"
        loop=$((loop+1))
    done
    echo_info 'Done.'
}
```

## Error Handling

- Use explicit return codes: `return 0` for success, `return 1` for failure.
- Print error messages to standard error, prefixed with a clear indicator such as `error: _help:`.

## Command Substitution

- Always use the modern `$(...)` syntax for command substitution. Do **not** use backticks `` `...` ``.
- Example: `__result__="$(_get_result "$1")"`
