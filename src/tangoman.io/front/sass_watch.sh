#!/bin/sh

## Watch scss
sass_watch() {
    if [ ! -x "$(command -v sass)" ]; then
        echo_error "\"$(basename "${0}")\" requires sass, try: \"sudo yarn global add sass\"\n"
        return 1
    fi

    echo_info 'sass --watch assets/scss:public/css\n'
    sass --watch assets/scss:public/css
}

