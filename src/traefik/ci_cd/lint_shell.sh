#!/bin/sh

## Sniff errors with shellcheck
lint_shell() {
    find . -type f -name '*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

