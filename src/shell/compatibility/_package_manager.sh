#!/bin/sh

## Print the default package manager for the current operating system
##
## The operating system type is resolved by _os_type. Linux
## distributions do not share a single package manager, so the first
## command found among the common ones is printed. Distribution-native
## managers come first, snap and flatpak last, since they are
## distribution-agnostic fallbacks. Termux is detected separately because
## it reports a Linux kernel but provides its own "pkg" wrapper.
##
## @namespace src/shell/compatibility
## @requires apk apt apt-get aptitude command dnf flatpak nala pacman printf snap yum zypper
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/compatibility/_is_termux.sh
## @depends src/shell/compatibility/_os_type.sh
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

        # Distro-native managers come first: snap and flatpak are
        # distribution-agnostic fallbacks, used only when no native
        # manager is available.
        set -- apt-get apt aptitude nala apk dnf pacman yum zypper \
            snap flatpak
        while [ $# -gt 0 ]; do
            if command -v "$1" >/dev/null 2>&1; then
                printf '%s' "$1"

                return 0
            fi

            shift
        done

        _echo_error '_package_manager: no package manager found\n'

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

