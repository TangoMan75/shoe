#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/development",
##   "summary": "Load .env variables",
##   "requires": [
##     "cat",
##     "eval"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ]
## }
_dotenv() {
    if [ -f ".env.${env}.local" ]; then
        eval "$(cat ".env.${env}.local")"
        return 0
    fi

    if [ -f ".env.${env}" ]; then
        eval "$(cat ".env.${env}")"
        return 0
    fi

    if [ -f ".env.local" ]; then
        eval "$(cat ".env.local")"
        return 0
    fi

    if [ -f .env ]; then
        eval "$(cat .env)"
        return 0
    fi

    _echo_error '".env" file not found\n'
    exit 1
}

