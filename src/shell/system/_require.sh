#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

# Install required command
_require() {
    # Synopsis: _require <COMMAND> [FROM_PACKAGE_NAME] [PACKAGE_MANAGER]
    #   COMMAND:           The command/package to install.
    #   FROM_PACKAGE_NAME: (optional) The package name where the command should be found (if different). Defaults to "COMMAND".
    #   PACKAGE_MANAGER:   (optional) The package manager required to install the package with. Defaults to "apt".
    #   note:              "FROM_PACKAGE_NAME" is required if you need to set "PACKCAGE_MANAGER" parameter.
    #                      eg: `_require curl` will install "curl" with "sudo apt install --yes curl".
    #                      eg: `_require adb android-tools-adb` will install "android-tools-adb" package.
    #                      eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn".

    if [ ${#} -lt 1 ]; then echo_danger 'error: _require: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _require: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-$1}" "${3:-apt}"

    # define inner function
    __require() {
        echo_info "$1\n"
        $1
    }

    if ! _is_installed "$3"; then
        echo_danger "error: \"$(basename "${0}")\" requires $3, try: 'sudo apt-get install -y $3'\n"
        exit 1
    fi

    if ! _is_installed "$1"; then
        if [ "$3" = apt ]; then
            __require "sudo apt install --yes $1"

        elif [ "$3" = apt-get ]; then
            __require "sudo apt-get install --assume-yes $1"

        elif [ "$3" = dnf ]; then
            __require "sudo dnf install --assumeyes --nogpgcheck -y $1"

        elif [ "$3" = flatpak ]; then
            __require "flatpak install --non-interactive $1"

        elif [ "$3" = pacman ]; then
            __require "sudo pacman -Sy $1"

        elif [ "$3" = yum ]; then
            __require "sudo yum install --assumeyes $1"

        elif [ "$3" = zypper ]; then
            __require "sudo zypper install --non-interactive $1"
        fi
    fi
}

