#!/bin/sh

## Check current system is MSYS or MINGW
##
## @namespace src/shell/compatibility
## @requires uname
_is_msys() {
    case "$(uname -s)" in
        MSYS*|MINGW*) return 0 ;;
    esac

    return 1
}

