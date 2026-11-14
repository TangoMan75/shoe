#!/bin/sh

## Check current system is Cygwin
##
## @namespace src/shell/compatibility
## @requires uname
_is_cygwin() {
    case "$(uname -s)" in
        CYGWIN*) return 0 ;;
    esac

    return 1
}

