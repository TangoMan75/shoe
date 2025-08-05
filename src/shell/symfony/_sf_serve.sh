#!/bin/sh

# Run a local web server with Symfony CLI
#
# {
#   "namespace": "symfony",
#   "requires": [
#     "symfony"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_info"
#   ]
# }
_sf_serve() {
    _check_installed symfony

    echo_info 'symfony local:server:start --no-tls\n'
    symfony local:server:start --no-tls
}

