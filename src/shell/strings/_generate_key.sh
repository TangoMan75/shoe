#!/bin/sh

## Generate random 32 bit string
##
## @namespace src/shell/strings
## @requires openssl
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_generate_key() {
    _check_installed openssl

    _echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
}

