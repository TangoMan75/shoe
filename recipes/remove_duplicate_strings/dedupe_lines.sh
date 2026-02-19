#!/bin/sh

## Remove every line in target file that contains substrings from source file
dedupe_lines() {
    if [ -z "${source}" ] || [ -z "${target}" ]; then echo_danger 'error: dedupe_lines: some mandatory parameter is missing\n'; return 1; fi

    source="$(realpath "${source}")"
    if [ ! -f "${source}" ]; then echo_danger "error: dedupe_lines: \"${source}\" file not found\n"; return 1; fi

    target="$(realpath "${target}")"
    if [ ! -f "${target}" ]; then echo_danger "error: dedupe_lines: \"${target}\" file not found\n"; return 1; fi

    while read -r _substring; do
        _echo_info "sed -i \"/${_substring}/d\" \"${target}\"\n"
        sed -i "/${_substring}/d" "${target}"
    done < "${source}"
}

