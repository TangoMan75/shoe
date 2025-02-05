#!/bin/sh

# Remove given package from system
_remove() {
    # Synopsis: _remove <PACKAGE> [PACKAGE_MANAGER]
    #   PACKAGE:         The command/package to remove.
    #   PACKAGE_MANAGER: (optional) The package manager required to remove the package with. Defaults to "apt".
    #   note:            eg: `_remove curl` will remove "curl" with "sudo apt remove --yes curl".
    #                    eg: `_remove adb android-tools-adb` will remove "android-tools-adb" package.

    if [ -z "$1" ]; then echo_danger 'error: _remove: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove: too many arguments (${#})\n"; return 1; fi

    if ! _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_get_package_manager)}"

    if ! _is_installed "$2"; then
        echo_danger "error: _remove \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        echo_info "sudo apk del \"$1\"\n"
        sudo apk del "$1"

    elif [ "$2" = apt ]; then
        echo_info "sudo apt remove --yes \"$1\"\n"
        sudo apt remove --yes "$1"

    elif [ "$2" = apt-get ]; then
        echo_info "sudo apt-get remove --assume-yes \"$1\"\n"
        sudo apt-get remove --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        echo_info "sudo aptitude remove --yes \"$1\"\n"
        sudo aptitude remove --yes "$1"

    elif [ "$2" = dnf ]; then
        echo_info "sudo dnf remove --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf remove --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        echo_info "flatpak remove --non-interactive \"$1\"\n"
        flatpak remove --non-interactive "$1"

    elif [ "$2" = nala ]; then
        echo_info "sudo nala remove --assume-yes \"$1\"\n"
        sudo nala remove --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        echo_info "sudo pacman -Rns \"$1\"\n"
        sudo pacman -Rns "$1"

    elif [ "$2" = snap ]; then
        echo_info "sudo snap remove \"$1\"\n"
        sudo snap remove "$1"

    elif [ "$2" = yum ]; then
        echo_info "sudo yum remove --assumeyes \"$1\"\n"
        sudo yum remove --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        echo_info "sudo zypper remove --non-interactive \"$1\"\n"
        sudo zypper remove --non-interactive "$1"
    fi
}

