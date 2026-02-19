#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Build given script from recipe",
##   "requires": [
##     "chmod",
##     "rm",
##     "sh",
##     "shoemaker.sh",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/documentation/generate_doc",
##     "src/shell/make/generate_makefile"
##   ]
## }
build() {
    if [ ! -f "recipes/${recipe}/${recipe}.shoe" ]; then
        _echo_error "\"${recipe}/${recipe}.shoe\" file not found\n"
        return 1
    fi

    _echo_info "rm \"build/${recipe}.sh\" || true\n"
    rm "build/${recipe}.sh" || true

    _echo_info "sh shoemaker.sh build -f \"recipes/${recipe}/${recipe}.shoe\"\n"
    sh shoemaker.sh build -f "recipes/${recipe}/${recipe}.shoe"

    _echo_info "chmod 775 \"build/${recipe}.sh\"\n"
    chmod 775 "build/${recipe}.sh"

    _echo_info "rm \"doc/${recipe}.md\" || true\n"
    rm "doc/${recipe}.md" || true

    _echo_info "sh shoemaker.sh generate_doc -f \"build/${recipe}.sh\" -d doc\n"
    sh shoemaker.sh generate_doc -f "build/${recipe}.sh" -d doc

    _echo_info "sh shoemaker.sh generate_makefile -f \"build/${recipe}.sh\"\n"
    sh shoemaker.sh generate_makefile -f "build/${recipe}.sh"
}

