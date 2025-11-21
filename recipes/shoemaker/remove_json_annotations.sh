#!/bin/sh

## Remove json annotations from file
##
## {
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "echo_danger",
##     "echo_info",
##     "sed_i"
##   ]
## }
remove_json_annotations() {
    if [ ! -f "${file}" ]; then
        echo_danger "error: \"${file}\" file not found\n"
        return 1
    fi

    echo_info "$(sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' \"${file}\"\n"
    $(sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' "${file}"
}

