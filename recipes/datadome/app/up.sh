#!/bin/sh

## {
##   "namespace": "recipes/datadome/app",
##   "summary": "Docker up, Composer install, import data, serve",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "recipes/datadome/app/import",
##     "recipes/datadome/install/install",
##     "recipes/datadome/symfony/serve"
##   ]
## }
up() {
    install
    import
    serve
}

