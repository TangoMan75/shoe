#!/bin/sh

## {
##   "namespace": "src/shell/compatibility",
##   "summary": "Open with default system handler",
##   "requires": [
##     "echo",
##     "uname"
##   ]
## }
_open() {
    # Synopsis: _open

    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

