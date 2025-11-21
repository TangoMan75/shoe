#!/bin/sh

# Install script via copy
#
# {
#   "namespace": "install",
#   "depends": [
#     "echo_danger",
#     "echo_info"
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
#     }
#   ]
# }
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file
    #   note:      Creates a symbolic link in the /usr/local/bin/ directory.

    if [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then echo_danger "error: _copy_install: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; return 1; fi

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

