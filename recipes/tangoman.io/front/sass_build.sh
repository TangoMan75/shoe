#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/front",
##   "summary": "Compile scss",
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
sass_build() {
    _check_installed sass

    _echo_info 'sass assets/scss/styles.scss public/css/styles.css\n'
    sass assets/scss/styles.scss public/css/styles.css
}

