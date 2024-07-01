#!/bin/sh

## Check app is installed
_is_installed() {
    # Synopsys : _require [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing.\n'
        return 1
    fi

    if [ ${#} -gt 2 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ -x "$(command -v "$1")" ]; then
        echo true

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then
        echo true

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x /home/linuxbrew/.linuxbrew/bin/"$1" ]; then
        echo true

        return 0
    fi

    echo false
}

