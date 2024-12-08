#!/bin/sh

# Parse docbloc at the top the provided shoe script file
_get_docbloc() {
    # Synopsis: _get_docbloc <FILE_PATH> <TAG_NAME>
    #   FILE_PATH:  The path to the input file.
    #   TAG_NAME:   The name of the docbloc parameter to return.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ ${#} -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_docbloc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_docbloc: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc: \"$1\" file not found\n"; return 1; fi

    # /^#\/\*\*$/,/^# \*\/$/ = Match a range of lines beginning with "#/**" and ending with "# */"
    # for(i=4;i<=NF;++i){printf "%s ",$i} = concat remainig string
    # exit = avoid returning duplicate matches
    awk -v TAG="$2" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}; exit}}' "$(realpath "$1")" | sed -E 's/ +$//'
}

