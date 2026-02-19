#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Deploy \"build\" folder to \"gh-pages\"",
##   "requires": [
##     "HEAD",
##     "git",
##     "split"
##   ],
##   "depends": [
##     "recipes/charlotte/app/build",
##     "recipes/charlotte/app/cname",
##     "recipes/charlotte/app/commit",
##     "src/shell/colors/_echo_info"
##   ]
## }
deploy() {
    build
    cname
    commit

    _echo_info "git push origin \"$(git subtree split --prefix dist HEAD)\":gh-pages --force\n"
    git push origin "$(git subtree split --prefix dist HEAD)":gh-pages --force
}

