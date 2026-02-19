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

    # @link https://github.com/PyCQA/pycodestyle
    # install pycodestyle globally with
    # sudo pip install --upgrade pycodestyle

    if [ "${fix}" = true ]; then
        if [ ! -x "$(command -v autopep8)" ]; then
            _echo_error "\"$(basename "${0}")\" requires autopep8\n"
            return 1
        fi
    fi

    find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
    do
        if [ "${fix}" = true ]; then
            _echo_info "autopep8 --in-place --aggressive --max-line-length 255 \"${_file}\"\n"
            autopep8 --in-place --aggressive --max-line-length 255 "${_file}"
            continue
        fi

        _echo_info "pylint --max-line-length 255 --disable R0903 \"${_file}\"\n"
        pylint --max-line-length 255 --disable R0903 "${_file}"
    done
}

