#!/bin/sh

## {
##   "namespace": "src/shell/help",
##   "summary": "Print infos of the provided shoe script (used by \"help\" command)",
##   "requires": [
##     "printf",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning",
##     "src/shell/shoedoc/_get_script_shoedoc",
##     "src/shell/shoedoc/_get_shoedoc_tag"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     }
##   ]
## }
_print_infos() {
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

