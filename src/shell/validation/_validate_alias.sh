#!/bin/sh

## Reject an alias that cannot be used as a single path component
##
## An install alias is concatenated into a path below "/usr/local/bin",
## below "/etc/bash_completion.d" or in the script folder, and the
## resulting command may run through sudo. A slash would let the alias
## address any path, and a leading dot would let it name a hidden or a
## parent entry: only a plain path component is accepted.
##
## @namespace src/shell/validation
## @depends src/shell/colors/_echo_error.sh
## @param {str} <ALIAS> (required) The alias to validate.
## @param {str} <FUNCTION_NAME> (required) The caller, used in the message.
_validate_alias() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_alias: some mandatory parameter is missing\n'

        return 1
    fi
    if [ $# -gt 2 ]; then
        _echo_error "_validate_alias: too many arguments ($#)\n"

        return 1
    fi

    case "$1" in
        ''|*/*|.*)
            _echo_error "$2: invalid alias \"$1\"\n"

            return 1
            ;;
    esac

    return 0
}

