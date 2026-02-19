#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/app",
##   "summary": "Clear export folder",
##   "requires": [
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
clear_exports() {
    _echo_info 'rm ./assets/exports/*\n'
    rm ./assets/exports/*
}

