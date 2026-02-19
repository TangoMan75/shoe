#!/bin/sh

## Delete "gh-pages" and rebuild branch from "build" folder
##
## {
##   "namespace": "app",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_info",
##     "build",
##     "cname"
##   ]
## }
reset() {
    build
    cname

    _echo_warning 'This will break custom domain configuration on github\n'

    _echo_info "git push origin --delete gh-pages || true\n"
    git push origin --delete gh-pages || true

    _echo_info "git subtree push --prefix dist origin gh-pages\n"
    git subtree push --prefix dist origin gh-pages
}
