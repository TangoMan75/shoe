#!/bin/sh

## Install required dependency
_install__require() {
    # Synopsys : _require [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 3 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! -x "$(command -v "$1")" ]; then
        _package_name=${2:-$1}
        if [ -z "$3" ]; then
            _command="sudo apt-get install -y ${_package_name}"
        else
            _command="$3 ${_package_name}"
        fi
        echo_info "${_command}\n"
        ${_command}
    fi
}

