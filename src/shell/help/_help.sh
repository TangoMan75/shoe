#!/bin/sh

## Print help for a shoe script or one of its commands
##
## @namespace src/shell/help
## @requires realpath
## @depends src/shell/colors/_alert_primary
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/help/_print_command_details
## @depends src/shell/help/_print_commands
## @depends src/shell/help/_print_constants
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_infos
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_constants
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_options
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_function_shoedoc
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> The command name to get detailed help for.
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    if [ -z "$2" ]; then
        __padding__=$(_get_padding "$1")
        __annotations__=$(_get_script_shoedoc "$1")

        _alert_primary "$(_get_shoedoc_title "${__annotations__}")"

        _print_infos "$1"
        _print_description "$(_get_shoedoc_description "${__annotations__}")"
        _print_usage "$1"

        if [ -n "$(_get_constants "$1")" ]; then
            _print_constants "$1" "${__padding__}"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            _print_flags "$1" "${__padding__}"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            _print_options "$1" "${__padding__}"
        fi

        _print_commands "$1" "${__padding__}"
        exit 0
    fi

    _alert_primary "$2"
    __annotations__="$(_get_function_shoedoc "$1" "$2")"
    if [ -n "${__annotations__}" ]; then
        _print_command_details "$1" "$2" "${__annotations__}"
        exit 0
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

