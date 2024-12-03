#!/bin/sh

## Compile scss
sass_build() {
    if [ ! -x "$(command -v sass)" ]; then
        echo_error "\"$(basename "${0}")\" requires sass, try: \"sudo yarn global add sass\"\n"
        return 1
    fi

    echo_info 'sass assets/scss/styles.scss public/css/styles.css\n'
    sass assets/scss/styles.scss public/css/styles.css
}

