#!/bin/sh

## Install Ck Editor
ckeditor() {
    echo_info "./bin/console ckeditor:install --no-interaction --env ${env}\n"
    ./bin/console ckeditor:install --no-interaction --env ${env}
}

