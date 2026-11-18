#!/bin/sh

## Print this help
##
## @namespace src/shell/help
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @param {str} <COMMAND_NAME> The command name to print detailed help for.
help() {
    if [ $# -gt 1 ]; then _echo_error "help: too many arguments ($#)\n"; return 1; fi

    _help "$0" "$1"
}

