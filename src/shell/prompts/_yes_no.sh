#!/bin/sh

## Promt user for yes or no
##
## @namespace src/shell/prompts
## @requires echo grep
## @depends src/shell/colors/_echo_success src/shell/colors/_echo_warning
## @param {str} <QUESTION> (default:"Confirm ?") A string containing the question.
_yes_no() {
    set -- "${1:-Confirm ?} (yes/no): "

    _echo_success "$1"; _echo_warning "[no] "
    read -r __select__

    if echo "${__select__}" | grep -qi '^[Yy]\(es\)\?$'; then

        return 0
    fi

    return 1
}

