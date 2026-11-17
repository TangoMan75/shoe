#!/bin/sh

## Print configured domains
##
## @namespace recipes/traefik/certificates
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_parameter
print_domains() {
    DOMAINS="$(_get_parameter .env DOMAINS)"
    _echo_warning 'Currently configured domains: ';
    _echo_success "${DOMAINS}\n"
}

