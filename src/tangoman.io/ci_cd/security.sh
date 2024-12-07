#!/bin/sh

## Check security issues in project dependencies (symfony-cli)
security() {
    _check_installed symfony

    echo_info 'symfony security:check\n'
    symfony security:check
}

