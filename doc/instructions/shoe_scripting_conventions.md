# POSIX Shell Scripting Conventions and Guidelines: TangoMan Shoe Style Guide

The following instructions, based on the [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html), outline custom rules for generating POSIX compliant Shell scripts.

These rules govern the creation of new executable POSIX-compliant shell scripts, emphasizing consistency, maintainability, and security without conflicting with "Google Shell Style Guide" conventions.

## 1. General Philosophy and POSIX compatibility

- **Shell Choice:** **POSIX Shell should be prefered over Bash for optimal portability and maximum compatibility** with Linux, MacOS, Android systems, Docker, or LXC containers.
- **Conditionals/Testing:** **Prefer `[ ... ]` or `test`** over `[[ ... ]]`.
- **String Equality:** Use **`=`** for string equality comparison, instead of `==`.
- **String Testing:** Prefer the use of **`-z`** (length is zero) over **`-n`** (length is non-zero) for string existence checks, invert logic when necessary.
- **Numerical Comparison:** For numerical comparisons, use **`-lt` / `-gt`**. Do not use `<` or `>` inside `[ ... ]` for numerical comparison.
- **Builtins:** Prefer external commands (`sed`, `awk`) over built-in bash features (e.g., arrays `( ... )`).
- **Arrays and Lists:** Avoid **Bash arrays** to store lists of elements.

## 2. Security

- **Executable Files:** Executables should have a `.sh` extension or **no extension** (if added directly to the user's `PATH`).
- **SUID/SGID:** **SUID and SGID are forbidden** on shell scripts due to security risks. Use `sudo` for elevated access needs.

## 3. Formatting

- **Indentation:** **Indent 2 spaces. Do not use tabs** (exception: the body of `<<-` tab-indented here-documents).
- **Line Length:** Maximum line length is **80 characters**. Use here documents (`cat << END ... END`) for long literal strings.
- **Pipelines:** If a pipeline does not fit on one line, split it at one pipe segment per line. Place the pipe operator (`|`, `||`, `&&`) on the newline, using `\` for continuation, followed by a **2-space indent**.
- **Control Flow:** Place `; then` and `; do` on the same line as the opening statement (`if`, `for`, `while`). Place `else` and closing statements (`fi`, `done`) on their own line, vertically aligned with the opening statement.

## 3. Naming Conventions

- **Function/Variable Names:** Use **lower-case, with underscores** to separate words (e.g., `my_func`). i.e., Use **snake_case** for all variable and function names (e.g., `variable_name`, `function_name()`). **Do not use dashes in variables and function names**.
- **Function Syntax:** Parentheses `()` are required after the function name. Braces `{}` must be on the same line.
- **Constants/Environment:** Variables that are constants or exported to the environment must be **capitalized, separated with underscores**.
- **Private Functions:** Prefix private functions with a single underscore (`_`). For example: `_private_function`. These functions are not intended to be called directly from outside the script.
- **Private Variables:** Enclose internal or temporary variable names **with double underscores** (e.g., `__internal_variable__`).

## 4. Variables and Quoting

- **Variable Expansion:** **Prefer brace-delimiting all variables** (e.g., `"${some_var}"`). (NOTE: Braces are not a form of quoting; double quotes must still be used).
- **Brace-delimiting Exceptions:** Do not use braces for single-character variables, shell special variables, or positional parameters.
    ```shell
    # Correct usage for positional parameters and special variables:
    echo "Positional parameters: $1" "$5" "$3"
    echo "Special variables: $!, $-, $_, $?, $#, $*, $@, $$ …"
    # Braces are required for variables with more than one character or for parameters above $9:
    echo "many parameters: ${10}"
    ```
- **Variables in Private Functions:** Minimize the use of variables **in private functions**. Prefer using positional parameters by resetting them with `set -- "$1" "$2" ...`.
- **Quoting (General):** **Always double-quote strings** containing variables, command substitutions, spaces, or shell meta characters to prevent word splitting and globbing.
- **Quoting Arguments:** **Use `"$@"`** when passing arguments, unless a specific reason exists to use `$*`.

## 5. Features and Commands

- **Command Substitution:** Use **`$(command)`** instead of backticks (`` `command` ``).
- **String Testing:** Explicitly use **`-z`** (length is zero) or **`-n`** (length is non-zero) for string existence checks.
- **Arithmetic:** Always use **`(( ... ))`** or **`$(( ... ))`**. Avoid `let`, `$[...]`, or `expr`. Omit braces/dollar signs (`${var}` or `$var`) when referencing variables within `((...))` or `$((...))`.
- **Pipes to While:** **Avoid piping directly to `while`** (e.g., `command | while read`). Use process substitution (`< <(command)`) to ensure variables modified within the loop propagate to the parent shell.
- **Wildcard Expansion:** When performing wildcard expansion of filenames, use an **explicit path** (e.g., `./*` instead of `*`) to prevent issues with filenames starting with `-`.
- **Eval:** **`eval` should be avoided**.
- **Aliases:** **Avoid aliases** in scripts; use functions instead.

## 6. Error Handling

- **Return Values:** **Always check return values** of commands and provide informative return values. Use `$?` or an `if` statement for unpiped commands. Use `PIPESTATUS` to check return codes of pipeline segments.
- **STDERR:** **All error messages must go to `STDERR`**. A function to print errors with status/timestamp is recommended.
- **Return Codes:** Use explicit return codes: `return 0` for success, `return 1` for failure.
- **Error Messages:** Error messages should mention explicitly from which function it was triggered : e.g., `"error: _greet_user: some mandatory parameter is missing\n"`.

## 7. Shoe Recipe and File Structure

- **Constants Location:** Put all constants together in `./constants.sh` file, and all private constants together in `./private_constants.sh` file.
- **Global Variables Location:** Put all global variables together in `./global_variables.sh` file.
- **Options Location:** Put all options together in `./options.sh` file.
- **Flags Location:** Put all flags together in `./flags.sh` file.
- **Functions Locations:** Put each function in it's own `[function_name].sh` file, the file should be named with the exact contained function name.
- **Imports:** Each file should be imported in the `[script_name].shoe` recipe file in the dedicated section.

## 5. Output

- Use dedicated semantic functions for colored output: `echo_primary`, `echo_secondary`, `echo_success`, `echo_danger`, `echo_warning`, and `echo_info`.
    - These `echo_...` functions don't add a trailing newline. An newline character (`\n`) should be added explicitly to the end of the string if a newline is needed.
- For prominent or title messages, use `alert_...` functions: `alert_primary`, `alert_secondary`, `alert_success`, `alert_danger`, `alert_warning`, and `alert_info`.
    - These `alert_...` functions automatically add a trailing newline. Do **not** add `\n` to the end of these strings.

## 6. Function Annotation

- **Shoedoc:** Document functions using the **Shoedoc** format: a JSON-formatted comment block at the top of each function, describing its parameters and dependencies.

### 6.1. Shoedoc Annotation Format

The **shoedoc** annotation is a JSON object placed in a comment block prefixed with two pond signs (`##`) above the function. It provides structured metadata about the function's purpose, requirements, and parameters.

#### 6.2. Shoedoc JSON Fields

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

#### 6.3. Example

```shell
## Greets a specified recipient a given number of times
##
## {
##   "namespace": "test",
##   "summary": "Greets a specified user a given number of times.",
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

