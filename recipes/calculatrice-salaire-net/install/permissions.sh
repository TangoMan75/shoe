#!/bin/sh

## Fix permissions
##
## {
##   "namespace": "install",
##   "requires": [
##     "chown",
##     "sudo"
##   ],
##   "depends": [
##     "_echo_info"
##   ],
##   "assumes": [
##     "USER"
##   ]
## }
permissions() {
    _echo_info "sudo chown \"${USER}:${USER}\" -R ./dist\n"
    sudo chown "${USER}:${USER}" -R ./dist
}

