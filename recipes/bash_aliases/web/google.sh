#!/bin/bash

alias gg='google' ## google alias

## Search on google.com
##
## @namespace recipes/bash_aliases/web
## @depends src/shell/colors/_echo_info src/shell/compatibility/_open
function google() {
    # ${*}  : capture all the arguments passed to the function
    # // / : substitution using a separator.
    # It replaces all single spaces with a single space.

    _echo_info "_open \"https://www.google.com/search?q=${*// /+}\"\n"
    _open "https://www.google.com/search?q=${*// /+}"
}

