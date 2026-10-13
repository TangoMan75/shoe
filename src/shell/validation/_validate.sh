#!/bin/sh

## {
##   "namespace": "src/shell/validation",
##   "summary": "Find constraints and validates a variable",
##   "requires": [
##     "cut",
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/reflexion/_get_constraint",
##     "src/shell/validation/_is_valid"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "VARIABLE",
##       "type": "str",
##       "description": "The variable to validate in the followling format : variable_name=value.",
##       "nullable": false
##     }
##   ]
## }
_validate() {
    # Synopsis: _validate <VARIABLE>
    #   VARIABLE: The variable to validate in the followling format : variable_name=value.

    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2)" "$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

