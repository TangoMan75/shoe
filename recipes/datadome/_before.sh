#!/bin/sh

## Run following code before each execution
##
## {
##   "depends": [
##     "requirements"
##   ]
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

