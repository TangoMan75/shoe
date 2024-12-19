#!/bin/sh

## Sniff errors with linter
lint() {
    _check_installed shellcheck

    find "${lint_folder}" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

