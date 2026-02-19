#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Dump functions from given script into individual files",
##   "requires": [
##     "basename",
##     "mkdir",
##     "printf",
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_success",
##     "src/shell/reflexion/_get_function",
##     "src/shell/reflexion/_get_functions_names"
##   ]
## }
dump() {
    if [ ! -f "${file}" ]; then
        _echo_error "\"${file}\" file not found\n"
        return 1
    fi
    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/dump/$(basename "${file}" .sh)"
    fi
    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi
    destination="$(realpath "${destination}")"

    _echo_success "Dumping functions from \"${file}\" to \"${destination}\"\n"
    for name in $(_get_functions_names "${file}" true); do
        printf '#!/bin/sh\n\n' > "${destination}/${name}.sh"
        _get_function "${file}" "${name}" >> "${destination}/${name}.sh"
    done
}

