#!/bin/sh

## Open in default browser
##
## @namespace recipes/pivot/app
## @requires nohup
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_open.sh
open() {
    _echo_info "nohup $(_open) ./dist/index.html >/dev/null 2>&1\n"
    nohup "$(_open)" ./dist/index.html >/dev/null 2>&1
}

