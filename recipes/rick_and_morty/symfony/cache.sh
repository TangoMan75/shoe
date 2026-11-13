#!/bin/sh

## Clear cache
##
## @namespace recipes/rick_and_morty/symfony
## @depends src/shell/symfony/_sf_cache
## @assumes env
cache() {
    _sf_cache "${env}"
}

