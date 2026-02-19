#!/bin/sh

## Build app to destination folder
##
## {
##   "namespace": "npm",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "DESTINATION",
##       "type": "folder",
##       "description": "The path to the destination folder.",
##       "nullable": false
##     }
##   ]
## }
_npm_build() {
    _check_installed npm

    if [ -z "$1" ]; then _echo_error '_npm_build: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_npm_build: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_npm_build: \"$1\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"

    _echo_info 'npm run build\n'
    npm run build
}
