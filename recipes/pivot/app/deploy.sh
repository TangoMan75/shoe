#!/bin/sh

## {
##   "namespace": "recipes/pivot/app",
##   "summary": "Deploy \"dist\" folder to \"gh-pages\"",
##   "depends": [
##     "src/shell/github/_deploy"
##   ]
## }
deploy() {
    _deploy dist
}
