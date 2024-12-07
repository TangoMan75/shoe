#!/bin/sh

## Remove network
remove_network() {
    _NETWORKS=$(docker network ls --format '{{ .Name }}' | tr '\n' ' ' | sed  -r 's/(bridge|host|none)\s//g' | sed -r 's/\s+$//')
    if [ -z "${network}" ]; then
        USER_PROMPT=''
        while [ -z "${USER_PROMPT}" ]; do
            echo_success "Enter network name : [${_NETWORKS}] "
            read -r USER_PROMPT
        done
        network="${USER_PROMPT}"
    fi

    echo_info "docker network rm \"${network}\" || true\n"
    docker network rm "${network}" || true
}

