#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/traefik
## @depends src/shell/system/_pwd.sh
## @overrides src/shell/hooks/_before
_before() {
    cd "$(_pwd)" || return 1
}

