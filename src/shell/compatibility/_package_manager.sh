#!/bin/sh

## Print the default package manager for the current operating system
##
## The operating system type is resolved by _os_type. Linux
## distributions do not share a single package manager, so the first
## command found among the common ones is printed. Termux is detected
## separately because it reports a Linux kernel but provides its own
## "pkg" wrapper.
##
## @namespace src/shell/compatibility
## @requires apt apt-get command printf snap
## @depends src/shell/compatibility/_is_termux src/shell/compatibility/_os_type
_package_manager() {
    set -- "$(_os_type)"

    if [ -z "$1" ]; then

        return 1
    fi

    if [ "$1" = 'linux' ]; then
        if _is_termux; then
            printf 'pkg'

            return 0
        fi

        set -- apt-get apt aptitude snap flatpak nala apk dnf pacman yum zypper
        while [ $# -gt 0 ]; do
            if command -v "$1" >/dev/null 2>&1; then
                printf '%s' "$1"

                return 0
            fi

            shift
        done

        printf 'error: _package_manager: no package manager found\n' >&2

        return 1
    fi

    case "$1" in
        bsd) printf 'pkg' ; return 0 ;;
        cygwin) printf 'apt-cyg' ; return 0 ;;
        darwin) printf 'brew' ; return 0 ;;
        msys) printf 'pacman' ; return 0 ;;
    esac

    return 1
}

