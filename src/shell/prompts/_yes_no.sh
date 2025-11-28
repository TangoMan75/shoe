#!/bin/sh

## Promt user for yes or no
##
## {
##   "namespace": "prompts",
##   "requires": [
##     "grep"
##   ],
##   "depends": [
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "QUESTION",
##       "type": "str",
##       "description": "A string containing the question.",
##       "default": "Confirm ?"
##     }
##   ]
## }
_yes_no() {
    # Synopsis: _yes_no [QUESTION]
    #   QUESTION: (optional) A string containing the question. Defaults to "Confirm ?".

    set -- "${1:-Confirm ?} (yes/no): "

    _echo_success "$1"; _echo_warning "[no] "
    read -r __select__

    if echo "${__select__}" | grep -qi '^[Yy]\(es\)\?$'; then

        return 0
    fi

    return 1
}

