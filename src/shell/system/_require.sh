#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Install required package globally",
##   "description": "eg: `_require curl` will install \"curl\" with \"sudo apt install --yes curl\".\neg: `_require adb` will install \"android-tools-adb\" package.",
##   "requires": [
##     "apt",
##     "apt-get",
##     "install",
##     "snap",
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_get_package_manager",
##     "src/shell/system/_get_package_name",
##     "src/shell/system/_is_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "PACKAGE",
##       "description": "The command/package to remove.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "PACKAGE_MANAGER",
##       "description": "The package manager required to remove the package with.",
##       "type": "str",
##       "default": "apt"
##     }
##   ]
## }
_require() {
    if [ -z "$1" ]; then _echo_error '_require: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_require: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_get_package_manager)}"

    if ! _is_installed "$2"; then
        _echo_error "_require \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        _echo_info "sudo apk add \"$1\"\n"
        sudo apk add "$1"

    elif [ "$2" = apt ]; then
        _echo_info "sudo apt install --yes \"$1\"\n"
        sudo apt install --yes "$1"

    elif [ "$2" = apt-get ]; then
        _echo_info "sudo apt-get install --assume-yes \"$1\"\n"
        sudo apt-get install --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        _echo_info "sudo aptitude install --yes \"$1\"\n"
        sudo aptitude install --yes "$1"

    elif [ "$2" = dnf ]; then
        _echo_info "sudo dnf install --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf install --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        _echo_info "flatpak install --non-interactive flathub \"$1\"\n"
        flatpak install --non-interactive flathub "$1"

    elif [ "$2" = nala ]; then
        _echo_info "sudo nala install --assume-yes \"$1\"\n"
        sudo nala install --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        _echo_info "sudo pacman -Sy \"$1\"\n"
        sudo pacman -Sy "$1"

    elif [ "$2" = snap ]; then
        _echo_info "sudo snap install \"$1\" --classic\n"
        sudo snap install "$1" --classic

    elif [ "$2" = yum ]; then
        _echo_info "sudo yum install --assumeyes \"$1\"\n"
        sudo yum install --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        _echo_info "sudo zypper install --non-interactive \"$1\"\n"
        sudo zypper install --non-interactive "$1"
    fi
}

