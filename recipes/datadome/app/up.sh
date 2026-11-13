#!/bin/sh

## Docker up, Composer install, import data, serve
##
## @namespace recipes/datadome/app
## @requires install
## @depends recipes/datadome/app/import recipes/datadome/install/install recipes/datadome/symfony/serve
up() {
    install
    import
    serve
}

