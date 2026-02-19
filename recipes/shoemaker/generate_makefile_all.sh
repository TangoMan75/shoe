#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Generate Makefile for all scripts",
##   "requires": [
##     "basename",
##     "find",
##     "mkdir"
##   ],
##   "depends": [
##     "src/shell/make/_generate_makefile",
##     "src/shell/system/_pwd"
##   ]
## }
generate_makefile_all() {
    build_folder="$(_pwd)/build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find "${build_folder}" -type f -name '*.sh' | while read -r file_path
    do
        _generate_makefile "${file_path}" "${build_folder}" "$(basename "${file_path}" .sh).makefile"
    done
}

