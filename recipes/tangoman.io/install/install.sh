#!/bin/sh

## Composer install, create DB, install assets, set env and clear cache
##
## {
##   "namespace": "install",
##   "depends": [
##     "_alert_primary",
##     "_composer_install",
##     "_db_schema",
##     "_sf_cache",
##     "create_db",
##     "fix_permissions",
##     "migrate",
##     "set_env"
##   ]
## }
install() {
    _alert_primary "Installing project with \"${env}\" environment"

    fix_permissions
    _composer_install

    create_db

    if [ "${migrate}" = true ]; then
        migrate
    else
        _db_schema "${env}"
    fi

    set_env

    _sf_cache "${env}"
}

