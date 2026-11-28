#!/bin/sh

## Docker up, Composer install, import data, serve
##
## @namespace recipes/datadome/app
## @requires install
## @depends recipes/datadome/app/import.sh
## @depends recipes/datadome/install/install.sh
## @depends recipes/datadome/symfony/serve.sh
up() {
    install
    import
    serve
}

