#!/bin/sh

## Build all scripts in recipes folder
##
## Each step is run from a temporary list instead of a pipeline, so a
## failure in the middle of a loop is reported instead of being lost,
## and the command fails when any of them fails.
##
## @namespace recipes/entrypoint/app
## @requires chmod cp find mktemp python3 rm sh true
## @depends src/shell/colors/_alert_info.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
build() {
    if [ ! -f "./shoemaker.py" ] || [ ! -d "./recipes" ]; then
        _echo_error "\"$1\" is not a Shoe project (shoemaker.py or recipes folder not found)\n"

        return 1
    fi

    _echo_info "rm -rf \"./build\" || true\n"
    rm -rf "./build" || true

    _alert_info 'Build all scripts from recipes folder'

    _echo_info "rm -f \"./build/*.sh\" || true\n"
    rm -f "./build"/*.sh || true

    __status__=0
    __list__="$(mktemp)" || return 1

    find "./recipes" -type f -name '*.shoe' > "${__list__}"
    while read -r file_path
    do
        _echo_info "python3 \"./shoemaker.py\" build \"${file_path}\"\n"
        if ! python3 "./shoemaker.py" build "${file_path}"; then
            __status__=1
        fi
    done < "${__list__}"

    find "./build" -type f -name '*.sh' > "${__list__}"
    while read -r file_path
    do
        _echo_info "chmod 775 \"${file_path}\"\n"
        if ! chmod 775 "${file_path}"; then
            __status__=1
        fi
    done < "${__list__}"

    _alert_info 'Generate documentation for all scripts from build folder'

    _echo_info "rm -f \"./doc/*.md\" || true\n"
    rm -f "./doc"/*.md || true

    find "./build" -type f -name '*.sh' > "${__list__}"
    while read -r file_path
    do
        if [ "${file_path}" = "./build/shoe.sh" ]; then
            _echo_info "python3 \"./shoemaker.py\" generate_doc \"${file_path}\" --destination \"./doc\" --private\n"
            if ! python3 "./shoemaker.py" generate_doc "${file_path}" \
                --destination "./doc" --private; then
                __status__=1
            fi

            continue
        fi

        _echo_info "python3 \"./shoemaker.py\" generate_doc \"${file_path}\" --destination \"./doc\"\n"
        if ! python3 "./shoemaker.py" generate_doc "${file_path}" \
            --destination "./doc"; then
            __status__=1
        fi
    done < "${__list__}"

    _alert_info 'Generate makefiles for all scripts from build folder'

    _echo_info "rm -f \"./build/*.makefile\" || true\n"
    rm -f "./build"/*.makefile || true

    find "./build" -type f -name '*.sh' > "${__list__}"
    while read -r file_path
    do
        _echo_info "python3 \"./shoemaker.py\" generate_makefile \"${file_path}\"\n"
        if ! python3 "./shoemaker.py" generate_makefile "${file_path}"; then
            __status__=1
        fi
    done < "${__list__}"

    # The repository entry point is a copy of the generated one: refresh it
    # so a stale copy cannot survive the build.
    if [ -f "./build/entrypoint.sh" ]; then
        _echo_info "cp \"./build/entrypoint.sh\" \"./entrypoint.sh\"\n"
        if ! cp "./build/entrypoint.sh" "./entrypoint.sh"; then
            __status__=1
        fi
        if ! chmod 775 "./entrypoint.sh"; then
            __status__=1
        fi
    fi

    rm -f -- "${__list__}"

    return "${__status__}"
}

