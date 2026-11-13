#!/bin/sh

## Print bookmark rows from the store
##
## @namespace recipes/bookmarks
## @requires grep printf
## @depends recipes/bookmarks/_print_row src/shell/colors/_echo_primary src/shell/colors/_echo_warning
## @assumes PADDING output store verbose
## @stdout the matching bookmark rows
## @param {str} <FILTER> Only print rows containing this text.
_list_rows() {
    __tab__=$(printf '\t')
    __count__=0

    if [ "${verbose}" = 'true' ]; then
        printf 'verbose: store=%s\n' "${store}" >&2
    fi

    while IFS="${__tab__}" read -r __name__ __url__; do
        if [ -z "${__name__}" ]; then
            continue
        fi

        if [ -n "$1" ]; then
            if ! printf '%s %s' "${__name__}" "${__url__}" | grep -Fqi -e "$1"; then
                continue
            fi
        fi

        if [ "${__count__}" -eq 0 ]; then
            case "${output}" in
                csv)
                    printf '"name","url"\n'
                    ;;
                plain)
                    ;;
                *)
                    _echo_warning 'NAME' 2 "${PADDING}"
                    _echo_primary 'URL\n'
                    ;;
            esac
        fi

        _print_row "${__name__}" "${__url__}"
        __count__=$((__count__ + 1))
    done < "${store}"
}

