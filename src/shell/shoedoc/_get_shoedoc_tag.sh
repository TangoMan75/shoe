#!/bin/sh

## {
##   "namespace": "src/shell/shoedoc",
##   "summary": "Return given tag values from shoedoc annotation",
##   "requires": [
##     "awk",
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "description": "The input shoedoc annotation bloc.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "TAG_NAME",
##       "description": "The name of tag to return.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_get_shoedoc_tag() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_shoedoc_tag: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_shoedoc_tag: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk -v TAG="$2" '/^## .*/ {
        if ($2=="@"TAG) {
            gsub(" +"," "); sub("^ +",""); sub(" +$",""); # trim input
            RESULT=substr($0,length($1)+length($2)+3);    # remove leading pound character(s)
            print RESULT
        }
    }'
}

