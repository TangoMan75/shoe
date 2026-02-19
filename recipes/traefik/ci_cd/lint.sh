#!/bin/sh

## {
##   "namespace": "recipes/traefik/ci_cd",
##   "summary": "Sniff errors with linters",
##   "depends": [
##     "recipes/traefik/ci_cd/lint_shell",
##     "recipes/traefik/ci_cd/lint_yaml"
##   ]
## }
lint() {
    lint_shell
    lint_yaml
}

