#!/bin/sh

## Prints flag status
##
## {
##   "parameters": [
##     {
##       "name": "flag",
##       "type": "bool",
##       "description": "The flag."
##     }
##   ]
## }
test_flag() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}

