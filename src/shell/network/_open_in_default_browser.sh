#!/bin/sh

## Open in default browser
##
## @namespace src/shell/network
## @requires nohup
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_open
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
## @param {str} <SCHEME> (default:"http") scheme - e.g. http.
_open_in_default_browser() {
    if [ $# -gt 3 ]; then _echo_error "_open_in_default_browser: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}" "${3:-http}"

    _echo_info "nohup \"$(_open)\" \"$3://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "$3://$1:$2" >/dev/null 2>&1
}

