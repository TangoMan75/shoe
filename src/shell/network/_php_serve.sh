#!/bin/sh

# Serve given local directory with PHP
_php_serve() {
    # Synopsis: _php_serve <DOCROOT> [IP] [PORT]
    #   DOCROOT: The root directory.
    #   IP:      (optional) Local IP address. (default=127.0.0.1)
    #   PORT:    (optional) Destination port. (default=8080)

    _check_installed php

    if [ -z "$1" ]; then echo_danger 'error: _php_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _php_serve: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then echo_danger "error: _php_serve: \"$1\" folder not found\n"; return 1; fi

    echo_info "php -d memory-limit=-1 -S \"$2:$3\" -t \"$1\"\n"
    php -d memory-limit=-1 -S "$2:$3" -t "$1"
}

