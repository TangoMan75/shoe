#!/bin/sh

## Bind positional parameters to the variables named in a function shoedoc
##
## Each positional value is matched with the `@param` declaration at the
## same position. The value is validated against the declared constraint,
## then assigned to the variable named by the declaration. Parameters
## without a value receive their declared default value, or an empty value
## when they declare none. A parameter annotated `(required)` aborts the
## command when no value is supplied, and surplus positional values are
## rejected instead of being silently discarded.
##
## Commands therefore read their parameters from named variables, and the
## positional parameters of the command itself remain empty.
##
## @namespace src/shell/validation
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/validation/_validate.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The command being executed.
## @param {str} <POSITIONAL> The positional values to bind.
_validate_positionals() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_positionals: some mandatory parameter is missing\n'

        return 1
    fi

    __script__="$1"
    __function__="$2"
    shift 2

    # Number of positional values supplied, reported when some are left
    # over after every declared parameter has been bound.
    __positional_count__=$#

    __records__="$(_get_function_parameters \
        "${__script__}" "${__function__}")" || return 1
    if [ -z "${__records__}" ]; then return 0; fi

    __separator__="$(printf '\037')"
    while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
          __long__ __constraint__ __default__ __required__ \
          __description__; do
        # Only positional parameters are bound here: options and flags
        # are handled by the kernel that owns the command line.
        if [ "${__kind__}" != 'param' ]; then continue; fi

        if [ $# -gt 0 ]; then
            # Consume the next positional value and validate it against
            # the shoedoc constraint, if any.
            __value__="$1"
            shift
            __assign__="\"\${__value__}\""
            if [ -n "${__constraint__}" ]; then
                _validate "${__name__}=${__value__}" "${__constraint__}"
            fi
        elif [ -n "${__default__}" ]; then
            # The default is shell syntax, evaluated the same way as an
            # option default by the kernel.
            __assign__="${__default__}"
        elif [ "${__required__}" = 'true' ]; then
            _echo_error "_validate_positionals: \"${__name__}\" is required\n"

            return 1
        else
            # Reset the variable so a previous command cannot leak its
            # own value into this one.
            __assign__='""'
        fi

        eval "${__name__}=${__assign__}"
    done <<EOF
${__records__}
EOF

    if [ "$#" -gt 0 ]; then
        _echo_error "_validate_positionals: too many arguments (${__positional_count__})\n"

        return 1
    fi

    return 0
}

