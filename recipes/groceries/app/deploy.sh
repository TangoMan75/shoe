#!/bin/sh

## Deploy "dist" folder to "gh-pages"
##
## @namespace recipes/groceries/app
## @depends src/shell/github/_deploy
deploy() {
    _deploy dist
}

