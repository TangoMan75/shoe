#!/bin/sh

## Print detailed help for a given command
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_warning
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> (required) The command name to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
_print_command_details() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_print_command_details: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_command_details: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "$3"
    if [ ! -f "$1" ]; then _echo_error "_print_command_details: \"$1\" file not found\n"; return 1; fi

    _echo_primary "$(_get_shoedoc_title "$3")\n\n"

    __description__=$(_get_shoedoc_description "$3")
    if [ -n "${__description__}" ]; then
        _print_description "${__description__}"
    fi

    _print_usage "$1" "$2"

    __examples__=$(_get_shoedoc_tag "$3" 'example')
    if [ -n "${__examples__}" ]; then
        _echo_warning 'Examples:\n'
        _echo_primary "${__examples__}\n" 2
        printf '\n'
    fi

    __assumes__=$(_get_shoedoc_tag "$3" 'assumes')
    if [ -n "${__assumes__}" ]; then
        _echo_warning 'Assumes:\n'
        _echo_primary "${__assumes__}\n" 2
        printf '\n'
    fi

    __stdin__=$(_get_shoedoc_tag "$3" 'stdin')
    if [ -n "${__stdin__}" ]; then
        _echo_warning 'Stdin:\n'
        _echo_primary "${__stdin__}\n" 2
        printf '\n'
    fi

    __stdout__=$(_get_shoedoc_tag "$3" 'stdout')
    if [ -n "${__stdout__}" ]; then
        _echo_warning 'Stdout:\n'
        _echo_primary "${__stdout__}\n" 2
        printf '\n'
    fi

    __padding__=$(_get_padding "$1")

    _print_flags "$1" "${__padding__}" "$2"
    _print_options "$1" "${__padding__}" "$2"
}

