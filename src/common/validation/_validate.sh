#!/bin/sh

_validate() {
    # Synopsis: _validate [variable]
    # find constraints and validates a variable from parameter string. e.g: "variable_name=value"
    _validate_variable=$(printf '%s' "$1" | cut -d= -f1)
    _validate_value=$(printf '%s' "$1" | cut -d= -f2)
    _validate_pattern=$(_get_constraint "$0" "${_validate_variable}")

    if [ "$(_is_valid "${_validate_value}" "${_validate_pattern}")" = false ]; then
        echo_danger "error: invalid \"${_validate_variable}\", expected \"${_validate_pattern}\", \"${_validate_value}\" given\n"
        exit 1
    fi
}

