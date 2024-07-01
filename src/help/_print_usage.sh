#!/bin/sh

## Print usage
_print_usage() {
    printf "%bUsage:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${INFO}  sh %s${INFO} [${SUCCESS}command${INFO}]${DEFAULT} " "$(basename "${0}")"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s ${WARNING}%s${INFO})${DEFAULT} \", \$1, \$2
    } { PREV = \$0 }" "$0"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 == \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s${INFO})${DEFAULT} \", \$1
    } { PREV = \$0 }" "$0"
    printf '\n\n'
}

