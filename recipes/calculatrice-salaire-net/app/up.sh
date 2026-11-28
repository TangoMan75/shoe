#!/bin/sh

## Install and serve locally
##
## @namespace recipes/calculatrice-salaire-net/app
## @requires install
## @depends recipes/calculatrice-salaire-net/app/serve.sh
## @depends recipes/calculatrice-salaire-net/install/install.sh
up() {
    install
    serve
}

