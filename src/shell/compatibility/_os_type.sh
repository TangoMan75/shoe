#!/bin/sh

## Print the current operating system type
##
## The kernel name reported by uname is normalised to a short lower case
## identifier: bsd, cygwin, darwin, linux or msys. Android, Termux and
## WSL all report a Linux kernel and are therefore reported as linux;
## use the _is_android, _is_termux and _is_wsl helpers when those
## environments need to be distinguished.
##
## uname is part of POSIX and is preferred over OSTYPE, which is a bash
## variable that is not always set and may hold an unexpected value.
##
## @namespace src/shell/compatibility
## @requires printf uname
## @assumes OSTYPE
_os_type() {
    if command -v uname >/dev/null 2>&1; then
        set -- "$(uname -s 2>/dev/null)"
    else
        # (warning): In POSIX sh, OSTYPE is undefined.
        # shellcheck disable=SC3028
        set -- "${OSTYPE:-}"
    fi

    case "$1" in
        Linux*|linux*)
            printf 'linux'
            return 0
            ;;
        Darwin*|darwin*)
            printf 'darwin'
            return 0
            ;;
        FreeBSD*|OpenBSD*|NetBSD*|DragonFly*|freebsd*|openbsd*|netbsd*|dragonfly*)
            printf 'bsd'
            return 0
            ;;
        CYGWIN*|cygwin*)
            printf 'cygwin'
            return 0
            ;;
        MSYS*|MINGW*|msys*|mingw*)
            printf 'msys'
            return 0
            ;;
    esac

    printf 'error: _os_type: unknown os type: "%s"\n' "$1" >&2

    return 1
}

