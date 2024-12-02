#!/bin/sh

#--------------------------------------------------
# shoe-md main function with hooks
#--------------------------------------------------

_main() {
    # medium version is optimized for performance, does not handle flags.
    #
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [X] options + validation
    #   - [ ] flags

    if [ ${#} -lt 1 ]; then help; exit 0; fi

    _error=''
    _eval=''
    _execute=''
    _requires_value=''
    for _argument in "$@"; do
        _is_valid=false
        # check if previous argument requires value
        if [ -n "${_requires_value}" ]; then
            _eval="${_eval} ${_requires_value}=${_argument}"
            _requires_value=''
            continue
        fi
        # check argument is a valid option (must start with - or --)
        if [ -n "$(printf '%s' "${_argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            for _option in $(_get_options "$0"); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_option}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_option}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    _requires_value="${_option}"
                    _is_valid=true
                    break
                fi
            done
            if [ "${_is_valid}" = false ]; then
                _error="\"${_argument}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names "$0"); do
            # get shorthand character
            _shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                # append argument to the execute stack
                _execute="${_execute} ${_function}"
                _is_valid=true
                break
            fi
        done
        if [ "${_is_valid}" = false ]; then
            _error="\"${_argument}\" is not a valid command"
            break
        fi
    done

    if [ -n "${_requires_value}" ]; then
        _error="\"--${_requires_value}\" requires value"
    fi

    if [ -n "${_error}" ]; then
        printf "${DANGER}error: %s${EOL}" "${_error}"
        exit 1
    fi

    for _option in ${_eval}; do
        # invalid parameters will raise errors
        _validate "${_option}"
        eval "${_option}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for _function in ${_execute}; do
        eval "${_function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

