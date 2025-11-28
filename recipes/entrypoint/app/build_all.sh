#!/bin/sh

## Build all scripts in recipes folder
##
## {
##   "namespace": "app",
##   "requires": [
##     "shoemaker.sh",
##     "chmod"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
build_all() {
    _echo_info 'rm -rf build || true\n'
    rm -rf build || true

    _echo_info 'sh shoemaker.sh build_all\n'
    sh shoemaker.sh build_all

    find ./build -type f | while read -r FILE
    do
        _echo_info "chmod 775 \"${FILE}\"\n"
        chmod 775 "${FILE}"
    done

    _echo_info 'rm -f doc/*.md || true\n'
    rm -f doc/*.md || true

    _echo_info 'sh shoemaker.sh generate_doc_all\n'
    sh shoemaker.sh generate_doc_all

    _echo_info 'sh shoemaker.sh generate_doc -p -f build/shoemaker.sh -d doc\n'
    sh shoemaker.sh generate_doc -p -f build/shoemaker.sh -d doc

    _echo_info 'sh shoemaker.sh generate_doc -p -f build/shoe.sh -d doc\n'
    sh shoemaker.sh generate_doc -p -f build/shoe.sh -d doc

    _echo_info 'sh shoemaker.sh generate_makefile_all\n'
    sh shoemaker.sh generate_makefile_all
}

