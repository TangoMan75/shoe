#!/bin/sh

## Check requirements
requirements() {
    _error=0

    if ! _check_installed awk; then
        _error=1
    fi

    if ! _check_installed sed; then
        _error=1
    fi

    if ! _check_installed php; then
        _error=1
    fi

    if ! _check_installed composer; then
        _error=1
    fi

    if ! _check_installed openssl; then
        _error=1
    fi
}

