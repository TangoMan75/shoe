#!/bin/sh

## Uninstall
uninstall() {
    if [ "$(_is_root)" = false ]; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    for _file in \
        ./var/*.db \
        .env.dev.local \
        .env.local \
        .env.prod.local \
        .php-cs-fixer.cache \
        .php_cs.cache \
        .phpcs-cache \
        .phpunit.result.cache \
    ; do
        echo_info "rm -f \"${_file}\"\n"
        rm -f "${_file}"
    done

    for _folder in \
        ./bin/.phpunit \
        ./coverage \
        ./logs/* \
        ./node_modules \
        ./public/bundles \
        ./var/cache \
        ./var/log \
        ./vendor \
        ./volumes/postgres_data \
    ; do
        echo_info "rm -rf \"${_folder}\"\n"
        rm -rf "${_folder}"
    done
}

