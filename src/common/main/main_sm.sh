#!/bin/sh

#--------------------------------------------------
# shoe-sm main function with hooks
#--------------------------------------------------

_main() {
    # small version is optimized for performance, does not handle flags, options and validation.
    #
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [ ] options + validation
    #   - [ ] flags

    if [ ${#} -lt 1 ]; then help; exit 0; fi

    __execute=''
    for __argument in "$@"; do
        __is_valid=false
        for __function in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand="$(printf '%s' "${__function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument}" = "${__function}" ] || [ "${__argument}" = "${__shorthand}" ]; then
                # append argument to the execute stack
                __execute="${__execute} ${__function}"
                __is_valid=true
                break
            fi
        done
        # unknown parameters will raise errors
        if [ "${__is_valid}" = false ]; then
            printf "${DANGER}error: \"%s\" is not a valid command${EOL}" "${__argument}"
            exit 1
        fi
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function in ${__execute}; do
        eval "${__function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

