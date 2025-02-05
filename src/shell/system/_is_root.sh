#!/bin/sh

# Check current user is root
_is_root() {
    # Synopsis: _is_root

    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        return 0
    fi

    return 1
}

