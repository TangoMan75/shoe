#!/bin/sh

## Shoe Light Kernel
##
## {
##   "namespace": "kernel",
##   "assumes": [
##     "DANGER"
##   ],
##   "requires": [
##     "awk",
##     "grep",
##     "printf"
##   ],
##   "depends": [
##     "_default",
##     "_get_functions_names"
##   ]
## }
_kernel() {
    # Check for duplicate function definitions
    __functions_names__=$(_get_functions_names "$0" true)
    for __function__ in ${__functions_names__}; do
        if [ "$(printf "%s" "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            printf "%serror: function \"%s\" is defined multiple times\n" "${DANGER}" "${__function__}"
            exit 1
        fi
    done

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        for __function__ in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${__function__}" | awk '{print substr($0,1,1)}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execution_stack__="${__execution_stack__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        # unknown parameters will raise errors
        if [ "${__is_valid__}" = false ]; then
            printf "${DANGER}error: \"%s\" is not a valid command${NL}" "${__argument__}"
            help
            exit 1
        fi
    done

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done
}

_kernel "$@"
