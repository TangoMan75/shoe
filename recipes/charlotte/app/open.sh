#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Open in default browser",
##   "requires": [
##     "nohup"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_open"
##   ]
## }
open() {
    _echo_info "nohup $(_open) ./dist/index.html >/dev/null 2>&1\n"
    nohup $(_open) ./dist/index.html >/dev/null 2>&1
}
