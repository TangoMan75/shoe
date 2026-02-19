#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/calculatrice-salaire-net/install/requirements"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
}

