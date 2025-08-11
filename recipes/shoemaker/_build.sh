#!/bin/sh

# Build from given "build.shoe" file
#
# {
#   "depends": [
#     "_collapse_blank_lines",
#     "_sed_i",
#     "alert_primary",
#     "echo_danger",
#     "echo_info"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "FILE_PATH",
#       "type": "file",
#       "description": "The path to the input file.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "DESTINATION",
#       "type": "folder",
#       "description": "The path to the destination folder.",
#       "nullable": false
#     },
#     {
#       "position": 3,
#       "name": "TYPE",
#       "type": "str",
#       "description": "The script type to build (bash or sh).",
#       "constraint": "/^(bash|sh)$/",
#       "default": "sh"
#     }
#   ]
# }
_build() {
    # Synopsis: _build <FILE_PATH> <DESTINATION> [TYPE]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  The path to the destination folder.
    #   TYPE:         (optional) The script type to build (bash or sh). Will default to "sh".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _build: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then echo_danger "error: _build: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _build: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _build: \"$2\" folder not found\n"; return 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

    __output__="$2/$(basename "$1" .shoe).sh"

    alert_primary "Building $(basename "$1" .shoe).sh"

    echo_info "rm -f \"${__output__}\"\n"
    rm -f "${__output__}"

    # shellcheck disable=SC2094
    while read -r __current_line__; do
        if [ "$(printf '%s' "${__current_line__}" | cut -c 1)" = "#" ] || [ -z "${__current_line__}" ]; then
            printf '%s\n' "${__current_line__}" >> "${__output__}"
            continue
        fi

        __source_file__="$(dirname "$1")/${__current_line__}"
        if [ ! -f "${__source_file__}" ]; then
            echo_danger "error: \"${__source_file__}\": file not found\n"

            return 1
        fi
        echo_info "${__source_file__}\n"

        printf '%s\n' "$(cat "${__source_file__}")" >> "${__output__}"
    done < "$1"

    # Remove all "#!/bin/bash" or "#!/bin/sh" from result file
    echo_info "$(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' \"${__output__}\"\n"
    $(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' "${__output__}"

    # Prepend shebang
    if [ "$3" = bash ]; then
        echo_info "$(_sed_i) '1i#!\/usr\/bin\/env bash' \"${__output__}\"\n"
        $(_sed_i) '1i#!\/usr\/bin\/env bash' "${__output__}"
    else
        echo_info "$(_sed_i) '1i#!\/usr\/bin\/env sh' \"${__output__}\"\n"
        $(_sed_i) '1i#!\/usr\/bin\/env sh' "${__output__}"
    fi

    _collapse_blank_lines "${__output__}"

    echo_success "\"${__output__}\" generated\n"
}

