#!/bin/sh

## Watch with parcel
##
## @namespace recipes/groceries/app
## @requires yarn
## @depends src/shell/colors/_echo_info.sh
watch() {
    _echo_info 'yarn watch\n'
    yarn watch
}

