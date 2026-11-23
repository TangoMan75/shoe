#!/bin/sh

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename cmp dirname realpath rm sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/install/_remove_completion_autoload.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_uninstall() {
    if [ -z "$1" ]; then _echo_error '_uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_uninstall: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_uninstall: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    _echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"
    __installed__="${__bin_dir__}/$2"

    # Remove a symbolic link that points at the source, or a copy whose
    # content still matches it: a binary installed by _copy_install is a
    # regular file, and a file that differs belongs to something else.
    __remove__='false'
    if [ -L "${__installed__}" ]; then
        if [ "$(realpath -- "${__installed__}" 2>/dev/null)" = "$1" ]; then
            __remove__='true'
        fi
    elif [ -f "${__installed__}" ] && cmp -s "$1" "${__installed__}"; then
        __remove__='true'
    fi

    if [ "${__remove__}" = 'true' ]; then
        _echo_info "sudo rm -f \"${__installed__}\"\n"
        if ! sudo rm -f -- "${__installed__}"; then
            _echo_error "_uninstall: could not remove \"${__installed__}\"\n"

            return 1
        fi
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        _echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

