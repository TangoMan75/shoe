#!/bin/sh

## Check current system is BSD
##
## @namespace src/shell/compatibility
## @requires uname
_is_bsd() {
    case "$(uname -s)" in
        FreeBSD|OpenBSD|NetBSD|DragonFly) return 0 ;;
    esac

    return 1
}

