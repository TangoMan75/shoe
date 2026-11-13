#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/agnostic-companion
## @depends recipes/agnostic-companion/install/requirements src/shell/system/_pwd
## @overrides src/shell/hooks/_before
_before() {
    requirements
    cd "$(_pwd)" || return 1
}

