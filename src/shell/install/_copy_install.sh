#!/bin/sh

## Install script via copy
##
## Creates a symbolic link in the /usr/local/bin/ directory
##
## @namespace src/shell/install
## @requires basename cp realpath sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_copy_install() {
    if [ -z "$1" ]; then _echo_error '_copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_copy_install: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_copy_install: \"$1\" file not found\n"; return 1; fi

    # -a, --archive    same as -dR --preserve=all
    _echo_info "sudo cp --archive \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp --archive "$1" "/usr/local/bin/$2"
}

