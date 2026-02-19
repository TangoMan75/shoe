#!/bin/sh

## {
##   "namespace": "recipes/pivot/app",
##   "summary": "Watch source folder for changes",
##   "requires": [
##     "npm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}
