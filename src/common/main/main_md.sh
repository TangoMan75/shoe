#!/bin/sh

## shoe-md main function with hooks
_main() {
    # medium version is optimized for performance, does not handle flags.
    #
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [X] options + validation
    #   - [ ] flags

    if [ ${#} -lt 1 ]; then _default; exit 0; fi

    __error__=''
    __eval__=''
    __execute__=''
    __requires_value__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        # check if previous argument requires value
        if [ -n "${__requires_value__}" ]; then
            __eval__="${__eval__} ${__requires_value__}=${__argument__}"
            __requires_value__=''
            continue
        fi
        # check argument is a valid option (must start with - or --)
        if [ -n "$(printf '%s' "${__argument__}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            for __option__ in $(_get_options "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__option__}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument__}" = "--${__option__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    __requires_value__="${__option__}"
                    __is_valid__=true
                    break
                fi
            done
            if [ "${__is_valid__}" = false ]; then
                __error__="\"${__argument__}\" is not a valid option"
                break
            fi
            continue
        fi
        for __function__ in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${__function__}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execute__="${__execute__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            __error__="\"${__argument__}\" is not a valid command"
            break
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        __error__="\"--${__requires_value__}\" requires value"
    fi

    if [ -n "${__error__}" ]; then
        echo_danger "error: ${__error__}"
        exit 1
    fi

    for __option__ in ${__eval__}; do
        # invalid parameters will raise errors
        _validate "${__option__}"
        eval "${__option__}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function__ in ${__execute__}; do
        eval "${__function__}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

