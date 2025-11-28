#!/bin/sh

## Sniff errors with linter
##
## {
##   "namespace": "app",
##   "requires": [
##     "shellcheck"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
lint() {
    _check_installed shellcheck

    find "${lint_folder}" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

