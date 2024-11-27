#!/bin/sh

## Set new host in /etc/hosts
set_host() {
    if [ ${#} -lt 1 ]; then
        echo_danger 'error: some mandatory parameter is missing.\n'
        return 1
    fi

    remove_host "$1"

    echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

