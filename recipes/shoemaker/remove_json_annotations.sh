#!/bin/sh

## {
##   "namespace": "recipes/shoemaker",
##   "summary": "Remove json annotations from file",
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_sed_i"
##   ]
## }
remove_json_annotations() {
    if [ ! -f "${file}" ]; then
        _echo_error "\"${file}\" file not found\n"
        return 1
    fi

    _echo_info "$(_sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' \"${file}\"\n"
    $(_sed_i) -r '/^##? \{$/,/^##? \}$/d; /^##?$/d' "${file}"
}

