#!/bin/sh

## Print the Fibonacci sequence
##
## Prints the first terms of the Fibonacci sequence.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_echo_warning.sh
## @assumes verbose
## @option {int} <count> /^[1-9][0-9]?$/ (default:10) Number of terms to print.
fibonacci() {
    if [ "${verbose}" = true ]; then
        _echo_warning "Print the Fibonacci sequence from \"0\" to \"${count:-10}\"\n"
    fi

    current=0
    next=1
    i=0

    while [ "$i" -lt "${count:-10}" ]; do
        printf '%d\n' "${current}"

        current="${next}"
        next="$((current + next))"
        i="$((i + 1))"
    done
}

