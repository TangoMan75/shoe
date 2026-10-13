#!/bin/sh

## {
##   "namespace": "src/shell/network",
##   "summary": "Serve given local directory with Python 3",
##   "requires": [
##     "python3",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "DOCROOT",
##       "description": "The path to the root directory.",
##       "type": "folder",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "IP",
##       "description": "Target IP address or domain.",
##       "type": "str",
##       "default": "127.0.0.1"
##     },
##     {
##       "position": 3,
##       "name": "PORT",
##       "description": "Destination port.",
##       "type": "int",
##       "constraint": "/^[0-9]{1,5}$/",
##       "default": "8080"
##     }
##   ]
## }
_py_serve() {
    _check_installed python3

    if [ -z "$1" ]; then _echo_error '_py_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_py_serve: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then _echo_error "_php_serve: \"$1\" folder not found\n"; return 1; fi

    _echo_info "python3 -m http.server --directory \"$1\" --bind \"$2\" \"$3\"\n"
    python3 -m http.server --directory "$1" --bind "$2" "$3"
}

