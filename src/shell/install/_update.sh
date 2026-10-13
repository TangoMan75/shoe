#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Updates given script from the provided URL",
##   "requires": [
##     "basename",
##     "curl",
##     "realpath",
##     "wget"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/install/_install",
##     "src/shell/install/_uninstall",
##     "src/shell/system/_is_installed"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "URL",
##       "type": "str",
##       "description": "The URL of the script to download and install.",
##       "required": true
##     },
##     {
##       "position": 3,
##       "name": "ALIAS",
##       "type": "str",
##       "description": "The alias of the script to install. Defaults to the basename of the provided file."
##     },
##     {
##       "position": 4,
##       "name": "GLOBAL",
##       "type": "bool",
##       "description": "Install globally.",
##       "default": false
##     }
##   ]
## }
_update() {
    # Synopsis: _update <FILE_PATH> <URL> [ALIAS] [GLOBAL]
    #   FILE_PATH: The path to the input file.
    #   URL:       The URL of the script to download and install.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:    (optional) Install globally. Defaults to "false".

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_update: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_update: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_update: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}"

    if _is_installed curl; then
        _echo_info "curl -sSL \"$2\" > \"$1\"\n"
        curl -sSL "$2" > "$1"

    elif _is_installed  wget; then
        _echo_info "wget -qO - \"$2\" > \"$1\"\n"
        wget -qO - "$2" > "$1"

    else
        _echo_error "\"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    _uninstall "$1" "$3"
    _install "$1" "$3" "$4"
}

