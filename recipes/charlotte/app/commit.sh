#!/bin/sh

## Commit dist directory changes
##
## {
##   "namespace": "app",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_info"
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
