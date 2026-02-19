#!/bin/sh

## {
##   "namespace": "recipes/shoe",
##   "summary": "Prints flag status",
##   "requires": [
##     "echo",
##     "true"
##   ],
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

