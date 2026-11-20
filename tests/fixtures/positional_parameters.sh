#!/usr/bin/env sh

## Positional Parameters Test Fixture
##
## Example script for testing function-level positional parameters,
## options and flags.

## Greet somebody
##
## @namespace tests/fixtures
## @param {str} <WHO> /^[A-Za-z-]+$/ (default:"World") The recipient.
## @param {int} <COUNT> (default:1) Repetition count.
## @option {str} <prefix> [-p|--prefix] (default:"") Output prefix.
## @flag <loud> [-l|--loud] Uppercase the output.
greet() {
    printf '%sHello, %s !\n' "${prefix}" "${1:-World}"
}

## Plain command
##
## @namespace tests/fixtures
plain() {
    :
}
