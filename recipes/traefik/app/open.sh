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
    DOMAINS="$(_get_parameter .env DOMAINS)"

    for _domain in ${DOMAINS}; do
        _echo_info "nohup \"$(_open)\" \"https://${_domain}.localhost\" >/dev/null 2>&1\n"
        nohup "$(_open)" "https://${_domain}.localhost" >/dev/null 2>&1
    done

    _echo_info "nohup \"$(_open)\" https://traefik.localhost/api/rawdata >/dev/null 2>&1\n"
    nohup "$(_open)" https://traefik.localhost/api/rawdata >/dev/null 2>&1
}

