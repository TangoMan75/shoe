#!/bin/sh

## Validate a file checksum
_is_checksum_valid() {
    # synopsys: _is_checksum_valid [sha256sum] [file_path]
    if [ ${#} -lt 2 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_danger "error: too many arguments (${#})\n"
        return 1
    fi

    set -- "$1" "$2" "$(mktemp /tmp/XXXXXXXXXX.sha256)"
    echo "$1  $2" > "$3"

    if sha256sum --status -c "$3"; then
        echo true

        return 0
    fi

    echo false
}

