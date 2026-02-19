#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/agnostic-companion/install/requirements",
##     "src/shell/system/_pwd"
##   ]
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

