#!/bin/sh

## Validate a file checksum
##
## @namespace src/shell/system
## @requires awk printf realpath sha256sum tr
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/system/_check_installed.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <SHA256SUM> (required) A string containing file checksum.
_is_checksum_valid() {
    _check_installed sha256sum

    if [ $# -lt 2 ]; then _echo_error '_is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

    # Compare the full digest: `grep -q "$2"` would accept a truncated
    # checksum, a regular expression or any substring of the hash.
    case "$2" in
        *[!0-9a-fA-F]*|'')
            _echo_error "_is_checksum_valid: invalid checksum \"$2\"\n"

            return 1
            ;;
    esac
    if [ "${#2}" -ne 64 ]; then
        _echo_error "_is_checksum_valid: checksum must be 64 characters\n"

        return 1
    fi

    __checksum__="$(sha256sum "$1" | awk '{print $1}')"
    if [ -z "${__checksum__}" ]; then
        _echo_error "_is_checksum_valid: could not hash \"$1\"\n"

        return 1
    fi

    if [ "${__checksum__}" != "$(printf '%s' "$2" | tr '[:upper:]' '[:lower:]')" ]; then
        return 1
    fi
}

