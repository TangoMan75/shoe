#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/pivot
## @depends recipes/pivot/requirements.sh
## @depends src/shell/system/_pwd.sh
## @overrides src/shell/hooks/_before
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

