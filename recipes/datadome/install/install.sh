#!/bin/sh

## Install app, import data and clear cache
##
## @namespace recipes/datadome/install
## @depends src/shell/colors/_alert_primary
## @depends src/shell/docker/_docker_compose_start
## @depends src/shell/symfony/_composer_install
## @depends src/shell/symfony/_db_create
## @depends src/shell/symfony/_db_schema
## @depends src/shell/symfony/_sf_cache
## @assumes env
install() {
    _alert_primary "Installing project with \"${env}\" environment"

    _composer_install
    _docker_compose_start
    _db_create "${env}"
    _db_schema "${env}"
    _sf_cache "${env}"
}

