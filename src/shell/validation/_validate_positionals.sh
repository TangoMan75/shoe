#!/bin/sh

## Validate positional parameters against the function shoedoc
##
## Each positional value is matched with the parameter declared at the
## same position. Parameters without a constraint accept any value.
##
## @namespace src/shell/validation
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/validation/_validate
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The command being executed.
## @param {str} <POSITIONAL> The positional values to validate.
_validate_positionals() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_positionals: some mandatory parameter is missing\n'

        return 1
    fi

    __script__="$1"
    __function__="$2"
    shift 2

    __index__=0
    for __value__ in "$@"; do
        __index__=$((__index__ + 1))
        __record__=$(
            _get_function_parameters "${__script__}" "${__function__}" \
                | awk -F '\037' -v wanted="${__index__}" '
                    $1 == "param" {
                        count++
                        if (count == wanted) {
                            print $2 "\037" $5
                            exit
                        }
                    }
                '
        )
        if [ -z "${__record__}" ]; then continue; fi

        __name__="${__record__%%"$(printf '\037')"*}"
        __constraint__="${__record__#*"$(printf '\037')"}"
        if [ -z "${__constraint__}" ]; then continue; fi

        _validate "${__name__}=${__value__}" "${__constraint__}"
    done
}

