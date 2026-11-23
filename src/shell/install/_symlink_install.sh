#!/bin/sh

## Install script via symlink
##
## @namespace src/shell/install
## @requires basename ln realpath rm sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/validation/_validate_alias.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_symlink_install(){
    if [ -z "$1" ]; then _echo_error '_symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_symlink_install too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_symlink_install \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is used as a path component under the installation
    # folder, and the commands run through sudo: refuse anything that
    # could escape it.
    _validate_alias "$2" '_symlink_install' || return 1

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"

    # Checks whether the installed name already exists as a symbolic link.
    if [ -L "${__bin_dir__}/$2" ]; then
        _echo_info "sudo rm -f \"${__bin_dir__}/$2\"\n"
        if ! sudo rm -f -- "${__bin_dir__}/$2"; then
            _echo_error "_symlink_install: could not remove \"${__bin_dir__}/$2\"\n"

            return 1
        fi
    fi

    _echo_info "sudo ln -s \"$1\" \"${__bin_dir__}/$2\"\n"
    if ! sudo ln -s -- "$1" "${__bin_dir__}/$2"; then
        _echo_error "_symlink_install: could not link \"$1\" to \"${__bin_dir__}/$2\"\n"

        return 1
    fi
}

