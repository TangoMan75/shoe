#!/bin/sh

## Print infos of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "depends": [
##     "_get_script_shoedoc",
##     "_get_shoedoc_tag",
##     "_echo_error",
##     "_echo_primary",
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     }
##   ]
## }
_print_infos() {
    # Synopsis: _print_infos <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

    __annotations__=$(_get_script_shoedoc "$1")

    _echo_warning 'Infos:\n'
    _echo_success 'author'  2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    _echo_success 'version' 2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    _echo_success 'link'    2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

