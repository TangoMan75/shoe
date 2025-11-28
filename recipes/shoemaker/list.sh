#!/bin/sh

## Dump "build.shoe" file
##
## {
##   "depends": [
##     "_get_functions_names",
##     "_pwd",
##     "_echo_error",
##     "_echo_success"
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

