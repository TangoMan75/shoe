#!/bin/sh

## Sniff errors with linter
##
## @namespace recipes/entrypoint/app
## @requires find python3 shellcheck sort
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
lint() {
    _check_installed shellcheck
    _check_installed python3

    find ./src ./recipes -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck \"${FILE}\"\n"
        SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck "${FILE}"
    done

    find ./build -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done

    _echo_info 'python3 shoemaker.py lint ./build ./recipes ./src\n'
    python3 shoemaker.py lint ./build ./recipes ./src
}

