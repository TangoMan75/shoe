#!/bin/sh

## Present user with a list of choices and prompt them to select one
##
## @namespace src/shell/prompts
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {str} <CHOICES> (required) Array containing choices.
_select() {
    if [ -z "$1" ]; then _echo_error '_select: some mandatory parameter is missing\n'; return 1; fi

    __item__=0
    for __choice__ in "$@"; do
        __item__=$((__item__ + 1))
        __choices__="${__choices__} ${__item__}"
        _echo_success "$__item__)"; _echo_warning " ${__choice__}\n"
    done

    _echo_success 'Please select your choice : \n'
    __select__=''
    while :; do
        if ! read -r __select__; then
            _echo_error '_select: could not read a selection\n'

            return 1
        fi

        # Re-ask on anything that is not a number in range.
        case "${__select__}" in
            ''|*[!0-9]*) continue ;;
        esac

        # POSIX arithmetic reads a leading zero as an octal prefix: "08"
        # is not a valid octal number. Normalise the selection first.
        while [ "${__select__#0}" != "${__select__}" ]; do
            __select__="${__select__#0}"
        done
        if [ -z "${__select__}" ]; then continue; fi

        if [ "${__select__}" -ge 1 ] && [ "${__select__}" -le "$#" ]; then
            break
        fi
    done

    shift "$((__select__ - 1))"
    printf '%s\n' "$1"
}

