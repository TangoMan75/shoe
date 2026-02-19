#!/bin/sh

## {
##   "namespace": "recipes/py_entrypoint",
##   "summary": "Install tools",
##   "requires": [
##     "python3"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info"
##   ]
## }
install() {
    for _file in \
        shoemaker.py \
    ; do
        _echo_info "python3 \"${_file}\" self-install\n"
        python3 "${_file}" self-install
    done
}

