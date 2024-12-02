#!/bin/sh

_build() {
    # Build from given "build.lst" file
    # Synopsis: _build <FILE_PATH> <DESTINATION> [TYPE]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  The path to the destination folder.
    #   TYPE:         (optional) The script type to build (bash or sh). Will default to "sh".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _build: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _build: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _build: \"$1\" file not found\n"; exit 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _build: \"$2\" folder not found\n"; exit 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

    _output="$2/$(basename "$1" .lst).sh"

    alert_primary "$(basename "$1" .lst).sh"

    echo_info "rm \"${_output}\" || true\n"
    rm "${_output}" || true

    # get all pathes from build.lst file ignoring comments and empty lines
    # shellcheck disable=SC2094
    < "$1" grep -Pv '^(#|\s*$)' | while read -r file_path;
    do
        # shellcheck disable=SC2094
        _source_file="$(realpath "$(dirname "$1")/${file_path}")"
        echo_info "${_source_file}\n"

        # append file content to "script" build
        printf '%s\n' "$(cat "${_source_file}")" >> "${_output}"
    done

    # Remove all "#!/bin/bash" or "#!/bin/sh" from result file
    echo_info "$(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' \"${_output}\"\n"
    $(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' "${_output}"

    # Prepend shebang
    if [ "$3" = bash ]; then
        echo_info "$(_sed_i) '1i#!\/bin\/bash' \"${_output}\"\n"
        $(_sed_i) '1i#!\/bin\/bash' "${_output}"
    else
        echo_info "$(_sed_i) '1i#!\/bin\/sh' \"${_output}\"\n"
        $(_sed_i) '1i#!\/bin\/sh' "${_output}"
    fi

    _collapse_blank_lines "${_output}"

    echo_success "\"${_output}\" generated\n"
}

