#!/bin/sh

## {
##   "namespace": "src/shell/prompts",
##   "summary": "Promt user for yes or no",
##   "requires": [
##     "echo",
##     "grep"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "QUESTION",
##       "description": "A string containing the question.",
##       "type": "str",
##       "default": "Confirm ?"
##     }
##   ]
## }
_yes_no() {
    set -- "${1:-Confirm ?} (yes/no): "

    _echo_success "$1"; _echo_warning "[no] "
    read -r __select__

    if echo "${__select__}" | grep -qi '^[Yy]\(es\)\?$'; then

        return 0
    fi

    return 1
}

