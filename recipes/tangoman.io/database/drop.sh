#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/database",
##   "summary": "Drop database",
##   "requires": [
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ],
##   "assumes": [
##     "env"
##   ]
## }
drop() {
    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "./bin/console doctrine:database:drop --force --env ${env} || true\n"
    ./bin/console doctrine:database:drop --force --env ${env} || true
}

