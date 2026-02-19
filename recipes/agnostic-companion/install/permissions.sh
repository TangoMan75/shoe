#!/bin/sh

## Fix permissions
##
## {
##   "namespace": "install",
##   "requires": [
##     "chmod"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
permissions() {
    if [ "$(stat -c "%A" ./data)" != 'drwxrwxrwx' ]; then
        _echo_info 'sudo chmod 777 ./data\n'
        sudo chmod 777 ./data
    fi
}

