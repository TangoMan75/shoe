#!/bin/bash

alias gg='google' ## google alias

## {
##   "namespace": "recipes/bash_aliases/web",
##   "summary": "Search on google.com",
##   "requires": [
##     "open"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
function google() {
    # ${*}  : capture all the arguments passed to the function
    # // / : substitution using a separator.
    # It replaces all single spaces with a single space.

    _echo_info "open \"https://www.google.com/search?q=${*// /+}\"\n"
    open "https://www.google.com/search?q=${*// /+}"
}
