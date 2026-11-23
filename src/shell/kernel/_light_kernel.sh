#!/bin/sh

## Shoe Light Kernel
##
## Runs exactly one command given on the command line, without
## positional parameters, flags or options: the single argument must be
## a valid command name.
##
## The command name is validated before anything runs. Optional
## `_before` and `_after` hooks run around the command: `_after` runs
## only when the command succeeded, and never masks its exit status.
## `_default` runs when no argument is given.
##
## @namespace src/shell/kernel
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/hooks/_after.sh
## @depends src/shell/hooks/_before.sh
## @depends src/shell/hooks/_default.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @depends src/shell/validation/_check_duplicate_functions.sh
_light_kernel() {
    # Abort before doing anything when the script declares two functions
    # with the same name: command resolution would silently pick one.
    _check_duplicate_functions "$0"

    # Without any argument there is no command to resolve: run the default hook immediately.
    if [ $# -lt 1 ]; then _default; exit 0; fi

    if [ $# -gt 1 ]; then
        _echo_error 'No positional parameter, option or flag is supported, and only one command may run at a time\n'
        exit 1
    fi

    for __command__ in $(_get_functions_names "$0"); do
        if [ "$1" != "${__command__}" ]; then continue; fi

        # Optional pre-execution hook, when the script defines one.
        [ -n "$(command -v _before)" ] && _before

        __status__=0
        "${__command__}" || __status__=$?

        # Optional post-execution hook, when the script defines one. It runs
        # only when the command succeeded, and never masks the exit status.
        if [ "${__status__}" -eq 0 ] && [ -n "$(command -v _after)" ]; then
            _after || :
        fi

        exit "${__status__}"
    done

    _echo_error "\"$1\" is not a valid command\n"
    exit 1
}

_light_kernel "$@"

