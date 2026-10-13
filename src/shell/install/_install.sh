#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Install script and enable autocompletion",
##   "requires": [
##     "basename",
##     "bash",
##     "realpath",
##     "touch",
##     "true",
##     "uname",
##     "zsh"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/install/_copy_install",
##     "src/shell/install/_generate_autocomplete",
##     "src/shell/install/_generate_global_autocomplete",
##     "src/shell/install/_set_completion_autoload",
##     "src/shell/install/_symlink_install",
##     "src/shell/system/_is_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "ALIAS",
##       "description": "The alias of the script to install. Defaults to the basename of the provided file.",
##       "type": "str"
##     },
##     {
##       "position": 3,
##       "name": "GLOBAL",
##       "description": "Install globally.",
##       "type": "bool",
##       "default": false
##     }
##   ]
## }
_install() {
    if [ -z "$1" ]; then _echo_error '_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_install: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"
    if [ ! -f "$1" ]; then _echo_error "_install: \"$1\" file not found\n"; return 1; fi

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

