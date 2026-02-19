#!/bin/sh

## Deploy "dist" folder to "gh-pages"
##
## {
##   "namespace": "app",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_info",
##     "build"
##   ]
## }
deploy() {
    build

    (
        _echo_info 'cd dist\n'
        cd dist

        _echo_info 'git init\n'
        git init

        _echo_info 'git add -A\n'
        git add -A

        _echo_info "git commit -m \"$(date '+%Y-%m-%d %H:%M:%S')\"\n"
        git commit -m "$(date '+%Y-%m-%d %H:%M:%S')"

        _echo_info 'git push --force git@github.com:TangoMan75/calculatrice-salaire-net.git main:gh-pages\n'
        git push --force git@github.com:TangoMan75/calculatrice-salaire-net.git main:gh-pages
    )
}
