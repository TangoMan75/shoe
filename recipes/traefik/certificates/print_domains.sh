#!/bin/sh

## Print configured domains
##
## {
##   "namespace": "certificates",
##   "depends": [
##     "_echo_info",
##     "_echo_success",
##     "_get_parameter"
##   ]
## }
print_domains() {
    DOMAINS="$(_get_parameter .env DOMAINS)"
    _echo_warning 'Currently configured domains: ';
    _echo_success "${DOMAINS}\n"
}

