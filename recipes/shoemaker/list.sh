#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Dump \"build.shoe\" file",
##   "requires": [
##     "basename",
##     "mkdir",
##     "realpath",
##     "sed",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_success",
##     "src/shell/reflexion/_get_functions_names",
##     "src/shell/system/_pwd"
##   ]
## }
list() {
    if [ ! -f "${file}" ]; then
        _echo_error "\"${file}\" file not found\n"
        return 1
    fi

    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/dump/$(basename "${file}" .sh)"
    fi

    destination="$(realpath "${destination}")"
    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    _echo_success "Listing functions from \"${file}\" to \"${destination}/$(basename "${file}" .sh).shoe\"\n"
    _get_functions_names "${file}" true | sed 's/$/.sh/g' > "${destination}/$(basename "${file}" .sh).shoe"
}

