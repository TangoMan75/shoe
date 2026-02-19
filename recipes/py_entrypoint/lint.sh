#!/bin/sh

## Sniff errors with linter
##
## {
##   "requires": [
##     "autopep8",
##     "pylint"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_success",
##     "_echo_warning"
##   ]
## }
lint() {
    # @link https://github.com/pylint-dev/pylint
    # install pylint globally with
    # sudo pip install --upgrade pylint

    # @link https://github.com/hhatto/autopep8
    # install autopep8 globally with
    # sudo pip install --upgrade autopep8g

    if [ "${fix}" = true ]; then
        if [ ! -x "$(command -v autopep8)" ]; then
            _echo_error "\"$(basename "${0}")\" requires autopep8\n"

            return 1
        fi

        find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
        do
            _echo_info "autopep8 --in-place --aggressive --max-line-length 255 \"${_file}\"\n"
            autopep8 --in-place --aggressive --max-line-length 255 "${_file}"
        done

        return 0
    fi

    find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
    do
        _echo_info "python3 -m py_compile \"${_file}\"\n"
        python3 -m py_compile "${_file}"
    done

    if [ -x "$(command -v pylint)" ]; then
        _echo_info 'pylint --version\n'
        pylint --version

        find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
        do
            _echo_info "pylint --max-line-length 255 \"${_file}\"\n"
            pylint --max-line-length 255 "${_file}"
        done
    fi
}

