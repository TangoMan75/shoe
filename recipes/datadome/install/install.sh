#!/bin/sh

## Install app, import data and clear cache
##
## {
##   "namespace": "install",
##   "depends": [
##     "alert_primary",
##     "_composer_install",
##     "_docker_compose_start",
##     "_db_create",
##     "_db_schema",
##     "_sf_cache"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
install() {
    _alert_primary "Installing project with \"${env}\" environment"

    _composer_install
    _docker_compose_start
    _db_create "${env}"
    _db_schema "${env}"
    _sf_cache "${env}"
}

