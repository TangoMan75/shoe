#!/bin/sh

## Watch with parcel
##
## @namespace recipes/parcel/app
## @requires npm
## @depends src/shell/colors/_echo_info
watch() {
    _echo_info 'npm run watch\n'
    npm run watch
}

