#!/bin/sh

# Own files or folders
_own() {
    if [ ${#} -lt 3 ]; then echo_danger 'error: _own: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _own: too many arguments (${#})\n"; return 1; fi

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

