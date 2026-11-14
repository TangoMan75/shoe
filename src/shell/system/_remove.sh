#!/bin/sh

## Remove given package from system
##
## eg: `_remove curl` will remove "curl" with "sudo apt remove --yes curl".
## eg: `_remove adb android-tools-adb` will remove "android-tools-adb" package.
##
## @namespace src/shell/system
## @requires apt apt-get snap sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_package_manager src/shell/system/_get_package_name src/shell/system/_is_installed
## @param {str} <PACKAGE> (required) The command/package to remove.
## @param {str} <PACKAGE_MANAGER> (default:"apt") The package manager required to remove the package with.
_remove() {
    if [ -z "$1" ]; then _echo_error '_remove: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove: too many arguments ($#)\n"; return 1; fi

    if ! _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_package_manager)}"

    if ! _is_installed "$2"; then
        _echo_error "_remove \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        _echo_info "sudo apk del \"$1\"\n"
        sudo apk del "$1"

    elif [ "$2" = apt ]; then
        _echo_info "sudo apt remove --yes \"$1\"\n"
        sudo apt remove --yes "$1"

    elif [ "$2" = apt-get ]; then
        _echo_info "sudo apt-get remove --assume-yes \"$1\"\n"
        sudo apt-get remove --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        _echo_info "sudo aptitude remove --yes \"$1\"\n"
        sudo aptitude remove --yes "$1"

    elif [ "$2" = dnf ]; then
        _echo_info "sudo dnf remove --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf remove --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        _echo_info "flatpak remove --non-interactive \"$1\"\n"
        flatpak remove --non-interactive "$1"

    elif [ "$2" = nala ]; then
        _echo_info "sudo nala remove --assume-yes \"$1\"\n"
        sudo nala remove --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        _echo_info "sudo pacman -Rns \"$1\"\n"
        sudo pacman -Rns "$1"

    elif [ "$2" = snap ]; then
        _echo_info "sudo snap remove \"$1\"\n"
        sudo snap remove "$1"

    elif [ "$2" = yum ]; then
        _echo_info "sudo yum remove --assumeyes \"$1\"\n"
        sudo yum remove --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        _echo_info "sudo zypper remove --non-interactive \"$1\"\n"
        sudo zypper remove --non-interactive "$1"
    fi
}

