#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Install Ck Editor",
##   "requires": [
##     "install"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
ckeditor() {
    _echo_info "./bin/console ckeditor:install --no-interaction --env ${env}\n"
    ./bin/console ckeditor:install --no-interaction --env ${env}
}

