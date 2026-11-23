#!/bin/sh

## Build app to destination folder
##
## @namespace src/shell/npm
## @requires npm pwd realpath rm
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
## @assumes HOME
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_npm_build() {
    _check_installed npm

    if [ -z "$1" ]; then _echo_error '_npm_build: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_npm_build: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_npm_build: \"$1\" folder not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$(pwd)"

    # Refuse to delete the root, the caller's home or any ancestor of the
    # working directory: `rm -rf` there would destroy unrelated files.
    case "$1" in
        /|"${HOME:-/nonexistent}")
            _echo_error "_npm_build: refusing to delete \"$1\"\n"

            return 1
            ;;
    esac
    case "$2/" in
        "$1"/*)
            _echo_error "_npm_build: refusing to delete \"$1\"\n"

            return 1
            ;;
    esac

    _echo_info "rm -rf \"$1\"\n"
    if ! rm -rf -- "$1"; then
        _echo_error "_npm_build: could not remove \"$1\"\n"

        return 1
    fi

    _echo_info 'npm run build\n'
    npm run build
}

