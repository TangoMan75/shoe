#!/bin/sh

## Deploy "build" folder to "gh-pages"
##
## {
##   "namespace": "app",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_info",
##     "build",
##     "cname",
##     "commit"
##   ]
## }
deploy() {
    build
    cname
    commit

    _echo_info "git push origin \"$(git subtree split --prefix dist HEAD)\":gh-pages --force\n"
    git push origin "$(git subtree split --prefix dist HEAD)":gh-pages --force
}
