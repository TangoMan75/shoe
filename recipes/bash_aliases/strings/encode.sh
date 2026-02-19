#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/strings",
##   "summary": "Encode string from base64 format",
##   "requires": [
##     "base64",
##     "echo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "string",
##       "type": "str",
##       "description": "String to encode to base64.",
##       "required": true
##     }
##   ]
## }
function encode() {
    #--------------------------------------------------
    # Check base64 installation
    #--------------------------------------------------

    if [ ! -x "$(command -v base64)" ]; then
        _echo_danger 'error: base64 required, enter: "sudo apt-get install -y base64" to install\n'
        return 1
    fi

    #--------------------------------------------------

    if [ -z "${*}" ]; then
        _echo_danger 'error: some mandatory argument missing\n'
        _echo_success 0 8 'usage:'; _echo_primary 'encode [string]\n'
        return 1
    fi

    #--------------------------------------------------

    echo "$@" | base64
}
