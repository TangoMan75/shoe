#!/bin/sh

## Set value for given parameter into provided file ".env" or ".sh" file
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_echo_warning",
##     "_has_parameter",
##     "_sed_i"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "type": "str",
##       "description": "The variable name to get from provided file.",
##       "nullable": false
##     },
##     {
##       "position": 3,
##       "name": "VALUE",
##       "type": "str",
##       "description": "The value to be set to provided file.",
##       "nullable": false
##     }
##   ]
## }
_set_parameter() {
    # Synopsys : _set_parameter <FILE_PATH> <KEY> <VALUE>
    #   FILE_PATH: The path to the input script.
    #   KEY:       The variable name to set to provided file
    #   VALUE:     The value to be set to provided file

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_set_parameter: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2" "$3"

    if ! _has_parameter "$1" "$2"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_parameter "$1" "$2")" = "$3" ]; then
        _echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    _echo_info "$(_sed_i) -E \"s/^$2=.*/$2=$3/\" \"$1\"\n"
    $(_sed_i) -E "s/^$2=.*/$2=$3/" "$1"
}

