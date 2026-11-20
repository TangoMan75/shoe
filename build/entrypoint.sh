#!/usr/bin/env sh

set -e

# This script is based on TangoMan Shoe Shell Microframework
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Source code is available here: https://github.com/TangoMan75/shoe

## TangoMan Entrypoint
##
## Execute Development and Continuous Integration tasks.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Recipe name to build /^~?[a-zA-Z0-9.\/_-]+$/
recipe=''

## Test directory /^~?[a-zA-Z0-9/._-]+$/
test_folder='./tests'

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Build given script from recipe
##
## @namespace recipes/entrypoint/app
## @requires chmod python3 rm true
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes recipe
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

    _echo_info "python3 shoemaker.py generate_doc --file \"build/${recipe}.sh\" --destination doc\n"
    python3 shoemaker.py generate_doc --file "build/${recipe}.sh" --destination doc

    _echo_info "python3 shoemaker.py generate_makefile --file \"build/${recipe}.sh\"\n"
    python3 shoemaker.py generate_makefile --file "build/${recipe}.sh"
}

## Build all scripts in recipes folder
##
## @namespace recipes/entrypoint/app
## @requires chmod find python3 rm sh true
## @depends src/shell/colors/_alert_info
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_pwd
build_all() {
    _echo_info 'rm -rf build || true\n'
    rm -rf build || true

    _alert_info 'Build all scripts from recipes folder'

    _echo_info 'rm -f build/*.sh || true\n'
    rm -f build/*.sh || true

    find "$(_pwd)/recipes" -type f -name '*.shoe' | while read -r file_path
    do
        _echo_info "python3 shoemaker.py build \"${file_path}\"\n"
        python3 shoemaker.py build "${file_path}"
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

## Sniff errors with linter
##
## @namespace recipes/entrypoint/app
## @requires find grep python3 shellcheck sort
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
lint() {
    _check_installed shellcheck
    _check_installed python3

    # `;&`, `;;&` and `;|` are Bash/ksh extensions, not POSIX.
    if grep -rn --include='*.sh' -- ';&\|;;&\|;|' ./src/shell; then
        _echo_error 'error: non-POSIX case terminators are forbidden in src/shell\n'

        return 1
    fi

    find ./src ./recipes -type f -name '*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck \"${FILE}\"\n"
        SHELLCHECK_OPTS='--exclude=SC2034,SC2154' shellcheck "${FILE}"
    done

    find ./build -type f -name '*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done

    _echo_info 'python3 shoemaker.py lint ./build ./recipes ./src\n'
    python3 shoemaker.py lint ./build ./recipes ./src
}

## Run tests
##
## @namespace recipes/entrypoint/app
## @requires bash_unit find sort
## @depends src/shell/colors/_echo_info
## @assumes test_folder
tests() {
    find "${test_folder}" -type f -name 'test_*.sh' | LC_ALL=C sort | while read -r FILE
    do
        _echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

## Install bash_unit framework
##
## @namespace recipes/entrypoint/app
## @requires cat chmod curl mkdir wget
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
bash_unit() {
    if [ ! -d ./tests ]; then
        mkdir -p ./tests

    cat > "./tests/test_sample.sh" <<EOF
#!/bin/bash
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
            _echo_info "wget -qO \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            wget -qO "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        elif [ -x "$(command -v curl)" ]; then
            _echo_info "curl -sSL -o \"./tests/bash_unit\" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit\n"
            curl -sSL -o "./tests/bash_unit" https://raw.githubusercontent.com/pgrange/bash_unit/master/bash_unit

        else
            _echo_error "could not find \"bash_unit\" executable, please install manually\n"
            exit 1
        fi
    fi

    if [ ! -x "./tests/bash_unit" ]; then
        _echo_info "chmod +x \"./tests\"/bash_unit\n"
        chmod +x ./tests/bash_unit
    fi
}

## Run script in Alpine Docker container
##
## @namespace recipes/entrypoint/app
## @requires docker pwd sh
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
alpine() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" alpine sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" alpine sh entrypoint.sh
}

## Run script in Busybox Docker container
##
## @namespace recipes/entrypoint/app
## @requires docker pwd sh
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
busybox() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

## Run script in Ubuntu Docker container
##
## @namespace recipes/entrypoint/app
## @requires docker pwd sh
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
ubuntu() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

###################################################
# TangoMan Shoe Shell Microframework
###################################################

#--------------------------------------------------
# Generated code : Do not edit below this line
#--------------------------------------------------

#--------------------------------------------------
#_ Colors
#--------------------------------------------------

## Print info alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_INFO _EOL
## @param {str} <STRING> (required) Text to display.
_alert_info()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

## Print primary alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_PRIMARY _EOL
## @param {str} <STRING> (required) Text to display.
_alert_primary()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" ''
}

## bold white text over bright blue background
_ALERT_PRIMARY='\033[1;104;97m'

## bold white text over bright purple background
_ALERT_SECONDARY='\033[1;45;97m'

## bold white text over bright green background
_ALERT_SUCCESS='\033[1;42;97m'

## bold white text over bright red background
_ALERT_DANGER='\033[1;41;97m'

## bold white text over bright orange background
_ALERT_WARNING='\033[1;43;97m'

## bold white text over blue background
_ALERT_INFO='\033[1;44;97m'

## bold white text over dark gray background
_ALERT_MUTED='\033[1;100;97m'

## bold dark gray text over light gray background
_ALERT_LIGHT='\033[1;47;90m'

## bold white text over black background
_ALERT_DARK='\033[1;40;37m'

## bright white text
_PRIMARY='\033[97m'

## bright blue text
_SECONDARY='\033[94m'

## bright green text
_SUCCESS='\033[32m'

## red text
_DANGER='\033[31m'

## orange text
_WARNING='\033[33m'

## bright purple text
_INFO='\033[95m'

## gray text
_MUTED='\033[90m'

## light gray background with dark gray text
_LIGHT='\033[47;90m'

## black background with light gray text
_DARK='\033[40;37m'

## reset formatting
_DEFAULT='\033[0m'

## reset formatting and carriage return
_EOL='\033[0m\n'

## Print error message to STDERR, prefixed with "error: "
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DANGER _DEFAULT
## @param {str} <MESSAGE> (required) Error message to display.
_echo_error() {
    printf "${_DANGER}error: %b${_DEFAULT}" "$1" >&2
}

## Print info text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _INFO
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_info() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_INFO}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print primary text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _PRIMARY
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_primary() {
    # Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    # this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_PRIMARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print success text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _SUCCESS
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_success() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SUCCESS}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print warning text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _WARNING
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_warning() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_WARNING}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

##################################################
### Help
##################################################

## Print help for a shoe script or one of its commands
##
## @namespace src/shell/help
## @requires realpath
## @depends src/shell/colors/_alert_primary
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/help/_print_command_details
## @depends src/shell/help/_print_commands
## @depends src/shell/help/_print_constants
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_infos
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_constants
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_options
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_function_shoedoc
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> The command name to get detailed help for.
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    if [ -z "$2" ]; then
        __padding__=$(_get_padding "$1")
        __annotations__=$(_get_script_shoedoc "$1")

        _alert_primary "$(_get_shoedoc_title "${__annotations__}")"

        _print_infos "$1"
        _print_description "$(_get_shoedoc_description "${__annotations__}")"
        _print_usage "$1"

        if [ -n "$(_get_constants "$1")" ]; then
            _print_constants "$1" "${__padding__}"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            _print_flags "$1" "${__padding__}"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            _print_options "$1" "${__padding__}"
        fi

        _print_commands "$1" "${__padding__}"
        exit 0
    fi

    _alert_primary "$2"
    __annotations__="$(_get_function_shoedoc "$1" "$2")"
    if [ -n "${__annotations__}" ]; then
        _print_command_details "$1" "$2" "${__annotations__}"
        exit 0
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

## Print this help
##
## @namespace src/shell/help
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @param {str} <COMMAND_NAME> The command name to print detailed help for.
help() {
    if [ $# -gt 1 ]; then _echo_error "help: too many arguments ($#)\n"; return 1; fi

    _help "$0" "$1"
}

## Print detailed help for a given command
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_warning
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> (required) The command name to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
_print_command_details() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_print_command_details: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_command_details: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_command_details: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "$3"

    _echo_primary "$(_get_shoedoc_title "$3")\n\n"

    __description__=$(_get_shoedoc_description "$3")
    if [ -n "${__description__}" ]; then
        _print_description "${__description__}"
    fi

    _print_usage "$1" "$2"

    __examples__=$(_get_shoedoc_tag "$3" 'example')
    if [ -n "${__examples__}" ]; then
        _echo_warning 'Examples:\n'
        _echo_primary "${__examples__}\n" 2
        printf '\n'
    fi

    __assumes__=$(_get_shoedoc_tag "$3" 'assumes')
    if [ -n "${__assumes__}" ]; then
        _echo_warning 'Assumes:\n'
        _echo_primary "${__assumes__}\n" 2
        printf '\n'
    fi

    __stdin__=$(_get_shoedoc_tag "$3" 'stdin')
    if [ -n "${__stdin__}" ]; then
        _echo_warning 'Stdin:\n'
        _echo_primary "${__stdin__}\n" 2
        printf '\n'
    fi

    __stdout__=$(_get_shoedoc_tag "$3" 'stdout')
    if [ -n "${__stdout__}" ]; then
        _echo_warning 'Stdout:\n'
        _echo_primary "${__stdout__}\n" 2
        printf '\n'
    fi

    __padding__=$(_get_padding "$1")

    _print_flags "$1" "${__padding__}" "$2"
    _print_options "$1" "${__padding__}" "$2"
}

## List commands of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_warning
## @assumes _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_commands() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_commands: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_commands: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"

    _echo_warning 'Commands:\n'
    awk -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" \
    '/^### /{printf"\n%s%s:%s\n",WARNING,substr($0,5),PRIMARY}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_") # ignore private functions
        printf "%s  %-'"$2"'s %s%s\n",SUCCESS,function_name,PRIMARY,annotation;
    } !/^## */{annotation=""}' "$1"
    printf '\n'

}

## List constants of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_warning
## @assumes _EOL _INFO _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_constants() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"

    _echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" -v INFO="${_INFO}" -v WARNING="${_WARNING}" -v EOL="${_EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(FIRST,4),INFO,WARNING,$2,INFO,EOL
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0,4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
        } else if (substr($0,1,3) == "## ") {
            if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
        } else {
            FIRST = ""
        }
        PREV = $0
    }' "$1"
    printf '\n'
}

## Print provided text formatted as a description (used by "help" command)
##
## @namespace src/shell/help
## @requires fold printf
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_warning
## @param {str} <DESCRIPTION> (required) A string containing script description.
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

## List flags of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_function_parameters
## @assumes _PRIMARY _SUCCESS
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose flags should be added.
_print_flags() {
    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"

    __separator__=$(printf '\037')
    __global_flags__=$(_get_flags "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_flags__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^flag${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  -%s, --%-'"$2"'s %s%s\n",SUCCESS,substr($1,1,1),$1,PRIMARY,substr(FIRST,4)
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0, 4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
        } else if (substr($0, 1, 3) == "## ") {
            if (substr($0, 1, 4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
        } else {
            FIRST = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'flag' ]; then
                continue
            fi
            case " ${__global_flags__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __short__="${__short__:-${__name__%"${__name__#?}"}}"
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  -%s, --%-*s' "${__short__}" "$2" "${__long__}")"
            _echo_primary " ${__description__}\n"
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

## Print infos of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @param {file} <FILE_PATH> (required) The path to the input file.
_print_infos() {
    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    __annotations__=$(_get_script_shoedoc "$1")

    _echo_warning 'Infos:\n'
    _echo_success 'author'  2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    _echo_success 'version' 2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    _echo_success 'link'    2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

## List options of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/reflexion/_get_options
## @assumes _DEFAULT _EOL _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose options should be added.
_print_options() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"

    __separator__=$(printf '\037')
    __global_options__=$(_get_options "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_options__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^option${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v INFO="${_INFO}" -v DEFAULT="${_DEFAULT}" -v EOL="${_EOL}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(FIRST,RSTART,RLENGTH);
                ANNOTATION=substr(FIRST,4,length(FIRST)-length(CONSTRAINT)-3);
            } else {
                ANNOTATION=substr(FIRST,4);
            }
            if (CONSTRAINT != "") {
                printf "%s  -%s, --%-'"$2"'s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,substr($1,1,1),$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                printf "%s  -%s, --%-'"$2"'s %s%s%s (default: %s%s%s)%s",SUCCESS,substr($1,1,1),$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0,4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
            if (CONSTRAINT == "" && match($0, / \/[^\/]+\/[a-z]*/)) {
                CONSTRAINT = " " substr($0, RSTART + 1, RLENGTH - 1)
            }
        } else if (substr($0,1,3) == "## ") {
            if ($0 ~ /^## @constraint([ \t]|$)/) {
                CONSTRAINT=substr($0,4);
                sub(/^@constraint[ \t]*/, "", CONSTRAINT);
                CONSTRAINT=" " CONSTRAINT;
            } else if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) {
                FIRST = $0
            }
        } else {
            FIRST = ""
            CONSTRAINT = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'option' ]; then
                continue
            fi
            case " ${__global_options__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __short__="${__short__:-${__name__%"${__name__#?}"}}"
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  -%s, --%-*s' "${__short__}" "$2" "${__long__}")"
            _echo_primary "${__description__}"
            if [ -n "${__constraint__}" ]; then
                _echo_success "  ${__constraint__}"
            fi
            if [ -n "${__default__}" ]; then
                _echo_info " (default: ${__default__})"
            fi
            printf '\n'
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

## Print usage of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk basename realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/reflexion/_get_options
## @assumes _DEFAULT _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> Optional command whose parameters should be added.
_print_usage() {
    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-}"

    _echo_warning 'Usage:\n'
    if [ -z "$2" ]; then
        _echo_info "sh $(basename "$1") <" 2
        _echo_success 'command'
        _echo_info '> '
    else
        _echo_info "sh $(basename "$1") " 2
        _echo_success "$2"
        _echo_info ' '
    fi
    # options
    awk -F '=' -v INFO="${_INFO}" -v SUCCESS="${_SUCCESS}" -v WARNING="${_WARNING}" -v DEFAULT="${_DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s-%s|--%s%s]%s ",INFO,SUCCESS,substr($1,1,1),$1,INFO,DEFAULT;next}
        printf "%s[%s-%s|--%s %s%s%s]%s ",INFO,SUCCESS,substr($1,1,1),$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0}' "$1"

    if [ -n "$2" ]; then
        __separator__=$(printf '\037')
        __global_parameters__="$(_get_flags "$1") $(_get_options "$1")"
        __records__=$(_get_function_parameters "$1" "$2")

        if [ -n "${__records__}" ]; then
            while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
                  __long__ __constraint__ __default__ __description__; do
                case " ${__global_parameters__} " in
                    *" ${__name__} "*)
                        continue
                        ;;
                esac
                if [ "${__kind__}" = 'param' ]; then
                    _echo_info '<'
                    _echo_success "${__name__}"
                    _echo_info '> '

                    continue
                fi

                __short__="${__short__:-${__name__%"${__name__#?}"}}"
                __long__="${__long__:-${__name__}}"

                _echo_info '['
                _echo_success "-${__short__}|--${__long__}"
                if [ "${__kind__}" = 'option' ]; then
                    if [ -n "${__default__}" ]; then
                        _echo_warning " ${__default__}"
                    else
                        _echo_warning ' VALUE'
                    fi
                fi
                _echo_info '] '
            done <<EOF
${__records__}
EOF
        fi
    fi

    printf '\n\n'
}

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

## Place here commands you need executed last every time (optional)
##
## @namespace src/shell/hooks
_after() {
    return 0
}

## Place here commands you need executed first every time (optional)
##
## @namespace src/shell/hooks
## @requires awk sed
## @depends src/shell/system/_check_installed
_before() {
    _check_installed awk
    _check_installed sed
}

## Place here commands you need executed by default (optional)
##
## @namespace src/shell/hooks
## @depends src/shell/help/help
_default() {
    help ''
}

## List constants from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private constants as well.
_get_constants() {
    if [ -z "$1" ]; then _echo_error '_get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    awk -F '=' -v GET_PRIVATE="$2" \
    '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

## Get constaint for given variable from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <VARIABLE_NAME> (required) The variable to validate.
_get_constraint() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v NAME="$2" '
    function trim(value) {
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        return value
    }

    /^## / {
        body = substr($0, 4)
        if (body ~ /^@constraint([ \t]|$)/) {
            sub(/^@constraint[ \t]*/, "", body)
            CONSTRAINT = trim(body)
        } else if (body ~ /^@(variable|option|constant)[ \t]/) {
            if (match(body, /\/.+\//)) {
                if (CONSTRAINT == "") {
                    CONSTRAINT = substr(body, RSTART, RLENGTH)
                }
            } else if (TITLE == "") {
                TITLE = body
            }
        } else if (TITLE == "" && substr(body, 1, 1) != "@") {
            TITLE = body
        }
        next
    }

    $0 == "##" { next }

    /^[a-zA-Z0-9_]+=.+$/ {
        if ($1 == NAME) {
            if (CONSTRAINT != "") { print CONSTRAINT; exit }
            if (TITLE != "" && match(TITLE, /\/.+\//)) {
                print substr(TITLE, RSTART, RLENGTH); exit
            }
        }
        TITLE = ""
        CONSTRAINT = ""
        next
    }

    { TITLE = ""; CONSTRAINT = "" }
    ' "$1"
}

## List flags from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_flags() {
    if [ -z "$1" ]; then _echo_error '_get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
    } {PREV = $0}' "$1"
}

## List parameters, options and flags declared in a function shoedoc annotation
##
## Outputs one record per entry with fields separated by the ASCII unit
## separator: kind, name, short alias, long alias, constraint, default
## value and description. Parameters are emitted in declaration order, so
## their position is implied by the order of their records.
##
## @namespace src/shell/reflexion
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/shoedoc/_get_function_shoedoc
## @stdout one record per option or flag, fields separated by ASCII 31.
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to inspect.
_get_function_parameters() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_parameters: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_parameters: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_parameters: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    printf '%s\n' "$(_get_function_shoedoc "$1" "$2")" | awk '
        BEGIN {
            separator = sprintf("%c", 31)
        }

        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        function emit(kind, value,    type, name, short, long_name,
                      constraint, default_value, stop, position, aliases,
                      parts, count, i, token) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            default_value = ""

            if (substr(value, 1, 1) == "{") {
                stop = index(value, "}")
                if (stop > 0) {
                    type = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }

            if (substr(value, 1, 1) == "<") {
                stop = index(value, ">")
                if (stop > 0) {
                    name = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }
            if (name == "")
                return

            if (substr(value, 1, 1) == "[") {
                stop = index(value, "]")
                if (stop > 0) {
                    aliases = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                    count = split(aliases, parts, "|")
                    for (i = 1; i <= count; i++) {
                        token = trim(parts[i])
                        if (substr(token, 1, 2) == "--")
                            long_name = substr(token, 3)
                        else if (substr(token, 1, 1) == "-")
                            short = substr(token, 2)
                        else if (long_name == "")
                            long_name = token
                    }
                }
            }

            if ((kind == "option" || kind == "param") \
                && substr(value, 1, 1) == "/") {
                position = index(value, " ")
                if (position == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, position - 1)
                    value = trim(substr(value, position + 1))
                }
            }

            if ((kind == "option" || kind == "param") \
                && substr(value, 1, 1) == "(") {
                stop = index(value, ")")
                if (stop > 0) {
                    token = trim(substr(value, 2, stop - 2))
                    value = trim(substr(value, stop + 1))
                    if (substr(token, 1, 8) == "default:")
                        default_value = substr(token, 9)
                }
            }

            printf "%s%s%s%s%s%s%s%s%s%s%s%s%s\n", kind, separator,
                name, separator, short, separator, long_name, separator,
                constraint, separator, default_value, separator, value
        }

        {
            line = $0
            sub(/^##[ \t]?/, "", line)
            line = trim(line)
            if (line ~ /^@param[ \t]/) {
                sub(/^@param[ \t]+/, "", line)
                emit("param", line)
            } else if (line ~ /^@option[ \t]/) {
                sub(/^@option[ \t]+/, "", line)
                emit("option", line)
            } else if (line ~ /^@flag[ \t]/) {
                sub(/^@flag[ \t]+/, "", line)
                emit("flag", line)
            }
        }
    '
}

## List functions names from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private functions as well.
_get_functions_names() {
    if [ -z "$1" ]; then _echo_error '_get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_functions_names: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" \
    '/^(function +)?[a-zA-Z0-9_]+ *\(\)/ {          # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (GET_PRIVATE == "true") {
            print function_name
        } else {
            if (substr($0,1,1) != "_") print function_name
        }
    } {PREV = $0}' "$1"
}

## List options from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE_ONLY> (default:false) If set to "true", retrieves private options only.
_get_options() {
    if [ -z "$1" ]; then _echo_error '_get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    awk -F '=' -v GET_PRIVATE_ONLY="$2" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE_ONLY == "true") {
            if ($1 != toupper($1) && $2 != "false" && substr($1,1,1) == "_") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($1,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

## Guess padding length from longest constant, option, flag or command of the provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_padding() {
    if [ -z "$1" ]; then _echo_error '_get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_padding: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_padding: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk -F '=' '
        /^[a-zA-Z0-9_]+=.+$/ { MATCH=$1 }       # matches constants, options and flags
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {   # matches a function (ignoring curly braces)
            MATCH=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
            sub("^function ","",MATCH);         # remove leading "function " if present
            gsub(" +","",MATCH);                # trim whitespaces
        } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
        {PREV = $0} END {print LENGTH}
    ' "$1"
}

## Get function shedoc annotation by name
##
## @namespace src/shell/shoedoc
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to retrieve.
_get_function_shoedoc() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    awk -v FUNCTION_NAME="$2" '
        /^##/ { annotation=annotation$0"\n" }                   # concatenates annotations
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {                   # matches a function (ignoring curly braces)
            function_name=substr($0,1,index($0,"(")-1);         # truncate string at opening round bracket
            sub("^function ","",function_name);                 # remove leading "function " if present
            gsub(" +","",function_name);                        # trim whitespaces
            if (function_name==FUNCTION_NAME) print annotation; # print annotation
        }
        !/^##/ { annotation="" }
    ' "$1"
}

## Get top-level shoedoc annotation of the provided shoe script file
##
## @namespace src/shell/shoedoc
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_script_shoedoc() {
    if [ -z "$1" ]; then _echo_error '_get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_script_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk '
        /^##/ { annotation=annotation$0"\n" }
        !/^##/ {
            if (annotation != "") {
                if ($0 == "") {
                    print annotation
                }
                exit
            }
        }
    ' "$1"
}

## Get shoedoc description
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc_description() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_description: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            count+=1;
            if (count==2 && RESULT=="") next;
            if (count>1) print RESULT
        }
    }'
}

## Return given tag values from shoedoc annotation
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
## @param {str} <TAG_NAME> (required) The name of tag to return.
_get_shoedoc_tag() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_shoedoc_tag: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_shoedoc_tag: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk -v TAG="$2" '/^## .*/ {
        if ($2=="@"TAG) {
            gsub(" +"," "); sub("^ +",""); sub(" +$",""); # trim input
            RESULT=substr($0,length($1)+length($2)+3);    # remove leading pound character(s)
            print RESULT
        }
    }'
}

## Get shoedoc title
##
## Returns the first line that does not contain a tag
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc_title() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_title: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

## Print error message if provided command is missing
##
## @namespace src/shell/system
## @requires basename
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_get_package_name
## @depends src/shell/system/_is_installed
## @terminal
## @param {str} <COMMAND> (required) A string containing the command name to find.
_check_installed() {
    if [ -z "$1" ]; then _echo_error '_check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_check_installed: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    _echo_error "\"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

## Find package name for given command
##
## @namespace src/shell/system
## @requires echo snap
## @depends src/shell/colors/_echo_error
## @param {str} <COMMAND> (required) A string containing the command name to find.
_get_package_name() {
    if [ -z "$1" ]; then _echo_error '_get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_package_name: too many arguments ($#)\n"; return 1; fi

    # debian packages
    if [ "$1" = aapt ];     then echo android-tools-adb;      return 0; fi
    if [ "$1" = adb ];      then echo android-tools-adb;      return 0; fi
    if [ "$1" = fastboot ]; then echo android-tools-fastboot; return 0; fi
    if [ "$1" = snap ];     then echo snapd;                  return 0; fi

    for __package__ in \
        ab \
        check_forensic \
        checkgid \
        fcgistarter \
        htcacheclean \
        htdbm \
        htdigest \
        htpasswd \
        httxt2dbm \
        logresolve \
        rotatelogs \
        split-logfile \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo apache2-utils

            return 0
        fi
    done

    for __package__ in \
        certutil \
        modutil \
        pk12util \
        shlibsign \
        signtool \
        ssltap \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo libnss3-tools

            return 0
        fi
    done

    for __package__ in \
        arp \
        ifconfig \
        ipmaddr \
        iptunnel \
        mii-tool \
        nameif \
        plipconfig \
        rarp \
        route \
        slattach \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo net-tools

            return 0
        fi
    done

    echo "$1"
}

## Check provided command is installed
##
## @namespace src/shell/system
## @requires dpkg grep
## @depends src/shell/colors/_echo_error
## @param {str} <COMMAND> (required) A string containing the command name to find.
_is_installed() {
    if [ -z "$1" ]; then _echo_error '_is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_installed: too many arguments ($#)\n"; return 1; fi

    if [ -x "$(command -v "$1")" ]; then

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x "/home/linuxbrew/.linuxbrew/bin/$1" ]; then

        return 0
    fi

    return 1
}

## Return current project directory realpath, or "pwd" when installed globally
##
## @namespace src/shell/system
## @requires dirname pwd realpath
## @assumes HOME
_pwd() {
    if [ "$(dirname "$(realpath "$0")")" = '/usr/bin' ] || [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ] || [ "$(dirname "$(realpath "$0")")" = "${HOME}/.local/bin" ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

## Exit with an error when a script defines a function more than once
##
## @namespace src/shell/validation
## @requires grep printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_functions_names
## @param {file} <SCRIPT_PATH> (required) The path to the script to inspect.
_check_duplicate_functions() {
    if [ -z "$1" ]; then _echo_error '_check_duplicate_functions: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_check_duplicate_functions: too many arguments ($#)\n"; return 1; fi

    __functions_names__=$(_get_functions_names "$1" 'true')

    for __function__ in ${__functions_names__}; do
        if [ "$(printf '%s' "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    return 0
}

## Checks if variable is valid given regex constraint
##
## The pattern is applied with POSIX extended regular expressions, as
## data (never as a command-line option), and every line of the value
## must match it in full.
##
## @namespace src/shell/validation
## @requires awk printf sed
## @depends src/shell/colors/_echo_error
## @param {str} <VALUE> (required) The string to be compared to regex pattern.
## @param {str} <PATTERN> (required) The regex parttern to apply.
_is_valid() {
    if [ $# -lt 2 ]; then _echo_error '_is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_valid: too many arguments ($#)\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # remove leading and ending forward slashes from regular expression,
    # including its optional trailing flags
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/[a-z]*$@@')"

    if ! printf '%s\n' "$1" | awk -v pattern="$2" '
        $0 !~ ("^(" pattern ")$") { invalid = 1 }
        END { exit invalid }
    '; then

        return 1
    fi

    return 0
}

## Find constraints and validates a variable
##
## @namespace src/shell/validation
## @requires cut printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_constraint
## @depends src/shell/validation/_is_valid
## @terminal
## @param {str} <VARIABLE> (required) The variable to validate in the followling format : variable_name=value.
## @param {str} <CONSTRAINT> Optional constraint, read from the script when omitted.
_validate() {
    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2-)" "${2:-$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")}"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

## Validate positional parameters against the function shoedoc
##
## Each positional value is matched with the parameter declared at the
## same position. Parameters without a constraint accept any value.
##
## @namespace src/shell/validation
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/validation/_validate
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The command being executed.
## @param {str} <POSITIONAL> The positional values to validate.
_validate_positionals() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_positionals: some mandatory parameter is missing\n'

        return 1
    fi

    __script__="$1"
    __function__="$2"
    shift 2

    __index__=0
    for __value__ in "$@"; do
        __index__=$((__index__ + 1))
        __record__=$(
            _get_function_parameters "${__script__}" "${__function__}" \
                | awk -F '\037' -v wanted="${__index__}" '
                    $1 == "param" {
                        count++
                        if (count == wanted) {
                            print $2 "\037" $5
                            exit
                        }
                    }
                '
        )
        if [ -z "${__record__}" ]; then continue; fi

        __name__="${__record__%%"$(printf '\037')"*}"
        __constraint__="${__record__#*"$(printf '\037')"}"
        if [ -z "${__constraint__}" ]; then continue; fi

        _validate "${__name__}=${__value__}" "${__constraint__}"
    done
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

## Shoe Default Kernel
##
## @namespace src/shell/kernel
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @depends src/shell/hooks/_after
## @depends src/shell/hooks/_before
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/reflexion/_get_options
## @depends src/shell/validation/_check_duplicate_functions
## @depends src/shell/validation/_validate
## @depends src/shell/validation/_validate_positionals
_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''
    # Execution plan: one record per command, fields separated by the
    # ASCII unit separator and records by the ASCII record separator.
    __record_separator__=$(printf '\036')
    __field_separator__=$(printf '\037')
    __plan__=''
    __flags__="$(_get_flags "$0")"
    __options__="$(_get_options "$0")"

    #--------------------------------------------------
    # Resolve flags, options and commands
    #--------------------------------------------------

    while [ $# -gt 0 ]; do
        __argument__="$1"
        shift

        # Command names never start with a dash.
        case "${__argument__}" in
            -*)
                # Flags never consume the following argument.
                for __parameter__ in ${__flags__}; do
                    __short__="${__parameter__%"${__parameter__#?}"}"
                    if [ "${__argument__}" = "--${__parameter__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        eval "${__parameter__}=true"
                        continue 2
                    fi
                done

                # Options consume the following argument as their value.
                for __parameter__ in ${__options__}; do
                    __short__="${__parameter__%"${__parameter__#?}"}"
                    if [ "${__argument__}" = "--${__parameter__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        if [ $# -eq 0 ]; then
                            _echo_error "\"--${__parameter__}\" requires value\n"
                            exit 1
                        fi
                        _validate "${__parameter__}=$1"
                        eval "${__parameter__}=\"\${1}\""
                        shift
                        continue 2
                    fi
                done

                _echo_error "\"${__argument__}\" is not a valid parameter\n"
                exit 1
                ;;
        esac

        # Every declared command starts a new execution record.
        for __function__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __plan__="${__plan__}${__record_separator__}${__function__}"
                continue 2
            fi
        done

        # Every other argument is a positional parameter of the command
        # resolved last. A positional before any command is an error.
        if [ -z "${__execution_stack__}" ]; then
            _echo_error "\"${__argument__}\" is not a valid command\n"
            exit 1
        fi
        __plan__="${__plan__}${__field_separator__}${__argument__}"
    done

    #--------------------------------------------------
    # Run hooks and dispatch resolved commands
    #--------------------------------------------------

    [ -n "$(command -v _before)" ] && _before

    # `help` takes precedence over every command around it.
    __function__=''
    for __argument__ in ${__execution_stack__}; do
        if [ "${__function__}" = 'help' ]; then
            _help "$0" "${__argument__}"
            exit 0
        fi
        __function__="${__argument__}"
    done

    if [ "${__function__}" = 'help' ]; then
        _help "$0" ''
        exit 0
    fi

    if [ -z "${__execution_stack__}" ]; then _default; exit 0; fi

    # Dispatch each command with its positional parameters. Word
    # splitting is intentional here, so pathname expansion is disabled.
    __old_ifs__="${IFS}"
    case "$-" in *f*) __noglob__='true' ;; *) __noglob__='false' ;; esac
    IFS="${__record_separator__}"
    for __record__ in ${__plan__}; do
        if [ -z "${__record__}" ]; then continue; fi
        IFS="${__field_separator__}"
        set -f
        # shellcheck disable=SC2086  # word splitting is intentional
        set -- ${__record__}
        [ "${__noglob__}" = 'true' ] || set +f
        IFS="${__old_ifs__}"
        __function__="$1"
        shift
        _validate_positionals "$0" "${__function__}" "$@"
        eval "${__function__} \"\$@\""
    done
    IFS="${__old_ifs__}"

    [ -n "$(command -v _after)" ] && _after
}

_kernel "$@"

