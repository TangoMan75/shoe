#!/bin/sh

# Place here commands you need executed first every time (optional)
#
# {
#   "namespace": "hooks"
# }
_before() {
    _check_installed awk
    _check_installed sed
}

