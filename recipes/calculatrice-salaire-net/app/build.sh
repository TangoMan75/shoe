#!/bin/sh

## {
##   "namespace": "recipes/calculatrice-salaire-net/app",
##   "summary": "Build app to \"dist\" folder",
##   "requires": [
##     "npm",
##     "rm"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
build() {
    _echo_info 'rm -rf ./dist\n'
    rm -rf ./dist

    _echo_info 'npm run build\n'
    npm run build
}
