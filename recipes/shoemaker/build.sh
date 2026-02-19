#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Build from given \"build.shoe\" file",
##   "requires": [
##     "mkdir",
##     "realpath"
##   ],
##   "depends": [
##     "recipes/shoemaker/_build",
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_pwd"
##   ]
## }
build() {
    if [ ! -f "${file}" ]; then
        _echo_error "\"${file}\" file not found\n"
        return 1
    fi
    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/build"
    fi
    destination="$(realpath "${destination}")"

    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    _build "${file}" "${destination}" "${type}"
}

