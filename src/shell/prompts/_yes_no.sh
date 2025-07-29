#!/bin/sh

# Promt user for yes or no
_yes_no() {
    # Synopsis: _yes_no [QUESTION]
    #   QUESTION: (optional) A string containing the question. Defaults to "Confirm ?".

    set -- "${1:-Confirm ?} (yes/no): "

    echo_success "$1"; echo_warning "[no] "

    read -r __select__
    if [ "${__select__}" != "$(printf '%s' "${__select__}" | awk '/^[Yy](ES|es)?$/ {print}')" ]; then

        return 1
    fi

    return 0
}

