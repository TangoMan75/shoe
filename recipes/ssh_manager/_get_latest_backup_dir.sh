#!/bin/sh

## {
##   "namespace": "recipes/ssh_manager",
##   "summary": "Get latest backup directory path",
##   "requires": [
##     "echo",
##     "find",
##     "sort",
##     "tail"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/system/_pwd"
##   ]
## }
_get_latest_backup_dir() {
    latest="$(find "$(_pwd)/backups" -mindepth 1 -maxdepth 1 -type d | sort | tail -1)"
    if [ ! -d "${latest}" ]; then
        _echo_danger "error: no backup folder found\n"

        return 1
    fi

    echo "${latest}"
}

