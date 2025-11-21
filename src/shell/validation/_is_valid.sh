#!/bin/sh

# Checks if variable is valid given regex constraint
#
# {
#   "namespace": "validation",
#   "requires": [
#     "grep",
#     "sed"
#   ],
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "VALUE",
#       "type": "str",
#       "description": "The string to be compared to regex pattern.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "PATTERN",
#       "type": "str",
#       "description": "The regex parttern to apply.",
#       "nullable": false
#     }
#   ]
# }
_is_valid() {
    # Synopsis: _is_valid <VALUE> <PATTERN>
    #   VALUE:   The string to be compared to regex pattern.
    #   PATTERN: The regex parttern to apply.

    if [ $# -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then echo_danger "error: _is_valid: too many arguments ($#)\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # remove leading and ending forward slashes from regular expression
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/$@@')"

    # if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then
    if [ "$1" != "$(printf '%s' "$1" | grep -E "$2")" ]; then

        return 1
    fi

    return 0
}

