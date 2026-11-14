#!/bin/sh

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename dirname realpath rm sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/install/_remove_completion_autoload
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_uninstall() {
    if [ -z "$1" ]; then _echo_error '_uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_uninstall: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_uninstall: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    _echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    if [ -f "$1" ]; then
        _echo_info "sudo rm -f \"/usr/local/bin/$2\"\n"
        sudo rm -f "/usr/local/bin/$2"
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        _echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

