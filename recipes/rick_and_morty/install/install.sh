#!/bin/sh

## Composer install, create DB, set env and clear cache
##
## {
##   "namespace": "install",
##   "depends": [
##     "_alert_primary",
##     "_composer_install",
##     "_db_schema",
##     "_sf_cache",
##     "create_db",
##     "set_env"
##   ]
## }
install() {
    _alert_primary "Installing project with \"${env}\" environment"
    _composer_install
    create_db
    _db_schema "${env}"
    set_env
    _sf_cache "${env}"
}

