#!/bin/sh

## Print the FizzBuzz sequence
##
## Prints the numbers from 1 to the configured limit.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends recipes/demo/app/_fizzbuzz.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes verbose
## @option {int} <limit> /^[1-9][0-9]?$/ (default:10) Last number to print.
## @flag <prefix> Prefix output with a line number.
fizzbuzz() {
    if [ $# -gt 1 ]; then
        _echo_error "fizzbuzz: too many arguments ($#)\n"
        return 1
    fi

    if [ "${verbose}" = true ]; then
        _echo_warning "Print the FizzBuzz sequence from \"0\" to \"${limit:-10}\"\n"
    fi

    counter=1

    while [ "${counter}" -le "${limit:-10}" ]; do
        fizzbuzz=$(_fizzbuzz "${counter}")
        if [ "${prefix:-false}" = true ]; then
            printf '%d: %s\n' "${counter}" "${fizzbuzz}"
        else
            printf '%s\n' "${fizzbuzz}"
        fi
        counter="$((counter + 1))"
    done
}

