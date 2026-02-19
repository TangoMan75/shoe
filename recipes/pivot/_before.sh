#!/bin/sh

## {
##   "namespace": "recipes/pivot",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/pivot/requirements",
##     "src/shell/system/_pwd"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

