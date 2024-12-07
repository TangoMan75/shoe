#!/bin/sh

# Set permissions
_permissions() {
    _check_installed setfacl

    if [ ${#} -lt 2 ]; then echo_danger 'error: _own: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _own: too many arguments (${#})\n"; return 1; fi

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

