#!/bin/sh

# Clear Symfony cache
#
# {
#   "namespace": "symfony",
#   "depends": [
#     "_console",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "ENV",
#       "type": "str",
#       "description": "Environment.",
#       "constraint": "/^(dev|prod|test)$/"
#     }
#   ]
# }
_sf_cache() {
    if [ -z "$1" ]; then echo_danger 'error: _sf_cache: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then echo_danger "error: _sf_cache: too many arguments ($#)\n"; return 1; fi

    echo_info "$(_console) cache:clear --env \"$1\"\n"
    $(_console) cache:clear --env "$1"

    echo_info "$(_console) cache:warmup --env \"$1\"\n"
    $(_console) cache:warmup --env "$1"
}

