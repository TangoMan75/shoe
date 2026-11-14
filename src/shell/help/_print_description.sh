#!/bin/sh

## Print provided text formatted as a description (used by "help" command)
##
## @namespace src/shell/help
## @requires fold printf
## @depends src/shell/colors/_echo_primary src/shell/colors/_echo_warning
## @param {str} <DESCRIPTION> (required) A string containing script description.
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

