#!/bin/sh

# Return given tag values from shoedoc bloc
#
# {
#   "namespace": "shoedoc",
#   "requires": [
#     "awk"
#   ],
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "TEXT",
#       "type": "str",
#       "description": "The input shoedoc annotation bloc.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "TAG_NAME",
#       "type": "str",
#       "description": "The name of tag to return.",
#       "nullable": false
#     }
#   ]
# }
_get_shoedoc_tag() {
    # Synopsis: _get_shoedoc_tag <TEXT> <TAG_NAME>
    #   TEXT:     The input shoedoc annotation bloc.
    #   TAG_NAME: The name of tag to return.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_shoedoc_tag: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_shoedoc_tag: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk -v TAG="$2" '/^#.*/ {
        if ($2=="@"TAG) {
            gsub(" +"," "); sub("^ +",""); sub(" +$",""); # trim input
            RESULT=substr($0,length($1)+length($2)+3);    # remove leading pound character(s)
            print RESULT
        }
    }'
}

