#!/bin/sh

## Install git hooks
##
## @namespace recipes/entrypoint/app
## @depends src/shell/git/_git_hooks
git_hooks() {
    _git_hooks
}

