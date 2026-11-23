#!/usr/bin/env sh

## Positional Parameters Test Fixture
##
## Example script for testing function-level positional parameters,
## options and flags.

## Greet somebody
##
## @namespace tests/fixtures
## @param {str} <who> /^[A-Za-z-]+$/ (default:"World") The recipient.
## @param {int} <count> (default:1) Repetition count.
## @option {str} <prefix> [-p|--prefix] (default:"") Output prefix.
## @flag <loud> [-l|--loud] Uppercase the output.
greet() {
    printf '%sHello, %s !\n' "${prefix}" "${who}"
}

## Plain command
##
## @namespace tests/fixtures
plain() {
    :
}

## Message with spaces
##
## @namespace tests/fixtures
## @param {str} <message> /^[a-z ]+$/ (required) A message made of words.
spaced() {
    printf '%s\n' "${message}"
}

