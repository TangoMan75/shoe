#!/bin/sh

## {
##   "namespace": "recipes/datadome/app",
##   "summary": "Docker up, Composer install, import data, serve",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "recipes/agnostic_repository_installer/install",
##     "recipes/calculatrice-salaire-net/app/serve",
##     "recipes/datadome/app/import"
##   ]
## }
up() {
    install
    import
    serve
}

