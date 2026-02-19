#!/bin/sh

## {
##   "namespace": "recipes/datadome",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/agnostic-companion/install/requirements"
##   ]
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

