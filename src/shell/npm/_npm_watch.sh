#!/bin/sh

## {
##   "namespace": "src/shell/npm",
##   "summary": "Watch source folder for changes",
##   "requires": [
##     "npm",
##     "watch"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_npm_watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}
