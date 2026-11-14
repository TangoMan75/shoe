#!/bin/sh

## Sniff errors with linter
##
## @namespace recipes/entrypoint/app
## @requires find shellcheck sort
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
## @assumes lint_folder
lint() {
    _check_installed shellcheck

    find "${lint_folder}" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

