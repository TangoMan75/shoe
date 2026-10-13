#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Get repository latest release version from github",
##   "requires": [
##     "curl",
##     "grep",
##     "sed"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "REPOSITORY",
##       "type": "str",
##       "description": "Owner and repository name in the form: owner/repository.",
##       "default": null,
##       "nullable": false
##     }
##   ]
## }
function _get_latest_release() {
    if [ ! -x "$(command -v curl)" ]; then
        _echo_danger "error: \"${FUNCNAME[0]}\" requires curl, try: 'sudo apt-get install -y curl'\n"

        return 1
    fi

    local REPOSITORY=$1

    OPTIND=0
    while getopts :h OPTION; do
        case "${OPTION}" in
            h|*) _echo_warning "${FUNCNAME[0]}";
                _echo_success 'description:' 2 14; _echo_primary 'Get repository latest release\n'
                _echo_success 'usage:' 2 14; _echo_primary "${FUNCNAME[0]} [owner/repository] -h (help)\n"
                return 0;;
        esac
    done

    if [ "$#" -lt 1 ]; then
        _echo_danger 'error: some mandatory parameter is missing'
        _echo_success 'usage:' 2 7; _echo_primary "${FUNCNAME[0]} [owner/repository] -h (help)\n"
        return 1
    fi

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($#)\n"
        _echo_success 'usage:' 2 7; _echo_primary "${FUNCNAME[0]} [owner/repository] -h (help)\n"
        return 1
    fi

    curl --silent "https://api.github.com/repos/${REPOSITORY}/releases/latest" |
        grep '"tag_name":' |                                  # find tag name
        sed -E 's/.*"tag_name":[[:space:]]*"([^"]+)".*/\1/' | # extract tag name
        sed -E 's/^[vV]ersion//; s/^[vV]//'                   # remove leading version or v prefix if any
}
