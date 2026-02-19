#!/bin/sh

## Run following code before each execution
##
## {
##   "depends": [
##     "_pwd",
##     "requirements"
##   ]
## }
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

