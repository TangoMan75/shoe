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
##   "parameters": [
##     {
##       "position": 1,
##       "name": "user",
##       "type": "str",
##       "description": "GitHub username (defaults to the current user).",
##       "default": "${USER}",
##       "nullable": false
##     }
##   ]
## }
function github() {
    _echo_info "open \"https://github.com/${1:-${USER}}\"\n"
    open "https://github.com/${1:-${USER}}"
}
