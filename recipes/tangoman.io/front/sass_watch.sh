#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Watch scss",
##   "requires": [
##     "sass"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
sass_watch() {
    _check_installed sass

    _echo_info 'sass --watch assets/scss:public/css\n'
    sass --watch assets/scss:public/css
}

