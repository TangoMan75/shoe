#!/bin/sh

## {
##   "namespace": "recipes/traefik/certificates",
##   "summary": "Print configured domains",
##   "depends": [
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning",
##     "src/shell/reflexion/_get_parameter"
##   ]
## }
print_domains() {
    DOMAINS="$(_get_parameter .env DOMAINS)"
    _echo_warning 'Currently configured domains: ';
    _echo_success "${DOMAINS}\n"
}

