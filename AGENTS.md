# Shell Scripting Conventions and Guidelines: TangoMan Shoe Style Guide

The following instructions, based on the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html), outline custom rules for generating shell scripts.

These rules govern the creation of new executable shell scripts, emphasizing consistency, maintainability, and security without conflicting with "Google Shell Style Guide" conventions.

**Note:** This guide supports both POSIX-compliant scripts (for maximum portability) and Bash scripts.

---

## 1. General Philosophy

- **Shell Choice:** Choose the appropriate shell for your use case:
  - **POSIX Shell (`#!/bin/sh`)** for maximum portability across Linux, macOS, Android, Docker, LXC.
  - **Bash (`#!/bin/bash`)** when Bash features are needed.
    - Some rules apply to both POSIX and Bash scripts, while others are specific to one or the other. Always check the "POSIX Specific Rules" section for any POSIX-specific guidelines.

## 2. Security

- **Executable Files:** Executables should have a `.sh` extension or **no extension** (if added directly to the user's `PATH`).
- **SUID/SGID:** **SUID and SGID are forbidden** on shell scripts due to security risks. Use `sudo` for elevated access needs.

---

## 3. Formatting

- **Indentation:** **Indent 2 spaces. Do not use tabs** (exception: the body of `<<-` tab-indented here-documents).
- **Line Length:** Maximum line length is **80 characters**. Use here documents (`cat << END ... END`) for long literal strings.
- **Pipelines:** If a pipeline does not fit on one line, split it at one pipe segment per line. Place the pipe operator (`|`, `||`, `&&`) on the newline, using `\` for continuation, followed by a **2-space indent**.
- **Control Flow:** Place `; then` and `; do` on the same line as the opening statement (`if`, `for`, `while`). Place `else` and closing statements (`fi`, `done`) on their own line, vertically aligned with the opening statement.

---

## 4. Naming Conventions

- **Function/Variable Names:** Use **lower-case, with underscores** to separate words (e.g., `my_func`). i.e., Use **snake_case** for all variable and function names (e.g., `variable_name`, `function_name()`). **Do not use dashes in variables and function names**.
- **Function Syntax (POSIX):** Parentheses `()` are required after the function name. Opening brace `{` must be on the same line. (e.g., `function_name() {`). Do **not use the `function` keyword** for POSIX.
- **Function Syntax (Bash):** Both `name() {` and `function name {` syntaxes are allowed.
- **Constants/Environment:** Variables that are constants or exported to the environment must be **capitalized, separated with underscores**.
- **Private Functions:** Prefix private functions with a single underscore (`_`). For example: `_private_function`. These functions are not intended to be called directly from outside the script.
- **Private Variables:** Enclose internal or temporary variable names **with double underscores** (e.g., `__internal_variable__`).

---

## 5. Variables and Quoting

- **Quoting (General):** **Always double-quote strings** containing variables, command substitutions, spaces, or shell meta characters to prevent word splitting and globbing.
- **Variable Expansion:** **Prefer brace-delimiting all variables** (e.g., `"${some_var}"`). (NOTE: Braces are not a form of quoting; double quotes must still be used).
- **Brace-delimiting Exceptions:** Do not use braces for single-character variables, shell special variables, or positional parameters.
  ```shell
  # Correct usage for positional parameters and special variables:
  echo "Positional parameters: $1" "$5" "$3"
  echo "Special variables: $!, $-, $_, $?, $#, $*, $@, $$ …"
  # Braces are required for variables with more than one character or for parameters above $9:
  echo "many parameters: ${10}"
  ```
- **Boolean Values:** Use quoted strings for booleans (e.g., `'true'`/`'false'`) for consistent string comparison.
- **Quoting Arguments:** **Use `"$@"`** when passing arguments to preserve each argument as a separate value. Only use `$*` when you need all arguments concatenated into a single string.

---

## 6. Features and Commands

- **Command Substitution:** Use **`$(command)`** instead of backticks.
- **String Testing:** Prefer the use of **`-z`** (length is zero) over **`-n`** (length is non-zero) for string existence checks, invert logic when necessary.
- **Arithmetic:** Always use **`(( ... ))`** or **`$(( ... ))`**. Avoid `let`, `$[...]`, or `expr`. Omit braces/dollar signs (`${var}` or `$var`) when referencing variables within `((...))` or `$((...))`.
- **Numerical Comparison:** For numerical comparisons, use **`-lt` / `-gt`**. Do not use `<` or `>` inside `[ ... ]` for numerical comparison.
- **Pipes to While:** **Avoid piping directly to `while`** (e.g., `command | while read`). Use process substitution (`< <(command)`) to ensure variables modified within the loop propagate to the parent shell.
- **Wildcard Expansion:** When performing wildcard expansion of filenames, use an **explicit path** (e.g., `./*` instead of `*`) to prevent issues with filenames starting with `-`.
- **Eval:** **`eval` should be avoided**.
- **Aliases:** **Aliases are not allowed** in scripts; use functions instead.
- **String Concatenation:** Prefer the use of `var="${var}value"` instead of `var+=value`.
- **String Equality:** Prefer the use of **`[ "$1" = "$2" ]`** instead of **`[[ "$1" == "$2" ]]`** for POSIX compatibility.
- **Output:** Use `printf '%s'` instead of `echo` for portable output without newline interpretation issues.

## 7. Regular Expressions and BRE/ERE

- **`grep -E`:** Avoid using `grep -E` (`--extended-regexp`). Use basic regular expressions (BRE) instead. Example: `grep -E 'apple|orange'` should be replaced with `grep 'apple\|orange'`.
- **`grep -P`:** Never use `grep -P` (`--perl-regexp`). Use POSIX BRE syntax instead. Example: `grep -Pv '^(#|\s*$)'` should be replaced with `grep -v '^\(#\|[[:space:]]*$\)'`.
- **`sed -E`:** Avoid using `sed -E` (`--extended-regexp`). Use POSIX BRE (Basic Regular Expressions) instead.
- **POSIX Character Classes:** Use character classes like `[:upper:]`, `[:lower:]`, and `[:alnum:]` in both BRE and ERE for better readability and portability.
- **BRE Syntax Differences:** When using BRE, apply these key differences from ERE:
  - Alternation: `\|` instead of `|` (e.g., `\(build\|chore\)`)
  - Quantifiers: `\+` instead of `+`, `\?` instead of `?`, `\{n\}` instead of `{n}`
  - Grouping: `\(` and `\)` instead of `(` and `)`

---

## 8. Error Handling

- **Return Values:** **Always check return values** of commands and provide informative return values. Use `$?` or an `if` statement for unpiped commands. Use `PIPESTATUS` to check return codes of pipeline segments.
- **STDERR:** **All error messages must go to `STDERR`**. A function to print errors with status/timestamp is recommended.
- **Return Codes:** Use explicit return codes: `return 0` for success, `return 1` for failure.
- **Error Messages:** Error messages should mention explicitly from which function it was triggered : e.g., `"error: _greet_user: some mandatory parameter is missing\n"`.

---

## 9. Shoe Recipe and File Structure

- **Constants Location:** Put all constants together in `./constants.sh` file, and all private constants together in `./private_constants.sh` file.
- **Global Variables Location:** Put all global variables together in `./global_variables.sh` file.
- **Options Location:** Put all options together in `./options.sh` file.
- **Flags Location:** Put all flags together in `./flags.sh` file.
- **Functions Locations:** Put each function in it's own `[function_name].sh` file, the file should be named with the exact contained function name.
- **Imports:** Each file should be imported in the `[script_name].shoe` recipe file in the dedicated section.

---

## 10. Output

- Use dedicated semantic functions for colored output: `_echo_primary`, `_echo_secondary`, `_echo_success`, `_echo_danger`, `_echo_warning`, and `_echo_info`.
  - These `_echo_...` functions don't add a trailing newline. An newline character (`\n`) should be added explicitly to the end of the string if a newline is needed.
- For prominent or title messages, use `_alert_...` functions: `_alert_primary`, `_alert_secondary`, `_alert_success`, `_alert_danger`, `_alert_warning`, and `_alert_info`.
  - These `_alert_...` functions automatically add a trailing newline. Do **not** add `\n` to the end of these strings.

---

## 11. Function Annotation

- **Shoedoc:** Document functions using the **Shoedoc** format: a JSON-formatted comment block at the top of each function, describing its parameters and dependencies.

### 11.1. Shoedoc Annotation Format

The **shoedoc** annotation is a JSON object placed in a comment block prefixed with two pond signs (`##`) above the function. It provides structured metadata about the function's purpose, requirements, and parameters.

### 11.2. Shoedoc JSON Fields

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

---

## 12. POSIX Specific Rules

This chapter consolidates all rules that apply specifically to POSIX-compliant shell scripts (`#!/bin/sh`). These rules ensure maximum portability across different Unix-like systems.

### 12.3. Bash builtins

- The following builtins are not available in POSIX sh and are not allowed in POSIX scripts:
  - `bind`, `builtin`, `caller`, `compgen`, `complete`, `compopt`, `declare`, `dirs`, `disown`, `enable`, `fc`, `help`, `history`, `let`, `local`, `logout`, `mapfile`, `popd`, `pushd`, `readarray`, `shopt`, `source`, `suspend`, `type`, `typeset`, `ulimit`

### 12.4. Bash Extensions

- The following Bash extensions are not available in POSIX sh and are **not allowed** in POSIX scripts:
  - `[[ ... ]]` for conditionals
  - `(( ... ))` for arithmetic
  - `declare`, `local`, and `typeset` for variable declarations
  - Arrays (e.g., `array=(value1 value2)`)
  - Brace expansion (e.g., `{1..10}`)
  - Process substitution (e.g., `< <(command)`)
  - Here strings (e.g., `command <<< "input"`)
  - `getopts` for option parsing.

### 12.5. Function Syntax

- Do **not use the `function` keyword** - use `name() {` for POSIX compatibility. The `function` keyword is a Bash extension.

### 12.6. Variables

- **Avoid using variables in private functions.** In POSIX sh, all variables are global by default since `local` variables are not supported. To prevent unintended side effects, minimize variable use in private functions. If variables are unavoidable, enclose their names with double underscores (e.g., `__internal_variable__`) to signal their private intent and reduce naming conflicts. (Note: The `local` keyword is a Bash builtin unavailable in POSIX sh.)
- As an alternative for managing variable scope, use `set --` to append a new positional parameter to the existing ones. For example, if a private function requires a counter variable, you can add it as an additional positional parameter:
  ```shell
  example_function() {
      set -- "$1" 0  # Set a counter reference initialized to 0 as the second positional parameter
      while [ "$2$" -lt 10 ]; do
          printf '%s\n' "$1"
          # Increment $2 (counter) by updating the second positional parameter using `set` keyword instead of a variable
          set -- "$1" "$(($2+1))"
      done
  }
  ```

---

### 12.7. POSIX Compatible Shell Example

```shell
#!/bin/sh

## Greets a specified recipient a given number of times
##
## {
##   "namespace": "test",
##   "summary": "Greets a specified user a given number of times.",
##   "requires": [
##     "printf"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "WHO",
##       "type": "str",
##       "description": "The recipient's name.",
##       "default": "World",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "COUNT",
##       "type": "int",
##       "description": "Number of repetions.",
##       "default": 1
##     }
##   ]
## }
hello() {
    # Check if first positional parameter is empty (mandatory parameter missing)
    if [ -z "$1" ]; then _echo_error 'hello: some mandatory parameter is missing\n'; return 1; fi
    # Check if more than 2 arguments were provided
    if [ $# -gt 2 ]; then _echo_error "hello: too many arguments ($#)\n"; return 1; fi

    # Set positional parameters: WHO=$1, COUNT=$2 (default 1), initialize counter=0 using `set` keywork instead of a variable
    set -- "$1" "${2:-1}" 0
    while [ "$3" -lt "$2" ]; do
        printf 'Hello, %s !\n' "$1"
        # Increment $3 (counter) using `set` keywork instead of a variable
        set -- "$1" "$2" "$(($3+1))"
    done
}
```

## 12. Bash Specific Rules

The following features are allowed in Bash scripts:

- **Function Syntax:** The `function` keyword is mandatory for function declaration in Bash scripts.
- **Local Variables:** The `local` keyword is mandatory in Bash scripts for function-scoped variables.
- **Arrays:** Bash arrays are allowed in Bash scripts.
- **Regex Matching:** The use of the `=~` operator within `[[ ... ]]` for pattern matching is allowed in Bash scripts. Example: `[[ "$1" =~ ^#\ .+ ]]` matches lines starting with `#` followed by a space.
- **Getopts:** The `getopts` builtin is allowed for option parsing in Bash scripts.

### 12.1. Bash Example

```bash
#!/bin/bash

## Greets a specified recipient a given number of times
##
## {
##   "namespace": "test",
##   "summary": "Greets a specified user a given number of times.",
##   "requires": [
##     "getopts",
##     "printf"
##   ],
##   "depends": [
##     "_echo_danger",
##     "_echo_error",
##     "_echo_primary",
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "LBOUND"
##   ],
##   "parameters": [
##     {
##       "name": "who",
##       "type": "str",
##       "description": "The recipient's name.",
##       "default": "World",
##       "nullable": false
##     },
##     {
##       "name": "count",
##       "flag": "-c",
##       "type": "int",
##       "description": "Number of repetions.",
##       "default": 1
##     },
##     {
##       "name": "verbose",
##       "flag": "-v",
##       "type": "int",
##       "description": "Verbose level.",
##       "default": 0
##     }
##   ]
## }
function hello() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'hello [who] -c (count) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local count=1
    local counter=0
    local verbose=0
    local who

    #--------------------------------------------------
    # Parse parameters
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        # This nested loop structure allows to pass arguments and multiple options in any arbitrary order, without affecting the parsing of positional parameters.
        while getopts :c:vh option; do
            case "${option}" in
                c) count="${OPTARG}";;
                v) verbose="$((verbose+=1))";;
                h) _echo_warning 'hello\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Greets a specified recipient a given number of times\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        # The OPTIND reset inside the outer loop is necessary to allow getopts to parse options in any arbitrary order.
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # LBOUND variable allows script to be shell agnostic (unfortunately zsh arrays start at index 1 for some reason)
    who="${arguments[${LBOUND}]}"

    #--------------------------------------------------
    # Validate values
    #--------------------------------------------------

    if [ -z "${who}" ]; then
        _echo_danger 'error: some mandatory parameter is missing\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------

    if [ "${verbose}" -gt 1 ]; then
        _echo_info "verbose level: ${verbose}"
    fi

    while [ "${counter}" -lt "${count}" ]; do
        printf 'Hello, %s !\n' "${who}"
        counter=$((counter+1))
    done

    if [ "${verbose}" -gt 0 ]; then
        _echo_info 'Done.'
    fi
}

hello -c 3 "World" -vv
```
