#!/bin/sh

## {
##   "namespace": "recipes/traefik/app",
##   "summary": "Restore traefik configuration",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
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

