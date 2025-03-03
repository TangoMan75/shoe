#!/bin/sh

## Generate Makefile for current shoe script
##
## {
##   "namespace": "make",
##   "depends": [
##     "_generate_makefile"
##   ]
## }
generate_makefile() {
    _generate_makefile "$0"
}

