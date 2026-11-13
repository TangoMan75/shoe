#!/bin/sh

## Install Ck Editor
##
## @namespace recipes/tangoman.io/front
## @requires install
## @depends src/shell/colors/_echo_info
## @assumes env
ckeditor() {
    _echo_info "./bin/console ckeditor:install --no-interaction --env ${env}\n"
    ./bin/console ckeditor:install --no-interaction --env ${env}
}

