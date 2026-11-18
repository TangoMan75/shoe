#!/bin/sh

## Create a ".env" file when missing
##
## Creates the parent folder as needed. When a template file is provided
## its contents are copied into the new file.
##
## @namespace src/shell/env
## @requires cp dirname mkdir
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path of the ".env" file to create.
## @param {file} <TEMPLATE> Optional template file to copy into the new file.
_create_env() {
    if [ -z "$1" ]; then _echo_error '_create_env: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_create_env: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$(dirname "$1")" ]; then
        _echo_info "mkdir -p \"$(dirname "$1")\"\n"
        mkdir -p "$(dirname "$1")"
    fi

    if [ -f "$1" ]; then

        return 0
    fi

    if [ -n "$2" ]; then
        if [ ! -f "$2" ]; then _echo_error "_create_env: \"$2\" template not found\n"; return 1; fi

        _echo_info "cp \"$2\" \"$1\"\n"
        cp "$2" "$1"

        return 0
    fi

    : > "$1"
}

