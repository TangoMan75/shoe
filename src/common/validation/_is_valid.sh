#!/bin/sh

_is_valid() {
    # Synopsis: _is_valid VALUE PATTERN
    #   VALUE:    The string to be compared to regex pattern.
    #   PATTERN:  The regex parttern to apply.
    #   TODO:     "nullable=true" ; "nullable=false" : "length=10"

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_valid: too many arguments (${#})\n"; exit 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then
        echo true
        return 0
    fi

    # if [ "$1" != "$(tr -dc "$2" < printf '%s' "$1" | fold -w "${length}" | head -n 1)" ]; then
    if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then
        echo false
        return 0
    fi

    echo true
}

