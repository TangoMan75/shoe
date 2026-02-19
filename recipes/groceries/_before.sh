#!/bin/sh

## {
##   "namespace": "recipes/groceries",
##   "summary": "Run following code before each execution",
##   "depends": [
##     "recipes/groceries/requirements"
##   ],
##   "overrides": "src/shell/hooks/_before"
## }
_before() {
    requirements
}

