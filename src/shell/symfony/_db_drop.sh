#!/bin/sh

# Drop database with Doctrine
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
_db_drop() {
    if [ -z "$1" ]; then echo_danger 'error: _db_drop: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then echo_danger "error: _db_drop: too many arguments ($#)\n"; return 1; fi

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "$(_console) doctrine:database:drop --force --env \"$1\" || true\n"
    $(_console) doctrine:database:drop --force --env "$1" || true
}

