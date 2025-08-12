#!/bin/sh


# Print help for provider shoe script
#
# {
#   "namespace": "help",
#   "depends": [
#     "_get_constants",
#     "_get_flags",
#     "_get_function_annotation",
#     "_get_options",
#     "_get_padding",
#     "_get_script_shoedoc",
#     "_get_shoedoc_description",
#     "_get_shoedoc_title",
#     "_print_commands",
#     "_print_constants",
#     "_print_description",
#     "_print_flags",
#     "_print_infos",
#     "_print_options",
#     "_print_synopsis",
#     "_print_usage",
#     "alert_primary",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "FUNCTION_NAME",
#       "type": "str",
#       "description": "The function name to get help for.",
#     }
#   ]
# }
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH: The path to the input file.
    #   FUNCTION_NAME: The function name to get help for.

    if [ -z "$1" ]; then echo_danger 'error: _help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then echo_danger "error: _help: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _help: \"$1\" file not found\n"; return 1; fi

    if [ -z "$2" ]; then
        __padding__=$(_get_padding "$1")
        __annotations__=$(_get_script_shoedoc "$1")

        alert_primary "$(_get_shoedoc_title "${__annotations__}")"

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

    alert_primary "$2"
    if [ -x "$(command -v jq)" ]; then
        __json__="$(_parse_annotation "$1" "$2")"
        if [ -n "${__json__}" ]; then
            echo_primary "$(printf '%s' "${__json__}" | jq -r '.summary')\n\n"
            echo_secondary "$(_print_synopsis "${__json__}")\n"
            exit 0
        fi
    fi
    echo_info "$(_get_function_annotation "$0" "$2")"
}

