#!/bin/sh

## Watch source folder for changes
##
## @namespace src/shell/npm
## @requires npm watch
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/system/_check_installed.sh
_npm_watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}

