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
    for _folder in \
        ./bin/.phpunit \
        ./coverage \
        ./logs/* \
        ./node_modules \
        ./public/bundles \
        ./public/build \
        ./var \
        ./vendor \
        ./volumes/postgres_data \
    ; do
        echo_info "rm -rf \"${_folder}\"\n"
        rm -rf "${_folder}"
    done

    for _file in \
        .env.dev.local \
        .env.local \
        .env.local.php \
        .env.prod.local \
        .php-cs-fixer.cache \
        .php_cs.cache \
        .phpcs-cache \
        .phpunit.result.cache \
    ; do
        echo_info "rm -f \"${_file}\"\n"
        rm -f "${_file}"
    done
}

