#!/bin/sh

## Get shoedoc description
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "type": "str",
##       "description": "The input shoedoc annotation bloc.",
##       "nullable": false
##     }
##   ]
## }
_get_shoedoc_description() {
    # Synopsis: _get_shoedoc_description <TEXT>
    #   TEXT: The input shoedoc annotation bloc.

    if [ -z "$1" ]; then _echo_error '_get_shoedoc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_description: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            if (index($0, "{") > 0) exit;
            count+=1;
            if (count==2 && RESULT=="") next;
            if (count>1) print RESULT
        }
    }'
}
