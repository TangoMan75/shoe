#!/bin/sh

## Return the command that computes a SHA-256 digest
##
## @namespace src/shell/compatibility
## @requires command openssl printf sha256sum shasum
_sha256() {
    set -- sha256sum shasum openssl

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                shasum) set -- 'shasum -a 256' ;;
                openssl) set -- 'openssl dgst -sha256' ;;
            esac

            printf '%s\n' "$1"

            return 0
        fi

        shift
    done

    printf 'error: _sha256: no SHA-256 command found\n' >&2

    return 1
}

