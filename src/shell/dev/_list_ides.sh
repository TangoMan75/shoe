#!/bin/sh

## List installed ides
##
## {
##   "namespace": "dev",
##   "requires": [
##     "command",
##     "printf"
##   ]
## }
_list_ides() {
    set -- antigravity atom clion code codium cursor intellij-idea-community micro nano nvim phpstorm pycharm pycharm-community subl vim webstorm windsurf zed
    while [ "$#" -gt 0 ]; do
        if [ -n "$(command -v "$1")" ]; then
            printf '%s ' "$1"
        fi
        shift
    done
}
