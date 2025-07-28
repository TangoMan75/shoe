#!/bin/sh

# Open in default browser
_open_in_default_browser() {
    # Synopsis: _open_in_default_browser [IP] [PORT] [SCHEME]
    #   IP:     (optional) Target IP address or domain. (default=127.0.0.1)
    #   PORT:   (optional) Destination port. (default=8080)
    #   SCHEME: (optional) scheme - e.g. http. (default=http)

    if [ ${#} -gt 3 ]; then echo_danger "error: _open_in_default_browser: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}" "${3:-http}"

    echo_info "nohup \"$(_open)\" \"$3://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "$3://$1:$2" >/dev/null 2>&1
}

