#!/bin/sh

## Shoe Large Kernel
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @depends src/shell/hooks/_after
## @depends src/shell/hooks/_before
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_constraint
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/reflexion/_get_options
## @depends src/shell/validation/_check_duplicate_functions
## @depends src/shell/validation/_validate
## @depends src/shell/validation/_validate_positionals
## @assumes __default__
_large_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __separator__="$(printf '\037')"
    __record_separator__="$(printf '\036')"
    __functions_names__="$(_get_functions_names "$0")"
    __all_options__=''
    __plan__=''

    #--------------------------------------------------
    # Collect every option spelling
    #--------------------------------------------------

    # Commands are resolved before their scope is known, so the value of
    # any option declared by the script or its globals must be skipped.
    # Only options consume the following argument, hence only their
    # spellings are collected here.

    for __name__ in $(_get_options "$0"); do
        __short__="${__name__%"${__name__#?}"}"
        __all_options__="${__all_options__} --${__name__} -${__short__}"
    done

    for __function__ in ${__functions_names__}; do
        __records__="$(_get_function_parameters "$0" "${__function__}")"

        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" = 'option' ]; then
                __short__="${__short__:-${__name__%"${__name__#?}"}}"
                __long__="${__long__:-${__name__}}"
                __all_options__="${__all_options__} --${__long__}"
                __all_options__="${__all_options__} --${__name__} -${__short__}"
            fi
        done <<EOF
${__records__}
EOF
    done

    #--------------------------------------------------
    # Resolve commands before validating option scopes
    #--------------------------------------------------

    __execution_stack__=''
    __skip_next__='false'

    for __argument__ in "$@"; do
        # The value of an option must not be resolved as a command.
        if [ "${__skip_next__}" = 'true' ]; then
            __skip_next__='false'
            continue
        fi

        # Only options consume the following argument as their value.
        case " ${__all_options__} " in
            *" ${__argument__} "*)
                __skip_next__='true'
                continue
                ;;
        esac

        # Every other parameter is validated against the resolved scope.
        case "${__argument__}" in
            -*) continue;;
        esac

        # Every declared command starts a new execution record.
        for __function__ in ${__functions_names__}; do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __plan__="${__plan__}${__record_separator__}${__function__}"
                continue 2
            fi
        done

        # Every other argument is a positional parameter of the command
        # resolved last. A positional before any command is an error.
        if [ -z "${__execution_stack__}" ]; then
            _echo_error "\"${__argument__}\" is not a valid command\n"
            exit 1
        fi
        __plan__="${__plan__}${__separator__}${__argument__}"
    done

    #--------------------------------------------------
    # Build the parameter scope from global and command entries
    #--------------------------------------------------

    __scope__=''

    # Global flags carry neither constraint nor default value.
    for __name__ in $(_get_flags "$0"); do
        __short__="${__name__%"${__name__#?}"}"
        __scope__="${__scope__}flag${__separator__}${__name__}"
        __scope__="${__scope__}${__separator__}${__short__}"
        __scope__="${__scope__}${__separator__}${__name__}
"
    done

    # Global options carry a constraint, but no default value.
    for __name__ in $(_get_options "$0"); do
        __short__="${__name__%"${__name__#?}"}"
        __constraint__="$(_get_constraint "$0" "${__name__}")"
        __scope__="${__scope__}option${__separator__}${__name__}"
        __scope__="${__scope__}${__separator__}${__short__}"
        __scope__="${__scope__}${__separator__}${__name__}"
        __scope__="${__scope__}${__separator__}${__constraint__}
"
    done

    # Command entries also provide the default value of their options.
    for __function__ in ${__execution_stack__}; do
        __records__="$(_get_function_parameters "$0" "${__function__}")"
        if [ -z "${__records__}" ]; then continue; fi

        __scope__="${__scope__}${__records__}
"

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
    done

    #--------------------------------------------------
    # Parse parameters within the resolved command scope
    #--------------------------------------------------

    while [ $# -gt 0 ]; do
        __argument__="$1"
        shift

        # Command names were already resolved during the first pass.
        case "${__argument__}" in
            -*) ;;
            *) continue;;
        esac

        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            # Ignore the trailing empty line of the record block, and
            # only options and flags are addressed by name on the command
            # line: positionals are handled by the execution plan.
            if [ -z "${__kind__}" ]; then continue; fi
            if [ "${__kind__}" != 'flag' ] && [ "${__kind__}" != 'option' ]; then
                continue
            fi

            if [ -z "${__short__}" ]; then
                __short__="${__name__%"${__name__#?}"}"
            fi
            __long__="${__long__:-${__name__}}"

            if [ "${__argument__}" = "--${__long__}" ] ||
               [ "${__argument__}" = "--${__name__}" ] ||
               [ "${__argument__}" = "-${__short__}" ]; then
                if [ "${__kind__}" = 'flag' ]; then
                    eval "${__name__}=true"
                elif [ $# -eq 0 ]; then
                    _echo_error "\"--${__name__}\" requires value\n"
                    exit 1
                else
                    _validate "${__name__}=$1" "${__constraint__}"
                    eval "${__name__}=\"\${1}\""
                    shift
                fi
                continue 2
            fi
        done <<EOF
${__scope__}
EOF

        _echo_error "\"${__argument__}\" is not a valid parameter\n"
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

    # Dispatch each command with its positional parameters. Word
    # splitting is intentional here, so pathname expansion is disabled.
    __old_ifs__="${IFS}"
    case "$-" in *f*) __noglob__='true' ;; *) __noglob__='false' ;; esac
    IFS="${__record_separator__}"
    for __record__ in ${__plan__}; do
        if [ -z "${__record__}" ]; then continue; fi
        IFS="${__separator__}"
        set -f
        # shellcheck disable=SC2086  # word splitting is intentional
        set -- ${__record__}
        [ "${__noglob__}" = 'true' ] || set +f
        IFS="${__old_ifs__}"
        __function__="$1"
        shift
        _validate_positionals "$0" "${__function__}" "$@"
        eval "${__function__} \"\$@\""
    done
    IFS="${__old_ifs__}"

    [ -n "$(command -v _after)" ] && _after
}

_large_kernel "$@"

