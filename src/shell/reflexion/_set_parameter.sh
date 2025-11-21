#!/bin/sh

# Set value for given parameter into provided file ".env" or ".sh" file
#
# {
#   "namespace": "reflexion",
#   "requires": [
#     "sed"
#   ],
#   "depends": [
#     "_sed_i",
#     "echo_danger",
#     "echo_info",
#     "echo_warning"
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
#       "name": "KEY",
#       "type": "str",
#       "description": "The variable name to get from provided file.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "VALUE",
#       "type": "str",
#       "description": "The value to be set to provided file.",
#       "nullable": false
#     }
#   ]
# }
_set_parameter() {
    # Synopsys : _set_parameter <FILE_PATH> <KEY> <VALUE>
    #   FILE_PATH: The path to the input script.
    #   KEY:       The variable name to set to provided file
    #   VALUE:     The value to be set to provided file

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then echo_danger 'error: _set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then echo_danger "error: _set_parameter: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2" "$3"

    if [ ! -f "$1" ]; then echo_danger "error: _set_parameter: \"$1\" file not found\n"; return 1; fi

    if [ -z "$(_get_parameter "$1")" ]; then
        echo_danger "error: _set_parameter: \"$1\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_parameter "$1")" = "$2" ]; then
        echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    echo_info "$(_sed_i) -E \"s/^$2=.*/$2=$3/\" \"$1\"\n"
    $(_sed_i) -E "s/^$2=.*/$2=$3/" "$1"
}

