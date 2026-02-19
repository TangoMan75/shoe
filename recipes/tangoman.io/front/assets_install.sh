#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Install bundle assets",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
assets_install() {
    _echo_info "./bin/console assets:install --env=\"${env}\"\n"
    ./bin/console assets:install --env="${env}"
}

