#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/groceries
## @depends recipes/groceries/requirements
## @overrides src/shell/hooks/_before
_before() {
    requirements
}

