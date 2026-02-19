#!/bin/sh

## {
##   "namespace": "recipes/traefik",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "src/shell/system/_pwd"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    cd "$(_pwd)" || return 1
}

