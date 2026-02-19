#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Delete \"gh-pages\" and rebuild branch from \"build\" folder",
##   "requires": [
##     "git",
##     "true"
##   ],
##   "depends": [
##     "recipes/calculatrice-salaire-net/app/build",
##     "recipes/charlotte/app/cname",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_warning"
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
