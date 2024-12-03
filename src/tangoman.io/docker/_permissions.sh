#!/bin/sh

## Set permissions
_permissions() {
    if [ ! -x "$(command -v setfacl)" ]; then
        echo_error "\"$(basename "${0}")\" requires setfacl\n"
        return 1
    fi

    if [ $# -lt 2 ]; then
        echo_error 'some mandatory argument is missing\n'
        return 1
    fi

    if [ $# -gt 2 ]; then
        echo_error "too many arguments: expected 2, $# given.\n"
        return 1
    fi

    _httpduser="$1"
    _directory="$2"

    if [ -d "${_directory}" ]; then
        # set permissions for future files and folders
        echo_info "setfacl -dR -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -dR -m "u:${_httpduser}:rwX" "${_directory}"

        # set permissions on the existing files and folders
        echo_info "setfacl -R -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -R -m "u:${_httpduser}:rwX" "${_directory}"
    else
        echo_warning "directory not found \"${_directory}\"\n"
    fi
}

