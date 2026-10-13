#!/bin/sh

## {
##   "namespace": "src/shell/network",
##   "summary": "Open in default browser",
##   "requires": [
##     "nohup"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_open"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "IP",
##       "description": "Target IP address or domain.",
##       "type": "str",
##       "default": "127.0.0.1"
##     },
##     {
##       "position": 2,
##       "name": "PORT",
##       "description": "Destination port.",
##       "type": "int",
##       "constraint": "/^[0-9]{1,5}$/",
##       "default": "8080"
##     },
##     {
##       "position": 3,
##       "name": "SCHEME",
##       "description": "scheme - e.g. http.",
##       "type": "str",
##       "default": "http"
##     }
##   ]
## }
_open_in_default_browser() {
    if [ $# -gt 3 ]; then _echo_error "_open_in_default_browser: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}" "${3:-http}"

    _echo_info "nohup \"$(_open)\" \"$3://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "$3://$1:$2" >/dev/null 2>&1
}

