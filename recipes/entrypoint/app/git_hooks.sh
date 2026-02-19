#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Install git hooks",
##   "depends": [
##     "src/shell/git/_git_hooks"
##   ]
## }
git_hooks() {
    _git_hooks
}

