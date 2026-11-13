#!/bin/sh

## Clear cache
##
## @namespace recipes/tangoman.io/symfony
## @depends src/shell/symfony/_sf_cache
## @assumes env
cache() {
    _sf_cache "${env}"
}

