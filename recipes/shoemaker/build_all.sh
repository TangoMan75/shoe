#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Build all scripts",
##   "requires": [
##     "find",
##     "mkdir"
##   ],
##   "depends": [
##     "recipes/shoemaker/_build",
##     "src/shell/system/_pwd"
##   ]
## }
build_all() {
    build_folder="$(_pwd)/build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find "$(_pwd)/recipes" -type f -name '*.shoe' | while read -r file_path
    do
        _build "${file_path}" "${build_folder}" "${type}"
    done
}

