#!/bin/sh

## Unconfig Taco
##
## @namespace recipes/taco/app
## @requires git
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
unconfig() {
    if command -v git >/dev/null 2>&1; then
        if git config --global --get core.pager >/dev/null 2>&1; then
            _echo_info "git config --global --unset core.pager\n"
            git config --global --unset core.pager

            _echo_success 'Removed core.pager from the global Git config.\n'
        else
            _echo_info 'core.pager is not set in the global Git config.\n'
        fi
    fi
}

