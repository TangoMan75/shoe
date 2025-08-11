#!/bin/sh

# Shoe Kernel
_kernel() {
    __functions_names__=$(_get_functions_names "$0" true)
    for __function__ in ${__functions_names__}; do
        if [ "$(printf "%s" "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            echo_danger "error: function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    if [ ${#} -lt 1 ]; then _default; exit 0; fi

    __error__=''
    __execute__=''
    __requires_value__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        # check if previous argument requires value
        if [ -n "${__requires_value__}" ]; then
            # invalid parameters will raise errors
            _validate "${__requires_value__}=${__argument__}"
            eval "${__requires_value__}=\"${__argument__}\";"
            __requires_value__=''
            continue
        fi
        if [ -n "$(printf '%s' "${__argument__}" | awk '/^--?[a-zA-Z0-9_]+$/')" ]; then
            # check argument is a valid flag (must start with - or --)
            for __flag__ in $(_get_flags "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__flag__}" | awk '{$0=substr($0,1,1); print}')"
                if [ "${__argument__}" = "--${__flag__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    eval "${__flag__}=true"
                    __is_valid__=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for __option__ in $(_get_options "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__option__}" | awk '{$0=substr($0,1,1); print}')"
                if [ "${__argument__}" = "--${__option__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    __requires_value__="${__option__}"
                    __is_valid__=true
                    break
                fi
            done
            if [ "${__is_valid__}" = false ]; then
                __error__="\"${__argument__}\" is not a valid parameter\n"
                break
            fi
            continue
        fi
        for __function__ in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${__function__}" | awk '{$0=substr($0,1,1); print}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execute__="${__execute__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            __error__="\"${__argument__}\" is not a valid command\n"
            break
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        __error__="\"--${__requires_value__}\" requires value\n"
    fi

    if [ -n "${__error__}" ]; then
        echo_danger "error: ${__error__}"
        exit 1
    fi

    if [ -n "$(command -v _before)" ]; then _before; fi

    if [ -z "${__execute__}" ]; then _default; exit 0; fi

    for __function__ in ${__execute__}; do
        eval "${__function__}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

