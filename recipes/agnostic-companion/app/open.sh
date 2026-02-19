#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/app",
##   "summary": "Open all configured domains in default browser",
##   "requires": [
##     "nohup"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_open"
##   ]
## }
open() {
    _echo_info "nohup \"$(_open)\" https://${ALIAS}.localhost >/dev/null 2>&1\n"
    nohup "$(_open)" https://${ALIAS}.localhost >/dev/null 2>&1
}

