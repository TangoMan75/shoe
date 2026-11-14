#!/bin/sh

## Serve given local directory with PHP
##
## @namespace src/shell/network
## @requires php realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {folder} <DOCROOT> (required) The path to the root directory.
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
_php_serve() {
    _check_installed php

    if [ -z "$1" ]; then _echo_error '_php_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_php_serve: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then _echo_error "_php_serve: \"$1\" folder not found\n"; return 1; fi

    _echo_info "php -d memory-limit=-1 -S \"$2:$3\" -t \"$1\"\n"
    php -d memory-limit=-1 -S "$2:$3" -t "$1"
}

