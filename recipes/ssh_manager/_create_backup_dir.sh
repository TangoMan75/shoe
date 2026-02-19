#!/bin/sh

## Create a new empty folder in the backup directory
_create_backup_dir() {
    if [ -z "$1" ] || [ -z "${current_backup}" ]; then echo_danger 'error: _create_backup_dir: some mandatory parameter is missing\n'; return 1; fi

    set -- "$(_pwd)/backups/${current_backup}/$1"

    if [ -d "$1" ]; then
        rm -rf "$1"
    fi

    mkdir -p "$1"

    realpath "$1"
}
