#!/bin/sh

## Install script via symlink
##
## @namespace src/shell/install
## @requires basename ln realpath sudo true
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_symlink_install(){
    if [ -z "$1" ]; then _echo_error '_symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_symlink_install too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_symlink_install \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\" || true\n"
    sudo ln -s "$1" "/usr/local/bin/$2" || true
}

