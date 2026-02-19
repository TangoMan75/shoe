#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Watch with webpack encore",
##   "requires": [
##     "install",
##     "yarn"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
encore_watch() {
    _check_installed yarn

    _echo_info 'yarn install\n'
    yarn install

    _echo_info 'yarn run encore dev --watch\n'
    yarn run encore dev --watch
}

