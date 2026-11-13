#!/bin/sh

## Watch scss
##
## @namespace recipes/tangoman.io/front
## @requires sass
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
sass_watch() {
    _check_installed sass

    _echo_info 'sass --watch assets/scss:public/css\n'
    sass --watch assets/scss:public/css
}

