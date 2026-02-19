#!/bin/bash

alias yt='youtube' ## youtube alias

## {
##   "namespace": "recipes/bash_aliases/web",
##   "summary": "Search on youtube.com",
##   "requires": [
##     "open"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
function youtube() {
    # ${*}  : capture all the arguments passed to the function
    # // / : substitution using a separator.
    # It replaces all single spaces with a "+" character.

    _echo_info "open \"https://www.youtube.com/results?search_query=${*// /+}\"\n"
    open "https://www.youtube.com/results?search_query=${*// /+}"
}
