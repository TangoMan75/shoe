#!/bin/sh

## Install App with npm
##
## @namespace recipes/parcel/app
## @requires npm
## @depends src/shell/colors/_echo_info.sh
install() {
    _echo_info 'npm install\n'
    npm install
}

