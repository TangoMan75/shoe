#!/bin/sh

## Copy ".env" from ".env.dist" file
##
## {
##   "namespace": "install",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "_echo_info"
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

