#!/bin/sh

## {
##   "namespace": "recipes/parcel",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/parcel/requirements"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
}

