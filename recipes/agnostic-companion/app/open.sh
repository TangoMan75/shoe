#!/bin/sh

## Open all configured domains in default browser
##
## @namespace recipes/agnostic-companion/app
## @requires nohup
## @depends src/shell/colors/_echo_info src/shell/compatibility/_open
## @assumes ALIAS
open() {
    _echo_info "nohup \"$(_open)\" https://${ALIAS}.localhost >/dev/null 2>&1\n"
    nohup "$(_open)" https://${ALIAS}.localhost >/dev/null 2>&1
}

