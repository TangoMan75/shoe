#!/bin/sh
set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework version 0.4.0-xl
# *
# * This file is distributed under to the MIT license.
# *
# * Copyright (c) 2022 "Matthias Morin" <mat@tangoman.io>
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
# * TangoMan Shoe XL
# *
# * Create self documented shell scripts with argument validation 
# * easily. Prefix a comment with two pound signs on the previous 
# * line of any function or variable you want documented with the 
# * "help" command.
# *
# * Flags are just regular variables with a "false" value assigned.
# *
# * Warning: Functions and variables names should not contain dashes.
# *
# * Note: Version xl is standard version with extra optional features.
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 0.4.0-xl
# * @link    https://github.com/TangoMan75/shoe
# */

#--------------------------------------------------
# Place your parameters after this line
#--------------------------------------------------

## Who do you want to say "hello" to ? /[a-zA-Z]+/
who="World"

## How many times to say hello /[1-9]/
count=1

## Environment /(prod|dev|test)/
env="dev"

#--------------------------------------------------
# Place flags after this line
#--------------------------------------------------

## Enable FooBar mode
flag=false

## Install script globally
global=false

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Constants are ignored (must be uppercase)
VERSION=0.3.0

## Private constants are prefixed with underscore
_SECRET=this_not_so_secret

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Say hello to arbitrary recipient
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello ${who} !"
        loop=$((loop+1))
    done

    if [ "${flag}" = true ]; then
        echo "FOOBAR MODE ENABLED !"
    fi
}

### Installation

## Install script and enable completion (run with root permissions)
install() {
    _set_autocomplete

    if [ "${global}" = true ]; then
        _install
    else
        _symlink
    fi
}

## Uninstall script from system
uninstall() {
    _uninstall
}

## Enable zsh autocompletion (run with user permissions)
zsh() {
    _set_zsh_completion_autoload
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

### This is a divider

## This is a private function
_version() {
    echo "${env}"
    echo "${VERSION}"
    echo "${_SECRET}"
}

#--------------------------------------------------
# copy/paste here TangoMan helper functions
# (like a nice set of semantic colors)
#--------------------------------------------------

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n';
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

echo_primary()   { printf "%b%b${DEFAULT}" "${PRIMARY}"   "${*}"; }
echo_secondary() { printf "%b%b${DEFAULT}" "${SECONDARY}" "${*}"; }
echo_success()   { printf "%b%b${DEFAULT}" "${SUCCESS}"   "${*}"; }
echo_danger()    { printf "%b%b${DEFAULT}" "${DANGER}"    "${*}"; }
echo_warning()   { printf "%b%b${DEFAULT}" "${WARNING}"   "${*}"; }
echo_info()      { printf "%b%b${DEFAULT}" "${INFO}"      "${*}"; }
echo_light()     { printf "%b%b${DEFAULT}" "${LIGHT}"     "${*}"; }
echo_dark()      { printf "%b%b${DEFAULT}" "${DARK}"      "${*}"; }

echo_label()     { if [ $# -eq 2 ]; then printf "%b%-${1}s ${DEFAULT}" "${SUCCESS}" "$2"; else printf "%b%b ${DEFAULT}" "${SUCCESS}" "${*}"; fi }
echo_error()     { printf "%berror: %b${DEFAULT}" "${DANGER}"  "${*}"; }

alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "${*}" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "${*}" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "${*}" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "${*}" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "${*}" "${ALERT_WARNING}"   ''; }
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "${*}" "${ALERT_INFO}"      ''; }
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "${*}" "${ALERT_LIGHT}"     ''; }
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "${*}" "${ALERT_DARK}"      ''; }

#--------------------------------------------------
# You do not need to worry about anything that's
# placed after this line. ;-)
#--------------------------------------------------

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title)"
    _print_infos       "${_padding}"
    _print_description "$(_get_docbloc_description)"
    _print_usage
    _print_constants   "${_padding}"
    _print_flags       "${_padding}"
    _print_options     "${_padding}"
    _print_commands    "${_padding}"
}

#--------------------------------------------------

_print_title() {
    printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" '' "$1" '';
}

_print_infos() {
    _padding="$1"
    if [ -z "$1" ]; then _padding=12; fi
    printf "%bInfos:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${SUCCESS}  %-${_padding}s ${DEFAULT}%s\n" 'author'  "$(_get_docbloc 'author')"
    printf "${SUCCESS}  %-${_padding}s ${DEFAULT}%s\n" 'version' "$(_get_docbloc 'version')"
    printf "${SUCCESS}  %-${_padding}s ${DEFAULT}%s\n" 'link'    "$(_get_docbloc 'link')"
    printf '\n'
}

_print_description() {
    printf "%bDescription:%b\n" "${WARNING}" "${DEFAULT}"
    printf "\033[97m  %s${EOL}\n" "$(printf '%s' "$1" | fold -w 64 -s)"
}

_print_usage() {
    printf "%bUsage:%b\n" "${WARNING}" "${DEFAULT}"
    printf "${INFO}  sh %s${INFO} [${SUCCESS}command${INFO}]${DEFAULT} " "$(basename "$0")"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s=${WARNING}%s${INFO})${DEFAULT} \", \$1, \$2
    } { PREV = \$0 }" "$0"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 == \"false\" && substr(\$0, 1, 1) != \"_\")
        printf \"${INFO}(${SUCCESS}--%s${INFO})${DEFAULT} \", \$1
    } { PREV = \$0 }" "$0"
    printf '\n\n'
}

_print_constants() {
    _padding="$1"
    if [ -z "$1" ]; then _padding=12; fi
    printf "%bConstants:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 == toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$((_padding+2))s ${DEFAULT}%s${INFO} (value: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_flags() {
    _padding="$1"
    if [ -z "$1" ]; then _padding=12; fi
    printf "%bFlags:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  --%-$((_padding))s ${DEFAULT}%s\n\", \$1, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_options() {
    _padding="$1"
    if [ -z "$1" ]; then _padding=12; fi
    printf "%bOptions:%b\n" "${WARNING}" "${DEFAULT}"
    awk -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0, 1, 1) != \"_\") {
            if (match(PREV, / \/.+\//)) {
                CONSTRAINT=substr(PREV, RSTART, RLENGTH);
                ANNOTATION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                printf \"${SUCCESS}  --%-$((_padding))s ${DEFAULT}%s${SUCCESS}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, ANNOTATION, CONSTRAINT, \$2
            } else {
                printf \"${SUCCESS}  --%-$((_padding))s ${DEFAULT}%s${INFO} (default: ${WARNING}%s${INFO})${EOL}\", \$1, substr(PREV, 4), \$2
            }
        }
    } { PREV = \$0 }" "$0"
    printf '\n'
}

_print_commands() {
    _padding="$1"
    if [ -z "$1" ]; then _padding=12; fi
    printf "%bCommands:%b\n" "${WARNING}" "${DEFAULT}"
    awk "/^### /{printf\"\n${WARNING}%s:${EOL}\",substr(\$0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\");
        FUNCTION = substr(\$0, 1, index(\$0, \"{\"));
        sub(\"{\$\", \"\", FUNCTION);
        if (substr(PREV, 1, 3) == \"## \" && substr(\$0, 1, 1) != \"_\")
        printf \"${SUCCESS}  %-$((_padding+2))s ${DEFAULT}%s\n\", FUNCTION, substr(PREV, 4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

#--------------------------------------------------

_get_docbloc_title() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$0"
}

_get_docbloc_description() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$0"
}

_get_docbloc() {
    # to change displayed items, edit docblock infos at the top of this file ↑
    awk -v TAG="$1" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$0"
}

_get_padding() {
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0, 1, index($0, "{"));
        sub("{$", "", MATCH);
    } { if (substr(PREV, 1, 3) == "## " && substr(MATCH, 1, 1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+1 }' "$0"
}

#--------------------------------------------------

_get_functions() {
    # this regular expression matches functions with either bash or sh syntax
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");   # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0, 1, index($0, "{")); # truncate string after opening curly brace
        sub("{$", "", FUNCTION);                  # remove trailing curly brace
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_") print FUNCTION
    } { PREV = $0 }' "$0"
}

_get_variables() {
    # constants, flags and private variables will be ignored
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")print $1
    } { PREV = $0 }' "$0"
}

_get_flags() {
    # flags are just regular variables with a value set to "false"
    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") print $1
    } { PREV = $0 }' "$0"
}

_get_constraints() {
    awk -v NAME="$1" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$0"
}

_validate() {
    # find constraints and validates a variable from parameter string. e.g: "variable_name=value"
    _validate_variable=$(printf '%s' "$1" | cut -d= -f1)
    _validate_value=$(printf '%s' "$1" | cut -d= -f2)
    _validate_pattern=$(_get_constraints "${_validate_variable}")

    if [ "$(_is_valid "${_validate_value}" "${_validate_pattern}")" = false ]; then
        printf "${DANGER}error: invalid \"%s\", expected \"%s\", \"%s\" given${EOL}" "${_validate_variable}" "${_validate_pattern}" "${_validate_value}"
        exit 1
    fi
}

_is_valid() {
    if [ $# -lt 2 ]; then
        echo_error 'some mandatory argument is missing\n'
        exit 1
    fi

    if [ $# -gt 2 ]; then
        echo_error "too many arguments: expected 2, $# given.\n"
        exit 1
    fi

    _is_valid_value="$1"
    _is_valid_pattern="$2"

    # missing pattern always returns valid status
    if [ -z "${_is_valid_pattern}" ]; then
        echo true
        return 0
    fi

    if [ "${_is_valid_value}" != "$(printf '%s' "${_is_valid_value}" | awk "match(\$0, ${_is_valid_pattern}) {print substr(\$0, RSTART, RLENGTH)}")" ]; then
        echo false
        return 0
    fi

    echo true
}

#--------------------------------------------------
# Use this section for installation and autocompletion
#--------------------------------------------------

## Install script globally (via copy)
_install() {
    if [ "$(_is_root)" = false ]; then
        echo_error 'cannot install, permission denied\n'
        exit 1
    fi

    echo_info "cp -af \"$0\" \"/usr/local/bin/$(basename "$0" .sh)\"\n"
    cp -af "$0" "/usr/local/bin/$(basename "$0" .sh)"
}

## Install script globally (via symlink in /usr/local/bin/ directory)
_symlink(){
    if [ "$(_is_root)" = false ]; then
        echo_error 'cannot create symlink, permission denied\n'
        exit 1
    fi

    # remove previous install if any
    echo_info "rm -f \"/usr/local/bin/$(basename "$0" .sh)\"\n"
    rm -f "/usr/local/bin/$(basename "$0" .sh)"

    echo_info "ln -s \"$(realpath "$0")\" \"/usr/local/bin/$(basename "$0" .sh)\"\n"
    ln -s "$(realpath "$0")" "/usr/local/bin/$(basename "$0" .sh)"
}

## Uninstall script from system
_uninstall() {
    if [ -n "$(command -v zsh)" ]; then
        _remove_zsh_completion_autoload
    fi

    echo_info "rm -f \"./$(basename "$0" .sh)-completion.sh\"\n"
    rm -f "./$(basename "$0" .sh)-completion.sh"

    if [ "$(_is_root)" = false ]; then
        echo_error 'cannot uninstall, permission denied\n'
        return 0
    fi

    echo_info "rm -f /usr/local/bin/$(basename "$0" .sh)\n"
    rm -f /usr/local/bin/"$(basename "$0" .sh)"

    echo_info "rm -f /etc/bash_completion.d/$(basename "$0" .sh)\n"
    rm -f /etc/bash_completion.d/"$(basename "$0" .sh)"
}

## Create autocomplete script
_set_autocomplete(){
    # check autocomplete tutorial here : https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial
    if [ "${global}" = true ] && [ "$(_is_root)" = true ]; then
        echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$(basename "$0" .sh)\" > \"/etc/bash_completion.d/$(basename "$0" .sh)\"\n"
        printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$(basename "$0" .sh)" > "/etc/bash_completion.d/$(basename "$0" .sh)"
    else
        set -- "./$(basename "$0" .sh)-completion.sh"
        echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_comspec)\" \"$(basename "$0")\" > \"./$(basename "$0" .sh)-completion.sh\"\n"
        printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_comspec)" "$(basename "$0")" > "./$(basename "$0" .sh)-completion.sh"
    fi
}

## Generate comspec string
_comspec() {
    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
        printf "%s ", FUNCTION, substr(PREV, 4)
    } { PREV = $0 }' "$0"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_") {
            printf "--%s ", $1
        }
    } { PREV = $0 }' "$0"
}

## Set completion script autoload in ~/.zshrc (optional)
_set_zsh_completion_autoload() {
    if [ -z "$(command -v zsh)" ]; then
        echo_error 'zsh not installed'
        return 1
    fi

    if [ "$(_is_root)" = true ]; then
        echo_warning 'cannot update "~/.zshrc"\n'
        return 1
    fi

    if [ ! -f ~/.zshrc ]; then
        echo_error 'file not found : "~/.zshrc"\n'
        return 1
    fi

    # remove previous install if any
    sed -i "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" ~/.zshrc

    if [ -f "/etc/bash_completion.d/$(basename "$0" .sh)" ]; then
        set -- "/etc/bash_completion.d/$(basename "$0" .sh)"
    elif [ -f "./$(basename "$0" .sh)-completion.sh" ]; then
        set -- "./$(basename "$0" .sh)-completion.sh"
    else
        echo_error 'completion script not found\n'
        return 1
    fi

    printf '\n###> %s\nsource %s\n###< %s\n' "$(basename "$0" .sh)" "$(realpath "$1")" "$(basename "$0" .sh)" >> ~/.zshrc
}

## Remove completion script autoload from ~/.zshrc
_remove_zsh_completion_autoload() {
    if [ -z "$(command -v zsh)" ]; then
        echo_error 'zsh not installed'
        return 1
    fi

    if [ "$(_is_root)" = true ]; then
        echo_warning 'cannot update "~/.zshrc"\n'
        return 1
    fi

    if [ ! -f ~/.zshrc ]; then
        echo_error 'file not found : "~/.zshrc"\n'
        return 1
    fi

    echo_info "sed -i \"/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d\" ~/.zshrc\n"
    sed -i "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" ~/.zshrc
}

#--------------------------------------------------

## Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        echo true
        return 0
    fi

    echo false
}

## Install required dependency
_require() {
    # Synopsys : _require [command] (package_name) (package_manager_command)
    # "_package_name" is the same as "_command" by default, except when given arguments
    # eg: `_require curl` will install "curl" with "sudo apt-get install -y curl" if command is unavailable
    # eg: `_require adb android-tools-adb` will install "android-tools-adb" package if "adb" command is unavailable
    # eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn" if command is unavailable

    if [ ${#} -lt 1 ]; then
        echo_error 'some mandatory parameter is missing\n'
        return 1
    fi

    if [ ${#} -gt 3 ]; then
        echo_error "too many arguments (${#})\n"
        return 1
    fi

    if [ ! -x "$(command -v "$1")" ]; then
        _package_name=${2:-$1}
        if [ -z "$3" ]; then
            _command="sudo apt-get install -y ${_package_name}"
        else
            _command="$3 ${_package_name}"
        fi
        echo_info "${_command}\n"
        ${_command}
    fi
}

#--------------------------------------------------
# This is the main loop
# you may remove parts you don't use
#--------------------------------------------------

_main() {
    if [ $# -lt 1 ]; then
        help
        exit 0
    fi

    _error=''
    _eval=''
    _execute=''
    for _argument in "$@"; do
        _is_valid=false
        # check argument is a valid option (must start with - or -- and contain =)
        if [ -n "$(printf '%s' "${_argument}" | awk '/^--?[a-zA-Z0-9_]+=.+$/{print}')" ]; then
            for _variable in $(_get_variables); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_variable}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "$(printf '%s' "${_argument}" | cut -d= -f1)" = "--${_variable}" ] || [ "$(printf '%s' "${_argument}" | cut -d= -f1)" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_variable}=$(printf '%s' "${_argument}" | cut -d= -f2)"
                    _is_valid=true
                    break
                fi
            done
        # check argument is a valid flag (must start with - or --)
        elif [ -n "$(printf '%s' "${_argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            for _flag in $(_get_flags); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "--${_flag}" ] || [ "${_argument}" = "-${_shorthand}" ]; then
                    # append argument to the eval stack
                    _eval="${_eval} ${_flag}=true"
                    _is_valid=true
                    break
                fi
            done
        else
            for _function in $(_get_functions); do
                # get shorthand character
                _shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${_argument}" = "${_function}" ] || [ "${_argument}" = "${_shorthand}" ]; then
                    # append argument to the execute stack
                    _execute="${_execute} ${_function}"
                    _is_valid=true
                    break
                fi
            done
        fi
        if [ "${_is_valid}" = false ]; then
            _error="${_error} ${_argument}"
        fi
    done

    # unknown parameters will raise errors
    for _argument in ${_error}; do
        _shorthand="$(printf '%s' "${_argument}" | awk '{$0=substr($0, 1, 1); print}')"
        if [ "${_shorthand}" = '-' ]; then
            printf "${DANGER}error: \"%s\" is not a valid option${EOL}" "${_argument}"
        else
            printf "${DANGER}error: \"%s\" is not a valid command${EOL}" "${_argument}"
        fi
        exit 1
    done

    # variables must be set before running functions for obvious reasons
    for _variable in ${_eval}; do
        # invalid parameters will raise errors
        _validate "${_variable}"
        eval "${_variable}"
    done

    for _function in ${_execute}; do
        eval "${_function}"
    done
}

_main "$@"
