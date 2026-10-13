#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Run a local web server with Symfony CLI",
##   "requires": [
##     "symfony"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_sf_serve() {
    _check_installed symfony

    _echo_info 'symfony local:server:start --no-tls\n'
    symfony local:server:start --no-tls
}

