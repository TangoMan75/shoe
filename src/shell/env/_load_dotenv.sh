#!/bin/sh

## Load the first dotenv file found for an environment
##
## Looks for ".env.<ENV>.local", ".env.<ENV>", ".env.local" and ".env"
## in this order and loads the first file that exists.
##
## @namespace src/shell/env
## @requires realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/env/_load_env.sh
## @param {str} <ENV> (required) The application environment name.
## @param {folder} <DIRECTORY> (default:".") The folder containing the dotenv files.
_load_dotenv() {
    if [ -z "$1" ]; then _echo_error '_load_dotenv: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_load_dotenv: too many arguments ($#)\n"; return 1; fi

    # The environment name is interpolated into a file name: anything
    # that is not a plain identifier could escape the folder.
    case "$1" in
        *[!A-Za-z0-9_-]*)
            _echo_error "_load_dotenv: invalid environment name \"$1\"\n"

            return 1
            ;;
    esac

    if [ ! -d "${2:-.}" ]; then
        _echo_error "_load_dotenv: \"${2:-.}\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath -- "${2:-.}")"

    if [ -f "$2/.env.$1.local" ]; then
        _load_env "$2/.env.$1.local"

        return 0
    fi

    if [ -f "$2/.env.$1" ]; then
        _load_env "$2/.env.$1"

        return 0
    fi

    if [ -f "$2/.env.local" ]; then
        _load_env "$2/.env.local"

        return 0
    fi

    if [ -f "$2/.env" ]; then
        _load_env "$2/.env"

        return 0
    fi

    _echo_error "_load_dotenv: no dotenv file found in \"$2\"\n"

    return 1
}

