#!/bin/bash

## Open github user profile
##
## @namespace recipes/bash_aliases/web
## @depends src/shell/colors/_echo_info src/shell/compatibility/_open
## @assumes USER
## @param {str} <user> (required) GitHub username (defaults to the current user).
function github() {
    _echo_info "_open \"https://github.com/${1:-${USER}}\"\n"
    _open "https://github.com/${1:-${USER}}"
}

