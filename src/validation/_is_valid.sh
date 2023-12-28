#!/bin/sh

## Chek if variable is valid
_is_valid() {
    if [ $# -lt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" %s${EOL}" 'some mandatory argument is missing'
        exit 1
    fi

    if [ $# -gt 2 ]; then
        printf "${DANGER}error: \"_is_valid\" too many arguments: expected 2, %s given.${EOL}" $#
        exit 1
    fi

    _is_valid_value="$1"
    _is_valid_pattern="$2"

    # missing pattern always returns valid status
    if [ -z "${_is_valid_pattern}" ]; then
        echo true
        return 0
    fi

    if [ "${_is_valid_value}" != "$(printf '%s' "${_is_valid_value}" | awk "${_is_valid_pattern} {print}")" ]; then
        echo false
        return 0
    fi

    echo true
}
