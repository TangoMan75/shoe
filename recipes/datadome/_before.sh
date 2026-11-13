#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/datadome
## @depends recipes/datadome/install/requirements src/shell/system/_pwd
## @overrides src/shell/hooks/_before
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

