#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/pivot
## @depends recipes/pivot/requirements src/shell/system/_pwd
## @overrides src/shell/hooks/_before
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

