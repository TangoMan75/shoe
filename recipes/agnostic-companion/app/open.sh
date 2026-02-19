#!/bin/sh

## Open all configured domains in default browser
##
## {
##   "namespace": "app",
##   "requires": [
##     "nohup"
##   ],
##   "depends": [
##     "_echo_info",
##     "_open"
##   ]
## }
open() {
    _echo_info "nohup \"$(_open)\" https://${ALIAS}.localhost >/dev/null 2>&1\n"
    nohup "$(_open)" https://${ALIAS}.localhost >/dev/null 2>&1
}

