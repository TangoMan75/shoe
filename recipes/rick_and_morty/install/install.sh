#!/bin/sh

## Composer install, create DB, set env and clear cache
##
## @namespace recipes/rick_and_morty/install
## @depends recipes/rick_and_morty/doctrine/create_db
## @depends recipes/rick_and_morty/install/set_env
## @depends src/shell/colors/_alert_primary
## @depends src/shell/symfony/_composer_install
## @depends src/shell/symfony/_db_schema
## @depends src/shell/symfony/_sf_cache
## @assumes env
install() {
    _alert_primary "Installing project with \"${env}\" environment"
    _composer_install
    create_db
    _db_schema "${env}"
    set_env
    _sf_cache "${env}"
}

