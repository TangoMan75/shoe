#!/bin/sh

## Sniff errors with yamllint
lint_yaml() {
    # https://yamllint.readthedocs.io
    find . -type f -iregex '.+\.ya?ml' | sort -t '\0' -n | while read -r FILE; do
        echo_info "yamllint \"${FILE}\"\n"
        yamllint "${FILE}"
    done
}

