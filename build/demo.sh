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

## TangoMan Shoe Demo
##
## Showcase the Shoe framework with a FizzBuzz sequence, a
## Fibonacci sequence, a color test and a Hello World command.
## Demonstrates global flags, command options, positional
## parameters, private helpers and generated help.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## @assumes NO_COLOR TERM

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Print additional details
##
## This is an example flag
## Any script-level variable set to "false" will convert to a flag at runtime
verbose=false

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

##################################################
### App
##################################################

## Hello World!
##
## Greets a specified recipient.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_echo_info.sh
## @assumes verbose
## @param {str} <recipient> /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
hello() {
    if [ "${verbose}" = true ]; then
        _echo_info "printf 'Hello, %s !\\\n' \"\${recipient}\"\n"
    fi

    printf 'Hello, %s !\n' "${recipient}"
}

## Color test
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_alert_danger.sh
## @depends src/shell/colors/_alert_dark.sh
## @depends src/shell/colors/_alert_info.sh
## @depends src/shell/colors/_alert_light.sh
## @depends src/shell/colors/_alert_muted.sh
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_alert_success.sh
## @depends src/shell/colors/_alert_warning.sh
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_dark.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_light.sh
## @depends src/shell/colors/_echo_muted.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_secondary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes _EOL verbose
colors() {
    if [ "${verbose}" = true ]; then
        _echo_warning 'verbose mode enabled\n'
    fi

    _alert_primary   '_alert_primary'
    _alert_secondary '_alert_secondary'
    _alert_success   '_alert_success'
    _alert_danger    '_alert_danger'
    _alert_warning   '_alert_warning'
    _alert_info      '_alert_info'
    _alert_muted     '_alert_muted'
    _alert_light     '_alert_light'
    _alert_dark      '_alert_dark'

    _echo_primary   '_echo_primary\n'
    _echo_secondary '_echo_secondary\n'
    _echo_success   '_echo_success\n'
    _echo_danger    '_echo_danger\n'
    _echo_warning   '_echo_warning\n'
    _echo_info      '_echo_info\n'
    _echo_muted     '_echo_muted\n'

    if [ "${verbose}" = true ]; then
        _echo_warning 'NOTE: If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line\n'
    fi

    _echo_light     "_echo_light${_EOL}"
    _echo_dark      "_echo_dark${_EOL}"

    _echo_error     '_echo_error\n'

    printf '\n'

    _alert_info '--- Standard 16 Colors ---'
    if [ "${verbose}" = true ]; then
        _echo_warning 'NOTE: This is the ANSI escape sequence for setting the background color.\n48 specifies background (use 38 for foreground text),\nand 5 indicates we are using the 256-color lookup table.\n'
    fi
    i=0
    while [ "$i" -le 15 ]; do
        printf '\033[48;5;%dm  %3d  \033[0m' "$i" "$i"

        if [ $(( (i + 1) % 8 )) -eq 0 ]; then
            printf '\n'
        fi
        i=$((i + 1))
    done

    printf '\n'

    _alert_info '--- 256 Color Palette ---'
    i=16
    while [ "$i" -le 255 ]; do
        printf '\033[48;5;%dm  %3d  \033[0m' "$i" "$i"

        if [ $(( (i - 15) % 6 )) -eq 0 ]; then
            printf ' '
        fi
        if [ $(( (i - 15) % 12 )) -eq 0 ]; then
            printf '\n'
        fi
        i=$((i + 1))
    done
}

## Print the FizzBuzz word for a given number
##
## Prints "FizzBuzz" for multiples of fifteen, "Fizz" for multiples of three,
## "Buzz" for multiples of five, and the number itself otherwise.
## This is an example of a private function
## Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
##
## @namespace recipes/demo/app
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @param {int} <NUMBER> (required) The number to convert.
_fizzbuzz() {
    if [ -z "$1" ]; then
        _echo_error '_fizzbuzz: some mandatory parameter is missing\n'
        return 1
    fi

    if [ $# -gt 1 ]; then
        _echo_error "_fizzbuzz: too many arguments ($#)\n"
        return 1
    fi

    if [ $(($1 % 15)) -eq 0 ]; then
        printf 'FizzBuzz'
    elif [ $(($1 % 3)) -eq 0 ]; then
        printf 'Fizz'
    elif [ $(($1 % 5)) -eq 0 ]; then
        printf 'Buzz'
    else
        printf '%d' "$1"
    fi
}

## Print the FizzBuzz sequence
##
## Prints the numbers from 1 to the configured limit.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends recipes/demo/app/_fizzbuzz.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes verbose
## @option {int} <limit> /^[1-9][0-9]?$/ (default:10) Last number to print.
## @flag <prefix> Prefix output with a line number.
fizzbuzz() {
    if [ $# -gt 1 ]; then
        _echo_error "fizzbuzz: too many arguments ($#)\n"
        return 1
    fi

    if [ "${verbose}" = true ]; then
        _echo_warning "Print the FizzBuzz sequence from \"0\" to \"${limit:-10}\"\n"
    fi

    counter=1

    while [ "${counter}" -le "${limit:-10}" ]; do
        fizzbuzz=$(_fizzbuzz "${counter}")
        if [ "${prefix:-false}" = true ]; then
            printf '%d: %s\n' "${counter}" "${fizzbuzz}"
        else
            printf '%s\n' "${fizzbuzz}"
        fi
        counter="$((counter + 1))"
    done
}

## Print the Fibonacci sequence
##
## Prints the first terms of the Fibonacci sequence.
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_echo_warning.sh
## @assumes verbose
## @option {int} <count> /^[1-9][0-9]?$/ (default:10) Number of terms to print.
fibonacci() {
    if [ "${verbose}" = true ]; then
        _echo_warning "Print the Fibonacci sequence from \"0\" to \"${count:-10}\"\n"
    fi

    current=0
    next=1
    i=0

    while [ "$i" -lt "${count:-10}" ]; do
        printf '%d\n' "${current}"

        current="${next}"
        next="$((current + next))"
        i="$((i + 1))"
    done
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

## Print danger alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_DANGER _EOL
## @param {str} <STRING> (required) Text to display.
_alert_danger()    {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}

## Print dark alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_DARK _EOL
## @param {str} <STRING> (required) Text to display.
_alert_dark()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}

## Print info alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_INFO _EOL
## @param {str} <STRING> (required) Text to display.
_alert_info()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

## Print light alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_LIGHT _EOL
## @param {str} <STRING> (required) Text to display.
_alert_light()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}

## Print muted alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_MUTED _EOL
## @param {str} <STRING> (required) Text to display.
_alert_muted()     {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_MUTED}" '' "${_ALERT_MUTED}" "$1" "${_ALERT_MUTED}" ''
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

## Print secondary alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_SECONDARY _EOL
## @param {str} <STRING> (required) Text to display.
_alert_secondary() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}

## Print success alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_SUCCESS _EOL
## @param {str} <STRING> (required) Text to display.
_alert_success()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}

## Print warning alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_WARNING _EOL
## @param {str} <STRING> (required) Text to display.
_alert_warning()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" ''
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

# Disable the colour constants when stdout is not a terminal, when TERM is
# "dumb", or when NO_COLOR is set. Sourced after the echo and alert constant
# files, so these empty assignments take effect.
if [ ! -t 1 ] || [ "${TERM:-}" = 'dumb' ] || [ -n "${NO_COLOR:-}" ]; then
    _ALERT_PRIMARY=''
    _ALERT_SECONDARY=''
    _ALERT_SUCCESS=''
    _ALERT_DANGER=''
    _ALERT_WARNING=''
    _ALERT_INFO=''
    _ALERT_MUTED=''
    _ALERT_LIGHT=''
    _ALERT_DARK=''
fi

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

# Disable the colour constants when stdout is not a terminal, when TERM is
# "dumb", or when NO_COLOR is set. Sourced after the echo and alert constant
# files, so these empty assignments take effect.
if [ ! -t 1 ] || [ "${TERM:-}" = 'dumb' ] || [ -n "${NO_COLOR:-}" ]; then
    _PRIMARY=''
    _SECONDARY=''
    _SUCCESS=''
    _DANGER=''
    _WARNING=''
    _INFO=''
    _MUTED=''
    _LIGHT=''
    _DARK=''
    _DEFAULT=''
    _EOL='\n'
fi

## Print danger text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DANGER _DEFAULT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_danger() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DANGER}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print dark text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DARK _DEFAULT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_dark() {
    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DARK}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

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

## Print light text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _LIGHT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_light() {
    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_LIGHT}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print muted text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _MUTED
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_muted() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_MUTED}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
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

## Print secondary text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _SECONDARY
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_secondary() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
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

## Edit a file in place with the system sed
##
## BSD sed (macOS) requires an empty backup suffix after "-i", GNU sed
## does not. Both forms are supported here.
##
## @namespace src/shell/compatibility
## @requires command sed uname
## @depends src/shell/colors/_echo_error.sh
## @param {str} <EXPRESSION> (required) The sed expression.
## @param {file} <FILE_PATH> (required) The file to edit.
_sed_i() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_sed_i: some mandatory parameter is missing\n'

        return 1
    fi
    if [ $# -gt 2 ]; then
        _echo_error "_sed_i: too many arguments ($#)\n"

        return 1
    fi
    if [ ! -f "$2" ]; then
        _echo_error "_sed_i: \"$2\" file not found\n"

        return 1
    fi

    if [ "$(uname)" = 'Darwin' ] \
        && [ -n "$(command -v sed)" ] \
        && [ -z "$(sed --version 2>/dev/null)" ]; then
        sed -i '' -e "$1" "$2"

        return $?
    fi

    sed -i -e "$1" "$2"
}

##################################################
### Documentation
##################################################

## Generate Markdown documentation for provided shoe script
##
## @namespace src/shell/documentation
## @requires awk basename dirname false printf realpath sed true
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/reflexion/_get_constants.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @depends src/shell/reflexion/_get_options.sh
## @depends src/shell/reflexion/_print_synopsis.sh
## @depends src/shell/shoedoc/_get_function_shoedoc.sh
## @depends src/shell/shoedoc/_get_script_shoedoc.sh
## @depends src/shell/shoedoc/_get_shoedoc_description.sh
## @depends src/shell/shoedoc/_get_shoedoc_tag.sh
## @depends src/shell/shoedoc/_get_shoedoc_title.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the documentation file. Defaults to "<BASENAME>.md".
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", documents private constants, options, flags, and commands as well.
_generate_doc() {
    if [ -z "$1" ]; then _echo_error '_generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_generate_doc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ -n "$2" ] && [ ! -d "$2" ]; then _echo_error "_generate_doc: \"$2\" folder not found\n"; return 1; fi

    # set default values
    set -- "$(realpath -- "$1")" "${2:-"$(realpath -- "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"

    # check valid input file type
    case "$1" in
        *.sh) ;;
        *) _echo_error '_generate_doc: file should be type ".sh"\n'; return 1 ;;
    esac

    _alert_primary "Generating $3"

    (
        __annotations__=$(_get_script_shoedoc "$1")

        printf '%s\n===\n\n' "$(_get_shoedoc_title "${__annotations__}")"

        printf '## ℹ️ Infos\n\n'
        # \055 is escape code for dash character within printf
        printf '\055 author:  %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'author')"
        printf '\055 version: %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'version')"
        printf '\055 link:    %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'link' )"
        printf '\n\n'

        printf '## 📑 Description\n\n'
        printf '%s\n\n' "$(_get_shoedoc_description "${__annotations__}")"

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
            if ($2 == "false") {printf "(--%s) ",$1;next}
            printf "(--%s %s) ",$1,$2
        } {PREV = $0}' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -F '=' -v GET_PRIVATE="$4" \
            '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                PRIVATE = "";
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_") PRIVATE = " (private)";
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,TITLE,$2
            } {
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
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`%s` (private)**\n> %s\n  - 🚩 Default: _%s_\n\n",++i,$1,TITLE,$2
            } {
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
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,TITLE
            } {
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
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(FIRST,RSTART+1,RLENGTH-1);
                    DESCRIPTION=substr(FIRST,4,RSTART-4);
                } else {
                    DESCRIPTION=substr(FIRST,4);
                }
                if (CONSTRAINT != "") {
                    printf "%d. **`--%s`**\n> %s\n  - 🧩 Constraint: `%s`\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`--%s`**\n> %s\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,$2
                }
                printf "\n\n"
            } {
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
                        CONSTRAINT = substr($0, RSTART + 1, RLENGTH - 1)
                    }
                } else if (substr($0,1,3) == "## ") {
                    body = substr($0,4);
                    if (body ~ /^@constraint([ \t]|$)/) {
                        sub(/^@constraint[ \t]*/, "", body);
                        sub(/[ \t]+$/, "", body);
                        CONSTRAINT = body
                    } else if (substr(body,1,1) != "@") {
                        if (FIRST == "" || FIRST == "##") FIRST = $0
                    }
                } else {
                    FIRST = ""
                    CONSTRAINT = ""
                }
                PREV = $0
            }' "$1"
        fi
    ) > "$2/$3"

    printf '## 🤖 Commands\n\n' >> "$2/$3"

    __index__=0
    __current_namespace__=''

    for __function_name__ in $(_get_functions_names "$1" true); do
        _echo_info "${__function_name__}\n"

        __annotations__="$(_get_function_shoedoc "$1" "${__function_name__}")"
        if [ -z "${__annotations__}" ]; then
            _echo_error "_generate_doc: no annotation found for function \"${__function_name__}\"\n"
            continue
        fi

        if [ "$4" = false ] && [ "${__function_name__#_}" != "${__function_name__}" ]; then
            continue
        fi

        __namespace__="$(_get_shoedoc_tag "${__annotations__}" 'namespace')"
        if [ -n "${__namespace__}" ] && [ "${__namespace__}" != "${__current_namespace__}" ]; then
            __index__=0
            __current_namespace__="${__namespace__}"
            printf '### ⚡ %s\n\n' "$(printf '%s' "${__namespace__}" | awk '{print toupper($0)}')" >> "$2/$3"
        fi

        __index__=$((__index__ + 1))
        __scope__='public'
        case "${__function_name__}" in
            _*) __scope__='private' ;;
        esac

        (
            # shellcheck disable=SC2016
            printf '#### ⌨️ %d. `%s` %s\n\n' "${__index__}" "${__function_name__}" "(${__scope__})"
            printf '%s\n\n' "$(_get_shoedoc_title "${__annotations__}")"
            # shellcheck disable=SC2016
            printf '%s\n\n' "$(_print_synopsis "${__function_name__}" "${__annotations__}" true)"
        ) >> "$2/$3"
    done

    _echo_success "Documentation generated : \"$2/$3\"\n"
}

## Generate Markdown documentation for current shoe script
##
## @namespace src/shell/documentation
## @depends src/shell/documentation/_generate_doc.sh
generate_doc() {
    _generate_doc "$0"
}

##################################################
### Help
##################################################

## Print help for a shoe script or one of its commands
##
## @namespace src/shell/help
## @requires realpath
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/help/_print_command_details.sh
## @depends src/shell/help/_print_commands.sh
## @depends src/shell/help/_print_constants.sh
## @depends src/shell/help/_print_description.sh
## @depends src/shell/help/_print_flags.sh
## @depends src/shell/help/_print_infos.sh
## @depends src/shell/help/_print_options.sh
## @depends src/shell/help/_print_usage.sh
## @depends src/shell/reflexion/_get_constants.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_options.sh
## @depends src/shell/reflexion/_get_padding.sh
## @depends src/shell/shoedoc/_get_function_shoedoc.sh
## @depends src/shell/shoedoc/_get_script_shoedoc.sh
## @depends src/shell/shoedoc/_get_shoedoc_description.sh
## @depends src/shell/shoedoc/_get_shoedoc_title.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> The command name to get detailed help for.
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

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
    _echo_error "no documentation found for command \"$2\"\n"

    return 1
}

## Print this help
##
## @namespace src/shell/help
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/help/_help.sh
## @param {str} <COMMAND_NAME> The command name to print detailed help for.
help() {
    if [ $# -gt 1 ]; then _echo_error "help: too many arguments ($#)\n"; return 1; fi

    _help "$0" "$1"
}

## Print detailed help for a given command
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/help/_print_description.sh
## @depends src/shell/help/_print_flags.sh
## @depends src/shell/help/_print_options.sh
## @depends src/shell/help/_print_usage.sh
## @depends src/shell/reflexion/_get_padding.sh
## @depends src/shell/shoedoc/_get_shoedoc_description.sh
## @depends src/shell/shoedoc/_get_shoedoc_tag.sh
## @depends src/shell/shoedoc/_get_shoedoc_title.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> (required) The command name to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
_print_command_details() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_print_command_details: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_command_details: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_command_details: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2" "$3"

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

    __stderr__=$(_get_shoedoc_tag "$3" 'stderr')
    if [ -n "${__stderr__}" ]; then
        _echo_warning 'Stderr:\n'
        _echo_primary "${__stderr__}\n" 2
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
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_commands() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_commands: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_commands: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-12}"

    _echo_warning 'Commands:\n'
    awk -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" \
    '/^### /{printf"\n%s%s:%s\n",WARNING,substr($0,5),PRIMARY}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^[a-zA-Z0-9_]+ *\(\)/ || /^function +[a-zA-Z0-9_]+/ {  # matches any function declaration
        function_name=$1                                     # the name, or the "function" keyword
        if (function_name == "function") function_name=$2    # skip the "function" keyword
        sub(/\(.*/, "", function_name)                       # truncate at the opening round bracket
        if (annotation!="" && substr(function_name,1,1) != "_") # ignore private functions
        printf "%s  %-'"$2"'s %s%s\n",SUCCESS,function_name,PRIMARY,annotation;
    } !/^## */{annotation=""}' "$1"
    printf '\n'

}

## List constants of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes _EOL _INFO _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_constants() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-12}"

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
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {str} <DESCRIPTION> (required) A string containing script description.
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

## List flags of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath tr
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @assumes _PRIMARY _SUCCESS
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose flags should be added.
_print_flags() {
    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" $((${2:-12}-2)) "${3:-}"

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
              __long__ __constraint__ __default__ __required__ \
              __description__; do
            if [ "${__kind__}" != 'flag' ]; then
                continue
            fi
            case " $(printf '%s' "${__global_flags__}" | tr '\n' ' ') " in
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
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/shoedoc/_get_script_shoedoc.sh
## @depends src/shell/shoedoc/_get_shoedoc_tag.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
_print_infos() {
    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

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
## @requires awk grep printf realpath tr
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/reflexion/_get_options.sh
## @assumes _DEFAULT _EOL _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose options should be added.
_print_options() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" $((${2:-12}-2)) "${3:-}"

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
              __long__ __constraint__ __default__ __required__ \
              __description__; do
            if [ "${__kind__}" != 'option' ]; then
                continue
            fi
            case " $(printf '%s' "${__global_options__}" | tr '\n' ' ') " in
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
## @requires awk basename printf realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/reflexion/_get_options.sh
## @assumes _DEFAULT _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> Optional command whose parameters should be added.
_print_usage() {
    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-}"

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
                  __long__ __constraint__ __default__ __required__ \
                  __description__; do
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

## Place here commands you need executed last on success (optional)
##
## @namespace src/shell/hooks
_after() {
    return 0
}

## Place here commands you need executed first every time (optional)
##
## @namespace src/shell/hooks
## @requires awk sed
## @depends src/shell/system/_check_installed.sh
_before() {
    _check_installed awk
    _check_installed sed
}

## Place here commands you need executed by default (optional)
##
## @namespace src/shell/hooks
## @depends src/shell/help/help.sh
_default() {
    help ''
}

##################################################
### Self Install
##################################################

## Install script via copy
##
## Creates a symbolic link in the /usr/local/bin/ directory
##
## @namespace src/shell/install
## @requires basename cp realpath sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/validation/_validate_alias.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_copy_install() {
    if [ -z "$1" ]; then _echo_error '_copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_copy_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_copy_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is used as a path component under the installation
    # folder, and the command runs through sudo: refuse anything that
    # could escape it.
    _validate_alias "$2" '_copy_install' || return 1

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"

    # -a, --archive    same as -dR --preserve=all
    _echo_info "sudo cp -R -p \"$1\" \"${__bin_dir__}/$2\"\n"
    if ! sudo cp -R -p -- "$1" "${__bin_dir__}/$2"; then
        _echo_error "_copy_install: could not copy \"$1\" to \"${__bin_dir__}/$2\"\n"

        return 1
    fi
}

## Generates an autocomplete script for the provided file
##
## This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
## Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
## Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
##
## @namespace src/shell/install
## @requires basename dirname printf realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/install/_get_comspec.sh
## @depends src/shell/validation/_validate_alias.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_autocomplete: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias names the completion file created next to the script:
    # refuse anything that could escape that folder.
    _validate_alias "$2" '_generate_autocomplete' || return 1

    _echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    if ! printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"; then
        _echo_error "_generate_autocomplete: could not write \"$(dirname "$1")/$2-completion.sh\"\n"

        return 1
    fi
}

## Creates a system-wide autocomplete script for the provided file
##
## This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
## in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
## It uses sudo for file creation in a system directory, requiring root privileges.
##
## @namespace src/shell/install
## @requires basename printf realpath sudo tee
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/install/_get_comspec.sh
## @depends src/shell/validation/_validate_alias.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_global_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_global_autocomplete: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is a path component used by sudo: refuse traversal.
    _validate_alias "$2" '_generate_global_autocomplete' || return 1

    _echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

## Generate comspec string for the provided file
##
## @namespace src/shell/install
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_comspec() {
    if [ -z "$1" ]; then _echo_error '_get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_comspec: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_comspec: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

    awk '/^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s ",FUNCTION,substr(PREV,4)
    } {PREV = $0}' "$1"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") {
            printf "--%s ",$1
        }
    } {PREV = $0}' "$1"
}

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename bash realpath touch true uname zsh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/install/_copy_install.sh
## @depends src/shell/install/_generate_autocomplete.sh
## @depends src/shell/install/_generate_global_autocomplete.sh
## @depends src/shell/install/_set_completion_autoload.sh
## @depends src/shell/install/_symlink_install.sh
## @depends src/shell/system/_is_installed.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_install() {
    if [ -z "$1" ]; then _echo_error '_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"

    if [ "$3" = true ]; then
        _copy_install "$1" "$2" || return 1
        _generate_global_autocomplete "$1" "$2" || return 1
    else
        _symlink_install "$1" "$2" || return 1
        _generate_autocomplete "$1" "$2" || return 1
    fi

    if _is_installed zsh; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$1" "$2" || true
    fi

    if _is_installed bash; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            if [ ! -f ~/.profile ]; then touch ~/.profile 2>/dev/null || true; fi
            _set_completion_autoload ~/.profile "$1" "$2" || true
        else
            _set_completion_autoload ~/.bashrc "$1" "$2" || true
        fi
    fi
}

## Remove completion script autoload
##
## Removes an autoload line for a completion script from a shell rc configuration file
##
## @namespace src/shell/install
## @requires basename printf realpath sed
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_sed_i.sh
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_remove_completion_autoload() {
    if [ $# -lt 1 ]; then _echo_error '_remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_completion_autoload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is literal text: escape the regular expression
    # metacharacters so a dot or a bracket cannot widen the match.
    __pattern__="$(printf '%s' "$2" | sed 's@[\\.*^$/[]@\\&@g')" || return 1

    _echo_info "_sed_i \"/^###> ${__pattern__}$/,/^###< ${__pattern__}$/d\" \"$1\"\n"
    _sed_i "/^###> ${__pattern__}$/,/^###< ${__pattern__}$/d" "$1" || return 1

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    _sed_i '/^$/{N;s/^\n$//;}' "$1" || return 1
}

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/install/_install.sh
## @assumes ALIAS global
self_install() {
    _install "$0" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/install/_uninstall.sh
## @assumes ALIAS
self_uninstall() {
    _uninstall "$0" "${ALIAS:-$(basename "$0" .sh)}"
}

## Adds an autoload line for completion script to a shell configuration file
##
## @namespace src/shell/install
## @requires basename dirname printf realpath sed
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_sed_i.sh
## @depends src/shell/strings/_collapse_blank_lines.sh
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {file} <SCRIPT_FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_set_completion_autoload() {
    if [ -z "$1" ]  || [ -z "$2" ]; then _echo_error '_set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_completion_autoload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$(realpath -- "$2")" "${3:-"$(basename "$2" .sh)"}"

    # declare inner function
    __set_completion_autoload() {
        # Synopsis: __set_completion_autoload <SHELL_CONFIG_FILE_PATH> <COMPLETION_FILE_PATH> <ALIAS>
        # remove previous install if any
        # The alias is literal text: escape the regular expression
        # metacharacters so a dot or a bracket cannot widen the match.
        __pattern__="$(printf '%s' "$3" | sed 's@[\\.*^$/[]@\\&@g')" || return 1
        _sed_i "/^###> ${__pattern__}$/,/^###< ${__pattern__}$/d" "$1" || return 1

        _echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$3\" \"$2\" \"$3\" >> \"$1\"\n"
        printf '\n###> %s\nsource %s\n###< %s\n' "$3" "$2" "$3" >> "$1"

        _collapse_blank_lines "$1"
    }

    # set global completion file path
    if [ -f "/etc/bash_completion.d/$3" ]; then
        __set_completion_autoload "$1" "/etc/bash_completion.d/$3" "$3"
    fi

    # set completion file path
    if [ -f "$(dirname "$2")/$3-completion.sh" ]; then
        __set_completion_autoload "$1" "$(dirname "$2")/$3-completion.sh" "$3"
    fi
}

## Install script via symlink
##
## @namespace src/shell/install
## @requires basename ln realpath rm sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/validation/_validate_alias.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_symlink_install(){
    if [ -z "$1" ]; then _echo_error '_symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_symlink_install too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_symlink_install \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    # The alias is used as a path component under the installation
    # folder, and the commands run through sudo: refuse anything that
    # could escape it.
    _validate_alias "$2" '_symlink_install' || return 1

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"

    # Checks whether the installed name already exists as a symbolic link.
    if [ -L "${__bin_dir__}/$2" ]; then
        _echo_info "sudo rm -f \"${__bin_dir__}/$2\"\n"
        if ! sudo rm -f -- "${__bin_dir__}/$2"; then
            _echo_error "_symlink_install: could not remove \"${__bin_dir__}/$2\"\n"

            return 1
        fi
    fi

    _echo_info "sudo ln -s \"$1\" \"${__bin_dir__}/$2\"\n"
    if ! sudo ln -s -- "$1" "${__bin_dir__}/$2"; then
        _echo_error "_symlink_install: could not link \"$1\" to \"${__bin_dir__}/$2\"\n"

        return 1
    fi
}

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename cmp dirname realpath rm sudo
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/install/_remove_completion_autoload.sh
## @assumes SHOE_BIN_DIR
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_uninstall() {
    if [ -z "$1" ]; then _echo_error '_uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_uninstall: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_uninstall: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(basename "$1" .sh)"}"

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    _echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    __bin_dir__="${SHOE_BIN_DIR:-/usr/local/bin}"
    __installed__="${__bin_dir__}/$2"

    # Remove a symbolic link that points at the source, or a copy whose
    # content still matches it: a binary installed by _copy_install is a
    # regular file, and a file that differs belongs to something else.
    __remove__='false'
    if [ -L "${__installed__}" ]; then
        if [ "$(realpath -- "${__installed__}" 2>/dev/null)" = "$1" ]; then
            __remove__='true'
        fi
    elif [ -f "${__installed__}" ] && cmp -s "$1" "${__installed__}"; then
        __remove__='true'
    fi

    if [ "${__remove__}" = 'true' ]; then
        _echo_info "sudo rm -f \"${__installed__}\"\n"
        if ! sudo rm -f -- "${__installed__}"; then
            _echo_error "_uninstall: could not remove \"${__installed__}\"\n"

            return 1
        fi
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        _echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

##################################################
### Make
##################################################

## Generate Makefile for provided shoe script
##
## @namespace src/shell/make
## @requires awk basename cat dirname printf realpath tr
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/shoedoc/_get_script_shoedoc.sh
## @depends src/shell/shoedoc/_get_shoedoc_description.sh
## @depends src/shell/shoedoc/_get_shoedoc_tag.sh
## @depends src/shell/shoedoc/_get_shoedoc_title.sh
## @assumes _ALERT_DANGER _ALERT_DARK _ALERT_INFO _ALERT_LIGHT _ALERT_MUTED _ALERT_PRIMARY _ALERT_SECONDARY _ALERT_SUCCESS _ALERT_WARNING _DANGER _DARK _DEFAULT _EOL _INFO _LIGHT _MUTED _PRIMARY _SECONDARY _SUCCESS _WARNING
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the generated Makefile. Defaults to "<BASENAME>.makefile".
_generate_makefile() {
    if [ -z "$1" ]; then _echo_error '_generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_generate_makefile: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ -n "$2" ] && [ ! -d "$2" ]; then _echo_error "_generate_makefile: \"$2\" folder not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-"$(realpath -- "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"

    # check valid input file type
    case "$1" in
        *.sh) ;;
        *) _echo_error '_generate_makefile: file should be type ".sh"\n'; return 1 ;;
    esac

    _alert_primary "Generating $3"

    __annotations__=$(_get_script_shoedoc "$1")

    cat > "$2/$3" <<EOT
## $(printf '%s' "$(_get_shoedoc_title "${__annotations__}")")
##
## $(printf '%s' "$(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')")
##
## @version $(_get_shoedoc_tag "${__annotations__}" 'version')
## @author  $(_get_shoedoc_tag "${__annotations__}" 'author')
## @license $(_get_shoedoc_tag "${__annotations__}" 'license')
## @link    $(_get_shoedoc_tag "${__annotations__}" 'link')

EOT
    # generate .PHONY
    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } {PREV = $0} END {print "\n"}' "$1" >> "$2/$3"

    cat >> "$2/$3" <<EOT
##################################################
## Colors
##################################################

_PRIMARY   = ${_PRIMARY}
_SECONDARY = ${_SECONDARY}
_SUCCESS   = ${_SUCCESS}
_DANGER    = ${_DANGER}
_WARNING   = ${_WARNING}
_INFO      = ${_INFO}
_MUTED     = ${_MUTED}
_LIGHT     = ${_LIGHT}
_DARK      = ${_DARK}
_DEFAULT   = ${_DEFAULT}
_EOL       = ${_EOL}

_ALERT_PRIMARY   = ${_ALERT_PRIMARY}
_ALERT_SECONDARY = ${_ALERT_SECONDARY}
_ALERT_SUCCESS   = ${_ALERT_SUCCESS}
_ALERT_DANGER    = ${_ALERT_DANGER}
_ALERT_WARNING   = ${_ALERT_WARNING}
_ALERT_INFO      = ${_ALERT_INFO}
_ALERT_MUTED     = ${_ALERT_MUTED}
_ALERT_LIGHT     = ${_ALERT_LIGHT}
_ALERT_DARK      = ${_ALERT_DARK}

##################################################
## Color Functions
##################################################

define _echo_primary
	@printf "\${_PRIMARY}%b\${_EOL}" \$(1)
endef
define _echo_secondary
	@printf "\${_SECONDARY}%b\${_EOL}" \$(1)
endef
define _echo_success
	@printf "\${_SUCCESS}%b\${_EOL}" \$(1)
endef
define _echo_danger
	@printf "\${_DANGER}%b\${_EOL}" \$(1)
endef
define _echo_warning
	@printf "\${_WARNING}%b\${_EOL}" \$(1)
endef
define _echo_info
	@printf "\${_INFO}%b\${_EOL}" \$(1)
endef
define _echo_muted
	@printf "\${_MUTED}%b\${_EOL}" \$(1)
endef
define _echo_light
	@printf "\${_LIGHT}%b\${_EOL}" \$(1)
endef
define _echo_dark
	@printf "\${_DARK}%b\${_EOL}" \$(1)
endef
define _echo_error
	@printf "\${_DANGER}error: %b\${_EOL}" \$(1)
endef

define _alert_primary
	@printf "\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\${_ALERT_PRIMARY} %-63s\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_secondary
	@printf "\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\${_ALERT_SECONDARY} %-63s\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_success
	@printf "\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\${_ALERT_SUCCESS} %-63s\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_danger
	@printf "\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\${_ALERT_DANGER} %-63s\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_warning
	@printf "\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\${_ALERT_WARNING} %-63s\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_info
	@printf "\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\${_ALERT_INFO} %-63s\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_muted
	@printf "\${_EOL}\${_ALERT_MUTED}%64s\${_EOL}\${_ALERT_MUTED} %-63s\${_EOL}\${_ALERT_MUTED}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_light
	@printf "\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\${_ALERT_LIGHT} %-63s\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_dark
	@printf "\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\${_ALERT_DARK} %-63s\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\n" "" \$(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
	\$(call _alert_primary, "$(_get_shoedoc_title "${__annotations__}")")

	@printf "\${_WARNING}Description:\${_EOL}"
	@printf "\${_PRIMARY}  $(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')\${_EOL}\n"

	@printf "\${_WARNING}Usage:\${_EOL}"
	@printf "\${_PRIMARY}  make [command]\${_EOL}\n"

	@printf "\${_WARNING}Commands:\${_EOL}"
	@awk '/^### /{printf"\n\${_WARNING}%s\${_EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${_SUCCESS}  %-12s  \${_PRIMARY}%s\${_EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
	}{PREV=\$\$0}' \${MAKEFILE_LIST}

EOT

    # Reference the script by its path relative to the Makefile so the
    # generated targets run from the folder that holds the Makefile.
    case "$1" in
        "$2"/*) __script_ref__="${1#"$2"/}" ;;
        *)      __script_ref__="$1" ;;
    esac

    # generate rules
    awk -v SHELL_SCRIPT="$__script_ref__" \
    'BEGIN {HR="##################################################\n"}
    /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_" && function_name != "help") # ignore private functions and help
        printf "## %s\n%s:\n\t@printf \"${_INFO}sh %s %s${_EOL}\"\n\t@sh %s %s\n\n",annotation,function_name,SHELL_SCRIPT,function_name,SHELL_SCRIPT,function_name,function_name
    }
    !/^## */{annotation=""}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    _echo_success "Makefile generated : \"$2/$3\"\n"
}

## Generate Makefile for current shoe script
##
## @namespace src/shell/make
## @depends src/shell/make/_generate_makefile.sh
generate_makefile() {
    _generate_makefile "$0"
}

## List constants from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private constants as well.
_get_constants() {
    if [ -z "$1" ]; then _echo_error '_get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-false}"

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
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <VARIABLE_NAME> (required) The variable to validate.
_get_constraint() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

    awk -F '=' -v NAME="$2" '
    function trim(value) {
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        return value
    }

    # The value starts with a "/": return the index of its closing slash,
    # or 0 when the expression is never closed. The closing slash may be
    # followed by flags only, and then by a space or the end of the line:
    # that rule lets a character class contain a space ("/^[a-z ]+$/")
    # without letting a path quoted in a description be read as one.
    function closing_slash(value,    i, tail) {
        for (i = 2; i <= length(value); i++) {
            if (substr(value, i, 1) != "/") continue
            tail = substr(value, i + 1)
            if (tail ~ /^[a-z]*([ \t]|$)/) return i
        }
        return 0
    }

    /^## / {
        body = substr($0, 4)
        if (body ~ /^@constraint([ \t]|$)/) {
            sub(/^@constraint[ \t]*/, "", body)
            CONSTRAINT = trim(body)
        } else if (body ~ /^@(variable|option|constant)[ \t]/) {
            # Only the annotation that declares NAME may contribute its
            # constraint: scanning every line would apply the regular
            # expression of another entry to this value.
            line = body
            sub(/^@[a-zA-Z]+[ \t]+/, "", line)
            sub(/^\{[^}]*\}[ \t]*/, "", line)
            # A declared "<name>" scopes the constraint to that entry; an
            # annotation without one belongs to the assignment that follows.
            if (substr(line, 1, 1) == "<") {
                stop = index(line, ">")
                if (stop > 0 && substr(line, 2, stop - 2) != NAME) next
                line = trim(substr(line, stop + 1))
            }
            # Drop the aliases, then read the constraint that directly
            # follows them.
            if (substr(line, 1, 1) == "[") {
                stop = index(line, "]")
                if (stop > 0) line = trim(substr(line, stop + 1))
            }
            if (substr(line, 1, 1) == "/") {
                stop = closing_slash(line)
                if (stop > 0) CONSTRAINT = substr(line, 1, stop)
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
            if (TITLE != "" && index(TITLE, "/") > 0) {
                line = substr(TITLE, index(TITLE, "/"))
                stop = closing_slash(line)
                if (stop > 0) { print substr(line, 1, stop); exit }
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
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_flags() {
    if [ -z "$1" ]; then _echo_error '_get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
    } {PREV = $0}' "$1"
}

## List parameters, options and flags declared in a function shoedoc annotation
##
## Outputs one record per entry with fields separated by the ASCII unit
## separator: kind, name, short alias, long alias, constraint, default
## value, required marker and description. Parameters are emitted in
## declaration order, so their position is implied by the order of their
## records.
##
## @namespace src/shell/reflexion
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/shoedoc/_get_function_shoedoc.sh
## @stdout one record per option or flag, fields separated by ASCII 31.
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to inspect.
_get_function_parameters() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_parameters: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_parameters: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_parameters: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

    printf '%s\n' "$(_get_function_shoedoc "$1" "$2")" | awk '
        BEGIN {
            separator = sprintf("%c", 31)
        }

        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        # The value starts with a "/": return the index of its closing
        # slash, or 0 when the expression is never closed. The closing
        # slash may be followed by flags only, and then by a space or the
        # end of the line: that rule lets a character class contain a
        # space ("/^[a-z ]+$/") without letting a path quoted in the
        # description be read as one.
        function closing_slash(value,    i, tail) {
            for (i = 2; i <= length(value); i++) {
                if (substr(value, i, 1) != "/") continue
                tail = substr(value, i + 1)
                if (tail ~ /^[a-z]*([ \t]|$)/) return i
            }
            return 0
        }

        function emit(kind, value,    type, name, short, long_name,
                      constraint, default_value, required_value, stop,
                      position, aliases, parts, count, i, token) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            default_value = ""
            required_value = ""

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
                stop = closing_slash(value)
                if (stop == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, stop)
                    value = trim(substr(value, stop + 1))
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
                    else if (token == "required")
                        required_value = "true"
                }
            }

            printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n", kind, separator,
                name, separator, short, separator, long_name, separator,
                constraint, separator, default_value, separator,
                required_value, separator, value
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
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private functions as well.
_get_functions_names() {
    if [ -z "$1" ]; then _echo_error '_get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_functions_names: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-false}"

    # Matches `name() {`, `name(){`, `name()` alone, `name() { ...; }` on
    # one line and `function name {`.
    awk -v GET_PRIVATE="$2" \
    '/^[a-zA-Z0-9_]+ *\(\)/ || /^function +[a-zA-Z0-9_]+/ {
        function_name=$1
        if (function_name == "function") function_name=$2
        sub(/\(.*/, "", function_name)
        if (GET_PRIVATE == "true") {
            print function_name
        } else {
            if (substr(function_name,1,1) != "_") print function_name
        }
    } {PREV = $0}' "$1"
}

## List options from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE_ONLY> (default:false) If set to "true", retrieves private options only.
_get_options() {
    if [ -z "$1" ]; then _echo_error '_get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "${2:-false}"

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
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_padding() {
    if [ -z "$1" ]; then _echo_error '_get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_padding: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_padding: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

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

## Print function synopsis from shoedoc annotations
##
## @namespace src/shell/reflexion
## @requires awk printf
## @depends src/shell/colors/_echo_error.sh
## @param {str} <FUNCTION_NAME> (required) The name of the function to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
## @param {bool} <MARKDOWN_FORMAT> (default:false) If set to "true", returns result as markdown.
_print_synopsis() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_synopsis: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-false}"

    #--------------------------------------------------
    # Classic @-tag annotations
    #--------------------------------------------------

    printf '%s' "$2" | awk -v NAME="$1" -v MARKDOWN="$3" '
        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        function add_words(target, value,    count, words, i) {
            count = split(value, words, /[ \t]+/)
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (target == "requires")
                    requires = requires (requires == "" ? "" : " ") words[i]
                else
                    depends = depends (depends == "" ? "" : " ") words[i]
            }
        }

        function add_entry(kind, value,    type, name, short, long_name,
                           constraint, required, has_default, default_value,
                           summary, description, stop, position, aliases,
                           parts, count, i, token, marker) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            required = 0
            has_default = 0
            default_value = ""
            summary = ""
            description = ""

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
                    for (i = 1; i <= count && i <= 2; i++) {
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

            if (substr(value, 1, 1) == "/") {
                position = index(value, " ")
                if (position == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, position - 1)
                    value = trim(substr(value, position + 1))
                }
            }

            if (substr(value, 1, 1) == "(") {
                stop = index(value, ")")
                if (stop > 0) {
                    marker = trim(substr(value, 2, stop - 2))
                    value = trim(substr(value, stop + 1))
                    if (marker == "required")
                        required = 1
                    else if (substr(marker, 1, 8) == "default:") {
                        has_default = 1
                        default_value = substr(marker, 9)
                    }
                }
            }

            position = index(value, " - ")
            if (position > 0) {
                summary = trim(substr(value, 1, position - 1))
                description = trim(substr(value, position + 3))
            } else {
                description = value
            }
            if (summary != "")
                value = summary " - " description
            else
                value = description

            entry_count++
            entry_kind[entry_count] = kind
            entry_name[entry_count] = name
            entry_type[entry_count] = type
            entry_short[entry_count] = short
            entry_long[entry_count] = long_name
            entry_constraint[entry_count] = constraint
            entry_required[entry_count] = required
            entry_has_default[entry_count] = has_default
            entry_default[entry_count] = default_value
            entry_text[entry_count] = value
        }

        function alias_list(i,    result) {
            result = ""
            if (entry_short[i] != "")
                result = "-" entry_short[i]
            if (entry_long[i] != "") {
                if (result != "")
                    result = result "|"
                result = result "--" entry_long[i]
            }
            if (result == "")
                result = "--" entry_name[i]
            return result
        }

        function signature(i) {
            if (entry_kind[i] == "param") {
                if (entry_required[i])
                    return "<" entry_name[i] ">"
                return "[" entry_name[i] "]"
            }
            if (entry_kind[i] == "option")
                return "[" alias_list(i) " VALUE]"
            return "[" alias_list(i) "]"
        }

        function plain_label(i) {
            if (entry_kind[i] == "param")
                return entry_name[i]
            return alias_list(i)
        }

        function markdown_label(i,    result) {
            if (entry_kind[i] == "param")
                return "`" entry_name[i] "`"
            result = ""
            if (entry_short[i] != "")
                result = "`-" entry_short[i] "`"
            if (entry_long[i] != "") {
                if (result != "")
                    result = result ", "
                result = result "`--" entry_long[i] "`"
            }
            if (result == "")
                result = "`--" entry_name[i] "`"
            return result
        }

        function quote_default(value,    result) {
            result = value
            if (length(result) >= 2 &&
                substr(result, 1, 1) == "\"" &&
                substr(result, length(result), 1) == "\"")
                result = substr(result, 2, length(result) - 2)
            return "\"" result "\""
        }

        function detail(i, markdown,    result, value) {
            result = ""
            if (entry_kind[i] != "flag" && entry_type[i] != "") {
                if (markdown)
                    result = result "_(type: \"" entry_type[i] "\")_ "
                else
                    result = result "(" entry_type[i] ") "
            }
            if (entry_kind[i] == "param" && !entry_required[i])
                result = result "(optional) "
            if (entry_text[i] != "")
                result = result entry_text[i] " "
            if (entry_constraint[i] != "") {
                if (markdown)
                    result = result "_Constraint: `" entry_constraint[i] "`._ "
                else
                    result = result "Constraint: " entry_constraint[i] ". "
            }
            if (entry_kind[i] != "flag" && entry_has_default[i]) {
                value = quote_default(entry_default[i])
                if (markdown)
                    result = result "_Defaults to " value "._ "
                else
                    result = result "Defaults to " value ". "
            }
            return trim(result)
        }

        function word_list(value, markdown,    count, words, i, result) {
            count = split(value, words, " ")
            result = ""
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (result != "")
                    result = result ", "
                result = result (markdown ? "`" words[i] "`" : words[i])
            }
            return result
        }

        {
            line = $0
            sub(/^[ \t]*#+[ \t]?/, "", line)
            line = trim(line)
            if (line == "")
                next
            split(line, tokens, /[ \t]+/)
            tag = tokens[1]
            value = trim(substr(line, length(tag) + 1))
            if (tag == "@requires") {
                add_words("requires", value)
                next
            }
            if (tag == "@depends") {
                add_words("depends", value)
                next
            }
            if (tag == "@private") {
                private_flag = 1
                next
            }
            if (tag == "@public") {
                private_flag = 0
                next
            }
            if (tag == "@param") {
                add_entry("param", value)
                next
            }
            if (tag == "@option") {
                add_entry("option", value)
                next
            }
            if (tag == "@flag") {
                add_entry("flag", value)
            }
        }

        END {
            if (substr(NAME, 1, 1) == "_")
                private_flag = 1
            if (MARKDOWN == "true") {
                printf "> Synopsis:\n> `%s", NAME
                for (i = 1; i <= entry_count; i++)
                    printf " %s", signature(i)
                printf "`\n"
                details = ""
                for (i = 1; i <= entry_count; i++) {
                    line = detail(i, 1)
                    if (details != "")
                        details = details "\n"
                    if (line != "")
                        details = details "- " markdown_label(i) ": " line
                    else
                        details = details "- " markdown_label(i) ":"
                }
                if (details != "")
                    printf "%s\n\n", details
                if (requires != "")
                    printf "- ⚠️ Requires: %s\n", word_list(requires, 1)
                if (depends != "")
                    printf "- 🔗 Depends: %s\n", word_list(depends, 1)
                printf "\n"
                exit
            }
            scope = private_flag ? "private" : "public"
            printf "Synopsis: %s (%s)", NAME, scope
            for (i = 1; i <= entry_count; i++)
                printf " %s", signature(i)
            printf "\n"
            for (i = 1; i <= entry_count; i++) {
                line = detail(i, 0)
                if (line != "")
                    printf "    %s: %s\n", plain_label(i), line
                else
                    printf "    %s:\n", plain_label(i)
            }
            if (requires != "")
                printf "    Requires: %s\n", word_list(requires, 0)
            if (depends != "")
                printf "    Depends: %s\n", word_list(depends, 0)
            printf "\n"
        }
    '
}

## Get function shedoc annotation by name
##
## @namespace src/shell/shoedoc
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to retrieve.
_get_function_shoedoc() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

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
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_script_shoedoc() {
    if [ -z "$1" ]; then _echo_error '_get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_script_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")"

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
## @depends src/shell/colors/_echo_error.sh
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
## @depends src/shell/colors/_echo_error.sh
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
## @depends src/shell/colors/_echo_error.sh
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

## Collapse blank lines with "sed"
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/compatibility/_sed_i.sh
## @param {file} <FILE_PATH> (required) The path to the input file.
_collapse_blank_lines() {
    if [ -z "$1" ]; then _echo_error '_collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_collapse_blank_lines: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath -- "$1")"

    # The N command reads the next line into the pattern space.
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    _echo_info "_sed_i '/^$/{N;s/^\\\n$//;}' \"$1\"\n"
    _sed_i '/^$/{N;s/^\n$//;}' "$1" || return 1
}

## Print error message if provided command is missing
##
## @namespace src/shell/system
## @requires basename
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/system/_get_package_name.sh
## @depends src/shell/system/_is_installed.sh
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
## @depends src/shell/colors/_echo_error.sh
## @param {str} <COMMAND> (required) A string containing the command name to find.
_get_package_name() {
    if [ -z "$1" ]; then _echo_error '_get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_package_name: too many arguments ($#)\n"; return 1; fi

    # debian packages
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
## @depends src/shell/colors/_echo_error.sh
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

## Exit with an error when a script defines a function more than once
##
## @namespace src/shell/validation
## @requires grep printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/reflexion/_get_functions_names.sh
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
## @depends src/shell/colors/_echo_error.sh
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

    # The pattern is passed through the environment because `awk -v`
    # expands escape sequences such as "\." and corrupts the expression.
    # The match is checked for full-line coverage instead of wrapping the
    # pattern in "^(...)$", because some awks (BWK awk on macOS) treat a
    # mid-expression "^" or "$" as a literal character.
    if ! printf '%s\n' "$1" | __pattern__="$2" awk '
        BEGIN { pattern = ENVIRON["__pattern__"] }
        {
            if (!match($0, pattern) || substr($0, RSTART, RLENGTH) != $0) {
                invalid = 1
            }
        }
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
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/reflexion/_get_constraint.sh
## @depends src/shell/validation/_is_valid.sh
## @param {str} <VARIABLE> (required) The variable to validate in the followling format : variable_name=value.
## @param {str} <CONSTRAINT> Optional constraint, read from the script when omitted.
_validate() {
    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2-)" "${2:-$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")}"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"

        # A failing status, not "exit": the caller decides whether an
        # invalid value is fatal, and a command substitution must not
        # terminate the shell running it.
        return 1
    fi
}

## Reject an alias that cannot be used as a single path component
##
## An install alias is concatenated into a path below "/usr/local/bin",
## below "/etc/bash_completion.d" or in the script folder, and the
## resulting command may run through sudo. A slash would let the alias
## address any path, and a leading dot would let it name a hidden or a
## parent entry: only a plain path component is accepted.
##
## @namespace src/shell/validation
## @depends src/shell/colors/_echo_error.sh
## @param {str} <ALIAS> (required) The alias to validate.
## @param {str} <FUNCTION_NAME> (required) The caller, used in the message.
_validate_alias() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_alias: some mandatory parameter is missing\n'

        return 1
    fi
    if [ $# -gt 2 ]; then
        _echo_error "_validate_alias: too many arguments ($#)\n"

        return 1
    fi

    case "$1" in
        ''|*/*|.*)
            _echo_error "$2: invalid alias \"$1\"\n"

            return 1
            ;;
    esac

    return 0
}

## Bind positional parameters to the variables named in a function shoedoc
##
## Each positional value is matched with the `@param` declaration at the
## same position. The value is validated against the declared constraint,
## then assigned to the variable named by the declaration. Parameters
## without a value receive their declared default value, or an empty value
## when they declare none. A parameter annotated `(required)` aborts the
## command when no value is supplied, and surplus positional values are
## rejected instead of being silently discarded.
##
## Commands therefore read their parameters from named variables, and the
## positional parameters of the command itself remain empty.
##
## @namespace src/shell/validation
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/validation/_validate.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The command being executed.
## @param {str} <POSITIONAL> The positional values to bind.
_validate_positionals() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_positionals: some mandatory parameter is missing\n'

        return 1
    fi

    __script__="$1"
    __function__="$2"
    shift 2

    # Number of positional values supplied, reported when some are left
    # over after every declared parameter has been bound.
    __positional_count__=$#

    __records__="$(_get_function_parameters \
        "${__script__}" "${__function__}")" || return 1
    if [ -z "${__records__}" ]; then return 0; fi

    __separator__="$(printf '\037')"
    while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
          __long__ __constraint__ __default__ __required__ \
          __description__; do
        # Only positional parameters are bound here: options and flags
        # are handled by the kernel that owns the command line.
        if [ "${__kind__}" != 'param' ]; then continue; fi

        if [ $# -gt 0 ]; then
            # Consume the next positional value and validate it against
            # the shoedoc constraint, if any.
            __value__="$1"
            shift
            __assign__="\"\${__value__}\""
            if [ -n "${__constraint__}" ]; then
                _validate "${__name__}=${__value__}" "${__constraint__}"
            fi
        elif [ -n "${__default__}" ]; then
            # The default is shell syntax, evaluated the same way as an
            # option default by the kernel.
            __assign__="${__default__}"
        elif [ "${__required__}" = 'true' ]; then
            _echo_error "_validate_positionals: \"${__name__}\" is required\n"

            return 1
        else
            # Reset the variable so a previous command cannot leak its
            # own value into this one.
            __assign__='""'
        fi

        eval "${__name__}=${__assign__}"
    done <<EOF
${__records__}
EOF

    if [ "$#" -gt 0 ]; then
        _echo_error "_validate_positionals: too many arguments (${__positional_count__})\n"

        return 1
    fi

    return 0
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

## Shoe Kernel
##
## Full-featured kernel for scripts that need global and per-command
## flags, options and positional parameters.
##
## Global (file-level) flags and options apply to every command and may
## appear anywhere on the command line. Per-command flags and options
## belong to the command they follow; those given before the command
## also belong to it. Command flags and options are initialized and
## bound immediately before the command runs.
##
## Exactly one command may be given on the command line. Positional
## parameters belong to that command and are bound to the variables
## named by its `@param` annotations, which receive the caller value or
## their declared default value. The command itself runs without
## positional parameters. `help` takes precedence over the command name
## that follows it, and `_default` runs when no command is given.
##
## A literal `--` ends option parsing: every following argument is a
## positional parameter of the command, even when it starts with `-`.
##
## `_before` runs before the command. `_after` runs after it only when
## the command succeeded, and never masks the command exit status.
##
## A short or long spelling declared both globally and by a command is
## rejected instead of being silently captured by the global parser.
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/help/_help.sh
## @depends src/shell/hooks/_after.sh
## @depends src/shell/hooks/_before.sh
## @depends src/shell/hooks/_default.sh
## @depends src/shell/reflexion/_get_constraint.sh
## @depends src/shell/reflexion/_get_flags.sh
## @depends src/shell/reflexion/_get_function_parameters.sh
## @depends src/shell/reflexion/_get_functions_names.sh
## @depends src/shell/reflexion/_get_options.sh
## @depends src/shell/validation/_check_duplicate_functions.sh
## @depends src/shell/validation/_validate.sh
## @depends src/shell/validation/_validate_positionals.sh
_kernel() {
    # Abort before doing anything when the script declares two functions
    # with the same name: command resolution would silently pick one.
    _check_duplicate_functions "$0"

    # Without any argument there is no command to resolve: run the
    # default hook immediately.
    if [ $# -lt 1 ]; then _default; exit 0; fi

    # Shoedoc records are line based and use the ASCII unit separator
    # between their fields. It is reserved for this internal record
    # format and never carries user arguments.
    __unit_separator__="$(printf '\037')"

    # Names of the public functions declared by the script. Only these
    # names can be resolved as commands.
    __commands__="$(_get_functions_names "$0")"

    # Global (file-level) flags and options apply to every command.
    __global_flags__="$(_get_flags "$0")"
    __global_options__="$(_get_options "$0")"

    # Every option spelling declared by a command. This list recognizes
    # the value that follows a command option before the command owning
    # that option is known. The surrounding spaces make membership tests
    # exact without a temporary delimiter.
    __spellings__=' '
    # Every spelling declared by a command, flags included: used to
    # detect a spelling that a global flag or option also claims.
    __command_spellings__=' '
    for __candidate__ in ${__commands__}; do
        __function_parameters__="$(_get_function_parameters "$0" "${__candidate__}")" || exit 1
        if [ -z "${__function_parameters__}" ]; then continue; fi

        while IFS="${__unit_separator__}" read -r __kind__ __parameter_name__ __short__ __long__ __constraint__ __default_value__ __required__ __description__; do
            case "${__kind__}" in
                flag|option) ;;
                *) continue ;;
            esac

            if [ -z "${__short__}" ]; then
                __short__="${__parameter_name__}"
                __short__="${__short__%"${__short__#?}"}"
            fi
            __long__="${__long__:-${__parameter_name__}}"

            for __spelling__ in "--${__long__}" "--${__parameter_name__}" "-${__short__}"; do
                case "${__command_spellings__}" in
                    *" ${__spelling__} "*) ;;
                    *) __command_spellings__="${__command_spellings__}${__spelling__} " ;;
                esac
                if [ "${__kind__}" != 'option' ]; then continue; fi
                case "${__spellings__}" in
                    *" ${__spelling__} "*) ;;
                    *) __spellings__="${__spellings__}${__spelling__} " ;;
                esac
            done
        done <<EOF
${__function_parameters__}
EOF
    done

    # Command selected by the command line, its arguments (held in the
    # positional parameters), and the target of `help` when one is given.
    __command__=''
    __help_target__=''

    # First command argument, reported when no command is selected, and
    # whether that argument is a parameter rather than a command name.
    __first_argument__=''
    __first_argument_is_parameter__='false'
    __has_first_argument__='false'

    #--------------------------------------------------
    # Resolve global inputs, the command and its arguments
    #--------------------------------------------------

    # Arguments are moved from the front of the positional parameters to
    # the back as they are classified. This keeps their exact contents,
    # including empty values, spaces and control characters: nothing is
    # ever joined into a string and split again.
    __remaining__=$#

    while [ "${__remaining__}" -gt 0 ]; do
        __argument__="$1"
        shift
        __remaining__=$((__remaining__ - 1))

        # A literal "--" ends option parsing: every following argument is
        # a positional parameter of the command, even when it starts with
        # "-". Handling it here matters: this loop classifies arguments
        # before the command loop runs, so guarding the command loop alone
        # would leave a "-x" after "--" misread as an option.
        if [ "${__argument__}" = '--' ]; then
            # The terminator itself is handed to the command loop, which
            # stops option parsing for the command arguments.
            set -- "$@" '--'
            if [ "${__has_first_argument__}" = 'false' ] &&
               [ "${__remaining__}" -gt 0 ]; then
                __first_argument__="$1"
                __first_argument_is_parameter__='false'
                __has_first_argument__='true'
            fi
            while [ "${__remaining__}" -gt 0 ]; do
                set -- "$@" "$1"
                shift
                __remaining__=$((__remaining__ - 1))
            done
            break
        fi

        # Global flags never consume the following argument.
        __matched__='false'
        for __flag__ in ${__global_flags__}; do
            __short__="${__flag__%"${__flag__#?}"}"
            if [ "${__argument__}" = "--${__flag__}" ] ||
               [ "${__argument__}" = "-${__short__}" ]; then
                # A spelling the command also declares is ambiguous: the
                # global parser would silently capture the command's flag.
                case "${__command_spellings__}" in
                    *" ${__argument__} "*)
                        _echo_error "\"${__argument__}\" is ambiguous: declared both globally and by a command\n"
                        exit 1
                        ;;
                esac
                eval "${__flag__}=true"
                __matched__='true'
                break
            fi
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # Global options consume the following argument as their value.
        for __option__ in ${__global_options__}; do
            __short__="${__option__%"${__option__#?}"}"
            if [ "${__argument__}" = "--${__option__}" ] ||
               [ "${__argument__}" = "-${__short__}" ]; then
                case "${__command_spellings__}" in
                    *" ${__argument__} "*)
                        _echo_error "\"${__argument__}\" is ambiguous: declared both globally and by a command\n"
                        exit 1
                        ;;
                esac
                if [ "${__remaining__}" -eq 0 ]; then
                    _echo_error "\"--${__option__}\" requires value\n"
                    exit 1
                fi
                __value__="$1"
                shift
                __remaining__=$((__remaining__ - 1))
                __constraint__="$(_get_constraint "$0" "${__option__}")" || exit 1
                _validate "${__option__}=${__value__}" "${__constraint__}"  || exit 1
                eval "${__option__}=\"\${__value__}\""
                __matched__='true'
                break
            fi
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # A command option and its value are arguments of the selected
        # command. They are kept even when the command is not known yet.
        case "${__spellings__}" in
            *" ${__argument__} "*)
                set -- "$@" "${__argument__}"
                if [ "${__remaining__}" -gt 0 ]; then
                    set -- "$@" "$1"
                    shift
                    __remaining__=$((__remaining__ - 1))
                fi
                if [ "${__has_first_argument__}" = 'false' ]; then
                    __first_argument__="${__argument__}"
                    __first_argument_is_parameter__='true'
                    __has_first_argument__='true'
                fi
                continue
                ;;
        esac

        # A known command is selected. Only one command may be given;
        # `help` is the exception, since the command that follows it is
        # the help target rather than a second command.
        __matched__='false'
        for __candidate__ in ${__commands__}; do
            if [ "${__argument__}" != "${__candidate__}" ]; then continue; fi
            if [ -z "${__command__}" ]; then
                __command__="${__candidate__}"
            elif [ "${__command__}" = 'help' ] &&
                 [ -z "${__help_target__}" ]; then
                __help_target__="${__candidate__}"
            else
                _echo_error 'only one command at a time\n'
                exit 1
            fi
            __matched__='true'
            break
        done
        if [ "${__matched__}" = 'true' ]; then continue; fi

        # `help` with an unknown name keeps it as the target, so the help
        # command reports it instead of printing the whole script help.
        if [ "${__command__}" = 'help' ] && [ -z "${__help_target__}" ]; then
            __help_target__="${__argument__}"
            continue
        fi

        # Every other argument is a positional or an unknown parameter
        # of the selected command.
        set -- "$@" "${__argument__}"
        if [ "${__has_first_argument__}" = 'false' ]; then
            __first_argument__="${__argument__}"
            case "${__argument__}" in
                -*) __first_argument_is_parameter__='true' ;;
            esac
            __has_first_argument__='true'
        fi
    done

    # Without a command, report the first stray argument as a command or
    # a parameter error, then run the default hook only when silent.
    if [ -z "${__command__}" ]; then
        if [ -n "${__first_argument__}" ]; then
            if [ "${__first_argument_is_parameter__}" = 'true' ]; then
                __message__="\"${__first_argument__}\" is not a valid parameter"
            else
                __message__="\"${__first_argument__}\" is not a valid command"
            fi
            _echo_error "${__message__}\n"
            exit 1
        fi
        _default
        exit 0
    fi

    # Optional pre-execution hook, when the script defines one.
    if [ -n "$(command -v _before)" ]; then _before; fi

    # `help` is special: it never runs, it displays the help of the
    # command that follows it.
    if [ "${__command__}" = 'help' ]; then
        _help "$0" "${__help_target__}" || exit $?
        exit 0
    fi

    #--------------------------------------------------
    # Bind command inputs and dispatch the command
    #--------------------------------------------------

    # Load the entries of this command. Flags start as `false`, and
    # options are reset before receiving their declared default. Every
    # name is checked before any `eval`: a name is a shell identifier,
    # so an untrusted annotation can never inject code.
    __function_parameters__="$(_get_function_parameters \
        "$0" "${__command__}")" || exit 1
    while IFS="${__unit_separator__}" read -r __kind__ \
          __parameter_name__ __short__ __long__ \
          __constraint__ __default_value__ __required__ \
          __description__; do
        case "${__kind__}" in
            flag|option|param) ;;
            *) continue ;;
        esac

        case "${__parameter_name__}" in
            ''|[!A-Za-z_]*|*[!A-Za-z0-9_]*)
                __message__="invalid parameter name: ${__parameter_name__}"
                _echo_error "${__message__}\n"
                exit 1
                ;;
        esac

        if [ "${__kind__}" = 'flag' ]; then
            eval "${__parameter_name__}=false"
        elif [ "${__kind__}" = 'option' ]; then
            eval "${__parameter_name__}=''"
            if [ -n "${__default_value__}" ]; then
                eval "${__parameter_name__}=${__default_value__}"
            fi
        fi
    done <<EOF
${__function_parameters__}
EOF

    # Parse the arguments of this command: flags, options and
    # positionals. Positionals are moved to the back of the positional
    # parameters with the same rotation used for the command line.
    __remaining__=$#

    while [ "${__remaining__}" -gt 0 ]; do
        __argument__="$1"
        shift
        __remaining__=$((__remaining__ - 1))

        # Same terminator, for arguments that reach this loop directly.
        # Everything left is a positional parameter, "-" prefixed or not.
        if [ "${__argument__}" = '--' ]; then
            while [ "${__remaining__}" -gt 0 ]; do
                set -- "$@" "$1"
                shift
                __remaining__=$((__remaining__ - 1))
            done
            break
        fi

        case "${__argument__}" in
            -*)
                __matched__='false'
                while IFS="${__unit_separator__}" read -r __kind__ __parameter_name__ __short__ __long__ __constraint__ __default_value__ __required__ __description__; do
                    if [ "${__kind__}" != 'flag' ] &&
                       [ "${__kind__}" != 'option' ]; then
                        continue
                    fi

                    if [ -z "${__short__}" ]; then
                        __short__="${__parameter_name__}"
                        __short__="${__short__%"${__short__#?}"}"
                    fi
                    __long__="${__long__:-${__parameter_name__}}"

                    if [ "${__argument__}" = "--${__long__}" ] ||
                       [ "${__argument__}" = "--${__parameter_name__}" ] ||
                       [ "${__argument__}" = "-${__short__}" ]; then
                        if [ "${__kind__}" = 'flag' ]; then
                            eval "${__parameter_name__}=true"
                        elif [ "${__remaining__}" -eq 0 ]; then
                            __message__="\"--${__parameter_name__}\""
                            __message__="${__message__} requires value"
                            _echo_error "${__message__}\n"
                            exit 1
                        else
                            __value__="$1"
                            shift
                            __remaining__=$((__remaining__ - 1))
                            _validate "${__parameter_name__}=${__value__}" "${__constraint__}" || exit 1
                            eval "${__parameter_name__}=\"\${__value__}\""
                        fi
                        __matched__='true'
                        break
                    fi
                done <<EOF
${__function_parameters__}
EOF

                if [ "${__matched__}" = 'false' ]; then
                    _echo_error "\"${__argument__}\" is not a valid parameter\n"
                    exit 1
                fi
                ;;
            *)
                set -- "$@" "${__argument__}"
                ;;
        esac
    done

    # Bind the positional parameters to the variables declared by the
    # command shoedoc, then call the command without positional
    # arguments: commands read their values from named variables.
    __status__=0
    if ! _validate_positionals "$0" "${__command__}" "$@"; then
        __status__=1
    else
        "${__command__}" || __status__=$?
    fi

    # Optional post-execution hook, when the script defines one. It runs
    # only when the command succeeded, and never masks the exit status.
    if [ "${__status__}" -eq 0 ] && [ -n "$(command -v _after)" ]; then
        _after || :
    fi

    exit "${__status__}"
}

_kernel "$@"

