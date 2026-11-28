#!/bin/sh

## Sniff errors with linter
##
## install ruff globally with
## sudo pip install --upgrade ruff
##
## @namespace recipes/taco/app
## @link https://github.com/astral-sh/ruff
## @requires basename find ruff sort true
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @flag <fix> [-f|--fix] Autofix lint errors
lint() {

    if [ ! -x "$(command -v ruff)" ]; then
        _echo_error "\"$(basename "${0}")\" requires ruff\n"

        return 1
    fi

    if [ "${fix}" = true ]; then
        find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
        do
            _echo_info "ruff check --fix \"${_file}\"\n"
            ruff check --fix "${_file}"
        done

        return 0
    fi

    find . -maxdepth 2 -type f -name '*.py' | sort -t '\0' -n | while read -r _file
    do
        _echo_info "ruff check \"${_file}\"\n"
        ruff check "${_file}"
    done
}

