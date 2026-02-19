#!/bin/sh

## {
##   "namespace": "recipes/traefik/app",
##   "summary": "Open all configured domains in default browser",
##   "requires": [
##     "nohup"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_open",
##     "src/shell/reflexion/_get_parameter"
##   ]
## }
open() {
    DOMAINS="$(_get_parameter .env DOMAINS)"

    for _domain in ${DOMAINS}; do
        _echo_info "nohup \"$(_open)\" \"https://${_domain}.localhost\" >/dev/null 2>&1\n"
        nohup "$(_open)" "https://${_domain}.localhost" >/dev/null 2>&1
    done

    _echo_info "nohup \"$(_open)\" https://traefik.localhost/api/rawdata >/dev/null 2>&1\n"
    nohup "$(_open)" https://traefik.localhost/api/rawdata >/dev/null 2>&1
}

