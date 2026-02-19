#!/bin/sh

## Watch scss
sass_watch() {
    _check_installed sass

    _echo_info 'sass --watch assets/scss:public/css\n'
    sass --watch assets/scss:public/css
}

