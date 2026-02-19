#!/bin/sh

## {
##   "namespace": "recipes/charlotte",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/charlotte/requirements"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
}

