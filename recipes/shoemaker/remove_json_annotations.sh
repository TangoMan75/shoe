#!/bin/sh

## Remove json annotations from file
##
## {
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "sed_i"
##   ]
## }
remove_json_annotations() {
    if [ ! -f "${file}" ]; then
        _echo_error "\"${file}\" file not found\n"
        return 1
    fi

    _echo_info "$(sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' \"${file}\"\n"
    $(sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' "${file}"
}

