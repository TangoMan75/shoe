#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/docker",
##   "summary": "Set permissions",
##   "requires": [
##     "setfacl"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning",
##     "src/shell/system/_check_installed"
##   ]
## }
_permissions() {
    _check_installed setfacl

    if [ ${#} -lt 2 ]; then echo_danger 'error: _own: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _own: too many arguments (${#})\n"; return 1; fi

    _httpduser="$1"
    _directory="$2"

    if [ -d "${_directory}" ]; then
        # set permissions for future files and folders
        _echo_info "setfacl -dR -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -dR -m "u:${_httpduser}:rwX" "${_directory}"

        # set permissions on the existing files and folders
        _echo_info "setfacl -R -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -R -m "u:${_httpduser}:rwX" "${_directory}"
    else
        _echo_warning "directory not found \"${_directory}\"\n"
    fi
}

