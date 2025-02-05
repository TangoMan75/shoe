#!/bin/sh

# Get shoedoc title
_get_shoedoc_title() {
    # Synopsis: _get_shoedoc_title <TEXT>
    #   TEXT: The input shoedoc annotation bloc.
    #   note: Returns the first line that does not contain a tag

    if [ -z "$1" ]; then echo_danger 'error: _get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_shoedoc_title: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk '/^#.*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

