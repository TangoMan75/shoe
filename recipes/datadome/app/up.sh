#!/bin/sh

## Docker up, Composer install, import data, serve
##
## {
##   "namespace": "app",
##   "depends": [
##     "import",
##     "install",
##     "serve"
##   ]
## }
up() {
    install
    import
    serve
}

