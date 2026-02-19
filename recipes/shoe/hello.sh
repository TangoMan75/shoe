#!/bin/sh

## {
##   "namespace": "recipes/shoe",
##   "summary": "Hello World!",
##   "description": "Greets a specified user a given number of times. (the recipient's name is provided with the \"--who\" option)",
##   "requires": [
##     "echo"
##   ],
##   "params": [
##     {
##       "name": "who",
##       "type": "str",
##       "description": "The recipient's name.",
##       "position": 1
##     }
##   ]
## }
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done
}

