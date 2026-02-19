#!/bin/sh

## Get latest backup directory path
_get_latest_backup_dir() {
    latest="$(find "$(_pwd)/backups" -mindepth 1 -maxdepth 1 -type d | sort | tail -1)"
    if [ ! -d "${latest}" ]; then
        _echo_danger "error: no backup folder found\n"

        return 1
    fi

    echo "${latest}"
}
