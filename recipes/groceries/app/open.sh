#!/bin/sh

## Open in default browser
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
    _echo_info "nohup $(_open) https://tangoman75.github.io/groceries >/dev/null 2>&1\n"
    nohup $(_open) https://tangoman75.github.io/groceries >/dev/null 2>&1
}
