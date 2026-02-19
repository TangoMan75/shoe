#!/bin/sh

## Restore traefik configuration
##
## {
##   "namespace": "app",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "_echo_info"
##   ],
##   "assumes": [
##     "HOME"
##   ]
## }
restore() {
    _backup_dir=${HOME}/.tangoman75/traefik-partner/backup
    _echo_info "cp -rfvT \"${_backup_dir}\" .\n"
    cp -rfvT "${_backup_dir}" .
}

