#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Run webpack encore",
##   "requires": [
##     "install",
##     "yarn"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
encore() {
    _check_installed yarn

    _echo_info 'yarn install\n'
    yarn install

    if [ "${env}" = prod ]; then
        _echo_info 'yarn run encore production\n'
        yarn run encore production
    else
        _echo_info 'yarn run encore dev\n'
        yarn run encore dev
    fi
}

