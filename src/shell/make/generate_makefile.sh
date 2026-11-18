#!/bin/sh

## Generate Makefile for current shoe script
##
## @namespace src/shell/make
## @depends src/shell/make/_generate_makefile
generate_makefile() {
    _generate_makefile "$0"
}

