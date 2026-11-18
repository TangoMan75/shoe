#!/bin/sh

## Check current user is root
##
## @namespace src/shell/system
## @requires awk id
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        return 0
    fi

    return 1
}

