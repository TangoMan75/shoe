#!/bin/sh

## {
##   "namespace": "recipes/entrypoint/app",
##   "summary": "Build all scripts in recipes folder",
##   "requires": [
##     "chmod",
##     "find",
##     "python3",
##     "rm",
##     "sh",
##     "true"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_info",
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_pwd"
##   ]
## }
build_all() {
    _echo_info 'rm -rf build || true\n'
    rm -rf build || true

    _alert_info 'Build all scripts from recipes folder'

    _echo_info 'rm -f build/*.sh || true\n'
    rm -f build/*.sh || true

    find "$(_pwd)/recipes" -type f -name '*.shoe' | while read -r file_path
    do
        _echo_info "python3 shoemaker.py build \"${file_path}\" --sh\n"
        python3 shoemaker.py build "${file_path}" --sh
    done

    find ./build -type f -name '*.sh' | while read -r file_path
    do
        _echo_info "chmod 775 \"${file_path}\"\n"
        chmod 775 "${file_path}"
    done

    _alert_info 'Generate documentation for all scripts from build folder'

    _echo_info 'rm -f doc/*.md || true\n'
    rm -f doc/*.md || true

    find ./build -type f -name '*.sh' | while read -r file_path
    do
        if [ "${file_path}" = './build/shoe.sh' ]; then
            _echo_info "python3 shoemaker.py generate_doc \"${file_path}\" --destination doc --private\n"
            python3 shoemaker.py generate_doc "${file_path}" --destination doc --private

            continue
        fi

        _echo_info "python3 shoemaker.py generate_doc \"${file_path}\" --destination doc\n"
        python3 shoemaker.py generate_doc "${file_path}" --destination doc
    done

    _alert_info 'Generate makefiles for all scripts from build folder'

    _echo_info 'rm -f build/*.makefile || true\n'
    rm -f build/*.makefile || true

    find ./build -type f -name '*.sh' | while read -r file_path
    do
        _echo_info "python3 shoemaker.py generate_makefile \"${file_path}\"\n"
        python3 shoemaker.py generate_makefile "${file_path}"
    done
}

