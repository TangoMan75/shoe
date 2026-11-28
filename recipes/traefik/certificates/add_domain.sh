#!/bin/sh

## Add a new domain to current local certificates
##
## @namespace recipes/traefik/certificates
## @requires read
## @depends recipes/traefik/certificates/certs.sh
## @depends recipes/traefik/certificates/print_domains.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/reflexion/_get_parameter.sh
## @depends src/shell/reflexion/_set_parameter.sh
## @assumes domain env
add_domain() {
    if [ "${env}" = prod ]; then
        _echo_error 'This command should not be executed in production environement!\n'

        return 0
    fi

    print_domains

    while [ -z "${domain}" ]; do
        _echo_success "Enter domain name (without tld) (eg: traefik): "
        read -r domain
    done

    DOMAINS="$(_get_parameter .env DOMAINS)"
    _set_parameter .env DOMAINS "\"${DOMAINS} ${domain}\""

    certs
}

