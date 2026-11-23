#!/bin/sh

## Load environment variables from a ".env" file
##
## Safely loads environment variables from a specified .env file
## into the current shell environment while preserving the
## caller's previous export settings.
##
## @namespace src/shell/env
## @depends src/shell/colors/_echo_error.sh
## @param {file} <FILE_PATH> (required) The path of the ".env" file to load.
_load_env() {
    if [ -z "$1" ]; then _echo_error '_load_env: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_load_env: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_load_env: \"$1\" file not found\n"; return 1; fi

    # "$-" equals "${-%%a*}" when the "a" (allexport) flag is not set
    if [ "$-" = "${-%%a*}" ]; then
        set -a
        # shellcheck source=/dev/null
        if . "$1"; then
            set +a

            return 0
        fi
        set +a

        return 1
    fi

    # Allexport is already enabled: leave it as is
    # shellcheck source=/dev/null
    if . "$1"; then
        return 0
    fi

    return 1
}

