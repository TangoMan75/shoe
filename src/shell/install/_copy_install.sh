#!/bin/sh

## Install script via copy
##
## Creates a symbolic link in the /usr/local/bin/ directory
##
## @namespace src/shell/install
## @requires basename cp realpath sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/validation/_validate_alias.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_copy_install() {
    if [ -z "$1" ]; then _echo_error '_copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_copy_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_copy_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is used as a path component under the installation
    # folder, and the command runs through sudo: refuse anything that
    # could escape it.
    _validate_alias "$2" '_copy_install' || return 1

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"

    # -a, --archive    same as -dR --preserve=all
    _echo_info "sudo cp -R -p \"$1\" \"${__bin_dir__}/$2\"\n"
    if ! sudo cp -R -p -- "$1" "${__bin_dir__}/$2"; then
        _echo_error "_copy_install: could not copy \"$1\" to \"${__bin_dir__}/$2\"\n"

        return 1
    fi
}

