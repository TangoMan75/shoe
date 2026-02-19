#!/bin/sh

## {
##   "namespace": "recipes/traefik",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "src/shell/system/_pwd"
##   ]
## }
_before() {
    cd "$(_pwd)" || return 1
}

