#!/bin/sh

## Composer install, create DB, install assets, set env and clear cache
##
## @namespace recipes/tangoman.io/install
## @requires true
## @depends recipes/tangoman.io/database/create_db.sh
## @depends recipes/tangoman.io/database/migrate.sh
## @depends recipes/tangoman.io/docker/fix_permissions.sh
## @depends recipes/tangoman.io/front/assets_build.sh
## @depends recipes/tangoman.io/install/set_env.sh
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/symfony/_composer_install.sh
## @depends src/shell/symfony/_db_schema.sh
## @depends src/shell/symfony/_sf_cache.sh
## @assumes env migrate
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
    assets_build

    _sf_cache "${env}"
}

