#!/bin/sh

## Uninstall
##
## {
##   "namespace": "install",
##   "depends": [
##     "_db_drop",
##     "_docker_compose_stop",
##     "_echo_info"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
uninstall() {
    _db_drop "${env}"
    _docker_compose_stop
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

