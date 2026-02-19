#!/bin/sh

## Deploy "dist" folder to "gh-pages"
##
## {
##   "namespace": "app",
##   "depends": [
##     "_deploy"
##   ]
## }
deploy() {
    _deploy dist
}
