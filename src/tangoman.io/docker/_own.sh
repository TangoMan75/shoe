#!/bin/sh

## Own files or folders
_own() {
    if [ ! -x "$(command -v chown)" ]; then
        echo_error "\"$(basename "${0}")\" requires chown\n"
        return 1
    fi

    if [ ! -x "$(command -v chmod)" ]; then
        echo_error "\"$(basename "${0}")\" requires chmod\n"
        return 1
    fi

    if [ $# -lt 3 ]; then
        echo_error 'some mandatory argument is missing\n'
        return 1
    fi

    if [ $# -gt 3 ]; then
        echo_error "too many arguments: expected 3, $# given.\n"
        return 1
    fi

    _owner="$1"
    _group="$2"
    _target="$3"

    if [ -d "${_target}" ];then
        echo_info "chown -R \"${_owner}:${_group}\" \"${_target}\"\n"
        chown -R "${_owner}:${_group}" "${_target}"

        echo_info "chmod 775 -R \"${_target}\"\n"
        chmod 775 -R "${_target}"
    elif [ -f "${_target}" ];then
        echo_info "chown \"${_owner}:${_group}\" \"${_target}\"\n"
        chown "${_owner}:${_group}" "${_target}"

        echo_info "chmod 664 -R \"${_target}\"\n"
        chmod 664 -R "${_target}"
    else
        echo_warning "file not found \"${_target}\"\n"
    fi
}

