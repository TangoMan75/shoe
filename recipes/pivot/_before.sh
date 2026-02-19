#!/bin/sh

## {
##   "namespace": "recipes/pivot",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/agnostic-companion/install/requirements"
##   ]
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}
