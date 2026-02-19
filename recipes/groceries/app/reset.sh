#!/bin/sh

## {
##   "namespace": "recipes/groceries/app",
##   "summary": "Delete \"gh-pages\" and rebuild branch from \"build\" folder",
##   "requires": [
##     "git",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
reset() {
    _echo_info "git push origin --delete gh-pages || true\n"
    git push origin --delete gh-pages || true

    _echo_info "git subtree push --prefix dist origin gh-pages\n"
    git subtree push --prefix dist origin gh-pages
}
