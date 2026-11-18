#!/bin/sh

## Shoe Light Kernel
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/validation/_check_duplicate_functions
## @assumes _DANGER _EOL
_light_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''

    for __argument__ in "$@"; do
        # Append resolved commands to the execution stack.
        for __function__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                continue 2
            fi
        done

        # Unknown arguments raise an error and print the help.
        printf "${_DANGER}error: \"%s\" is not a valid command${_EOL}" "${__argument__}"
        exit 1
    done

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done
}

_light_kernel "$@"

