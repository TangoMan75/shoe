#!/bin/sh

## Replace shoemaker, entrypoint and Makefile in root directory
##
## {
##   "namespace": "app",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
replace() {
    _echo_info 'cp build/shoemaker.sh .\n'
    cp build/shoemaker.sh .

    _echo_info 'cp build/entrypoint.sh .\n'
    cp build/entrypoint.sh .

    _echo_info 'cp build/shoemaker.makefile Makefile\n'
    cp build/shoemaker.makefile Makefile
}

