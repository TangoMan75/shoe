#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Install and serve locally",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "recipes/agnostic_repository_installer/install",
##     "recipes/calculatrice-salaire-net/app/serve"
##   ]
## }
up() {
    install
    serve
}

