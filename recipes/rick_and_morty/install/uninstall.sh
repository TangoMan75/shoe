#!/bin/sh

## Uninstall
##
## {
##   "namespace": "install",
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ]
## }
uninstall() {
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
        _echo_info "rm -f \"${_file}\"\n"
        rm -f "${_file}"
    done

    if [ "${force}" = true ]; then
        _echo_info "rm -f composer.lock\n"
        rm -f composer.lock

        _echo_info "rm -f symfony.lock\n"
        rm -f symfony.lock
    fi

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
        _echo_info "rm -rf \"${_folder}\"\n"
        rm -rf "${_folder}"
    done
}

