#!/bin/sh

## Generate a random alphanumeric string
##
## @namespace src/shell/strings
## @requires cut od printf tr
## @depends src/shell/colors/_echo_error.sh
## @param {int} <LENGTH> (required) The length of the generated string.
_generate_random_string() {
    if [ -z "$1" ]; then _echo_error '_generate_random_string: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_generate_random_string: too many arguments ($#)\n"; return 1; fi

    if [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '0-9')" ] \
        || [ "${1#0}" != "$1" ]; then
        _echo_error '_generate_random_string: length should be a positive integer\n'

        return 1
    fi

    # Read a bounded number of random bytes and keep the first characters
    # of their hexadecimal representation. This avoids relying on SIGPIPE
    # to terminate an endless "/dev/urandom" pipeline, which hangs when
    # SIGPIPE is ignored, as on some CI runners.
    LC_ALL=C od -v -A n -N "$(( ($1 + 1) / 2 ))" -t x1 /dev/urandom \
      | tr -d ' \n' \
      | cut -c "1-$1"
}

