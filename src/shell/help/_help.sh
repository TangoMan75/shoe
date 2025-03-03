#!/bin/sh


# Print help for provider shoe script
#
# {
#   "namespace": "help",
#   "depends": [
#     "_get_constants",
#     "_get_flags",
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
#     }
#   ]
# }
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _help: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _help: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _help: \"$1\" file not found\n"; return 1; fi

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
}

