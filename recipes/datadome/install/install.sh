#!/bin/sh

## {
##   "namespace": "recipes/datadome/install",
##   "summary": "Install app, import data and clear cache",
##   "depends": [
##     "src/shell/colors/_alert_primary",
##     "src/shell/docker/_docker_compose_start",
##     "src/shell/symfony/_composer_install",
##     "src/shell/symfony/_db_create",
##     "src/shell/symfony/_db_schema",
##     "src/shell/symfony/_sf_cache"
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

