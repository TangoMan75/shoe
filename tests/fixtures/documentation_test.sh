#!/bin/sh

## TangoMan Documentation Fixture
##
## Example script for testing documentation generation.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe

## Public constant
PUBLIC_CONSTANT=value

## Public option /^[a-z]+$/
##
## The public option value.
public_option=value

## Public flag
##
## Whether the public flag is enabled.
public_flag=false

## Public command
##
## @namespace tests/fixtures
## @requires echo
## @param {str} <WHO> (default:"World") The recipient name.
public_command() {
    echo "public"
}

## Private command
##
## @namespace tests/fixtures
## @requires echo
_private_command() {
    echo "private"
}
