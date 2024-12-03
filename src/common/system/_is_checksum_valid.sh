#!/bin/sh

# Validate a file checksum
_is_checksum_valid() {
    # Synopsis: _is_checksum_valid <SHA256SUM> <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   SHA256SUM:  A string containing file checksum.

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_checksum_valid: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_checksum_valid: too many arguments (${#})\n"; exit 1; fi

    set -- "$2" "$1" "$(mktemp /tmp/XXXXXXXXXX.sha256)"
    echo "$2  $1" > "$3"

    if sha256sum --status -c "$3"; then

        return 0
    fi

    return 1
}

