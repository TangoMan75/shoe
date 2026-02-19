#!/bin/sh

## {
##   "namespace": "recipes/datadome",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/datadome/install/requirements",
##     "src/shell/system/_pwd"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

