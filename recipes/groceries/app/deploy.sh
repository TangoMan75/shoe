#!/bin/sh

## {
##   "namespace": "recipes/groceries/app",
##   "summary": "Deploy \"dist\" folder to \"gh-pages\"",
##   "depends": [
##     "src/shell/github/_deploy"
##   ]
## }
deploy() {
    _deploy dist
}
