#!/bin/sh

## Docker up, Composer install, import data, serve
##
## @namespace recipes/datadome/app
## @requires install
## @depends recipes/datadome/app/import
## @depends recipes/datadome/install/install
## @depends recipes/datadome/symfony/serve
up() {
    install
    import
    serve
}

