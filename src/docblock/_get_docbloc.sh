#!/bin/sh

## Get docblock value by key
_get_docbloc() {
    # to change displayed items, edit docblock infos at the top of this file ↑

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing.\n'
        return 1
    fi

    if [ ${#} -gt 1 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    awk -v TAG="$1" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$0" | sed -E 's/ +$//'
}

