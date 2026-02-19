#!/bin/sh

## {
##   "namespace": "recipes/traefik/ci_cd",
##   "summary": "Sniff errors with yamllint",
##   "requires": [
##     "find",
##     "read",
##     "sort",
##     "yamllint"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
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

