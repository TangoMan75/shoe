#!/bin/sh

## Install Ck Editor
ckeditor() {
    _echo_info "./bin/console ckeditor:install --no-interaction --env ${env}\n"
    ./bin/console ckeditor:install --no-interaction --env ${env}
}

