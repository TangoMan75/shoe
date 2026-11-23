#!/bin/sh

## Checks if variable is valid given regex constraint
##
## The pattern is applied with POSIX extended regular expressions, as
## data (never as a command-line option), and every line of the value
## must match it in full.
##
## @namespace src/shell/validation
## @requires awk printf sed
## @depends src/shell/colors/_echo_error.sh
## @param {str} <VALUE> (required) The string to be compared to regex pattern.
## @param {str} <PATTERN> (required) The regex parttern to apply.
_is_valid() {
    if [ $# -lt 2 ]; then _echo_error '_is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_valid: too many arguments ($#)\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # remove leading and ending forward slashes from regular expression,
    # including its optional trailing flags
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/[a-z]*$@@')"

    # The pattern is passed through the environment because `awk -v`
    # expands escape sequences such as "\." and corrupts the expression.
    # The match is checked for full-line coverage instead of wrapping the
    # pattern in "^(...)$", because some awks (BWK awk on macOS) treat a
    # mid-expression "^" or "$" as a literal character.
    if ! printf '%s\n' "$1" | __pattern__="$2" awk '
        BEGIN { pattern = ENVIRON["__pattern__"] }
        {
            if (!match($0, pattern) || substr($0, RSTART, RLENGTH) != $0) {
                invalid = 1
            }
        }
        END { exit invalid }
    '; then

        return 1
    fi

    return 0
}

