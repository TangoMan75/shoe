#!/bin/sh

## Install and serve locally
##
## @namespace recipes/calculatrice-salaire-net/app
## @requires install
## @depends recipes/calculatrice-salaire-net/app/serve recipes/calculatrice-salaire-net/install/install
up() {
    install
    serve
}

