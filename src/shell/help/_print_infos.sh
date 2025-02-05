#!/bin/sh

# Print infos of the provided shoe script (used by "help" command)
_print_infos() {
    # Synopsis: _print_infos <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _print_infos: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _print_infos: \"$1\" file not found\n"; return 1; fi

    __annotations__=$(_get_script_shoedoc "$1")

    echo_warning 'Infos:\n'
    echo_success 'author'  2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    echo_success 'version' 2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    echo_success 'link'    2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

