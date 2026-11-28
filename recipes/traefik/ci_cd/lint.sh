#!/bin/sh

## Sniff errors with linters
##
## @namespace recipes/traefik/ci_cd
## @depends recipes/traefik/ci_cd/lint_shell.sh
## @depends recipes/traefik/ci_cd/lint_yaml.sh
lint() {
    lint_shell
    lint_yaml
}

