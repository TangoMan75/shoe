#!/bin/sh
set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework version 0.13.0-xxs
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
# * TangoMan Shoe XXS
# *
# * Create self documented shell scripts with argument validation
# * easily. Prefix a comment with two pound signs on the previous
# * line of any function or variable you want documented with the
# * "help" command.
# *
# * XXS version is optimized for performance,
# * does not handle flags, options, validation or docbloc parsing.
# *
# * Features:
# *   - [X] colors
# *   - [X] commands
# *   - [X] help
# *   - [ ] docbloc
# *   - [ ] parameters
# *   - [ ] validation
# *   - [ ] flags
# *   - [ ] install
# *   - [ ] autocomplete
# *   - [ ] generate_doc
# *
# * Warning: Functions names should not contain dashes.
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 0.13.0-xxs
# * @link    https://github.com/TangoMan75/shoe
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

WHO=World

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Say hello to the world
hello() {
    echo "Hello ${WHO} !"
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

## Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
_private() {
    echo "I'm private"
}

## Place here commands you need executed first every time (optional)
_before() {
    true
}

## Place here commands you need executed last every time (optional)
_after() {
    true
}

############################################################
# TangoMan Shoe Shell Microframework version 0.13.0-xxs
############################################################

#--------------------------------------------------
# A semantic set of colors functions
#--------------------------------------------------

# Synopsys: echo_* [string] (indentation) (padding)
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[97m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[94m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[32m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[31m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[33m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[95m%-*b\033[0m'    "$2" '' "$3" "$1" ; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[47;90m%-*b\033[0m' "$2" '' "$3" "$1" ; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b\033[40;37m%-*b\033[0m' "$2" '' "$3" "$1" ; }

# Synopsys: alert_* [string]
alert_primary()   { printf '\033[0m\n\033[1;104;97m%64s\033[0m\n\033[1;104;97m %-63s\033[0m\n\033[1;104;97m%64s\033[0m\n\n' '' "$1" '' ; }
alert_secondary() { printf '\033[0m\n\033[1;45;97m%64s\033[0m\n\033[1;45;97m %-63s\033[0m\n\033[1;45;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_success()   { printf '\033[0m\n\033[1;42;97m%64s\033[0m\n\033[1;42;97m %-63s\033[0m\n\033[1;42;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_danger()    { printf '\033[0m\n\033[1;41;97m%64s\033[0m\n\033[1;41;97m %-63s\033[0m\n\033[1;41;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_warning()   { printf '\033[0m\n\033[1;43;97m%64s\033[0m\n\033[1;43;97m %-63s\033[0m\n\033[1;43;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_info()      { printf '\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_light()     { printf '\033[0m\n\033[1;47;90m%64s\033[0m\n\033[1;47;90m %-63s\033[0m\n\033[1;47;90m%64s\033[0m\n\n'    '' "$1" '' ; }
alert_dark()      { printf '\033[0m\n\033[1;40;37m%64s\033[0m\n\033[1;40;37m %-63s\033[0m\n\033[1;40;37m%64s\033[0m\n\n'    '' "$1" '' ; }

#--------------------------------------------------
# Self documentation
#--------------------------------------------------

### Help

## Print this help (default)
help() {
    alert_primary 'TangoMan Shoe XXS'
    echo_warning 'Infos:\n'
    echo_success 'author'  2 10; echo_primary '"Matthias Morin" <mat@tangoman.io>\n'
    echo_success 'version' 2 10; echo_primary '0.13.0-xxs\n'
    echo_success 'link'    2 10; echo_primary 'https://github.com/TangoMan75/shoe\n\n'
    echo_warning 'Description:\n'
    echo_primary 'Create self documented shell scripts with argument validation easily. Prefix a comment with two pound signs on the previous line of any function or variable you want documented with the "help" command.\n\n' 2 | fold -w 64 -s
    echo_warning 'Usage:\n'
    echo_info "sh $(basename "${0}") [" 2; echo_success 'command'; echo_info ']\n\n'
    _print_commands
}

#--------------------------------------------------

_print_commands() {
    printf '\033[33mCommands:\033[0m\n'
    awk '/^### /{printf"\n\033[33m%s:\033[0m\n",substr($0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$","",FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "\033[32m  %-10s \033[0m%s\n", FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

#--------------------------------------------------
# Reflexion
#--------------------------------------------------

_get_functions_names() {
    if [ -z "$1" ]; then echo_danger 'error: some mandatory parameter is missing.\n'; return 1; fi
    # this regular expression matches functions with either bash or sh syntax
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");   # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0, 1, index($0, "{")); # truncate string after opening curly brace
        sub("{$", "", FUNCTION);                  # remove trailing curly brace
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_") print FUNCTION
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Main loop
#--------------------------------------------------

_main() {
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi

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
