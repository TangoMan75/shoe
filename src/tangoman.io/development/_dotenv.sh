#!/bin/sh

# Load .env variables
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

    echo_error '".env" file not found\n'
    exit 1
}

