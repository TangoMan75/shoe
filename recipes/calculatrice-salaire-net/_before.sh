#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/calculatrice-salaire-net
## @depends recipes/calculatrice-salaire-net/install/requirements
## @overrides src/shell/hooks/_before
_before() {
    requirements
}

