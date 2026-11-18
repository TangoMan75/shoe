---
name: convert-bash-to-posix-shell
description: Convert Bash scripts to portable POSIX sh by removing bashisms while preserving behavior. Use when asked to convert a Bash script to POSIX shell, make a script work with /bin/sh or dash, replace bashisms, or make a Shoemaker framework module POSIX-compliant.
---

# Convert Bash to POSIX Shell

Produce a `#!/bin/sh` script that behaves like the original Bash script, following the project conventions in `AGENTS.md`. Framework modules under `src/shell/**` additionally follow the strict rules in `AGENTS.md` section 12.8.

Work collaboratively: the user names the target file and any acceptable portability or behavior trade-offs; you inventory the bashisms, rewrite them, and verify the result with syntax checks, ShellCheck, project lint, and tests.

## 1. Resolve the target and its rule set

- Use the file or directory the user named. If none is given, ask; do not
  guess.
- Read the target and `AGENTS.md` sections 3 through 12 before editing.
- Classify the target:
  - **Framework POSIX module** — under `src/shell/**/*.sh`, bundled by Shoemaker. Apply section 12.8: no `case`, no shell variables (use `set --`).
  - **Ordinary POSIX script** — recipes, generated scripts, standalone tools. Apply the general POSIX rules; `case` and variables are allowed, but prefer `set --` in private functions (section 12.6).
- If the target is a test file or a Bash-only script that is not meant to run under `sh`, stop and confirm before converting it.

## 2. Inventory the bashisms

Run ShellCheck in POSIX mode first, then walk this list manually:

```shell
shellcheck -s sh path/to/script.sh
```

Check for:

- shebang `#!/bin/bash` or `#!/usr/bin/env bash`
- `function name {`
- `[[ ... ]]`, `==`, `=~`, `&&` and `||` inside `[[ ]]`
- `(( ... ))` as a command, `let`, `i++`, C-style `for`
- indexed arrays, associative arrays, `mapfile`, `readarray`
- `local`, `declare`, `typeset`, `export -f`
- `source`, `shopt`, `set -o pipefail`, `set -o errtrace`
- brace expansion, process substitution, here-strings
- `$'...'`, `${var,,}`, `${var^^}`, `${!var}`, `${var:offset:length}`
- `$RANDOM`, `$SECONDS`, `$EPOCHSECONDS`, `$BASH_SOURCE`, `$FUNCNAME`
- `echo -e`, `echo -n`, `printf -v`
- `&>`, `&>>`
- `read -p`, `read -n`, `read -s`, `read -a`
- `select`, `getopts`, `pushd`, `popd`
- `trap ... ERR`, `wait -n`, `disown`

The project also forbids `grep -E`, `grep -P`, and `sed -E`; rewrite regexes
as POSIX BRE (AGENTS.md section 7).

## 3. Rewrite common bashisms

|                 Bash                 |                                                  POSIX `sh`                                                  |
|--------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `#!/bin/bash`                        | `#!/bin/sh`                                                                                                  |
| `function foo {` or `function foo()` | `foo() {`                                                                                                    |
| `[[ -f "$1" ]]`                      | `[ -f "$1" ]`                                                                                                |
| `[[ "$a" == "$b" ]]`                 | `[ "$a" = "$b" ]`                                                                                            |
| `[[ "$a" =~ ^x ]]`                   | ordinary: `case "$a" in x*) ... esac`; framework: `if` plus parameter expansion                              |
| `[[ -v var ]]`                       | `[ "${var+x}" = x ]`                                                                                         |
| `(( i++ ))`                          | `i=$((i + 1))`; framework: update a positional parameter                                                     |
| `for ((i=0; i<n; i++))`              | `i=0; while [ "$i" -lt "$n" ]; do ...; i=$((i + 1)); done`                                                   |
| `a=(x y)`, `${a[0]}`, `${#a[@]}`     | `set -- x y`, `$1`, `$#`                                                                                     |
| `local x`                            | no equivalent; use `set --` (framework) or a `__x__` global                                                  |
| `source file`                        | `. file`                                                                                                     |
| `cmd <<< "$x"`                       | `printf '%s\n' "$x" \| cmd`                                                                                  |
| `cmd < <(other)`                     | run `other` into a temp file, then `cmd < "$tmp"`                                                            |
| `cmd &> file`                        | `cmd > file 2>&1`                                                                                            |
| `echo -e "$x"`                       | `printf '%b\n' "$x"`                                                                                         |
| `echo -n "$x"`                       | `printf '%s' "$x"`                                                                                           |
| `printf -v x '%s' ...`               | `x=$(printf '%s' ...)`                                                                                       |
| `read -p 'prompt' x`                 | `printf '%s' 'prompt' >&2; IFS= read -r x`                                                                   |
| `read -s x`                          | `stty -echo`; `IFS= read -r x`; `stty echo` with a `trap`                                                    |
| `mapfile -t a < file`                | ordinary scripts: `set --`; `while IFS= read -r line; do set -- "$@" "$line"; done < file`                   |
| `read -a a`                          | ordinary scripts: `set --`; `while IFS= read -r w; do set -- "$@" "$w"; done`                                |
| `type -t cmd`                        | `command -v cmd`                                                                                             |
| `$RANDOM`                            | `awk 'BEGIN { srand(); print int(rand() * N) }'`                                                             |
| `$SECONDS`                           | `date +%s` (widely supported, not strictly POSIX)                                                            |
| `$BASH_SOURCE`                       | `$0`                                                                                                         |
| `set -o pipefail`                    | no equivalent; use temp files and check each status                                                          |
| `trap ... ERR`                       | no equivalent; check each command explicitly                                                                 |
| `select`                             | `while` menu using `printf` and `read`                                                                       |
| `getopts`                            | project forbids it in POSIX scripts: parse manually with `while [ "$#" -gt 0 ]`, `case` or `if`, and `shift` |
| `pushd` / `popd`                     | `cd` in a subshell, or save and restore the directory                                                        |
| `${var,,}` / `${var^^}`              | `printf '%s' "$var" \| tr '[:upper:]' '[:lower:]'` and `tr '[:lower:]' '[:upper:]'`                          |
| `${var:o:l}`                         | `printf '%s' "$var" \| cut -c "$((o + 1))-$((o + l))"`                                                       |
| `${!var}`                            | no direct equivalent; redesign, or use `eval` only with documented justification                             |
| `$'...'`                             | `printf '%b'` or a literal string                                                                            |
| `declare -A`                         | no equivalent; use a temp file or delimited records                                                          |

Notes:

- A `while` loop fed by a pipeline runs in a subshell, so `set --` changes are lost. Use input redirection (`< file`) or a temp file to keep positional parameters in the current shell.
- `mktemp` and `date +%s` are common but not guaranteed by POSIX. If strict portability is required, use a `$$`-based temp path and document the dependency.
- POSIX `case` is allowed in ordinary scripts. It is forbidden in framework modules; emulate pattern checks with `${1#pattern}`, `${1##pattern}`, `${1%pattern}`, `${1%%pattern}`, and `[ ... ]` comparisons.

## 4. Apply framework module rules (`src/shell/**` only)

These rules apply if and only if the target is a framework POSIX module.
They do not apply to recipes, generated scripts, or test files.

- **No `case ... esac`.** Convert every branch to `if`, `elif`, and `else` using `[ ... ]` tests and parameter expansion.
- **No shell variables.** Do not create, assign, or modify variables, not even temporary or private ones. Store state in positional parameters with `set --` and document each index in a comment. Reading constants and environment variables declared through `@assumes` is allowed.
- Iterate by consuming positional parameters with `while [ "$#" -gt 0 ]; do ...; shift; done`, or delegate to a helper with `"$@"`. Do not use `for name in ...`, because the loop variable is an assignment.
- `read` requires a destination variable, so it cannot be used in a framework module. Use stream tools such as `sed`, `awk`, or `grep`, or have the caller pass items as positional parameters.
- Keep the Shoedoc block complete: `@namespace`, `@requires`, `@depends`, `@assumes`, plus `@param`, `@option`, or `@flag` entries.
- Use `_echo_*` and `_alert_*` for output, send errors to stderr with the function name, and return explicit status codes.
- Follow the formatting rules: 2-space indent, 80 columns, brace-delimited variables, `"$@"`, and `printf` instead of `echo`.
- Do not use `getopts`, `local`, `declare`, the `(( ))` command form, arrays, `[[ ]]`, or the `function` keyword.

```shell
# Bad: case statement and a temporary variable.
_get_ext() {
    file="$1"
    case "${file}" in
        *.gz)  printf 'gzip\n' ;;
        *.bz2) printf 'bzip2\n' ;;
        *)     printf 'unknown\n' ;;
    esac
}

# Good: if/elif and positional parameters only.
_get_ext() {
    if [ "${1##*.}" = 'gz' ]; then
        printf 'gzip\n'
    elif [ "${1##*.}" = 'bz2' ]; then
        printf 'bzip2\n'
    else
        printf 'unknown\n'
    fi
}
```

```shell
# $1: text, $2: repeat count, $3: internal counter.
_repeat() {
    set -- "$1" "$2" 0
    while [ "$3" -lt "$2" ]; do
        printf '%s\n' "$1"
        set -- "$1" "$2" "$(($3 + 1))"
    done
}
```

## 5. Preserve behavior

- Match exit status, stdout versus stderr, argument order, and `--` handling.
- Replace `echo` carefully: `echo -e 'a\nb'` becomes `printf '%b\n' 'a\nb'`, while `echo 'a\nb'` becomes `printf '%s\n' 'a\nb'`.
- Keep quoting unchanged unless the Bash version relied on word splitting; then reproduce the splitting explicitly with `set -- $var` and the intended `IFS`.
- Do not add or remove `set -e` or `set -u` silently. `set -u` is POSIX; `set -o pipefail` is not.
- When no exact POSIX equivalent exists, choose a documented fallback and report the behavior difference. Do not hide it.
- Leave unrelated logic alone so the conversion diff stays reviewable.

## 6. Verify

- Syntax: `sh -n file` and, when installed, `dash -n file`.
- Portability: `shellcheck -s sh file`; resolve every SC3xxx warning or justify it in the report.
- Framework modules: `python3 shoemaker.py lint src` or `make lint`.
- Tests: `./entrypoint.sh tests` for the suite, or `./tests/bash_unit -f tap tests/path/test_file.sh` for one file.
- Behavior: run the original Bash script and the converted script with the same inputs, then diff stdout, stderr, and exit codes.
- Leftovers: grep for `[[`, `local`, `declare`, `function`, `<<<`, `&>`, `$'`, `mapfile`, `readarray`, and `pipefail`. Check for standalone `((` arithmetic commands separately. For framework modules, also grep for `case`, `esac`, and variable assignments.
- Whitespace: `git diff --check`.

## Output

Report, in this order:

1. Files converted and the rule set applied (framework module or ordinary script).
2. A table of bashisms found and the replacement used, including any intentional behavior differences.
3. Verification commands and their results.
4. Remaining risks or unsupported features.

## Success and failure

**Success:** The converted script runs under `sh` and `dash`, passes syntax checks, ShellCheck, project lint, and the relevant tests, preserves observable behavior, and any framework module contains no `case`, no variable assignments, and a complete Shoedoc block.

**Failure:** Bashisms remain, observable behavior changes silently, a framework module still uses `case` or variables, or verification is claimed without being run.
