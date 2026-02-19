#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/system",
##   "summary": "Change files mode recursively",
##   "requires": [
##     "chmod",
##     "false",
##     "find",
##     "realpath",
##     "sudo",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ],
##   "assumes": [
##     "LBOUND"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "source",
##       "type": "str",
##       "description": "Source file or folder to update.",
##       "nullable": false
##     },
##     {
##       "name": "default",
##       "flag": "-d",
##       "type": "bool",
##       "description": "Use default mode (664).",
##       "default": false
##     },
##     {
##       "name": "recursive",
##       "flag": "-r",
##       "type": "bool",
##       "description": "Change mode recursively.",
##       "default": false
##     },
##     {
##       "name": "sudo",
##       "flag": "-s",
##       "type": "bool",
##       "description": "Execute with sudo.",
##       "default": false
##     },
##     {
##       "name": "executable",
##       "flag": "-x",
##       "type": "bool",
##       "description": "Use executable mode (775).",
##       "default": false
##     },
##     {
##       "name": "executable_full",
##       "flag": "-X",
##       "type": "bool",
##       "description": "Use full executable mode (777).",
##       "default": false
##     },
##     {
##       "name": "mode",
##       "flag": "-m",
##       "type": "str",
##       "description": "Desired mode (octal digits).",
##       "default": "664"
##     },
##     {
##       "name": "filter",
##       "flag": "-F",
##       "type": "str",
##       "description": "Only update files matching filter (suffix).",
##       "nullable": true
##     }
##   ]
## }
function mod() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'mod (source) -m [mode] -F [filter] -r (recursive) -d (default=664) -x (executable=775) -X (executable=777) -s (sudo) -h (help)\n'
    }

    #--------------------------------------------------
    # Declare subfunction
    #--------------------------------------------------

    function _mod() {
        # $1 = mode ; $2 = source ; $3 = sudo
        if [ "$3" = true ]; then
            _echo_info "sudo chmod \"$1\" \"$2\"\n"
            sudo chmod "$1" "$2"
        else
            _echo_info "chmod \"$1\" \"$2\"\n"
            chmod "$1" "$2"
        fi
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    # 664: rw-rw-r-- default file
    # 755: rwxr-xr-x default folder
    # 775: rwxrwxr-x default executable
    local mode='664'
    local recursive=false
    local filter
    local source
    local use_sudo

    #--------------------------------------------------
    # Parse arguments
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :drsxXm:F:h option; do
            case "${option}" in
                d) mode='664';;
                r) recursive=true;;
                s) use_sudo=false;;
                x) mode='775';;
                X) mode='777';;
                m) mode="${OPTARG}";;
                F) filter="${OPTARG}";;
                h) _echo_warning 'mod\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Change files mode recursively\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    # Check argument count
    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    if [[ ! "${mode}" =~ ^[0-7]+$ ]]; then
        _echo_danger 'error: some mandatory parameter is invalid\n'
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # excluding last forward slash if any
    source="$(realpath "${arguments[${LBOUND}]}")"

    #--------------------------------------------------
    # Validate argument type
    #--------------------------------------------------

    # Check source validity
    if [ ! -f "${source}" ] && [ ! -d "${source}" ]; then
        _echo_danger "error: source: \"${source}\" is invalid\n"
        _usage 2 8

        return 1
    fi

    if [ ! -d "${source}" ] && [ "${recursive}" = true ]; then
        _echo_danger "error: source: \"${source}\" is not a valid directory\n"
        _usage 2 8

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ -d "${source}" ] && [ "${recursive}" = true ]; then
        # Find all files recursively
        if [ -n "${filter}" ]; then
            find "${source}" -type f -name "*${filter}" | while read -r FILE
            do
                _mod "${mode}" "${FILE}" "${use_sudo}"
            done
        else
            find "${source}" -type f | while read -r FILE
            do
                _mod "${mode}" "${FILE}" "${use_sudo}"
            done
        fi

        return 0
    fi

    if [ -d "${source}" ]; then
        # Find all files inside given folder
        if [ -n "${filter}" ]; then
            find "${source}" -maxdepth 1 -type f -name "*${filter}" | while read -r FILE
            do
                _mod "${mode}" "${FILE}" "${use_sudo}"
            done
        else
            find "${source}" -maxdepth 1 -type f | while read -r FILE
            do
                _mod "${mode}" "${FILE}" "${use_sudo}"
            done
        fi

        return 0
    fi

    if [ -f "${source}" ]; then
        _mod "${mode}" "${source}" "${use_sudo}"

        return 0
    fi
}
