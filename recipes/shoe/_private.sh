#!/bin/sh

## {
##   "namespace": "recipes/shoe",
##   "summary": "Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.",
##   "requires": [
##     "echo"
##   ]
## }
_private() {
    echo "I'm private"
}

