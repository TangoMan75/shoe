#!/bin/sh

## {
##   "namespace": "recipes/agnostic-companion/install",
##   "summary": "Fix permissions",
##   "requires": [
##     "chmod",
##     "stat",
##     "sudo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
permissions() {
    if [ "$(stat -c "%A" ./data)" != 'drwxrwxrwx' ]; then
        _echo_info 'sudo chmod 777 ./data\n'
        sudo chmod 777 ./data
    fi
}

