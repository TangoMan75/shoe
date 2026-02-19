#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/development",
##   "summary": "Serve locally with PHP or symfony-cli",
##   "requires": [
##     "php",
##     "symfony"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
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

