#!/bin/sh

# Serve given local directory with Python 3
_py_serve() {
    # Synopsis: _py_serve <DOCROOT> [IP] [PORT]
    #   DOCROOT: The root directory.
    #   IP:      (optional) Local IP address. (default=127.0.0.1)
    #   PORT:    (optional) Destination port. (default=8080)

    _check_installed python3

    if [ -z "$1" ]; then echo_danger 'error: _py_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _py_serve: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then echo_danger "error: _php_serve: \"$1\" folder not found\n"; return 1; fi

    echo_info "python3 -m http.server --directory \"$1\" --bind \"$2\" \"$3\"\n"
    python3 -m http.server --directory "$1" --bind "$2" "$3"
}

