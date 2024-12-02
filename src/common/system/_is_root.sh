#!/bin/sh

# Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        echo true
        return 0
    fi

    echo false
}

