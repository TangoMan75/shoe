#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Deploy \"build\" folder to \"gh-pages\"",
##   "requires": [
##     "git",
##     "split"
##   ],
##   "depends": [
##     "recipes/bash_aliases/git/commit",
##     "recipes/calculatrice-salaire-net/app/build",
##     "recipes/charlotte/app/cname",
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
