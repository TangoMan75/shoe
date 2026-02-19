#!/bin/sh

## Sniff errors with yamllint
##
## {
##   "namespace": "ci_cd",
##   "requires": [
##     "find",
##     "read",
##     "sort",
##     "yamllint"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
lint_yaml() {
    _check_installed yamllint

    # https://yamllint.readthedocs.io
    find . -type f -iregex '.+\.ya?ml' | sort -t '\0' -n | while read -r FILE; do
        _echo_info "yamllint \"${FILE}\"\n"
        yamllint "${FILE}"
    done
}

