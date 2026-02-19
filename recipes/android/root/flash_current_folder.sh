#!/bin/sh

## {
##   "namespace": "recipes/android/root",
##   "summary": "Flash from current folder",
##   "requires": [
##     "basename",
##     "find"
##   ],
##   "depends": [
##     "src/shell/android/_flash_img"
##   ]
## }
flash_current_folder() {
    find . -maxdepth 1 -type f -name '*.img' | while read -r _file
    do
        _flash_img "${_file}" "$(basename "${file}" .img)"
    done
}

