#!/bin/bash

alias disks='drives'   ## drives alias

## {
##   "namespace": "recipes/bash_aliases/system",
##   "summary": "List connected drives (ignore loop devices)",
##   "requires": [
##     "blkid",
##     "df",
##     "fdisk",
##     "grep",
##     "lsblk",
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
function drives() {
    _echo_info 'lsblk -l | grep -v loop\n'
    lsblk -l | grep -v loop

    if [ -x "$(command -v df)" ]; then
        _echo_info 'df -h | grep -v loop\n'
        df -h | grep -v loop
    fi

    _echo_info 'df -hT -x squashfs\n'
    df -hT -x squashfs

    if [ -x "$(command -v blkid)" ]; then
        _echo_info "sudo blkid | grep -v '/dev/loop'\n"
        sudo blkid | grep -v '/dev/loop'
    fi

    if [ -x "$(command -v fdisk)" ]; then
        _echo_info 'sudo fdisk -l\n'
        sudo fdisk -l
    fi
}

