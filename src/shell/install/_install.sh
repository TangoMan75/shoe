#!/bin/sh

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename bash realpath touch true uname zsh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/install/_copy_install.sh
## @depends src/shell/install/_generate_autocomplete.sh
## @depends src/shell/install/_generate_global_autocomplete.sh
## @depends src/shell/install/_set_completion_autoload.sh
## @depends src/shell/install/_symlink_install.sh
## @depends src/shell/system/_is_installed.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_install() {
    if [ -z "$1" ]; then _echo_error '_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"

    if [ "$3" = true ]; then
        _copy_install "$1" "$2" || return 1
        _generate_global_autocomplete "$1" "$2" || return 1
    else
        _symlink_install "$1" "$2" || return 1
        _generate_autocomplete "$1" "$2" || return 1
    fi

    if _is_installed zsh; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$1" "$2" || true
    fi

    if _is_installed bash; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            if [ ! -f ~/.profile ]; then touch ~/.profile 2>/dev/null || true; fi
            _set_completion_autoload ~/.profile "$1" "$2" || true
        else
            _set_completion_autoload ~/.bashrc "$1" "$2" || true
        fi
    fi
}

