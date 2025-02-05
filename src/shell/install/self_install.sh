#!/bin/sh

## Install script and enable completion
self_install() {
    _install "$0" "${ALIAS}" "${global:-false}"
}

