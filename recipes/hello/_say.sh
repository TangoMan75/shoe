#!/bin/sh

## Print a message to the configured recipient
##
## This is an example of a private function
## Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
##
## @namespace recipes/hello
## @requires printf
## @assumes count ending prefix verbose who
## @param {str} <MESSAGE> (required) The message to print.
_say() {
    if [ -z "$1" ]; then
        printf 'error: _say: some mandatory parameter is missing\n' >&2
        return 1
    fi

    if [ $# -gt 1 ]; then
        printf 'error: _say: too many arguments (%d)\n' "$#" >&2
        return 1
    fi

    # Store the message in $1 and initialize the loop counter in $2
    set -- "$1" 0

    if [ "${verbose}" = 'true' ]; then
        printf 'verbose: %s %s %s time(s), ending "%s"\n' \
            "$1" "${who}" "${count}" "${ending}" >&2
    fi

    while [ "$2" -lt "${count}" ]; do
        if [ "${prefix}" = 'true' ]; then
            printf '%d: %s, %s %s\n' "$(($2 + 1))" "$1" "${who}" "${ending}"
        else
            printf '%s, %s %s\n' "$1" "${who}" "${ending}"
        fi
        set -- "$1" "$(($2 + 1))"
    done
}

