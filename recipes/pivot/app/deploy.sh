#!/bin/sh

## Deploy "dist" folder to "gh-pages"
##
## @namespace recipes/pivot/app
## @depends src/shell/github/_deploy.sh
deploy() {
    _deploy dist
}

