#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Build given script from recipe",
##   "requires": [
##     "chmod",
##     "python3",
##     "rm",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info"
##   ]
## }
build() {
    if [ ! -f "recipes/${recipe}/${recipe}.shoe" ]; then
        _echo_error "\"${recipe}/${recipe}.shoe\" file not found\n"
        return 1
    fi

    _echo_info "rm \"build/${recipe}.sh\" || true\n"
    rm "build/${recipe}.sh" || true

    _echo_info "python3 shoemaker.py build \"recipes/${recipe}/${recipe}.shoe\"\n"
    python3 shoemaker.py build "recipes/${recipe}/${recipe}.shoe"

    _echo_info "chmod 775 \"build/${recipe}.sh\"\n"
    chmod 775 "build/${recipe}.sh"

    _echo_info "rm \"doc/${recipe}.md\" || true\n"
    rm "doc/${recipe}.md" || true

    _echo_info "python3 shoemaker.py generate_doc -f \"build/${recipe}.sh\" --destination doc\n"
    python3 shoemaker.py generate_doc -f "build/${recipe}.sh" --destination doc

    _echo_info "python3 shoemaker.py generate_makefile -f \"build/${recipe}.sh\"\n"
    python3 shoemaker.py generate_makefile -f "build/${recipe}.sh"
}

