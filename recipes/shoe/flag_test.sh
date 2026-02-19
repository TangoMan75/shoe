#!/bin/sh

## {
##   "namespace": "recipes/shoe",
##   "summary": "Prints flag status",
##   "requires": [
##     "echo",
##     "true"
##   ],
##   "assumes": [
##     "flag"
##   ]
## }
flag_test() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}

