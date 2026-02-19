#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/web",
##   "summary": "Open github user profile",
##   "requires": [
##     "open"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ],
##   "assumes": [
##     "USER"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "user",
##       "description": "GitHub username (defaults to the current user).",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
function github() {
    _echo_info "open \"https://github.com/${1:-${USER}}\"\n"
    open "https://github.com/${1:-${USER}}"
}

