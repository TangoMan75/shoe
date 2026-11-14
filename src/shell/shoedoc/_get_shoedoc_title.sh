#!/bin/sh

## Get shoedoc title
##
## Returns the first line that does not contain a tag
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc_title() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_title: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

