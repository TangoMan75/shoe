#!/bin/sh

# Open in default browser
#
# {
#   "namespace": "network",
#   "depends": [
#     "_open",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "IP",
#       "type": "str",
#       "description": "Target IP address or domain.",
#       "default": "127.0.0.1"
#     },
#     {
#       "position": 2,
#       "name": "PORT",
#       "type": "int",
#       "description": "Destination port.",
#       "default": "8080",
#       "constraint": "/^[0-9]{1,5}$/"
#     }
#   ]
# }
_open_in_default_browser() {
    # Synopsis: _open_in_default_browser [IP] [PORT]
    #   IP:   (optional) Target IP address or domain. (default=127.0.0.1)
    #   PORT: (optional) Destination port. (default=8080)

    if [ ${#} -gt 2 ]; then echo_danger "error: _open_in_default_browser: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}"

    echo_info "nohup \"$(_open)\" \"http://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "http://$1:$2" >/dev/null 2>&1
}

