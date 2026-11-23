#!/bin/sh

## Print the FizzBuzz word for a given number
##
## Prints "FizzBuzz" for multiples of fifteen, "Fizz" for multiples of three,
## "Buzz" for multiples of five, and the number itself otherwise.
## This is an example of a private function
## Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
##
## @namespace recipes/demo/app
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @param {int} <NUMBER> (required) The number to convert.
_fizzbuzz() {
    if [ -z "$1" ]; then
        _echo_error '_fizzbuzz: some mandatory parameter is missing\n'
        return 1
    fi

    if [ $# -gt 1 ]; then
        _echo_error "_fizzbuzz: too many arguments ($#)\n"
        return 1
    fi

    if [ $(($1 % 15)) -eq 0 ]; then
        printf 'FizzBuzz'
    elif [ $(($1 % 3)) -eq 0 ]; then
        printf 'Fizz'
    elif [ $(($1 % 5)) -eq 0 ]; then
        printf 'Buzz'
    else
        printf '%d' "$1"
    fi
}

