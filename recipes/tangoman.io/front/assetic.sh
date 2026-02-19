#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Dump app assets",
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
assetic() {
    _echo_info "./bin/console assetic:dump --env=\"${env}\"\n"
    ./bin/console assetic:dump --env="${env}"
}

