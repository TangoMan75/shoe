#!/bin/sh

## Sniff errors with linters
##
## @namespace recipes/traefik/ci_cd
## @depends recipes/traefik/ci_cd/lint_shell recipes/traefik/ci_cd/lint_yaml
lint() {
    lint_shell
    lint_yaml
}

