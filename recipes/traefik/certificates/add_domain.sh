#!/bin/sh

## {
##   "namespace": "recipes/traefik/certificates",
##   "summary": "Add a new domain to current local certificates",
##   "requires": [
##     "read"
##   ],
##   "depends": [
##     "recipes/traefik/certificates/certs",
##     "recipes/traefik/certificates/print_domains",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_success",
##     "src/shell/reflexion/_get_parameter",
##     "src/shell/reflexion/_set_parameter"
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

