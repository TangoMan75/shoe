#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/install",
##   "summary": "Composer install, create DB, install assets, set env and clear cache",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "recipes/tangoman.io/database/create_db",
##     "recipes/tangoman.io/database/migrate",
##     "recipes/tangoman.io/docker/fix_permissions",
##     "recipes/tangoman.io/install/set_env",
##     "src/shell/colors/_alert_primary",
##     "src/shell/symfony/_composer_install",
##     "src/shell/symfony/_db_schema",
##     "src/shell/symfony/_sf_cache"
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

