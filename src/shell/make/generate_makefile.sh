#!/bin/sh

## {
##   "namespace": "src/shell/make",
##   "summary": "Generate Makefile for current shoe script",
##   "depends": [
##     "src/shell/make/_generate_makefile"
##   ]
## }
generate_makefile() {
    _generate_makefile "$0"
}

