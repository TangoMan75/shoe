#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Check current user is root",
##   "requires": [
##     "awk",
##     "id"
##   ]
## }
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        return 0
    fi

    return 1
}

