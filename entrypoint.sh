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

## Lint directory /^~?[a-zA-Z0-9/._-]+$/
lint_folder='./build'

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
## {
##   "namespace": "app",
##   "requires": [
##     "shoemaker.sh",
##     "chmod"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
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

## Build all scripts in recipes folder
##
## {
##   "namespace": "app",
##   "requires": [
##     "shoemaker.sh",
##     "chmod"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
build_all() {
    _echo_info 'rm -rf build || true\n'
    rm -rf build || true

    _echo_info 'sh shoemaker.sh build_all\n'
    sh shoemaker.sh build_all

    find ./build -type f | while read -r FILE
    do
        _echo_info "chmod 775 \"${FILE}\"\n"
        chmod 775 "${FILE}"
    done

    _echo_info 'rm -f doc/*.md || true\n'
    rm -f doc/*.md || true

    _echo_info 'sh shoemaker.sh generate_doc_all\n'
    sh shoemaker.sh generate_doc_all

    _echo_info 'sh shoemaker.sh generate_doc -p -f build/shoemaker.sh -d doc\n'
    sh shoemaker.sh generate_doc -p -f build/shoemaker.sh -d doc

    _echo_info 'sh shoemaker.sh generate_doc -p -f build/shoe.sh -d doc\n'
    sh shoemaker.sh generate_doc -p -f build/shoe.sh -d doc

    _echo_info 'sh shoemaker.sh generate_makefile_all\n'
    sh shoemaker.sh generate_makefile_all
}

## Replace shoemaker, entrypoint and Makefile in root directory
##
## {
##   "namespace": "app",
##   "requires": [
##     "cp"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
replace() {
    _echo_info 'cp build/shoemaker.sh .\n'
    cp build/shoemaker.sh .

    _echo_info 'cp build/entrypoint.sh .\n'
    cp build/entrypoint.sh .

    _echo_info 'cp build/shoemaker.makefile Makefile\n'
    cp build/shoemaker.makefile Makefile
}

## Sniff errors with linter
##
## {
##   "namespace": "app",
##   "requires": [
##     "shellcheck"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
lint() {
    _check_installed shellcheck

    find "${lint_folder}" -maxdepth 3 -type f -name '*.sh' ! -path './dump/*' ! -path './src/*' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "shellcheck \"${FILE}\"\n"
        shellcheck "${FILE}"
    done
}

## Run tests
##
## {
##   "namespace": "app",
##   "requires": [
##     "bash_unit"
##   ],
##   "depends": [
##     "_echo_info"
##   ]
## }
tests() {
    find "${test_folder}" -type f -name 'test_*.sh' | sort -t '\0' -n | while read -r FILE
    do
        _echo_info "./tests/bash_unit -f tap \"${FILE}\"\n"
        ./tests/bash_unit -f tap "${FILE}"
    done
}

## Install git hooks
##
## {
##   "namespace": "app",
##   "depends": [
##     "_git_hooks"
##   ]
## }
git_hooks() {
    _git_hooks
}

## Install bash_unit framework
##
## {
##   "namespace": "app",
##   "requires": [
##     "curl"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_error",
##     "_echo_info"
##   ]
## }
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
## {
##   "namespace": "app",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
alpine() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" alpine sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" alpine sh entrypoint.sh
}

## Run script in Busybox Docker container
##
## {
##   "namespace": "app",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
busybox() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" busybox sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" busybox sh entrypoint.sh
}

## Run script in Ubuntu Docker container
##
## {
##   "namespace": "app",
##   "requires": [
##     "docker"
##   ],
##   "depends": [
##     "_check_installed",
##     "_echo_info"
##   ]
## }
ubuntu() {
    _check_installed docker

    _echo_info "docker run -it --rm --volume=\"$(pwd):/home:ro\" --workdir=\"/home\" ubuntu sh entrypoint.sh\n"
    docker run -it --rm --volume="$(pwd):/home:ro" --workdir="/home" ubuntu sh entrypoint.sh
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

##################################################
### Help
##################################################

## Print this help
##
## {
##   "namespace": "help",
##   "depends": [
##     "_help"
##   ]
## }
help() {
    _help "$0"
}

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

## Place here commands you need executed by default (optional)
##
## {
##   "namespace": "hooks"
## }
_default() {
    help
}

## Place here commands you need executed first every time (optional)
##
## {
##   "namespace": "hooks"
## }
_before() {
    _check_installed awk
    _check_installed sed
}

## Place here commands you need executed last every time (optional)
##
## {
##   "namespace": "hooks"
## }
_after() {
    return 0
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

## shellcheck disable=SC2034

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

## light gray background with dark gray text
_LIGHT='\033[47;90m'

## black background with light gray text
_DARK='\033[40;37m'

## reset formatting
_DEFAULT='\033[0m'

## reset formatting and carriage return
_EOL='\033[0m\n'

## shellcheck disable=SC2034

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

## bold dark gray text over light gray background
_ALERT_LIGHT='\033[1;47;90m'

## bold white text over black background
_ALERT_DARK='\033[1;40;37m'

## Print primary text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_PRIMARY"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_primary() {
    # Synopsis: _echo_primary <STRING> [INDENTATION] [PADDING]
    #  STRING:      Text to display.
    #  INDENTATION: Indentation level (default: 0).
    #  PADDING:     Padding length (default: 0).
    #  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #               this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_PRIMARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print secondary text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_SECONDARY"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_secondary() {
    # Synopsis: _echo_secondary <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print success text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_SUCCESS"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_success() {
    # Synopsis: _echo_success <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SUCCESS}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print danger text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DANGER",
##     "_DEFAULT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_danger() {
    # Synopsis: _echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DANGER}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print warning text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_warning() {
    # Synopsis: _echo_warning <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_WARNING}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print info text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_INFO"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_info() {
    # Synopsis: _echo_info <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_INFO}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print light text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_LIGHT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_light() {
    # Synopsis: _echo_light <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_LIGHT}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print dark text with optional indentation and padding
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DEFAULT",
##     "_DARK"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "INDENTATION",
##       "type": "int",
##       "description": "Indentation level.",
##       "default": 0
##     },
##     {
##       "position": 3,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 0
##     }
##   ]
## }
_echo_dark() {
    # Synopsis: _echo_dark <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DARK}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print error message to STDERR, prefixed with "error: "
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_DANGER",
##     "_DEFAULT"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "MESSAGE",
##       "type": "str",
##       "description": "Error message to display.",
##       "nullable": false
##     }
##   ]
## }
_echo_error() {
    # Synopsis: _echo_error <MESSAGE>
    #   MESSAGE: Error message to display.

    printf "${_DANGER}error: %b${_DEFAULT}" "$1" >&2
}

## Print primary alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_PRIMARY",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_primary()   {
    # Synopsis: _alert_primary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" ''
}

## Print secondary alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_SECONDARY",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_secondary() {
    # Synopsis: _alert_secondary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}

## Print success alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_SUCCESS",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_success()   {
    # Synopsis: _alert_success <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}

## Print danger alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_DANGER",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_danger()    {
    # Synopsis: _alert_danger <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}

## Print warning alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_WARNING",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_warning()   {
    # Synopsis: _alert_warning <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" ''
}

## Print info alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_INFO",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_info()      {
    # Synopsis: _alert_info <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

## Print light alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_LIGHT",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_light()      {
    # Synopsis: _alert_light <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}

## Print dark alert
##
## {
##   "namespace": "colors",
##   "assumes": [
##     "_ALERT_DARK",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_dark()      {
    # Synopsis: _alert_dark <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}

#--------------------------------------------------
#_ Git
#--------------------------------------------------

## Update .git/hooks folder
##
## {
##   "namespace": "git",
##   "requires": [
##     "git"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SOURCE",
##       "type": "folder",
##       "description": "The source directory.",
##       "nullable": false
##     }
##   ]
## }
_git_hooks() {
    # Synopsis: _git_hooks <SOURCE>
    #   SOURCE: The source directory.

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_git_hooks: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_git_hooks: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "${1:-.githooks}")" '.git/hooks'
    if [ ! -d "$1" ]; then _echo_error "_git_hooks: \"$1\" folder not found\n"; return 1; fi

    _echo_info "rm -rf \"$2\"\n"
    rm -rf "$2"

    _echo_info "cp -r \"$1\" \"$2\"\n"
    cp -r "$1" "$2"

    _echo_info "chmod +x \"$2\"/*\n"
    chmod +x "$2"/*
}

#--------------------------------------------------
#_ Help
#--------------------------------------------------

## Print help for provider shoe script
##
## {
##   "namespace": "help",
##   "depends": [
##     "_alert_primary",
##     "_echo_error",
##     "_get_constants",
##     "_get_flags",
##     "_get_function_shoedoc",
##     "_get_options",
##     "_get_padding",
##     "_get_script_shoedoc",
##     "_get_shoedoc_description",
##     "_get_shoedoc_title",
##     "_print_commands",
##     "_print_constants",
##     "_print_description",
##     "_print_flags",
##     "_print_infos",
##     "_print_options",
##     "_print_synopsis",
##     "_print_usage"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "type": "str",
##       "description": "The function name to get help for.",
##     }
##   ]
## }
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH: The path to the input file.
    #   FUNCTION_NAME: The function name to get help for.

    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

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
    if [ -x "$(command -v jq)" ]; then
        __json__="$(_parse_shoedoc "$1" "$2")"
        if [ -n "${__json__}" ]; then
            _echo_primary "$(printf '%s' "${__json__}" | jq -r '.summary')\n\n"
            _echo_secondary "$(_print_synopsis "${__json__}")\n"
            exit 0
        fi
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

## List commands of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "PRIMARY",
##     "SUCCESS",
##     "WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 12
##     }
##   ]
## }
_print_commands() {
    # Synopsis: _print_commands <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_commands: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then _echo_error "_print_commands: \"$1\" file not found\n"; return 1; fi

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
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "EOL",
##     "INFO",
##     "PRIMARY",
##     "SUCCESS",
##     "WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 12
##     }
##   ]
## }
_print_constants() {
    # Synopsis: _print_constants <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" -v INFO="${_INFO}" -v WARNING="${_WARNING}" -v EOL="${_EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print provided text formatted as a description (used by "help" command)
##
## {
##   "namespace": "help",
##   "depends": [
##     "_echo_primary",
##     "_echo_warning"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "DESCRIPTION",
##       "type": "str",
##       "description": "A string containing script description.",
##       "nullable": false
##     }
##   ]
## }
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION: A string containing script description.

    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

## List flags of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "PRIMARY",
##     "SUCCESS"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 12
##     }
##   ]
## }
_print_flags() {
    # Synopsis: _print_flags <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-'"$2"'s %s%s\n",SUCCESS,$1,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print infos of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "depends": [
##     "_get_script_shoedoc",
##     "_get_shoedoc_tag",
##     "_echo_error",
##     "_echo_primary",
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     }
##   ]
## }
_print_infos() {
    # Synopsis: _print_infos <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

    __annotations__=$(_get_script_shoedoc "$1")

    _echo_warning 'Infos:\n'
    _echo_success 'author'  2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    _echo_success 'version' 2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    _echo_success 'link'    2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

## List options of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "DEFAULT",
##     "EOL",
##     "INFO",
##     "SUCCESS",
##     "WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 12
##     }
##   ]
## }
_print_options() {
    # Synopsis: _print_options <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    _echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v INFO="${_INFO}" -v DEFAULT="${_DEFAULT}" -v EOL="${_EOL}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (match(PREV,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(PREV,RSTART,RLENGTH);
                ANNOTATION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                printf "%s  --%-'"$2"'s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                ANNOTATION=substr(PREV,4);
                printf "%s  --%-'"$2"'s %s%s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print usage of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "DEFAULT",
##     "INFO",
##     "SUCCESS",
##     "WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     }
##   ]
## }
_print_usage() {
    # Synopsis: _print_usage <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Usage:\n'
    _echo_info "sh $(basename "$1") <" 2; _echo_success 'command'; _echo_info '> '
    # options
    awk -F '=' -v INFO="${_INFO}" -v SUCCESS="${_SUCCESS}" -v WARNING="${_WARNING}" -v DEFAULT="${_DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s--%s%s]%s ",INFO,SUCCESS,$1,INFO,DEFAULT;next}
        printf "%s[%s--%s %s%s%s]%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0} END {print "\n"}' "$1"
}

#--------------------------------------------------
#_ Reflexion
#--------------------------------------------------

## List constants from provided shoe script
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "GET_PRIVATE",
##       "type": "bool",
##       "description": "If set to \"true\", retrieves private constants as well.",
##       "default": false
##     }
##   ]
## }
_get_constants() {
    # Synopsis: _get_constants <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)

    if [ -z "$1" ]; then _echo_error '_get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constants: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_constants: \"$1\" file not found\n"; return 1; fi

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
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "VARIABLE_NAME",
##       "type": "str",
##       "description": "The variable to validate.",
##       "nullable": false
##     }
##   ]
## }
_get_constraint() {
    # Synopsis: _get_constraint <SCRIPT_PATH> <VARIABLE_NAME>
    #   SCRIPT_PATH:   The path to the input script.
    #   VARIABLE_NAME: The variable to validate.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v NAME="$2" \
    '/^## /{if (annotation=="") annotation=substr($0,4)}
    /^[a-zA-Z0-9_]+=.+$/ {
        if (annotation!="" && $1 == NAME) {
            match(annotation, /\/.+\//); print substr(annotation, RSTART, RLENGTH)
        }
    } !/^## */{annotation=""}' "$1"
}

## List flags from provided shoe script
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     }
##   ]
## }
_get_flags() {
    # Synopsis: _get_flags <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then _echo_error '_get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_flags: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_flags: \"$1\" file not found\n"; return 1; fi

    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
    } {PREV = $0}' "$1"
}

## Get function by name
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "type": "str",
##       "description": "The name of the function to retrieve.",
##       "nullable": false
##     }
##   ]
## }
_get_function() {
    # Synopsis: _get_function <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_function: \"$1\" file not found\n"; return 1; fi

    awk -v FUNCTION_NAME="$2" '
    function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }
    /^#/ { annotation=annotation"\n"$0 }
    in_function {
        print $0;
        count=count_occurrences($0,"{")-count_occurrences($0,"}");
        # count+=gsub("{","&")-gsub("}","&");
        if (count==0) exit
    }
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (function_name==FUNCTION_NAME) {
            if (annotation!="") print substr(annotation,2); # print annotation (without leading "\n")
            print $0;
            in_function=1;
            count=count_occurrences($0,"{")-count_occurrences($0,"}"); # count opened and closed curly braces on current line
            # count=gsub("{","&")-gsub("}","&"); # count opened and closed curly braces on current line
        }
    }
    !/^#/ { annotation="" }' "$1"
}

## List functions names from provided shoe script
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "GET_PRIVATE",
##       "type": "bool",
##       "description": "If set to \"true\", retrieves private functions as well.",
##       "default": false
##     }
##   ]
## }
_get_functions_names() {
    # Synopsis: _get_functions_names <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then _echo_error '_get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_functions_names: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

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
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "GET_PRIVATE_ONLY",
##       "type": "bool",
##       "description": "If set to \"true\", retrieves private options only.",
##       "default": false
##     }
##   ]
## }
_get_options() {
    # Synopsis: _get_options <SCRIPT_PATH> [GET_PRIVATE_ONLY]
    #   SCRIPT_PATH:      The path to the input script.
    #   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".

    if [ -z "$1" ]; then _echo_error '_get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_options: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_options: \"$1\" file not found\n"; return 1; fi

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
## {
##   "namespace": "reflexion",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     }
##   ]
## }
_get_padding() {
    # Synopsis: _get_padding <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then _echo_error '_get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_padding: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_padding: \"$1\" file not found\n"; return 1; fi

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

## Get value for given parameter from provided ".env" or ".sh" file
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "type": "str",
##       "description": "The variable name to get from provided file.",
##       "nullable": false
##     }
##   ]
## }
_get_parameter() {
    # Synopsys : _get_parameter <FILE_PATH> <KEY>
    #   FILE_PATH: The path to the input file.
    #   KEY:       The variable name to get from provided file.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_get_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    sed -n "s/^$2=\(.*\)/\1/p" "$1" | sed 's/^"//; s/"$//' # remove leading and trailing quotes
}

## Tests if parameter exists in provided ".env" or ".sh" file
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "type": "str",
##       "description": "The variable name to get from provided file.",
##       "nullable": false
##     }
##   ]
## }
_has_parameter() {
    # Synopsys : _has_parameter <FILE_PATH> <KEY>
    #   FILE_PATH: The path to the input file.
    #   KEY:       The variable name to get from provided file.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    grep -q "^${2}=" "$1"
}

## Print function synopsis from a JSON string.
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "jq"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "JSON",
##       "type": "json",
##       "description": "The input string containing raw JSON.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "MARKDOWN_FORMAT",
##       "type": "bool",
##       "description": "If set to \"true\", returns result as markdown.",
##       "default": false
##     }
##   ]
## }
_print_synopsis() {
    # Synopsis: _print_synopsis <JSON> [MARKDOWN_FORMAT]
    #   JSON: The input string containing raw JSON.
    #   MARKDOWN_FORMAT: (Optional) If set to 'true', returns result as markdown. Defaults to "false".

    if [ -z "$1" ]; then _echo_error '_print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_synopsis: too many arguments ($#)\n"; return 1; fi
    if ! printf '%s' "$1" | jq empty >/dev/null 2>&1; then _echo_error "_print_synopsis: invalid JSON input\n"; return 1; fi

    if [ "${2:-false}" = "true" ]; then
        printf '> Synopsis:\n> '
    else
        printf 'Synopsis: '
    fi

    printf '%s' "$1" | jq -rj '.name'

    if [ "${2:-false}" = "true" ]; then
        printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then " &lt;\(.name)&gt;" else " [\(.name)]" end] | join("")'
        printf '\n'
        printf '%s' "$1" | jq -r '.parameters // [] | .[] | "`\(.name)`: \(if .type then "_(type: \"\(.type)\")_ " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " _Defaults to \"\(.default|tostring)\"._" else "" end)"' | while read -r line; do
            printf '%s\n' "- ${line}"
        done
        printf '\n'
        printf '%s' "$1" | jq -rj '[.requires // [] | .[] | "`\(.)`"] | if length > 0 then "- ⚠️ Requires: \(.|join(", "))\n" else "" end'
        printf '%s' "$1" | jq -rj '[.depends // [] | .[] | "`\(.)`"] | if length > 0 then "- 🔗 Depends: \(.|join(", "))\n" else "" end'
        printf '\n'
        return 0
    fi

    printf '%s' "$1" | jq -rj 'if .scope then " (\(.scope)) " else "" end'
    printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then "<\(.name)>" else "[\(.name)]" end] | join(" ")'
    printf '\n'
    printf '%s' "$1" | jq -r '.parameters // [] | .[] | "\(.name): \(if .type then "(\(.type)) " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " Defaults to \"\(.default|tostring)\"." else "" end)"' | while read -r line; do
        printf '    %s\n' "${line}"
    done
    printf '%s' "$1" | jq -rj '[.requires // [] | .[]] | if length > 0 then "    Requires: \(.|join(", "))\n" else "" end'
    printf '%s' "$1" | jq -rj '[.depends // [] | .[]] | if length > 0 then "    Depends: \(.|join(", "))\n" else "" end'
    printf '\n'
}

## Set value for given parameter into provided file ".env" or ".sh" file
##
## {
##   "namespace": "reflexion",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_echo_warning",
##     "_has_parameter",
##     "_sed_i"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "KEY",
##       "type": "str",
##       "description": "The variable name to get from provided file.",
##       "nullable": false
##     },
##     {
##       "position": 3,
##       "name": "VALUE",
##       "type": "str",
##       "description": "The value to be set to provided file.",
##       "nullable": false
##     }
##   ]
## }
_set_parameter() {
    # Synopsys : _set_parameter <FILE_PATH> <KEY> <VALUE>
    #   FILE_PATH: The path to the input script.
    #   KEY:       The variable name to set to provided file
    #   VALUE:     The value to be set to provided file

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_set_parameter: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2" "$3"

    if ! _has_parameter "$1" "$2"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_parameter "$1" "$2")" = "$3" ]; then
        _echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    _echo_info "$(_sed_i) -E \"s/^$2=.*/$2=$3/\" \"$1\"\n"
    $(_sed_i) -E "s/^$2=.*/$2=$3/" "$1"
}

#--------------------------------------------------
#_ Shoedoc
#--------------------------------------------------

## Get function shedoc annotation by name
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "type": "str",
##       "description": "The name of the function to retrieve.",
##       "nullable": false
##     }
##   ]
## }
_get_function_shoedoc() {
    # Synopsis: _get_function_shoedoc <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_function_shoedoc: \"$1\" file not found\n"; return 1; fi

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
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     }
##   ]
## }
_get_script_shoedoc() {
    # Synopsis: _get_script_shoedoc <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then _echo_error '_get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_script_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

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

## Get shoedoc annotation
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "type": "str",
##       "description": "The input shoedoc annotation bloc.",
##       "nullable": false
##     }
##   ]
## }
_get_shoedoc() {
    # Synopsis: _get_shoedoc <TEXT>
    #   TEXT: The input shoedoc annotation bloc.
    #   note: Remove every line that does not start with a pound character or contains a tag
    #         Returns string without leading pound characters

    if [ -z "$1" ]; then _echo_error '_get_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT
        }
    }'
}

## Get shoedoc description
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "type": "str",
##       "description": "The input shoedoc annotation bloc.",
##       "nullable": false
##     }
##   ]
## }
_get_shoedoc_description() {
    # Synopsis: _get_shoedoc_description <TEXT>
    #   TEXT: The input shoedoc annotation bloc.

    if [ -z "$1" ]; then _echo_error '_get_shoedoc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_description: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            if (index($0, "{") > 0) exit;
            count+=1;
            if (count==2 && RESULT=="") next;
            if (count>1) print RESULT
        }
    }'
}

## Return given tag values from shoedoc annotation
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "type": "str",
##       "description": "The input shoedoc annotation bloc.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "TAG_NAME",
##       "type": "str",
##       "description": "The name of tag to return.",
##       "nullable": false
##     }
##   ]
## }
_get_shoedoc_tag() {
    # Synopsis: _get_shoedoc_tag <TEXT> <TAG_NAME>
    #   TEXT:     The input shoedoc annotation bloc.
    #   TAG_NAME: The name of tag to return.

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
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TEXT",
##       "type": "str",
##       "description": "The input shoedoc annotation bloc.",
##       "nullable": false
##     }
##   ]
## }
_get_shoedoc_title() {
    # Synopsis: _get_shoedoc_title <TEXT>
    #   TEXT: The input shoedoc annotation bloc.
    #   note: Returns the first line that does not contain a tag

    if [ -z "$1" ]; then _echo_error '_get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_title: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

## Return function shoedoc as json
##
## {
##   "namespace": "shoedoc",
##   "requires": [
##     "jq",
##     "sed"
##   ],
##   "depends": [
##     "_echo_error",
##     "_get_function_shoedoc"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "type": "str",
##       "description": "The name of the function to retrieve.",
##       "nullable": false
##     }
##   ]
## }
_parse_shoedoc() {
    # Synopsis: _parse_shoedoc <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_parse_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_parse_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_parse_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$1" "$2" "$(printf '%s' "$(_get_function_shoedoc "$1" "$2" | sed -nE 's/^ *#+ *//p')")"
    set -- "$1" "$2" "$3" "$(printf '%s' "$3" | sed -n '/^{/,$p')" "$(printf '%s' "$3" | head -n 1)"

    if [ "$(printf '%s' "$2" | cut -c1)" = "_" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" 'private'
    else
        set -- "$1" "$2" "$3" "$4" "$5" 'public'
    fi
    # $1: SCRIPT_PATH, $2: FUNCTION_NAME, $3: annotation, $4 json, $5: summary, $6: scope

    if [ -z "$4" ]; then
        jq --null-input \
            --arg name "$2" \
            --arg summary "$5" \
            --arg scope "$6" \
            '$ARGS.named'

        return 0
    fi

    jq --null-input \
    --arg name "$2" \
    --arg summary "$5" \
    --arg scope "$6" \
    '$ARGS.named + '"$4"
}

#--------------------------------------------------
#_ System
#--------------------------------------------------

## Print error message if provided command is missing
##
## {
##   "namespace": "system",
##   "depends": [
##     "_get_package_name",
##     "_is_installed",
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMAND",
##       "type": "str",
##       "description": "A string containing the command name to find.",
##       "nullable": false
##     }
##   ]
## }
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

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

## Check provided command is installed
##
## {
##   "namespace": "system",
##   "requires": [
##     "dpkg"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "COMMAND",
##       "type": "str",
##       "description": "A string containing the command name to find.",
##       "nullable": false
##     }
##   ]
## }
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

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
## {
##   "namespace": "system",
##   "returns": "str"
## }
_pwd() {
    # Synopsis: _pwd

    if [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

#--------------------------------------------------
#_ Validation
#--------------------------------------------------

## Checks if variable is valid given regex constraint
##
## {
##   "namespace": "validation",
##   "requires": [
##     "grep",
##     "sed"
##   ],
##   "depends": [
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "VALUE",
##       "type": "str",
##       "description": "The string to be compared to regex pattern.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "PATTERN",
##       "type": "str",
##       "description": "The regex parttern to apply.",
##       "nullable": false
##     }
##   ]
## }
_is_valid() {
    # Synopsis: _is_valid <VALUE> <PATTERN>
    #   VALUE:   The string to be compared to regex pattern.
    #   PATTERN: The regex parttern to apply.

    if [ $# -lt 2 ]; then _echo_error '_is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_valid: too many arguments ($#)\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # remove leading and ending forward slashes from regular expression
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/$@@')"

    # if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then
    if [ "$1" != "$(printf '%s' "$1" | grep -E "$2")" ]; then

        return 1
    fi

    return 0
}

## Find constraints and validates a variable
##
## {
##   "namespace": "validation",
##   "requires": [
##     "sed"
##   ],
##   "depends": [
##     "_get_constraint",
##     "_is_valid",
##     "_echo_error"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "VARIABLE",
##       "type": "str",
##       "description": "The variable to validate in the followling format : variable_name=value.",
##       "nullable": false
##     }
##   ]
## }
_validate() {
    # Synopsis: _validate <VARIABLE>
    #   VARIABLE: The variable to validate in the followling format : variable_name=value.

    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2)" "$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

## Shoe Kernel
##
## {
##   "namespace": "kernel",
##   "requires": [
##     "awk",
##     "grep"
##   ],
##   "depends": [
##     "_after",
##     "_before",
##     "_default",
##     "_echo_error",
##     "_get_flags",
##     "_get_functions_names",
##     "_get_options",
##     "_validate"
##   ]
## }
_kernel() {
    # Check for duplicate function definitions
    __functions_names__=$(_get_functions_names "$0" true)
    for __function__ in ${__functions_names__}; do
        if [ "$(printf "%s" "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''
    __requires_value__=''

    for __argument__ in "$@"; do
        __is_valid__=false

        # Handle required value for previous option
        if [ -n "${__requires_value__}" ]; then
            _validate "${__requires_value__}=${__argument__}"
            eval "${__requires_value__}=\"${__argument__}\";"
            __requires_value__=''
            continue
        fi

        # Check if argument is a flag or option (starts with - or --)
        if printf '%s' "${__argument__}" | grep -Eq '^--?[a-zA-Z0-9_]+$'; then
            for __type__ in flag option; do
                __parameters__="$(_get_flags "$0")"
                [ "$__type__" = 'option' ] && __parameters__="$(_get_options "$0")"
                for __parameter__ in $__parameters__; do
                    __shorthand__="$(printf '%s' "${__parameter__}" | awk '{print substr($0,1,1)}')"
                    if [ "${__argument__}" = "--${__parameter__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                        if [ "$__type__" = 'flag' ]; then
                            eval "${__parameter__}=true"
                        else
                            __requires_value__="${__parameter__}"
                        fi
                        __is_valid__=true
                        break 2
                    fi
                done
            done
            if [ "${__is_valid__}" = false ]; then
                _echo_error "\"${__argument__}\" is not a valid parameter\n"
                exit 1
            fi
            continue
        fi

        # Check if argument is a function name or its shorthand
        for __function__ in $(_get_functions_names "$0"); do
            __shorthand__="$(printf '%s' "${__function__}" | awk '{print substr($0,1,1)}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            _echo_error "\"${__argument__}\" is not a valid command\n"
            exit 1
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        _echo_error "\"--${__requires_value__}\" requires value\n"
        exit 1
    fi

    [ -n "$(command -v _before)" ] && _before

    if printf '%s' "${__execution_stack__}" | grep -qw 'help'; then
       _help "$0" "$(printf '%s' "${__execution_stack__}" | awk '{for(i=1;i<=NF;i++) if($i=="help") print $(i+1); exit}')"
       exit 0
    fi

    if [ -z "${__execution_stack__}" ]; then _default; exit 0; fi

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done

    [ -n "$(command -v _after)" ] && _after
}

_kernel "$@"

