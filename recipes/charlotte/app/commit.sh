#!/bin/sh

## {
##   "namespace": "recipes/charlotte/app",
##   "summary": "Commit dist directory changes",
##   "requires": [
##     "date",
##     "git",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
commit() {
    _echo_info 'git add ./dist || true\n'
    git add ./dist || true

    _echo_info "git commit -m \"build: $(date '+%Y-%m-%d %H:%M:%S')\" || true\n"
    git commit -m "build: $(date '+%Y-%m-%d %H:%M:%S')" || true

    _echo_info 'git push --force --set-upstream origin main || true\n'
    git push --force --set-upstream origin main || true
}
