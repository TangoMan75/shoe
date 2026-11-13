#!/bin/sh

## Composer install, create DB, set env and clear cache
##
## @namespace recipes/rick_and_morty/install
## @depends recipes/rick_and_morty/doctrine/create_db recipes/rick_and_morty/install/set_env src/shell/colors/_alert_primary src/shell/symfony/_composer_install src/shell/symfony/_db_schema src/shell/symfony/_sf_cache
## @assumes env
install() {
    _alert_primary "Installing project with \"${env}\" environment"
    _composer_install
    create_db
    _db_schema "${env}"
    set_env
    _sf_cache "${env}"
}

