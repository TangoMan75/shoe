#!/bin/sh

## Remove /etc/hosts
remove_host() {
    # synopsys: remove_host [hostname]
    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing.\n'
        return 1
    fi

    if [ "$(_sed_flavor)" = 'Darwin' ]; then
        echo_info "sudo sed -i '' \"/$1/d\" /etc/hosts\n"
        sudo sed -i '' "/$1/d" /etc/hosts
    else
        echo_info "sudo sed -i \"/$1/d\" /etc/hosts\n"
        sudo sed -i "/$1/d" /etc/hosts
    fi
}

