#!/bin/sh

_get_docbloc_description() {
    # Synopsis: _get_docbloc_description <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_description: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_description: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_description: \"$1\" file not found\n"; exit 1; fi

    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$(realpath "$1")"
}

