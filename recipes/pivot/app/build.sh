#!/bin/sh

## {
##   "namespace": "recipes/pivot/app",
##   "summary": "Build app to \"dist\" folder",
##   "requires": [
##     "npm",
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
build() {
    _check_installed npm

    _echo_info 'rm -rf ./dist/css\n'
    rm -rf ./dist/css

    _echo_info 'rm -rf ./dist/js\n'
    rm -rf ./dist/js

    _echo_info 'npm run build\n'
    npm run build
}

