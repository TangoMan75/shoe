#!/bin/sh

# Updates the script from the provided URL.
_update() {
    # Synopsis: _update <FILE_PATH> <URL>
    #   FILE_PATH:  The path to the input file.
    #   URL:        The URL of the script to download and install.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _update: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    if _check_installed curl; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$1")\"\n"
        curl -sSL "$1" > "$(realpath "$1")"

    elif _check_installed  wget; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$1")\"\n"
        wget -qO - "$1" > "$(realpath "$1")"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    "$(realpath "$1")" self_install
}

