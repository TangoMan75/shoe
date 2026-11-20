#!/bin/sh

## Sniff errors with linter
##
## @namespace recipes/entrypoint/app
## @requires find grep python3 shellcheck sort
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
lint() {
    _check_installed shellcheck
    _check_installed python3

    # `;&`, `;;&` and `;|` are Bash/ksh extensions, not POSIX.
    if grep -rn --include='*.sh' -- ';&\|;;&\|;|' ./src/shell; then
        _echo_error 'error: non-POSIX case terminators are forbidden in src/shell\n'

        return 1
    fi

    find ./src ./recipes -type f -name '*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck \"${FILE}\"\n"
        SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck "${FILE}"
    done

    find ./build -type f -name '*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done

    _echo_info 'python3 shoemaker.py lint ./build ./recipes ./src\n'
    python3 shoemaker.py lint ./build ./recipes ./src
}

