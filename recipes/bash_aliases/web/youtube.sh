#!/bin/bash

alias yt='youtube' ## youtube alias

## Search on youtube.com
##
## @namespace recipes/bash_aliases/web
## @depends src/shell/colors/_echo_info src/shell/compatibility/_open
function youtube() {
    # ${*}  : capture all the arguments passed to the function
    # // / : substitution using a separator.
    # It replaces all single spaces with a "+" character.

    _echo_info "_open \"https://www.youtube.com/results?search_query=${*// /+}\"\n"
    _open "https://www.youtube.com/results?search_query=${*// /+}"
}

