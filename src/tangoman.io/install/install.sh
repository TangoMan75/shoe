#!/bin/sh

## Install app, import data and clear cache
install() {
    alert_primary "Installing project with \"${env}\" environment"

    fix_permissions
    composer_install

    create_db

    if [ "${migrate}" = true ]; then
        migrate
    else
        schema
    fi

    assets_install
    # ckeditor
    # cron_scan

    set_env

    cache
}

