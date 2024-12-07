#!/bin/sh

## Fix permission issue (777 hack)
fix_permissions() {
    _check_installed mkdir
    _check_installed chmod

    for _folder in \
        ./assets \
        ./certs \
        ./drivers \
        ./logs \
        ./migrations \
        ./public \
        ./var \
        ./var/cache \
        ./var/log \
        ./vendor \
        ./volumes \
    ; do
        if [ ! -d ${_folder} ]; then
            echo_info "mkdir ${_folder}\n"
            mkdir ${_folder}
        fi

        echo_info "chmod 777 -R ${_folder}\n"
        chmod -R 777 ${_folder}
    done
}

