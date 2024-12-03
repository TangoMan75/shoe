#!/bin/sh

## Own project files
own() {
    if [ "$(_is_root)" = false ]; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    if [ -z "${owner}" ]; then
        owner=nobody
        group=nogroup
    else
        group="${owner}"
    fi

    for _file in \
        ./assets \
        ./bin \
        ./certs \
        ./logs \
        ./node_modules \
        ./var \
        ./vendor \
        ./volumes \
        .env.dev.local \
        .env.local \
        .env.prod.local \
        .php-cs-fixer.cache \
        composer.lock \
        symfony.lock \
        yarn.lock \
    ; do
        _own "${owner}" "${group}" "${_file}"
    done

    if [ "$(_get_database_type)" = sqlite ]; then
        for _file in \
            ./var/prod.db \
            ./var/dev.db \
            ./var/test.db \
        ; do
            _own "${owner}" "${group}" "${_file}"
        done
    fi
}

