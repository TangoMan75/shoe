#!/bin/sh

## Sniff errors with shellcheck
##
## @namespace recipes/traefik/ci_cd
## @requires find shellcheck sort
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
lint_shell() {
    _check_installed shellcheck

    find . -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

