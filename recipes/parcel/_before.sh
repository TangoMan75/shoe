#!/bin/sh

## Run following code before each execution
##
## @namespace recipes/parcel
## @depends recipes/parcel/requirements
## @overrides src/shell/hooks/_before
_before() {
    requirements
}

