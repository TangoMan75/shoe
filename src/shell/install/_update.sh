#!/bin/sh

## Updates given script from the provided URL
##
## @namespace src/shell/install
## @requires basename chmod curl grep head mv realpath rm stat wget
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/install/_install.sh
## @depends src/shell/install/_uninstall.sh
## @depends src/shell/system/_is_installed.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <URL> (required) The URL of the script to download and install.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_update() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_update: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_update: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_update: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}" "${1}.download.$$"

    # Keep the mode of the installed script: the downloaded temporary is
    # created with the default umask.
    __mode__=$(stat -c '%a' "$1" 2>/dev/null || stat -f '%Lp' "$1" 2>/dev/null)

    # Download to a temporary file first: a failed transfer (404, DNS
    # error, interrupted connection) must never overwrite the installed
    # script.
    if _is_installed curl; then
        _echo_info "curl -fsSL \"$2\" > \"$5\"\n"
        if ! curl -fsSL "$2" > "$5"; then
            rm -f "$5"
            _echo_error "_update: could not download \"$2\"\n"

            return 1
        fi

    elif _is_installed wget; then
        _echo_info "wget -qO \"$5\" \"$2\"\n"
        if ! wget -qO "$5" "$2"; then
            rm -f "$5"
            _echo_error "_update: could not download \"$2\"\n"

            return 1
        fi

    else
        _echo_error "\"$0\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    if [ ! -s "$5" ]; then
        rm -f "$5"
        _echo_error "_update: downloaded file is empty\n"

        return 1
    fi

    # A proxy, a captive portal or a renamed raw URL can answer 200 with an
    # HTML page: never replace a working script with one.
    if ! head -n 1 "$5" | grep -q '^#!.*sh'; then
        rm -f "$5"
        _echo_error "_update: downloaded file is not a shell script\n"

        return 1
    fi

    mv "$5" "$1"
    if [ -n "${__mode__}" ]; then
        chmod "${__mode__}" "$1"
    fi

    _uninstall "$1" "$3"
    _install "$1" "$3" "$4"
}

