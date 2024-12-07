#!/bin/sh

## Sniff errors with linter
lint() {
    if [ ! -x "$(command -v shellcheck)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
        exit 1
    fi

    find "./build" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

