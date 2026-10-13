#!/bin/sh

## {
##   "namespace": "src/shell/help",
##   "summary": "Print help for provider shoe script",
##   "requires": [
##     "jq",
##     "printf",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_secondary",
##     "src/shell/help/_print_commands",
##     "src/shell/help/_print_constants",
##     "src/shell/help/_print_description",
##     "src/shell/help/_print_flags",
##     "src/shell/help/_print_infos",
##     "src/shell/help/_print_options",
##     "src/shell/help/_print_usage",
##     "src/shell/reflexion/_get_constants",
##     "src/shell/reflexion/_get_flags",
##     "src/shell/reflexion/_get_options",
##     "src/shell/reflexion/_get_padding",
##     "src/shell/reflexion/_print_synopsis",
##     "src/shell/shoedoc/_get_function_shoedoc",
##     "src/shell/shoedoc/_get_script_shoedoc",
##     "src/shell/shoedoc/_get_shoedoc_description",
##     "src/shell/shoedoc/_get_shoedoc_title",
##     "src/shell/shoedoc/_parse_shoedoc"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "description": "The function name to get help for.",
##       "type": "str"
##     }
##   ]
## }
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

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
    if [ -x "$(command -v jq)" ]; then
        __json__="$(_parse_shoedoc "$1" "$2")"
        if [ -n "${__json__}" ]; then
            _echo_primary "$(printf '%s' "${__json__}" | jq -r '.summary')\n\n"
            _echo_secondary "$(_print_synopsis "${__json__}")\n"
            exit 0
        fi
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

