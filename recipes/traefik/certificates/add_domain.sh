#!/bin/sh

## Add a new domain to current local certificates
##
## {
##   "namespace": "certificates",
##   "requires": [
##     "read"
##   ],
##   "depends": [
##     "_echo_error",
##     "_get_parameter",
##     "_set_parameter",
##     "certs",
##     "print_domains"
##   ],
##   "assumes": [
##     "domain"
##   ]
## }
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

