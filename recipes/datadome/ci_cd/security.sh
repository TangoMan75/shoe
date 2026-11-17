#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
##
## @namespace recipes/datadome/ci_cd
## @depends src/shell/symfony/_sf_security
security() {
    _sf_security
}

