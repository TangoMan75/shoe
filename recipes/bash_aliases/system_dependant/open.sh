#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/system_dependant",
##   "summary": "Open file or folder with appropriate app",
##   "requires": [
##     "open",
##     "start",
##     "xdg-open"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger"
##   ],
##   "assumes": [
##     "OSTYPE"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "path",
##       "type": "str",
##       "description": "File or folder path to open.",
##       "nullable": false
##     }
##   ]
## }
function open() {
    local ARGUMENTS

    ARGUMENTS=()
    for ARGUMENTS in "${@}"; do
        case "${OSTYPE}" in
            'cygwin'|'msys')
                start "${ARGUMENTS}";;
            'darwin'*)
                open "${ARGUMENTS}";;
            'linux-gnu'|'linux-androideabi')
                xdg-open "${ARGUMENTS}" &>/dev/null;;
            *) _echo_danger "error: ostype: \"${OSTYPE}\" is not handled\n"; return 1;;
        esac
    done
}
