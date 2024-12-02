#!/bin/sh

set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework
# *
# * This file is distributed under to the MIT license.
# *
# * Copyright (c) 2024 "Matthias Morin" <mat@tangoman.io>
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy
# * of this software and associated documentation files (the "Software"), to deal
# * in the Software without restriction, including without limitation the rights
# * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# * copies of the Software, and to permit persons to whom the Software is
# * furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all
# * copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# * SOFTWARE.
# *
# * Source code is available here: https://github.com/TangoMan75/shoe
# */

#/**
# * TangoMan Entrypoint
# *
# * Execute Development and Continuous Integration tasks.
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 1.0.0-xxs
# * @link    https://github.com/TangoMan75/shoe
# */

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Install git hooks
git_hooks() {
    echo_info "rm -fr \"${_project_directory}/.git/hooks\"\n"
    rm -fr "${_project_directory}/.git/hooks"

    echo_info "cp -r \"${_project_directory}/.githooks\" \"${_project_directory}/.git/hooks\"\n"
    cp -r "${_project_directory}/.githooks" "${_project_directory}/.git/hooks"

    echo_info "chmod +x \"${_project_directory}/.git/hooks/*\"\n"
    chmod +x "${_project_directory}/.git/hooks/*"
}

## Install bash_unit framework
bash_unit() {
    if [ ! -d ./tests ]; then
        mkdir -p ./tests

    cat > "./tests/test_sample.sh" <<EOF

# https://github.com/pgrange/bash_unit
#
#     assert "test -e /tmp/the_file"
#     assert_fails "grep this /tmp/the_file" "should not write 'this' in /tmp/the_file"
#     assert_status_code 25 code
#     assert_equals "a string" "another string" "a string should be another string"
#     assert_not_equals "a string" "a string" "a string should be different from another string"
#     fake ps echo hello world
test_can_fail() {
    fail "You need to write some tests"
}
EOF
    fi

    if [ ! -f "./tests/bash_unit" ]; then
        if [ -x "$(command -v wget)" ]; then
            echo_info "wget -qO \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            wget -qO "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        elif [ -x "$(command -v curl)" ]; then
            echo_info "curl -sSL -o \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            curl -sSL -o "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        else
            echo_danger "error: could not find \"bash_unit\" executable, please install manually\n"
            exit 1
        fi
    fi

    if [ ! -x "./tests/bash_unit" ]; then
        echo_info "chmod +x \"./tests\"/bash_unit\n"
        chmod +x ./tests/bash_unit
    fi
}

## Sniff errors with linter
lint() {
    if [ ! -x "$(command -v shellcheck)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires shellcheck, try: 'sudo apt-get install -y shellcheck'\n"
        exit 1
    fi

    find "${_project_directory}/build" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

## Run tests
tests() {
    find "${_project_directory}/tests" -maxdepth 1 -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r FILE
    do
        echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

## Run script in Alpine Docker container
alpine() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" alpine sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" alpine sh entrypoint.sh
}

## Run script in Busybox Docker container
busybox() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

## Run script in Ubuntu Docker container
ubuntu() {
    if [ ! -x "$(command -v docker)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires docker, try 'sudo apt-get install -y docker.io'\n"
        return 1
    fi

    echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

# Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
_private() {
    echo "I'm private"
}

#--------------------------------------------------
# Hooks
#--------------------------------------------------

# Place here commands you need executed first every time (optional)
_before() {
    # this will resolve to current project directory
    # or to "pwd" when script is installed globally via copy
    _project_directory="$(_pwd)"

    # uncomment if you need to have all relative pathes to be resolved to the current project directory
    # cd "${_project_directory}" || return 1
}

# Place here commands you need executed last every time (optional)
_after() {
    echo_success 'Done.\n'
}

###################################################
# TangoMan Shoe Shell Microframework
###################################################

#--------------------------------------------------
# Generated code : Do not edit below this line
#--------------------------------------------------

#--------------------------------------------------
# Colors
#--------------------------------------------------

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[97m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[94m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[32m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[31m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[33m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[95m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[47;90m%-*b\033[0m' "$2" '' "$3" "$1" ; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[40;37m%-*b\033[0m' "$2" '' "$3" "$1" ; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.
alert_primary()   { printf '\033[0m\n\033[1;104;97m%64s\033[0m\n\033[1;104;97m %-63s\033[0m\n\033[1;104;97m%64s\033[0m\n\n' '' "$1" '' ; }
alert_secondary() { printf '\033[0m\n\033[1;45;97m%64s\033[0m\n\033[1;45;97m %-63s\033[0m\n\033[1;45;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_success()   { printf '\033[0m\n\033[1;42;97m%64s\033[0m\n\033[1;42;97m %-63s\033[0m\n\033[1;42;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_danger()    { printf '\033[0m\n\033[1;41;97m%64s\033[0m\n\033[1;41;97m %-63s\033[0m\n\033[1;41;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_warning()   { printf '\033[0m\n\033[1;43;97m%64s\033[0m\n\033[1;43;97m %-63s\033[0m\n\033[1;43;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_info()      { printf '\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_light()     { printf '\033[0m\n\033[1;47;90m%64s\033[0m\n\033[1;47;90m %-63s\033[0m\n\033[1;47;90m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_dark()      { printf '\033[0m\n\033[1;40;37m%64s\033[0m\n\033[1;40;37m %-63s\033[0m\n\033[1;40;37m%64s\033[0m\n\n'    '' "$1" '' ; }

##################################################
### Help
##################################################

## Print this help (default)
help() {
    alert_primary 'TangoMan Shoe Entrypoint'
    echo_warning 'Infos:\n'
    echo_success 'author'  2 10; echo_primary '"Matthias Morin" <mat@tangoman.io>\n'
    echo_success 'version' 2 10; echo_primary '1.0.0-xxs\n'
    echo_success 'link'    2 10; echo_primary 'https://github.com/TangoMan75/shoe\n\n'
    echo_warning 'Description:\n'
    echo_primary 'Execute Dev and CI tasks.\n\n' 2 | fold -w 64 -s
    echo_warning 'Usage:\n'
    echo_info "sh $(basename "${0}") [" 2; echo_success 'command'; echo_info ']\n\n'
    _print_commands 10
}

_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v PADDING="$1" '/^### /{printf"\n\033[33m%s:\033[0m\n",substr($0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")  # ignore private functions
        printf "\033[32m  %-*s \033[0m%s\n", PADDING, FUNCTION, substr(PREV,4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

#--------------------------------------------------
# Reflexion
#--------------------------------------------------

_get_functions_names() {
    # Synopsis: _get_functions_names [script_path] (get_private default=false)
    if [ -z "$1" ]; then echo_danger 'error: _get_functions_names: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_functions_names: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (GET_PRIVATE == "true") {
            print FUNCTION
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print FUNCTION
        }
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Sytem
#--------------------------------------------------

# Return current project directory path, or "pwd" when installed globally
_pwd() {
    # Synopsis: _pwd

    if [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ]; then
        pwd
        return 0
    fi

    echo "$(dirname "$(realpath "$0")")"
}

#--------------------------------------------------
# shoe-sm main function with hooks
#--------------------------------------------------

_main() {
    # small version is optimized for performance, does not handle flags, options and validation.
    #
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [ ] options + validation
    #   - [ ] flags

    if [ ${#} -lt 1 ]; then help; exit 0; fi

    _execute=''
    for _argument in "$@"; do
        _is_valid=false
        for _function in $(_get_functions_names "$0"); do
            # get shorthand character
            _shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                # append argument to the execute stack
                _execute="${_execute} ${_function}"
                _is_valid=true
                break
            fi
        done
        # unknown parameters will raise errors
        if [ "${_is_valid}" = false ]; then
            printf "${DANGER}error: \"%s\" is not a valid command${EOL}" "${_argument}"
            exit 1
        fi
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for _function in ${_execute}; do
        eval "${_function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
