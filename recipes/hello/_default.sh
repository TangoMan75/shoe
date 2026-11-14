#!/bin/sh

## Place here commands you need executed by default (optional)
##
## @namespace recipes/hello
## @depends recipes/hello/hello
## @overrides src/shell/hooks/_default
_default() {
    hello
}

