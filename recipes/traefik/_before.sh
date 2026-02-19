#!/bin/sh

## Run following code before each execution
##
## {
##   "depends": [
##     "_pwd"
##   ]
## }
_before() {
    cd "$(_pwd)" || return 1
}

