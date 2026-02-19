#!/bin/sh

## Sniff errors with shellcheck
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "find",
##     "shellcheck"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
lint_shell() {
    _check_installed shellcheck

    find . -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

