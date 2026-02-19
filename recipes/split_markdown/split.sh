#!/bin/sh

## Split chapters from given markdown file into individual files
split() {
    if [ -z "${input}" ] || [ -z "${output}" ]; then echo_danger 'error: split_markdown: some mandatory parameter is missing\n'; return 1; fi

    input="$(realpath "${input}")"
    if [ ! -f "${input}" ]; then echo_danger "error: split_markdown: \"${input}\" file not found\n"; return 1; fi

    if [ ! -d "${output}" ]; then
        _echo_info "mkdir -p \"${output}\"\n"
        mkdir -p "${output}"
    fi
    output="$(realpath "${output}")"

    filename="$(date -I)"

    while IFS= read -r line; do
        if printf '%s' "${line}" | grep -q '^## '; then
            title="$(printf '%s' "${line}" | sed 's/^## //')"
            if [ -n "${title}" ]; then
                # Convert title to snake_case and remove special characters
                filename=$(printf '%s' "${title}" | tr '[:upper:]' '[:lower:]' | tr -c '[:alnum:]' '_')
                _echo_info "${output}/${filename}.md\n"
            fi

            printf '' > "${output}/${filename}.md"
        fi

        printf '%s\n' "${line}" >> "${output}/${filename}.md"
    done < "${input}"
}

