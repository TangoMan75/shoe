#!/bin/sh

# Get APK package_name
_get_apk_package_name() {
    # Synopsis: _get_apk_package_name <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    _check_installed aapt

    if [ -z "$1" ]; then echo_danger 'error: _get_apk_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_apk_package_name: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_apk_package_name: \"$1\" file not found\n"; return 1; fi

    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("name=|'"'"'","");  print $2}'
}

