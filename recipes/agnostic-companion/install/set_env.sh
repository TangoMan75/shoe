#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/install",
##   "summary": "Copy \".env\" from \".env.dist\" file",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
set_env() {
    # do not overwrite
    if [ -f .env ]; then
        return 0
    fi

    _echo_info "cp -f .env.dist .env\n"
    cp -f .env.dist .env
}

