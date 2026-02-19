#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/symfony",
##   "summary": "Clear cache",
##   "depends": [
##     "src/shell/symfony/_sf_cache"
##   ]
## }
cache() {
    _sf_cache "${env}"
}

