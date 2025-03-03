#!/bin/sh

# Install script and enable completion
#
# {
#   "namespace": "install",
#   "depends": [
#     "_copy_install",
#     "_generate_autocomplete",
#     "_generate_global_autocomplete",
#     "_is_installed",
#     "_set_completion_autoload",
#     "_symlink_install",
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "ALIAS",
#       "type": "str",
#       "description": "The alias of the script to install. Defaults to the basename of the provided file."
#     },
#     {
#       "position": 3,
#       "name": "GLOBAL",
#       "type": "bool",
#       "description": "Install globally.",
#       "default": false
#     }
#   ]
# }
_install() {
    # Synopsis: _install <FILE_PATH> [ALIAS] [GLOBAL]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:    (optional) Install globally. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _install: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _install: \"$1\" file not found\n"; return 1; fi

    if [ "$3" = true ]; then
        _copy_install "$1" "$2"
        _generate_global_autocomplete "$1" "$2"
    else
        _symlink_install "$1" "$2"
        _generate_autocomplete "$1" "$2"
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
            _set_completion_autoload ~/.profile "$1" "$2"
        else
            _set_completion_autoload ~/.bashrc "$1" "$2"
        fi
    fi
}

