#!/bin/sh

## Run linter (sniff)
##
## @namespace recipes/datadome/ci_cd
## @depends src/shell/symfony/_sf_lint
lint() {
    _sf_lint
}

