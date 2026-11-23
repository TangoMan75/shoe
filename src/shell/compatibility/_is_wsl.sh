#!/bin/sh

## Check current system is Windows Subsystem for Linux
##
## @namespace src/shell/compatibility
## @requires grep
## @assumes WSL_DISTRO_NAME WSL_INTEROP
_is_wsl() {
    if [ -n "${WSL_DISTRO_NAME}" ] || [ -n "${WSL_INTEROP}" ]; then

        return 0
    fi

    if [ -r '/proc/version' ]; then
        if grep -qi 'microsoft' '/proc/version' 2>/dev/null; then

            return 0
        fi
    fi

    return 1
}

