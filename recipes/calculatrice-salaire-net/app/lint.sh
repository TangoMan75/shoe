#!/bin/sh

## Lint and fix files
##
## @namespace recipes/calculatrice-salaire-net/app
## @requires npm
## @depends src/shell/colors/_echo_info.sh
lint() {
    _echo_info 'npm run lint\n'
    npm run lint
}

