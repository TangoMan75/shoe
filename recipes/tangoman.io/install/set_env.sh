#!/bin/sh

## {
##   "namespace": "recipes/tangoman.io/install",
##   "summary": "Create \".env.local\" file",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "recipes/tangoman.io/symfony/generate_app_secret",
##     "src/shell/colors/_echo_info"
##   ]
## }
set_env() {
    _echo_info "cp -f .env.${env} .env.local\n"
    cp -f .env.${env} .env.local

    generate_app_secret
}

