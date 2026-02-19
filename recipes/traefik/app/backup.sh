#!/bin/sh

## Backup traefik configuration
##
## {
##   "namespace": "app",
##   "requires": [
##     "cp",
##     "mkdir"
##   ],
##   "depends": [
##     "_echo_info"
##   ],
##   "assumes": [
##     "HOME"
##   ]
## }
backup() {
    _backup_dir=${HOME}/.tangoman75/traefik-partner/backup
    _echo_info "mkdir -p \"${_backup_dir}/config\"\n"
    mkdir -p "${_backup_dir}/config"

    for _file in \
        .env \
        compose.yaml \
    ; do
        _echo_info "cp \"./${_file}\" \"${_backup_dir}\" || true\n"
        cp "./${_file}" "${_backup_dir}" || true
    done

    for _file in \
        acme.json \
        traefik.yaml \
    ; do
        _echo_info "cp \"./config/${_file}\" \"${_backup_dir}/config\" || true\n"
        cp "./config/${_file}" "${_backup_dir}/config" || true
    done
}

