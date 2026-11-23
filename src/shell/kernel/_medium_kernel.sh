#!/bin/sh

## Shoe Medium Kernel
##
## Kernel for scripts that need global flags and options but no
## per-command parameters.
##
## Global (file-level) flags and options apply to the script and may
## appear anywhere on the command line. Exactly one command may be
## given: it runs without positional parameters, flags or options.
## Command arguments are rejected instead of being silently ignored.
##
## `help` prints the script documentation and takes no target argument.
## `_default` runs when no command is given. Optional `_before` and
## `_after` hooks run around the command: `_after` runs only when the
## command succeeded, and never masks its exit status.
##
## @namespace src/shell/kernel
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/help/_help.sh
## @depends src/shell/hooks/_after.sh
## @depends src/shell/hooks/_before.sh
## @depends src/shell/hooks/_default.sh
## @depends src/shell/reflexion/_get_constraint.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @depends src/shell/reflexion/_get_options.sh
## @depends src/shell/validation/_check_duplicate_functions.sh
## @depends src/shell/validation/_validate.sh
_medium_kernel() {
    # Abort before doing anything when the script declares two functions
    # with the same name: command resolution would silently pick one.
    _check_duplicate_functions "$0"

    # Without any argument there is no command to resolve: run the
    # default hook immediately.
    if [ $# -lt 1 ]; then _default; exit 0; fi

    # Global (file-level) flags and options apply to every command.
    __global_flags__="$(_get_flags "$0")"
    __global_options__="$(_get_options "$0")"

    # Command selected by the command line.
    __command__=''

    # A literal `--` ends global option parsing. The command itself may
    # still follow it, but no later argument is read as a global input.
    __options_ended__='false'

    #--------------------------------------------------
    # Parse global inputs and resolve the command
    #--------------------------------------------------

    __remaining__=$#

    while [ "${__remaining__}" -gt 0 ]; do
        __argument__="$1"
        shift
        __remaining__=$((__remaining__ - 1))

        if [ "${__options_ended__}" = 'false' ] &&
           [ "${__argument__}" = '--' ]; then
            __options_ended__='true'
            continue
        fi

        # Global flags never consume the following argument.
        __matched__='false'
        if [ "${__options_ended__}" = 'false' ]; then
            for __flag__ in ${__global_flags__}; do
                __short__="${__flag__%"${__flag__#?}"}"
                if [ "${__argument__}" = "--${__flag__}" ] ||
                   [ "${__argument__}" = "-${__short__}" ]; then
                    eval "${__flag__}=true"
                    __matched__='true'
                    break
                fi
            done
        fi
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # Global options consume the following argument as their value.
        if [ "${__options_ended__}" = 'false' ]; then
            for __option__ in ${__global_options__}; do
                __short__="${__option__%"${__option__#?}"}"
                if [ "${__argument__}" != "--${__option__}" ] &&
                   [ "${__argument__}" != "-${__short__}" ]; then
                    continue
                fi

                if [ "${__remaining__}" -eq 0 ]; then
                    _echo_error "\"--${__option__}\" requires value\n"
                    exit 1
                fi

                __value__="$1"
                shift
                __remaining__=$((__remaining__ - 1))
                __constraint__="$(_get_constraint \
                    "$0" "${__option__}")" || exit 1
                _validate "${__option__}=${__value__}" \
                    "${__constraint__}" || exit 1
                eval "${__option__}=\"\${__value__}\""
                __matched__='true'
                break
            done
        fi
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # A known command is selected. Only one command may be given.
        __matched__='false'
        for __candidate__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" != "${__candidate__}" ]; then continue; fi

            if [ -z "${__command__}" ]; then
                __command__="${__candidate__}"
            else
                _echo_error 'only one command at a time\n'
                exit 1
            fi

            __matched__='true'
            break
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # No other input is supported: commands take neither positional
        # parameters nor their own flags and options.
        case "${__argument__}" in
            -*) _echo_error "\"${__argument__}\" is not a valid parameter\n" ;;
            *) _echo_error "\"${__argument__}\" is not a valid command\n" ;;
        esac
        exit 1
    done

    # Without a command, run the default hook only when the command line
    # carried no unsupported input.
    if [ -z "${__command__}" ]; then
        _default
        exit 0
    fi

    # Optional pre-execution hook, when the script defines one.
    if [ -n "$(command -v _before)" ]; then _before; fi

    # `help` is special: it never runs, it displays the script help
    if [ "${__command__}" = 'help' ]; then
        _help "$0" '' || exit $?
        exit 0
    fi

    # Commands run without positional parameters: their flags, options
    # and parameters are not supported by this kernel.
    __status__=0
    "${__command__}" || __status__=$?

    # Optional post-execution hook, when the script defines one. It runs
    # only when the command succeeded, and never masks the exit status.
    if [ "${__status__}" -eq 0 ] && [ -n "$(command -v _after)" ]; then
        _after || :
    fi

    exit "${__status__}"
}

_medium_kernel "$@"

