#!/bin/sh

## Shoe Light Kernel
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/help/_help
## @depends src/shell/hooks/_after
## @depends src/shell/hooks/_before
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/validation/_check_duplicate_functions
## @assumes _DANGER _EOL
_light_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __record_separator__=$(printf '\036')
    __field_separator__=$(printf '\037')
    __execution_stack__=''
    __plan__=''

    for __argument__ in "$@"; do
        # Append resolved commands to the execution stack.
        for __function__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __plan__="${__plan__}${__record_separator__}${__function__}"
                continue 2
            fi
        done

        # Every other argument is a positional parameter of the command
        # resolved last. A positional before any command is an error.
        if [ -z "${__execution_stack__}" ]; then
            printf "${_DANGER}error: \"%s\" is not a valid command${_EOL}" "${__argument__}"
            exit 1
        fi
        __plan__="${__plan__}${__field_separator__}${__argument__}"
    done

    [ -n "$(command -v _before)" ] && _before

    # `help` takes precedence over every command around it.
    __function__=''
    for __argument__ in ${__execution_stack__}; do
        if [ "${__function__}" = 'help' ]; then
            _help "$0" "${__argument__}"
            exit 0
        fi
        __function__="${__argument__}"
    done

    if [ "${__function__}" = 'help' ]; then
        _help "$0" ''
        exit 0
    fi

    # Dispatch each command with its positional parameters. Word
    # splitting is intentional here, so pathname expansion is disabled.
    __old_ifs__="${IFS}"
    case "$-" in *f*) __noglob__='true' ;; *) __noglob__='false' ;; esac
    IFS="${__record_separator__}"
    for __record__ in ${__plan__}; do
        if [ -z "${__record__}" ]; then continue; fi
        IFS="${__field_separator__}"
        set -f
        # shellcheck disable=SC2086  # word splitting is intentional
        set -- ${__record__}
        [ "${__noglob__}" = 'true' ] || set +f
        IFS="${__old_ifs__}"
        __function__="$1"
        shift
        eval "${__function__} \"\$@\""
    done
    IFS="${__old_ifs__}"

    [ -n "$(command -v _after)" ] && _after
}

_light_kernel "$@"

