#!/bin/sh

## Return the command that opens a file or URL with the default handler
##
## The operating system type is resolved by _os_type, which prefers
## the kernel name reported by uname and falls back to OSTYPE. When the
## type cannot be resolved, _os_type reports the error and _open
## only propagates the failure.
##
## @namespace src/shell/compatibility
## @requires printf
## @depends src/shell/compatibility/_os_type
_open() {
    set -- "$(_os_type)"

    if [ -z "$1" ]; then

        return 1
    fi

    case "$1" in
        cygwin|msys) printf 'start' ; return 0 ;;
        darwin) printf 'open' ; return 0 ;;
        linux) printf 'xdg-open' ; return 0 ;;
    esac

    printf 'error: _open: no default handler for os type: "%s"\n' "$1" >&2

    return 1
}

