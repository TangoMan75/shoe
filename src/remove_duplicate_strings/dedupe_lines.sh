#!/bin/sh

## Remove every line in target file that contains substrings from source file
dedupe_lines() {
    if [ -z "${source}" ] || [ -z "${target}" ]; then
        echo_error 'some mandatory parameter is missing.\n'
        return 1
    fi

    source="$(realpath "${source}")"
    if [ ! -f "${source}" ]; then
        echo_error 'file not found.\n'
        return 1
    fi

    target="$(realpath "${target}")"
    if [ ! -f "${target}" ]; then
        echo_error 'file not found.\n'
        return 1
    fi

    while read _substring; do
        echo_info "sed -i \"/${_substring}/d\" \"${target}\"\n"
        sed -i "/${_substring}/d" "${target}"
    done < "${source}"
}

