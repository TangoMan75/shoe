#!/bin/sh

# Updates given script from the provided URL
#
# {
#   "namespace": "install",
#   "requires": [
#     "curl",
#     "wget"
#   ],
#   "depends": [
#     "_copy_install",
#     "_generate_autocomplete",
#     "_generate_global_autocomplete",
#     "_install",
#     "_is_installed",
#     "_set_completion_autoload",
#     "_symlink_install",
#     "_uninstall",
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
#       "name": "URL",
#       "type": "str",
#       "description": "The URL of the script to download and install.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "ALIAS",
#       "type": "str",
#       "description": "The alias of the script to install. Defaults to the basename of the provided file."
#     },
#     {
#       "position": 4,
#       "name": "GLOBAL",
#       "type": "bool",
#       "description": "Install globally.",
#       "default": false
#     }
#   ]
# }
_update() {
    # Synopsis: _update <FILE_PATH> <URL> [ALIAS] [GLOBAL]
    #   FILE_PATH: The path to the input file.
    #   URL:       The URL of the script to download and install.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:    (optional) Install globally. Defaults to "false".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then echo_danger "error: _update: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    if _is_installed curl; then
        echo_info "curl -sSL \"$2\" > \"$1\"\n"
        curl -sSL "$2" > "$1"

    elif _is_installed  wget; then
        echo_info "wget -qO - \"$2\" > \"$1\"\n"
        wget -qO - "$2" > "$1"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    _uninstall "$1" "$3"
    _install "$1" "$3" "$4"
}

