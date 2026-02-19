#!/bin/sh

## {
##   "namespace": "recipes/shoe",
##   "summary": "Prints flag status",
##   "requires": [
##     "echo",
##     "true"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "flag",
##       "description": "The flag.",
##       "type": "bool"
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

