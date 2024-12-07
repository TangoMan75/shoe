#!/bin/sh

## Compile scss
sass_build() {
    _check_installed sass

    echo_info 'sass assets/scss/styles.scss public/css/styles.css\n'
    sass assets/scss/styles.scss public/css/styles.css
}

