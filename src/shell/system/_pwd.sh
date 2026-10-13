#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Return current project directory realpath, or \"pwd\" when installed globally",
##   "requires": [
##     "dirname",
##     "pwd",
##     "realpath"
##   ],
##   "returns": "str"
## }
_pwd() {
    # Synopsis: _pwd

    if [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

