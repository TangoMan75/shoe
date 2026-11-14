#!/usr/bin/env sh

## Function Parameters Test Fixture
##
## Example script for testing function-level option and flag parsing.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe

## Add something
##
## @namespace tests/fixtures
## @option {str} <name> [-n|--name] /^[A-Za-z0-9._-]+$/ (default:"") Display name
## @option {int} <count> [-c|--count] (default:1) Repetition count
## @option {str} <input> [-i] Path to input
## @flag <force> [-f|--force] Force the operation
## @flag <verbose> Verbose output
scoped_add() {
    printf '%s\n' "${name}" "${count}" "${input}" "${force}" "${verbose}"
}

## Function without function-level parameters
##
## @namespace tests/fixtures
scoped_plain() {
    return 0
}
