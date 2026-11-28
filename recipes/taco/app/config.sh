#!/bin/sh

## Config Taco
##
## @namespace recipes/taco/app
## @requires git
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
config() {
    if command -v git >/dev/null 2>&1; then
        _echo_info "git config --global core.pager 'taco'\n"
        git config --global core.pager 'taco'

        _echo_success 'Configured git to use taco as its pager.\n'
    fi
}

