#!/bin/sh

## Serve locally with PHP or Symfony
##
## {
##   "namespace": "development",
##   "requires": [
##     "php",
##     "symfony"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
serve() {
    if _check_installed symfony; then
        _echo_info "symfony serve --port=${port} --no-tls\n"
        symfony serve --port=${port} --no-tls
    else
        _echo_info "php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public\n"
        php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public
    fi
}

