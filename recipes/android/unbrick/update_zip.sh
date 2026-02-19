#!/bin/sh

## {
##   "namespace": "recipes/android/unbrick",
##   "summary": "Flash all partitions from an update.zip package",
##   "requires": [
##     "fastboot",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
update_zip() {
    if [ -z "${file}" ] && [ -z "$1" ]; then
        _echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ -z "${file}" ]; then
        file="$1"
    fi
    file=$(realpath "${file}")

    if [ ! -f "${file}" ]; then
        _echo_error "file not found: \"${file}\"\n"
        return 1
    fi

    _echo_info "fastboot update \"${file}\"\n"
    fastboot update "${file}"
}

