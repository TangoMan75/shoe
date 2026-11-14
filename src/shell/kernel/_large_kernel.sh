#!/bin/sh

## Shoe Kernel
##
## @namespace src/shell/kernel
## @requires awk grep printf
## @depends src/shell/colors/_echo_error src/shell/help/_help src/shell/hooks/_after src/shell/hooks/_before src/shell/hooks/_default src/shell/reflexion/_get_constraint src/shell/reflexion/_get_flags src/shell/reflexion/_get_function_parameters src/shell/reflexion/_get_functions_names src/shell/reflexion/_get_options src/shell/validation/_validate
## @assumes __default__
_large_kernel() {
    # Check for duplicate function definitions
    __functions_names__=$(_get_functions_names "$0" 'true')
    for __function__ in ${__functions_names__}; do
        if [ "$(printf "%s" "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __separator__=$(printf '\037')
    __functions_names__=$(_get_functions_names "$0")
    __global_flags__=$(_get_flags "$0")
    __global_options__=$(_get_options "$0")

    #--------------------------------------------------
    # Collect parameter spellings for command detection
    #--------------------------------------------------

    __all_parameters__=''
    __all_options__=''

    for __parameter__ in ${__global_flags__}; do
        __shorthand__="$(printf '%s' "${__parameter__}" | awk '{print substr($0,1,1)}')"
        __all_parameters__="${__all_parameters__} --${__parameter__} -${__shorthand__}"
    done

    for __parameter__ in ${__global_options__}; do
        __shorthand__="$(printf '%s' "${__parameter__}" | awk '{print substr($0,1,1)}')"
        __all_parameters__="${__all_parameters__} --${__parameter__} -${__shorthand__}"
        __all_options__="${__all_options__} --${__parameter__} -${__shorthand__}"
    done

    for __function__ in ${__functions_names__}; do
        __records__=$(_get_function_parameters "$0" "${__function__}")

        if [ -n "${__records__}" ]; then
            while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
                  __long__ __constraint__ __default__ __description__; do
                if [ -z "${__short__}" ]; then
                    __shorthand__="$(printf '%s' "${__name__}" | awk '{print substr($0,1,1)}')"
                else
                    __shorthand__="${__short__}"
                fi
                __long__="${__long__:-${__name__}}"

                __all_parameters__="${__all_parameters__} --${__long__} --${__name__} -${__shorthand__}"

                if [ "${__kind__}" = 'option' ]; then
                    __all_options__="${__all_options__} --${__long__} --${__name__} -${__shorthand__}"
                fi
            done <<EOF
${__records__}
EOF
        fi
    done

    #--------------------------------------------------
    # Resolve commands before validating option scopes
    #--------------------------------------------------

    __execution_stack__=''
    __skip_next__='false'

    for __argument__ in "$@"; do
        # Skip the value of a preceding option
        if [ "${__skip_next__}" = 'true' ]; then
            __skip_next__='false'
            continue
        fi

        # An option consumes the following argument as its value
        case " ${__all_options__} " in
            *" ${__argument__} "*)
                __skip_next__='true'
                continue
                ;;
        esac

        # Flags do not consume a value
        case " ${__all_parameters__} " in
            *" ${__argument__} "*)
                continue
                ;;
        esac

        # Unknown parameters are rejected before their value is inspected
        if printf '%s' "${__argument__}" | grep -Eq '^--?[a-zA-Z0-9_]+$'; then
            _echo_error "\"${__argument__}\" is not a valid parameter\n"
            exit 1
        fi

        # Check if argument is a function name or its shorthand
        __is_valid__='false'
        for __function__ in ${__functions_names__}; do
            __shorthand__="$(printf '%s' "${__function__}" | awk '{print substr($0,1,1)}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __is_valid__='true'
                break
            fi
        done
        if [ "${__is_valid__}" = 'false' ]; then
            _echo_error "\"${__argument__}\" is not a valid command\n"
            exit 1
        fi
    done

    #--------------------------------------------------
    # Build the parameter scope from global and command entries
    #--------------------------------------------------

    __parameters__=''

    for __name__ in ${__global_flags__}; do
        __shorthand__="$(printf '%s' "${__name__}" | awk '{print substr($0,1,1)}')"
        __parameters__="${__parameters__}flag${__separator__}${__name__}${__separator__}${__shorthand__}${__separator__}${__name__}${__separator__}${__separator__}${__separator__}
"
    done

    for __name__ in ${__global_options__}; do
        __shorthand__="$(printf '%s' "${__name__}" | awk '{print substr($0,1,1)}')"
        __constraint__=$(_get_constraint "$0" "${__name__}")
        __parameters__="${__parameters__}option${__separator__}${__name__}${__separator__}${__shorthand__}${__separator__}${__name__}${__separator__}${__constraint__}${__separator__}${__separator__}
"
    done

    for __command__ in ${__execution_stack__}; do
        __records__=$(_get_function_parameters "$0" "${__command__}")
        if [ -n "${__records__}" ]; then
            __parameters__="${__parameters__}${__records__}
"
        fi
    done

    #--------------------------------------------------
    # Initialise command options and flags from annotations
    #--------------------------------------------------

    for __command__ in ${__execution_stack__}; do
        __records__=$(_get_function_parameters "$0" "${__command__}")

        if [ -n "${__records__}" ]; then
            while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
                  __long__ __constraint__ __default__ __description__; do
                if [ "${__kind__}" = 'flag' ]; then
                    eval "${__name__}=false"
                elif [ -n "${__default__}" ]; then
                    eval "${__name__}=${__default__}"
                fi
            done <<EOF
${__records__}
EOF
        fi
    done

    #--------------------------------------------------
    # Parse parameters within the resolved command scope
    #--------------------------------------------------

    __requires_value__=''
    __requires_constraint__=''

    for __argument__ in "$@"; do
        # Handle required value for previous option
        if [ -n "${__requires_value__}" ]; then
            _validate "${__requires_value__}=${__argument__}" "${__requires_constraint__}"
            eval "${__requires_value__}=\"${__argument__}\";"
            __requires_value__=''
            __requires_constraint__=''
            continue
        fi

        # Check if argument is a flag or option (starts with - or --)
        if printf '%s' "${__argument__}" | grep -Eq '^--?[a-zA-Z0-9_]+$'; then
            __is_valid__='false'

            if [ -n "${__parameters__}" ]; then
                while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
                      __long__ __constraint__ __default__ __description__; do
                    if [ -z "${__short__}" ]; then
                        __shorthand__="$(printf '%s' "${__name__}" | awk '{print substr($0,1,1)}')"
                    else
                        __shorthand__="${__short__}"
                    fi
                    __long__="${__long__:-${__name__}}"

                    if [ "${__argument__}" = "--${__long__}" ] ||
                       [ "${__argument__}" = "--${__name__}" ] ||
                       [ "${__argument__}" = "-${__shorthand__}" ]; then
                        if [ "${__kind__}" = 'flag' ]; then
                            eval "${__name__}=true"
                        else
                            __requires_value__="${__name__}"
                            __requires_constraint__="${__constraint__}"
                        fi
                        __is_valid__='true'
                        break
                    fi
                done <<EOF
${__parameters__}
EOF
            fi

            if [ "${__is_valid__}" = 'false' ]; then
                _echo_error "\"${__argument__}\" is not a valid parameter\n"
                exit 1
            fi
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        _echo_error "\"--${__requires_value__}\" requires value\n"
        exit 1
    fi

    [ -n "$(command -v _before)" ] && _before

    if printf '%s' "${__execution_stack__}" | grep -qw 'help'; then
       _help "$0" "$(printf '%s' "${__execution_stack__}" | awk '{for(i=1;i<=NF;i++) if($i=="help") print $(i+1); exit}')"
       exit 0
    fi

    if [ -z "${__execution_stack__}" ]; then _default; exit 0; fi

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done

    [ -n "$(command -v _after)" ] && _after
}

_large_kernel "$@"

