#!/bin/sh

## Place here commands you need executed first every time (optional)
##
## @namespace src/shell/hooks
## @requires awk sed
## @depends src/shell/system/_check_installed
_before() {
    _check_installed awk
    _check_installed sed
}

