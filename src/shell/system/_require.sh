#!/bin/sh

# Install required package globally
#
# {
#   "namespace": "system",
#   "requires": [
#     "apt"
#   ],
#   "depends": [
#     "_get_package_manager",
#     "_get_package_name",
#     "_is_installed",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "PACKAGE",
#       "type": "str",
#       "description": "The command/package to remove.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "PACKAGE_MANAGER",
#       "type": "str",
#       "description": "The package manager required to remove the package with.",
#       "default": "apt"
#     }
#   ]
# }
_require() {
    # Synopsis: _require <PACKAGE> [PACKAGE_MANAGER]
    #   PACKAGE:         The command/package to install.
    #   PACKAGE_MANAGER: (optional) The package manager required to install the package with.
    #   note:            eg: `_require curl` will install "curl" with "sudo apt install --yes curl".
    #                    eg: `_require adb` will install "android-tools-adb" package.

    if [ -z "$1" ]; then echo_danger 'error: _require: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then echo_danger "error: _require: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_get_package_manager)}"

    if ! _is_installed "$2"; then
        echo_danger "error: _require \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        echo_info "sudo apk add \"$1\"\n"
        sudo apk add "$1"

    elif [ "$2" = apt ]; then
        echo_info "sudo apt install --yes \"$1\"\n"
        sudo apt install --yes "$1"

    elif [ "$2" = apt-get ]; then
        echo_info "sudo apt-get install --assume-yes \"$1\"\n"
        sudo apt-get install --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        echo_info "sudo aptitude install --yes \"$1\"\n"
        sudo aptitude install --yes "$1"

    elif [ "$2" = dnf ]; then
        echo_info "sudo dnf install --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf install --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        echo_info "flatpak install --non-interactive flathub \"$1\"\n"
        flatpak install --non-interactive flathub "$1"

    elif [ "$2" = nala ]; then
        echo_info "sudo nala install --assume-yes \"$1\"\n"
        sudo nala install --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        echo_info "sudo pacman -Sy \"$1\"\n"
        sudo pacman -Sy "$1"

    elif [ "$2" = snap ]; then
        echo_info "sudo snap install \"$1\" --classic\n"
        sudo snap install "$1" --classic

    elif [ "$2" = yum ]; then
        echo_info "sudo yum install --assumeyes \"$1\"\n"
        sudo yum install --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        echo_info "sudo zypper install --non-interactive \"$1\"\n"
        sudo zypper install --non-interactive "$1"
    fi
}

