#!/bin/sh

## Shoe Kernel
##
## Full-featured kernel for scripts that need global and per-command
## flags, options and positional parameters.
##
## Global (file-level) flags and options apply to every command and may
## appear anywhere on the command line. Per-command flags and options
## belong to the command they follow; those given before the command
## also belong to it. Command flags and options are initialized and
## bound immediately before the command runs.
##
## Exactly one command may be given on the command line. Positional
## parameters belong to that command and are bound to the variables
## named by its `@param` annotations, which receive the caller value or
## their declared default value. The command itself runs without
## positional parameters. `help` takes precedence over the command name
## that follows it, and `_default` runs when no command is given.
##
## A literal `--` ends option parsing: every following argument is a
## positional parameter of the command, even when it starts with `-`.
##
## `_before` runs before the command. `_after` runs after it only when
## the command succeeded, and never masks the command exit status.
##
## A short or long spelling declared both globally and by a command is
## rejected instead of being silently captured by the global parser.
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/help/_help.sh
## @depends src/shell/hooks/_after.sh
## @depends src/shell/hooks/_before.sh
## @depends src/shell/hooks/_default.sh
## @depends src/shell/reflexion/_get_constraint.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @depends src/shell/reflexion/_get_options.sh
## @depends src/shell/validation/_check_duplicate_functions.sh
## @depends src/shell/validation/_validate.sh
## @depends src/shell/validation/_validate_positionals.sh
_kernel() {
    # Abort before doing anything when the script declares two functions
    # with the same name: command resolution would silently pick one.
    _check_duplicate_functions "$0"

    # Without any argument there is no command to resolve: run the
    # default hook immediately.
    if [ $# -lt 1 ]; then _default; exit 0; fi

    # Shoedoc records are line based and use the ASCII unit separator
    # between their fields. It is reserved for this internal record
    # format and never carries user arguments.
    __unit_separator__="$(printf '\037')"

    # Names of the public functions declared by the script. Only these
    # names can be resolved as commands.
    __commands__="$(_get_functions_names "$0")"

    # Global (file-level) flags and options apply to every command.
    __global_flags__="$(_get_flags "$0")"
    __global_options__="$(_get_options "$0")"

    # Every option spelling declared by a command. This list recognizes
    # the value that follows a command option before the command owning
    # that option is known. The surrounding spaces make membership tests
    # exact without a temporary delimiter.
    __spellings__=' '
    # Every spelling declared by a command, flags included: used to
    # detect a spelling that a global flag or option also claims.
    __command_spellings__=' '
    for __candidate__ in ${__commands__}; do
        __function_parameters__="$(_get_function_parameters "$0" "${__candidate__}")" || exit 1
        if [ -z "${__function_parameters__}" ]; then continue; fi

        while IFS="${__unit_separator__}" read -r __kind__ __parameter_name__ __short__ __long__ __constraint__ __default_value__ __required__ __description__; do
            case "${__kind__}" in
                flag|option) ;;
                *) continue ;;
            esac

            if [ -z "${__short__}" ]; then
                __short__="${__parameter_name__}"
                __short__="${__short__%"${__short__#?}"}"
            fi
            __long__="${__long__:-${__parameter_name__}}"

            for __spelling__ in "--${__long__}" "--${__parameter_name__}" "-${__short__}"; do
                case "${__command_spellings__}" in
                    *" ${__spelling__} "*) ;;
                    *) __command_spellings__="${__command_spellings__}${__spelling__} " ;;
                esac
                if [ "${__kind__}" != 'option' ]; then continue; fi
                case "${__spellings__}" in
                    *" ${__spelling__} "*) ;;
                    *) __spellings__="${__spellings__}${__spelling__} " ;;
                esac
            done
        done <<EOF
${__function_parameters__}
EOF
    done

    # Command selected by the command line, its arguments (held in the
    # positional parameters), and the target of `help` when one is given.
    __command__=''
    __help_target__=''

    # First command argument, reported when no command is selected, and
    # whether that argument is a parameter rather than a command name.
    __first_argument__=''
    __first_argument_is_parameter__='false'
    __has_first_argument__='false'

    #--------------------------------------------------
    # Resolve global inputs, the command and its arguments
    #--------------------------------------------------

    # Arguments are moved from the front of the positional parameters to
    # the back as they are classified. This keeps their exact contents,
    # including empty values, spaces and control characters: nothing is
    # ever joined into a string and split again.
    __remaining__=$#

    while [ "${__remaining__}" -gt 0 ]; do
        __argument__="$1"
        shift
        __remaining__=$((__remaining__ - 1))

        # A literal "--" ends option parsing: every following argument is
        # a positional parameter of the command, even when it starts with
        # "-". Handling it here matters: this loop classifies arguments
        # before the command loop runs, so guarding the command loop alone
        # would leave a "-x" after "--" misread as an option.
        if [ "${__argument__}" = '--' ]; then
            # The terminator itself is handed to the command loop, which
            # stops option parsing for the command arguments.
            set -- "$@" '--'
            if [ "${__has_first_argument__}" = 'false' ] &&
               [ "${__remaining__}" -gt 0 ]; then
                __first_argument__="$1"
                __first_argument_is_parameter__='false'
                __has_first_argument__='true'
            fi
            while [ "${__remaining__}" -gt 0 ]; do
                set -- "$@" "$1"
                shift
                __remaining__=$((__remaining__ - 1))
            done
            break
        fi

        # Global flags never consume the following argument.
        __matched__='false'
        for __flag__ in ${__global_flags__}; do
            __short__="${__flag__%"${__flag__#?}"}"
            if [ "${__argument__}" = "--${__flag__}" ] ||
               [ "${__argument__}" = "-${__short__}" ]; then
                # A spelling the command also declares is ambiguous: the
                # global parser would silently capture the command's flag.
                case "${__command_spellings__}" in
                    *" ${__argument__} "*)
                        _echo_error "\"${__argument__}\" is ambiguous: declared both globally and by a command\n"
                        exit 1
                        ;;
                esac
                eval "${__flag__}=true"
                __matched__='true'
                break
            fi
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # Global options consume the following argument as their value.
        for __option__ in ${__global_options__}; do
            __short__="${__option__%"${__option__#?}"}"
            if [ "${__argument__}" = "--${__option__}" ] ||
               [ "${__argument__}" = "-${__short__}" ]; then
                case "${__command_spellings__}" in
                    *" ${__argument__} "*)
                        _echo_error "\"${__argument__}\" is ambiguous: declared both globally and by a command\n"
                        exit 1
                        ;;
                esac
                if [ "${__remaining__}" -eq 0 ]; then
                    _echo_error "\"--${__option__}\" requires value\n"
                    exit 1
                fi
                __value__="$1"
                shift
                __remaining__=$((__remaining__ - 1))
                __constraint__="$(_get_constraint "$0" "${__option__}")" || exit 1
                _validate "${__option__}=${__value__}" "${__constraint__}"  || exit 1
                eval "${__option__}=\"\${__value__}\""
                __matched__='true'
                break
            fi
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # A command option and its value are arguments of the selected
        # command. They are kept even when the command is not known yet.
        case "${__spellings__}" in
            *" ${__argument__} "*)
                set -- "$@" "${__argument__}"
                if [ "${__remaining__}" -gt 0 ]; then
                    set -- "$@" "$1"
                    shift
                    __remaining__=$((__remaining__ - 1))
                fi
                if [ "${__has_first_argument__}" = 'false' ]; then
                    __first_argument__="${__argument__}"
                    __first_argument_is_parameter__='true'
                    __has_first_argument__='true'
                fi
                continue
                ;;
        esac

        # A known command is selected. Only one command may be given;
        # `help` is the exception, since the command that follows it is
        # the help target rather than a second command.
        __matched__='false'
        for __candidate__ in ${__commands__}; do
            if [ "${__argument__}" != "${__candidate__}" ]; then continue; fi
            if [ -z "${__command__}" ]; then
                __command__="${__candidate__}"
            elif [ "${__command__}" = 'help' ] &&
                 [ -z "${__help_target__}" ]; then
                __help_target__="${__candidate__}"
            else
                _echo_error 'only one command at a time\n'
                exit 1
            fi
            __matched__='true'
            break
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # `help` with an unknown name keeps it as the target, so the help
        # command reports it instead of printing the whole script help.
        if [ "${__command__}" = 'help' ] && [ -z "${__help_target__}" ]; then
            __help_target__="${__argument__}"
            continue
        fi

        # Every other argument is a positional or an unknown parameter
        # of the selected command.
        set -- "$@" "${__argument__}"
        if [ "${__has_first_argument__}" = 'false' ]; then
            __first_argument__="${__argument__}"
            case "${__argument__}" in
                -*) __first_argument_is_parameter__='true' ;;
            esac
            __has_first_argument__='true'
        fi
    done

    # Without a command, report the first stray argument as a command or
    # a parameter error, then run the default hook only when silent.
    if [ -z "${__command__}" ]; then
        if [ -n "${__first_argument__}" ]; then
            if [ "${__first_argument_is_parameter__}" = 'true' ]; then
                __message__="\"${__first_argument__}\" is not a valid parameter"
            else
                __message__="\"${__first_argument__}\" is not a valid command"
            fi
            _echo_error "${__message__}\n"
            exit 1
        fi
        _default
        exit 0
    fi

    # Optional pre-execution hook, when the script defines one.
    if [ -n "$(command -v _before)" ]; then _before; fi

    # `help` is special: it never runs, it displays the help of the
    # command that follows it.
    if [ "${__command__}" = 'help' ]; then
        _help "$0" "${__help_target__}" || exit $?
        exit 0
    fi

    #--------------------------------------------------
    # Bind command inputs and dispatch the command
    #--------------------------------------------------

    # Load the entries of this command. Flags start as `false`, and
    # options are reset before receiving their declared default. Every
    # name is checked before any `eval`: a name is a shell identifier,
    # so an untrusted annotation can never inject code.
    __function_parameters__="$(_get_function_parameters \
        "$0" "${__command__}")" || exit 1
    while IFS="${__unit_separator__}" read -r __kind__ \
          __parameter_name__ __short__ __long__ \
          __constraint__ __default_value__ __required__ \
          __description__; do
        case "${__kind__}" in
            flag|option|param) ;;
            *) continue ;;
        esac

        case "${__parameter_name__}" in
            ''|[!A-Za-z_]*|*[!A-Za-z0-9_]*)
                __message__="invalid parameter name: ${__parameter_name__}"
                _echo_error "${__message__}\n"
                exit 1
                ;;
        esac

        if [ "${__kind__}" = 'flag' ]; then
            eval "${__parameter_name__}=false"
        elif [ "${__kind__}" = 'option' ]; then
            eval "${__parameter_name__}=''"
            if [ -n "${__default_value__}" ]; then
                eval "${__parameter_name__}=${__default_value__}"
            fi
        fi
    done <<EOF
${__function_parameters__}
EOF

    # Parse the arguments of this command: flags, options and
    # positionals. Positionals are moved to the back of the positional
    # parameters with the same rotation used for the command line.
    __remaining__=$#

    while [ "${__remaining__}" -gt 0 ]; do
        __argument__="$1"
        shift
        __remaining__=$((__remaining__ - 1))

        # Same terminator, for arguments that reach this loop directly.
        # Everything left is a positional parameter, "-" prefixed or not.
        if [ "${__argument__}" = '--' ]; then
            while [ "${__remaining__}" -gt 0 ]; do
                set -- "$@" "$1"
                shift
                __remaining__=$((__remaining__ - 1))
            done
            break
        fi

        case "${__argument__}" in
            -*)
                __matched__='false'
                while IFS="${__unit_separator__}" read -r __kind__ __parameter_name__ __short__ __long__ __constraint__ __default_value__ __required__ __description__; do
                    if [ "${__kind__}" != 'flag' ] &&
                       [ "${__kind__}" != 'option' ]; then
                        continue
                    fi

                    if [ -z "${__short__}" ]; then
                        __short__="${__parameter_name__}"
                        __short__="${__short__%"${__short__#?}"}"
                    fi
                    __long__="${__long__:-${__parameter_name__}}"

                    if [ "${__argument__}" = "--${__long__}" ] ||
                       [ "${__argument__}" = "--${__parameter_name__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        if [ "${__kind__}" = 'flag' ]; then
                            eval "${__parameter_name__}=true"
                        elif [ "${__remaining__}" -eq 0 ]; then
                            __message__="\"--${__parameter_name__}\""
                            __message__="${__message__} requires value"
                            _echo_error "${__message__}\n"
                            exit 1
                        else
                            __value__="$1"
                            shift
                            __remaining__=$((__remaining__ - 1))
                            _validate "${__parameter_name__}=${__value__}" "${__constraint__}" || exit 1
                            eval "${__parameter_name__}=\"\${__value__}\""
                        fi
                        __matched__='true'
                        break
                    fi
                done <<EOF
${__function_parameters__}
EOF

                if [ "${__matched__}" = 'false' ]; then
                    _echo_error "\"${__argument__}\" is not a valid parameter\n"
                    exit 1
                fi
                ;;
            *)
                set -- "$@" "${__argument__}"
                ;;
        esac
    done

    # Bind the positional parameters to the variables declared by the
    # command shoedoc, then call the command without positional
    # arguments: commands read their values from named variables.
    __status__=0
    if ! _validate_positionals "$0" "${__command__}" "$@"; then
        __status__=1
    else
        "${__command__}" || __status__=$?
    fi

    # Optional post-execution hook, when the script defines one. It runs
    # only when the command succeeded, and never masks the exit status.
    if [ "${__status__}" -eq 0 ] && [ -n "$(command -v _after)" ]; then
        _after || :
    fi

    exit "${__status__}"
}

_kernel "$@"

