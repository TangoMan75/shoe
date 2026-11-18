#!/bin/sh

## Shoe Default Kernel
##
## @namespace src/shell/kernel
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @depends src/shell/hooks/_after
## @depends src/shell/hooks/_before
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/reflexion/_get_options
## @depends src/shell/validation/_check_duplicate_functions
## @depends src/shell/validation/_validate
_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''
    __flags__="$(_get_flags "$0")"
    __options__="$(_get_options "$0")"

    #--------------------------------------------------
    # Resolve flags, options and commands
    #--------------------------------------------------

    while [ $# -gt 0 ]; do
        __argument__="$1"
        shift

        # Command names never start with a dash.
        case "${__argument__}" in
            -*)
                # Flags never consume the following argument.
                for __parameter__ in ${__flags__}; do
                    __short__="${__parameter__%"${__parameter__#?}"}"
                    if [ "${__argument__}" = "--${__parameter__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        eval "${__parameter__}=true"
                        continue 2
                    fi
                done

                # Options consume the following argument as their value.
                for __parameter__ in ${__options__}; do
                    __short__="${__parameter__%"${__parameter__#?}"}"
                    if [ "${__argument__}" = "--${__parameter__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        if [ $# -eq 0 ]; then
                            _echo_error "\"--${__parameter__}\" requires value\n"
                            exit 1
                        fi
                        _validate "${__parameter__}=$1"
                        eval "${__parameter__}=\"\${1}\""
                        shift
                        continue 2
                    fi
                done

                _echo_error "\"${__argument__}\" is not a valid parameter\n"
                exit 1
                ;;
        esac

        # Every remaining argument must be a declared command.
        for __function__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                continue 2
            fi
        done

        _echo_error "\"${__argument__}\" is not a valid command\n"
        exit 1
    done

    #--------------------------------------------------
    # Run hooks and dispatch resolved commands
    #--------------------------------------------------

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

    if [ -z "${__execution_stack__}" ]; then _default; exit 0; fi

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done

    [ -n "$(command -v _after)" ] && _after
}

_kernel "$@"

