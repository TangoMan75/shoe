#!/bin/sh

# Check provided user exists
#
# {
#   "namespace": "system",
#   "requires": [
#     "awk"
#   ],
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "USERNAME",
#       "type": "str",
#       "description": "The username to check.",
#       "nullable": false
#     }
#   ]
# }
_user_exists() {
    # Synopsis: _user_exists [USERNAME]
    #   USERNAME: The username to check.

    if [ -z "$1" ]; then echo_danger 'error: _user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _user_exists: too many arguments (${#})\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

