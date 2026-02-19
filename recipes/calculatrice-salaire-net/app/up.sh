#!/bin/sh

## Install and serve locally
##
## {
##   "namespace": "app",
##   "depends": [
##     "install",
##     "serve"
##   ]
## }
up() {
    install
    serve
}

