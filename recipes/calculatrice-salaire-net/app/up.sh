#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Install and serve locally",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "recipes/calculatrice-salaire-net/app/serve",
##     "recipes/calculatrice-salaire-net/install/install"
##   ]
## }
up() {
    install
    serve
}

