#!/bin/sh

#--------------------------------------------------
# shoe-lg main function with hooks
#--------------------------------------------------

_main() {
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [X] options + validation
    #   - [X] flags

    if [ ${#} -lt 1 ]; then help; exit 0; fi

    __error=''
    __eval=''
    __execute=''
    __requires_value=''
    for __argument in "$@"; do
        __is_valid=false
        # check if previous argument requires value
        if [ -n "${__requires_value}" ]; then
            __eval="${__eval} ${__requires_value}=${__argument}"
            __requires_value=''
            continue
        fi
        if [ -n "$(printf '%s' "${__argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            # check argument is a valid flag (must start with - or --)
            for __flag in $(_get_flags "$0"); do
                # get shorthand character
                __shorthand="$(printf '%s' "${__flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument}" = "--${__flag}" ] || [ "${__argument}" = "-${__shorthand}" ]; then
                    # append argument to the eval stack
                    __eval="${__eval} ${__flag}=true"
                    __is_valid=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for __option in $(_get_options "$0"); do
                # get shorthand character
                __shorthand="$(printf '%s' "${__option}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument}" = "--${__option}" ] || [ "${__argument}" = "-${__shorthand}" ]; then
                    __requires_value="${__option}"
                    __is_valid=true
                    break
                fi
            done
            if [ "${__is_valid}" = false ]; then
                __error="\"${__argument}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument}" = "${_function}" ] || [ "${__argument}" = "${__shorthand}" ]; then
                # append argument to the execute stack
                __execute="${__execute} ${_function}"
                __is_valid=true
                break
            fi
        done
        if [ "${__is_valid}" = false ]; then
            __error="\"${__argument}\" is not a valid command"
            break
        fi
    done

    if [ -n "${__requires_value}" ]; then
        __error="\"--${__requires_value}\" requires value"
    fi

    if [ -n "${__error}" ]; then
        printf "${DANGER}error: %s${EOL}" "${__error}"
        exit 1
    fi

    for __option in ${__eval}; do
        # invalid parameters will raise errors
        _validate "${__option}"
        eval "${__option}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function in ${__execute}; do
        eval "${__function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

