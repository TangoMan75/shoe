#!/usr/bin/env sh

set -e

# This script is based on TangoMan Shoe Shell Microframework
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2025 "Matthias Morin" <mat@tangoman.io>
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

## TangoMan Shoemaker
##
## A versatile developement tool to split a script file into its components,
## build a script from a build.lst file, generate Makefile or Markdown
## documentation from a shoe script.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 1.0.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoemaker.sh

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Source file /^~?[a-zA-Z0-9./_-]+$/
file=''

## Destination directory /^~?[a-zA-Z0-9/._-]+$/
destination=''

## Script type /(shell|bash)/
type=shell

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Document private elements
private=false

#--------------------------------------------------
# Place your private constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Dump functions
dump() {
    if [ ! -f "${file}" ]; then
        echo_danger "error: \"${file}\" file not found\n"
        return 1
    fi
    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/dump/$(basename "${file}" .sh)"
    fi
    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi
    destination="$(realpath "${destination}")"

    echo_success "Dumping functions from \"${file}\" to \"${destination}\"\n"
    for name in $(_get_functions_names "${file}" true); do
        printf '#!/bin/sh\n\n' > "${destination}/${name}.sh"
        _get_function "${file}" "${name}" >> "${destination}/${name}.sh"
    done
}

## Dump "build.shoe" file
list() {
    if [ ! -f "${file}" ]; then
        echo_danger "error: \"${file}\" file not found\n"
        return 1
    fi

    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/dump/$(basename "${file}" .sh)"
    fi

    destination="$(realpath "${destination}")"
    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    echo_success "Listing functions from \"${file}\" to \"${destination}/$(basename "${file}" .sh).shoe\"\n"
    _get_functions_names "${file}" true | sed 's/$/.sh/g' > "${destination}/$(basename "${file}" .sh).shoe"
}

## Build from given "build.shoe" file
build() {
    if [ ! -f "${file}" ]; then
        echo_danger "error: \"${file}\" file not found\n"
        return 1
    fi
    file="$(realpath "${file}")"

    if [ -z "${destination}" ]; then
        destination="$(_pwd)/build"
    fi
    destination="$(realpath "${destination}")"

    if [ ! -d "${destination}" ]; then
        mkdir -p "${destination}"
    fi

    _build "${file}" "${destination}" "${type}"
}

## Build all scripts
build_all() {
    build_folder="$(_pwd)/build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find "$(_pwd)/recipes" -type f -name '*.shoe' | while read -r file_path
    do
        _build "${file_path}" "${build_folder}" "${type}"
    done
}

##################################################
### Documentation
##################################################

## Generate Markdown documentation for provided shoe script
generate_doc() {
    _generate_doc "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).md" "${private}"
}

## Generate Markdown documentation for all scripts
generate_doc_all() {
    doc_folder="$(_pwd)/doc"

    if [ ! -d "${doc_folder}" ]; then
        mkdir -p "${doc_folder}"
    fi

    find "$(_pwd)/build" -type f -name '*.sh' | while read -r file_path
    do
        _generate_doc "${file_path}" "${doc_folder}" "$(basename "${file_path}" .sh).md" "${private}"
    done
}

##################################################
### Make
##################################################

## Generate Markdown documentation for provided shoe script
generate_makefile() {
    _generate_makefile "$(realpath "${file}")" "${destination}" "$(basename "${file}" .sh).makefile"
}

## Generate Makefile for all scripts
generate_makefile_all() {
    build_folder="$(_pwd)/build"

    if [ ! -d "${build_folder}" ]; then
        mkdir -p "${build_folder}"
    fi

    find "${build_folder}" -type f -name '*.sh' | while read -r file_path
    do
        _generate_makefile "${file_path}" "${build_folder}" "$(basename "${file_path}" .sh).makefile"
    done
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

# Build from given "build.shoe" file
_build() {
    # Synopsis: _build <FILE_PATH> <DESTINATION> [TYPE]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  The path to the destination folder.
    #   TYPE:         (optional) The script type to build (bash or sh). Will default to "sh".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _build: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _build: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _build: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _build: \"$2\" folder not found\n"; return 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

    __output__="$2/$(basename "$1" .shoe).sh"

    alert_primary "Building $(basename "$1" .shoe).sh"

    echo_info "rm -f \"${__output__}\"\n"
    rm -f "${__output__}"

    # shellcheck disable=SC2094
    while read -r __current_line__; do
        if [ "$(printf '%s' "${__current_line__}" | cut -c 1)" = "#" ] || [ -z "${__current_line__}" ]; then
            printf '%s\n' "${__current_line__}" >> "${__output__}"
            continue
        fi

        __source_file__="$(dirname "$1")/${__current_line__}"
        if [ ! -f "${__source_file__}" ]; then
            echo_danger "error: \"${__source_file__}\": file not found\n"

            return 1
        fi
        echo_info "${__source_file__}\n"

        printf '%s\n' "$(cat "${__source_file__}")" >> "${__output__}"
    done < "$1"

    # Remove all "#!/bin/bash" or "#!/bin/sh" from result file
    echo_info "$(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' \"${__output__}\"\n"
    $(_sed_i) -r 's/^#!\/bin\/(bash|sh)$//g' "${__output__}"

    # Prepend shebang
    if [ "$3" = bash ]; then
        echo_info "$(_sed_i) '1i#!\/usr\/bin\/env bash' \"${__output__}\"\n"
        $(_sed_i) '1i#!\/usr\/bin\/env bash' "${__output__}"
    else
        echo_info "$(_sed_i) '1i#!\/usr\/bin\/env sh' \"${__output__}\"\n"
        $(_sed_i) '1i#!\/usr\/bin\/env sh' "${__output__}"
    fi

    _collapse_blank_lines "${__output__}"

    echo_success "\"${__output__}\" generated\n"
}

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install() {
    _install "$0" "${ALIAS}" "${global:-false}"
}

## Uninstall script from system
self_uninstall() {
    _uninstall "$0" "${ALIAS}"
}

## Update script from @update
self_update() {
    _annotations="$(_get_script_shoedoc "$0")"
    _update_link="$(_get_annotation_tags "${_annotations}" 'update')"
    if [ -z "${_update_link}" ]; then
        echo_danger 'cannot update: "@update" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS}" "${global:-false}"
}

##################################################
### Help
##################################################

## Print this help
help() {
    _help "$0"
}

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

# Place here commands you need executed by default (optional)
_default() {
    help
}

# Place here commands you need executed first every time (optional)
_before() {
    _check_installed awk
    _check_installed sed
}

# Place here commands you need executed last every time (optional)
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
#_ Bashdoc
#--------------------------------------------------

# Get shoedoc description
_get_shoedoc_description() {
    # Synopsis: _get_shoedoc_description <TEXT>
    #   TEXT: The input shoedoc annotation bloc.

    if [ -z "$1" ]; then echo_danger 'error: _get_shoedoc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_shoedoc_description: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk '/^#.*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            count+=1;
            if (count==2 && RESULT=="") next;
            if (count>1) print RESULT
        }
    }'
}

# Get shoedoc
_get_shoedoc() {
    # Synopsis: _get_shoedoc <TEXT>
    #   TEXT: The input shoedoc annotation bloc.
    #   note: Remove every line that does not start with a pound character or contains a tag
    #         Returns string without leading pound characters

    if [ -z "$1" ]; then echo_danger 'error: _get_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_shoedoc: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk '/^#.*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT
        }
    }'
}

# Return given tag values from shoedoc bloc
_get_shoedoc_tag() {
    # Synopsis: _get_shoedoc_tag <TEXT> <TAG_NAME>
    #   TEXT:     The input shoedoc annotation bloc.
    #   TAG_NAME: The name of tag to return.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_shoedoc_tag: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_shoedoc_tag: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk -v TAG="$2" '/^#.*/ {
        if ($2=="@"TAG) {
            gsub(" +"," "); sub("^ +",""); sub(" +$",""); # trim input
            RESULT=substr($0,length($1)+length($2)+3);    # remove leading pound character(s)
            print RESULT
        }
    }'
}

# Get shoedoc title
_get_shoedoc_title() {
    # Synopsis: _get_shoedoc_title <TEXT>
    #   TEXT: The input shoedoc annotation bloc.
    #   note: Returns the first line that does not contain a tag

    if [ -z "$1" ]; then echo_danger 'error: _get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_shoedoc_title: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | awk '/^#.*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

# Get shoedoc bloc at the top the provided shoe script file
_get_script_shoedoc() {
    # Synopsis: _get_script_shoedoc <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.
    #   note:        Each shoedoc should strictly start with two pound signs (##)
    #                Returns the first valid docbloc found in the provided file

    if [ -z "$1" ]; then echo_danger 'error: _get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_script_shoedoc: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

    awk '/^## */ {count+=1; print} !/^## */ {if (count>1) exit}' "$1"
}

#--------------------------------------------------
#_ Colors
#--------------------------------------------------

# shellcheck disable=SC2034

# PRIMARY: bright white text
PRIMARY='\033[97m'

# SECONDARY: bright blue text
SECONDARY='\033[94m'

# SUCCESS: bright green text
SUCCESS='\033[32m'

# DANGER: red text
DANGER='\033[31m'

# WARNING: orange text
WARNING='\033[33m'

# INFO: bright purple text
INFO='\033[95m'

# LIGHT: black text over white background
LIGHT='\033[47;90m'

# DARK: white text over black background
DARK='\033[40;37m'

# DEFAULT: reset formatting
DEFAULT='\033[0m'

# EOF: reset formatting and carriage return
EOL='\033[0m\n'

# shellcheck disable=SC2034

# ALERT_PRIMARY: bold white text over bright blue background
ALERT_PRIMARY='\033[1;104;97m'

# ALERT_SECONDARY: bold white text over bright purple background
ALERT_SECONDARY='\033[1;45;97m'

# ALERT_SUCCESS: bold white text over bright green background
ALERT_SUCCESS='\033[1;42;97m'

# ALERT_DANGER: bold white text over bright red background
ALERT_DANGER='\033[1;41;97m'

# ALERT_WARNING: bold white text over bright orange background
ALERT_WARNING='\033[1;43;97m'

# ALERT_INFO: bold white text over bright blue background
ALERT_INFO='\033[1;44;97m'

# ALERT_LIGHT: bold grey text over white background
ALERT_LIGHT='\033[1;47;90m'

# ALERT_DARK: bold white text over black background
ALERT_DARK='\033[1;40;37m'

# Print primary text with optional indentation and padding
echo_primary() {
    # Synopsis: echo_primary <STRING> [INDENTATION] [PADDING]
    #  STRING:      Text to display.
    #  INDENTATION: Indentation level (default: 0).
    #  PADDING:     Padding length (default: 0).
    #  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #               this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print secondary text with optional indentation and padding
echo_secondary() {
    # Synopsis: echo_secondary <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

# Print success text with optional indentation and padding
echo_success() {
    # Synopsis: echo_success <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print danger text with optional indentation and padding
echo_danger() {
    # Synopsis: echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''
}

# Print warning text with optional indentation and padding
echo_warning() {
    # Synopsis: echo_warning <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print info text with optional indentation and padding
echo_info() {
    # Synopsis: echo_info <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''
}

# Print light text with optional indentation and padding
echo_light() {
    # Synopsis: echo_light <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''
}

# Print dark text with optional indentation and padding
echo_dark() {
    # Synopsis: echo_dark <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${DARK}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''
}

# Print primary alert
alert_primary()   {
    # Synopsis: alert_primary <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''
}

# Print secondary alert
alert_secondary() {
    # Synopsis: alert_secondary <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''
}

# Print success alert
alert_success()   {
    # Synopsis: alert_success <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''
}

# Print danger alert
alert_danger()    {
    # Synopsis: alert_danger <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''
}

# Print warning alert
alert_warning()   {
    # Synopsis: alert_warning <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''
}

# Print info alert
alert_info()      {
    # Synopsis: alert_info <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''
}

# Print light alert
alert_light()     {
    # Synopsis: alert_light <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''
}

# Print dark alert
alert_dark()      {
    # Synopsis: alert_dark <STRING>
    #   STRING: Text to display.

    printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''
}

#--------------------------------------------------
#_ Compatibility
#--------------------------------------------------

# Return sed -i system flavour
_sed_i() {
    # Synopsis: _sed_i

    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
#_ Documentation
#--------------------------------------------------

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
    #   SCRIPT_PATH:      The path to the input file.
    #   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME: (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
    #   GET_PRIVATE:      (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then echo_danger 'error: _generate_doc: file should be type ".sh"\n'; return 1; fi

    alert_primary "Generating $3"

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
                sub("^#+ ","",PREV);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,PREV,$2
            } {PREV = $0}' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                printf "%d. **`%s` (private)**\n> %s\n  - Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,substr(PREV,4)
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (match(PREV,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(PREV,RSTART+1,RLENGTH);
                    DESCRIPTION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                    printf "%d. **`--%s`**\n> %s\n  - Constraint: `%s`\n  - Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`%s`**\n> %s\n  - Default: _%s_",++i,$1,substr(PREV,4),$2
                }
                printf "\n\n"
            } {PREV = $0}' "$1"
        fi

        printf '## 🤖 Commands\n\n'
        awk -v GET_PRIVATE="$4" '/^#+/ {
                if (summary=="") {
                    summary=$0
                } else {
                    annotation=substr($0,length($1)+2);
                    if (annotation!="") annotations=annotations"\n"annotation
                }
            }
            /^#(##|_) / { # print section / divider
                if (GET_PRIVATE == "false" && $1 == "#_") next;
                sub("^#(##|_) +","");
                i=0; printf"### ⚡ %s\n\n",$0
            }
            in_function {
                # print comments
                if (sub("^ +# ","&")<1) {
                    print ""; in_function=0; next;
                }
                sub("^ +# ",""); gsub("<","\&lt;"); gsub(">","\&gt;"); printf "> %s<br>\n",$0;
            }
            /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
                function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
                sub("^function ","",function_name);         # remove leading "function " if present
                gsub(" +","",function_name);                # trim whitespaces
                is_private="";
                if (substr(summary,1,3) != "## " || substr(function_name,1,1) == "_") is_private=" (private)";
                if (GET_PRIVATE == "false" && is_private != "") next;
                in_function=1;
                printf "#### %d. `%s`%s\n\n",++i,function_name,is_private
                if (summary!="") {
                    sub("^##? ","",summary);
                    printf "%s\n\n",summary
                }
                if (annotations!="") {
                    sub("^\n","",annotations); # remove all leading "\n";
                    printf "```json\n%s\n```\n\n",annotations
                }
            }
            !/^#+/ { summary=""; annotations="" }' "$1"
    ) >> "$2/$3"

    echo_success "Documentation generated : \"$2/$3\"\n"
}

#--------------------------------------------------
#_ Help
#--------------------------------------------------


# Print help for provider shoe script
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _help: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _help: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _help: \"$1\" file not found\n"; return 1; fi

    __padding__=$(_get_padding "$1")
    __annotations__=$(_get_script_shoedoc "$1")

    alert_primary "$(_get_shoedoc_title "${__annotations__}")"

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
}

# List commands of the provided shoe script (used by "help" command)
_print_commands() {
    # Synopsis: _print_commands <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then echo_danger 'error: _print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_commands: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then echo_danger "error: _print_commands: \"$1\" file not found\n"; return 1; fi

    echo_warning 'Commands:\n'
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" \
    '/^### /{printf"\n%s%s:%s\n",WARNING,substr($0,5),PRIMARY}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_") # ignore private functions
        printf "%s  %-'"$2"'s %s%s\n",SUCCESS,function_name,PRIMARY,annotation;
        annotation=""
    }' "$1"
    printf '\n'

}

# List constants of the provided shoe script (used by "help" command)
_print_constants() {
    # Synopsis: _print_constants <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then echo_danger 'error: _print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_constants: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then echo_danger "error: _print_constants: \"$1\" file not found\n"; return 1; fi

    echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" -v INFO="${INFO}" -v WARNING="${WARNING}" -v EOL="${EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$1"
    printf '\n'
}

# Print provided text formatted as a description (used by "help" command)
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION: A string containing script description.

    echo_warning 'Description:\n'
    echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

# List flags of the provided shoe script (used by "help" command)
_print_flags() {
    # Synopsis: _print_flags <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then echo_danger 'error: _print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_flags: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then echo_danger "error: _print_flags: \"$1\" file not found\n"; return 1; fi

    echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-'"$2"'s %s%s\n",SUCCESS,$1,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$1"
    printf '\n'
}

# Print infos of the provided shoe script (used by "help" command)
_print_infos() {
    # Synopsis: _print_infos <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _print_infos: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _print_infos: \"$1\" file not found\n"; return 1; fi

    __annotations__=$(_get_script_shoedoc "$1")

    echo_warning 'Infos:\n'
    echo_success 'author'  2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    echo_success 'version' 2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    echo_success 'link'    2 8; echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

# List options of the provided shoe script (used by "help" command)
_print_options() {
    # Synopsis: _print_options <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then echo_danger 'error: _print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_options: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then echo_danger "error: _print_options: \"$1\" file not found\n"; return 1; fi

    echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v INFO="${INFO}" -v DEFAULT="${DEFAULT}" -v EOL="${EOL}" \
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

# Print usage of the provided shoe script (used by "help" command)
_print_usage() {
    # Synopsis: _print_usage <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _print_usage: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _print_usage: \"$1\" file not found\n"; return 1; fi

    echo_warning 'Usage:\n'
    echo_info "sh $(basename "$1") <" 2; echo_success 'command'; echo_info '> '
    # options
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v WARNING="${WARNING}" -v DEFAULT="${DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s--%s%s]%s ",INFO,SUCCESS,$1,INFO,DEFAULT;next}
        printf "%s[%s--%s %s%s%s]%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0} END {print "\n"}' "$1"
}

#--------------------------------------------------
#_ Install
#--------------------------------------------------

# Install script via copy
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file
    #   note:      Creates a symbolic link in the /usr/local/bin/ directory.

    if [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _copy_install: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; return 1; fi

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

# Generates an autocomplete script for the provided file
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file
    #   note:      This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #              Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
    #              Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins

    if [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

# Creates a system-wide autocomplete script for the provided file
_generate_global_autocomplete() {
    # Synopsis: _generate_global_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file
    #   note:      This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
    #              in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #              It uses sudo for file creation in a system directory, requiring root privileges.

    if [ -z "$1" ]; then echo_danger 'error: _generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_global_autocomplete: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

# Generate comspec string for the provided file
_get_comspec() {
    # Synopsis: _get_comspec <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_comspec: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_comspec: \"$1\" file not found\n"; return 1; fi

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

# Install script and enable completion
_install() {
    # Synopsis: _install <FILE_PATH> [ALIAS] [GLOBAL]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:    (optional) Install globally. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _install: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _install: \"$1\" file not found\n"; return 1; fi

    if [ "$3" = true ]; then
        _copy_install "$1" "$2"
        _generate_global_autocomplete "$1" "$2"
    else
        _symlink_install "$1" "$2"
        _generate_autocomplete "$1" "$2"
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
            _set_completion_autoload ~/.profile "$1" "$2"
        else
            _set_completion_autoload ~/.bashrc "$1" "$2"
        fi
    fi
}

# Remove completion script autoload
_remove_completion_autoload() {
    # Synopsis: _remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE: The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:             (optional) The alias of the script to remove. Defaults to the basename of the provided file

    if [ ${#} -lt 1 ]; then echo_danger 'error: _remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_completion_autoload: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

# Adds an autoload line for completion script to a shell configuration file
_set_completion_autoload() {
    # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <SCRIPT_FILE_PATH> [ALIAS]
    #   SHELL_CONFIG_FILE_PATH: The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_FILE_PATH:       The path to the input file.
    #   ALIAS:                  (optional) The alias of the input script. Defaults to the basename of the provided file

    if [ -z "$1" ]  || [ -z "$2" ]; then echo_danger 'error: _set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_completion_autoload: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$2" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then echo_danger "error: _set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    # declare inner function
    __set_completion_autoload() {
        # Synopsis: __set_completion_autoload <SHELL_CONFIG_FILE_PATH> <COMPLETION_FILE_PATH> <ALIAS>
        # remove previous install if any
        $(_sed_i) "/^###> $3$/,/^###< $3$/d" "$1"

        echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$3\" \"$2\" \"$3\" >> \"$1\"\n"
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

# Install script via symlink
_symlink_install(){
    # Synopsis: _symlink_install <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file
    #   note:      Creates a symbolic link in the /usr/local/bin/ directory.

    if [ -z "$1" ]; then echo_danger 'error: _symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _symlink_install too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _symlink_install \"$1\" file not found\n"; return 1; fi

    echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    sudo ln -s "$1" "/usr/local/bin/$2"
}

# Uninstall script from system
_uninstall() {
    # Synopsis: _uninstall <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.

    if [ -z "$1" ]; then echo_danger 'error: _uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _uninstall: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _uninstall: \"$1\" file not found\n"; return 1; fi

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    if [ -f "$1" ]; then
        echo_info "sudo rm -f \"/usr/local/bin/$2\"\n"
        sudo rm -f "/usr/local/bin/$2"
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

# Updates given script from the provided URL
_update() {
    # Synopsis: _update <FILE_PATH> <URL> [ALIAS] [GLOBAL]
    #   FILE_PATH: The path to the input file.
    #   URL:       The URL of the script to download and install.
    #   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:    (optional) Install globally. Defaults to "false".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _update: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    if _is_installed curl; then
        echo_info "curl -sSL \"$2\" > \"$1\"\n"
        curl -sSL "$2" > "$1"

    elif _is_installed  wget; then
        echo_info "wget -qO - \"$2\" > \"$1\"\n"
        wget -qO - "$2" > "$1"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    _uninstall "$1" "$3"
    _install "$1" "$3" "$4"
}

#--------------------------------------------------
#_ Make
#--------------------------------------------------

# Generate Makefile for provided shoe script
_generate_makefile() {
    # Synopsis: _generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]
    #   SCRIPT_PATH:      The path to the input script.
    #   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME: (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then echo_danger 'error: _generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_makefile: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_makefile: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then echo_danger 'error: _generate_makefile: file should be type ".sh"\n'; return 1; fi

    alert_primary "Generating $3"

    __annotations__=$(_get_script_shoedoc "$1")

    cat > "$2/$3" <<EOT
## $(printf '%s' "$(_get_shoedoc_title "${__annotations__}")")
## $(printf '%s' "$(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')")
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
# Colors
##################################################

PRIMARY   = ${PRIMARY}
SECONDARY = ${SECONDARY}
SUCCESS   = ${SUCCESS}
DANGER    = ${DANGER}
WARNING   = ${WARNING}
INFO      = ${INFO}
LIGHT     = ${LIGHT}
DARK      = ${DARK}
DEFAULT   = ${DEFAULT}
EOL       = ${EOL}

ALERT_PRIMARY   = ${ALERT_PRIMARY}
ALERT_SECONDARY = ${ALERT_SECONDARY}
ALERT_SUCCESS   = ${ALERT_SUCCESS}
ALERT_DANGER    = ${ALERT_DANGER}
ALERT_WARNING   = ${ALERT_WARNING}
ALERT_INFO      = ${ALERT_INFO}
ALERT_LIGHT     = ${ALERT_LIGHT}
ALERT_DARK      = ${ALERT_DARK}

##################################################
# Color Functions
##################################################

define echo_primary
	@printf "\${PRIMARY}%b\${EOL}" \$(1)
endef
define echo_secondary
	@printf "\${SECONDARY}%b\${EOL}" \$(1)
endef
define echo_success
	@printf "\${SUCCESS}%b\${EOL}" \$(1)
endef
define echo_danger
	@printf "\${DANGER}%b\${EOL}" \$(1)
endef
define echo_warning
	@printf "\${WARNING}%b\${EOL}" \$(1)
endef
define echo_info
	@printf "\${INFO}%b\${EOL}" \$(1)
endef
define echo_light
	@printf "\${LIGHT}%b\${EOL}" \$(1)
endef
define echo_dark
	@printf "\${DARK}%b\${EOL}" \$(1)
endef

define alert_primary
	@printf "\${EOL}\${ALERT_PRIMARY}%64s\${EOL}\${ALERT_PRIMARY} %-63s\${EOL}\${ALERT_PRIMARY}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_secondary
	@printf "\${EOL}\${ALERT_SECONDARY}%64s\${EOL}\${ALERT_SECONDARY} %-63s\${EOL}\${ALERT_SECONDARY}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_success
	@printf "\${EOL}\${ALERT_SUCCESS}%64s\${EOL}\${ALERT_SUCCESS} %-63s\${EOL}\${ALERT_SUCCESS}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_danger
	@printf "\${EOL}\${ALERT_DANGER}%64s\${EOL}\${ALERT_DANGER} %-63s\${EOL}\${ALERT_DANGER}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_warning
	@printf "\${EOL}\${ALERT_WARNING}%64s\${EOL}\${ALERT_WARNING} %-63s\${EOL}\${ALERT_WARNING}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_info
	@printf "\${EOL}\${ALERT_INFO}%64s\${EOL}\${ALERT_INFO} %-63s\${EOL}\${ALERT_INFO}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_light
	@printf "\${EOL}\${ALERT_LIGHT}%64s\${EOL}\${ALERT_LIGHT} %-63s\${EOL}\${ALERT_LIGHT}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_dark
	@printf "\${EOL}\${ALERT_DARK}%64s\${EOL}\${ALERT_DARK} %-63s\${EOL}\${ALERT_DARK}%64s\${EOL}\n" "" \$(1) ""
endef

##################################################
# Help
##################################################

## Print this help
help:
	\$(call alert_primary, "$(_get_shoedoc_title "${__annotations__}")")

	@printf "\${WARNING}Description:\${EOL}"
	@printf "\${PRIMARY}  $(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')\${EOL}\n"

	@printf "\${WARNING}Usage:\${EOL}"
	@printf "\${PRIMARY}  make [command]\${EOL}\n"

	@printf "\${WARNING}Commands:\${EOL}"
	@awk '/^### /{printf"\n\${WARNING}%s\${EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${SUCCESS}  %-12s  \${PRIMARY}%s\${EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
	}{PREV=\$\$0}' \${MAKEFILE_LIST}

EOT

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" \
    'BEGIN {HR="##################################################\n"}
    /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_" && function_name != "help") # ignore private functions and help
        printf "## %s\n%s:\n\t@printf \"${INFO}sh %s %s${EOL}\"\n\t@sh %s %s\n\n",annotation,function_name,SHELL_SCRIPT,function_name,SHELL_SCRIPT,function_name,function_name
    }
    !/^## */{annotation=""}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    echo_success "Makefile generated : \"$2/$3\"\n"
}

#--------------------------------------------------
#_ Reflexion
#--------------------------------------------------

# List constants from provided shoe script
_get_constants() {
    # Synopsis: _get_constants <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)

    if [ -z "$1" ]; then echo_danger 'error: _get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constants: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constants: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" \
    '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

# Get constaint for given variable from provided shoe script
_get_constraint() {
    # Synopsis: _get_constraint <SCRIPT_PATH> <VARIABLE_NAME>
    #   SCRIPT_PATH:   The path to the input script.
    #   VARIABLE_NAME: The variable to validate.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constraint: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v NAME="$2" \
    '/^## /{if (annotation=="") annotation=substr($0,4)}
    /^[a-zA-Z0-9_]+=.+$/ {
        if (annotation!="" && $1 == NAME) {
            match(annotation, /\/.+\//); print substr(annotation, RSTART, RLENGTH)
        }
    } !/^## */{annotation=""}' "$1"
}

# List flags from provided shoe script
_get_flags() {
    # Synopsis: _get_flags <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then echo_danger 'error: _get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_flags: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_flags: \"$1\" file not found\n"; return 1; fi

    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
    } {PREV = $0}' "$1"
}

# Get function by name
_get_function() {
    # Synopsis: _get_function <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_function: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_function: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_function: \"$1\" file not found\n"; return 1; fi

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

# Get function annotation by name
_get_function_annotation() {
    # Synopsis: _get_function_annotation <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_function_annotation: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_function_annotation: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_function_annotation: \"$1\" file not found\n"; return 1; fi

    awk -v FUNCTION_NAME="$2" '
        /^#/ { annotation=annotation"\n"$0 }
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
            function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
            sub("^function ","",function_name);         # remove leading "function " if present
            gsub(" +","",function_name);                # trim whitespaces
            if (function_name==FUNCTION_NAME) print substr(annotation,2); # print annotation (without leading "\n")
        }
        !/^#/ { annotation="" }
    ' "$1"
}

# List functions names from provided shoe script
_get_functions_names() {
    # Synopsis: _get_functions_names <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_functions_names: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_functions_names: \"$1\" file not found\n"; return 1; fi

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" \
    '/^(function +)?[a-zA-Z0-9_]+ *\(\)/ {          # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (GET_PRIVATE == "true") {
            print function_name
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print function_name
        }
    } {PREV = $0}' "$1"
}

# List options from provided shoe script
_get_options() {
    # Synopsis: _get_options <SCRIPT_PATH> [GET_PRIVATE_ONLY]
    #   SCRIPT_PATH:      The path to the input script.
    #   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_options: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_options: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE_ONLY="$2" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE_ONLY == "true") {
            if ($1 != toupper($1) && $2 != "false" && substr($1,1,1) == "_") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($1,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

# Guess padding length from longest constant, option, flag or command of the provided shoe script
_get_padding() {
    # Synopsis: _get_padding <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then echo_danger 'error: _get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_padding: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then echo_danger "error: _get_padding: \"$1\" file not found\n"; return 1; fi

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

# Get value for given parameter from provided ".env" or ".sh" file
_get_parameter() {
    # Synopsys : _get_parameter <FILE_PATH> <KEY>
    #   FILE_PATH: The path to the input file.
    #   KEY:       The variable name to get from provided file.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_parameter: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_parameter: \"$1\" file not found\n"; return 1; fi

    echo_info "sed -n \"s/^$2=\(.*\)/\1/p\" \"$1\"\n"
    sed -n "s/^$2=\(.*\)/\1/p" "$1"
}

# Return json object from annotation
_parse_annotation() {
    # Synopsis: _parse_annotation <ANNOTATION>
    #   ANNOTATION: The input text containing raw annotation.

    # if [ -z "$1" ]; then echo_danger 'error: _parse_annotation: some mandatory parameter is missing\n'; return 1; fi
    # if [ ${#} -gt 1 ]; then echo_danger "error: _parse_annotation: too many arguments (${#})\n"; return 1; fi

    set -- "$(printf '%s' "$1" | sed -E 's/^ *#+ ?//g')"

    result="$(printf '%s' "$1" | awk 'function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }{
        temp=$0;
        open+=count_occurrences($0,"{");
        if (open > closed) print temp;
        closed+=count_occurrences($0,"}");
    }')"

    summary="$(printf '%s' "$1" | head -n 1)"

    if [ -z "${result}" ]; then
        jq --null-input \
            --arg summary "${summary}" \
            '$ARGS.named'

        return 0
    fi

    jq --null-input \
    --arg summary "${summary}" \
    '$ARGS.named + '"${result}"
}

# Set value for given parameter into provided file ".env" or ".sh" file
_set_parameter() {
    # Synopsys : _set_parameter <FILE_PATH> <KEY> <VALUE>
    #   FILE_PATH: The path to the input script.
    #   KEY:       The variable name to set to provided file
    #   VALUE:     The value to be set to provided file

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then echo_danger 'error: _set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_parameter: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2" "$3"

    if [ ! -f "$1" ]; then echo_danger "error: _set_parameter: \"$1\" file not found\n"; return 1; fi

    if [ -z "$(_get_parameter "$1")" ]; then
        echo_danger "error: _set_parameter: \"$1\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_parameter "$1")" = "$2" ]; then
        echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    echo_info "$(_sed_i) -E \"s/^$2=.*/$2=$3/\" \"$1\"\n"
    $(_sed_i) -E "s/^$2=.*/$2=$3/" "$1"
}

#--------------------------------------------------
#_ Strings
#--------------------------------------------------

# Collapse blank lines with "sed"
_collapse_blank_lines() {
    # Synopsis: _collapse_blank_lines <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _collapse_blank_lines: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space.
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    echo_info "$(_sed_i) '/^$/{N;s/^\\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

#--------------------------------------------------
#_ System
#--------------------------------------------------

# Print error message if provided command is missing
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then echo_danger 'error: _check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _check_installed: too many arguments (${#})\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    echo_danger "error: \"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

# Find package name for given command
_get_package_name() {
    # Synopsis: _get_package_name <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then echo_danger 'error: _get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_package_name: too many arguments (${#})\n"; return 1; fi

    # debian packages
    if [ "$1" = aapt ];     then echo android-tools-adb;      return 0; fi
    if [ "$1" = adb ];      then echo android-tools-adb;      return 0; fi
    if [ "$1" = fastboot ]; then echo android-tools-fastboot; return 0; fi
    if [ "$1" = snap ];     then echo snapd;                  return 0; fi

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

# Check provided command is installed
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND: A string containing the command name to find.

    if [ -z "$1" ]; then echo_danger 'error: _is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_installed: too many arguments (${#})\n"; return 1; fi

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

# Return current project directory realpath, or "pwd" when installed globally
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

# Checks if variable is valid given regex constraint
_is_valid() {
    # Synopsis: _is_valid <VALUE> <PATTERN>
    #   VALUE:   The string to be compared to regex pattern.
    #   PATTERN: The regex parttern to apply.

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_valid: too many arguments (${#})\n"; return 1; fi

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

# Find constraints and validates a variable
_validate() {
    # Synopsis: _validate <VARIABLE>
    #   VARIABLE: The variable to validate in the followling format : variable_name=value.

    if [ -z "$1" ]; then echo_danger 'error: _validate: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _validate: too many arguments (${#})\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2)" "$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")"

    if ! _is_valid "$2" "$3"; then
        echo_danger "error: invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

# Shoe Kernel
_kernel() {
    if [ ${#} -lt 1 ]; then _default; exit 0; fi

    __error__=''
    __eval__=''
    __execute__=''
    __requires_value__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        # check if previous argument requires value
        if [ -n "${__requires_value__}" ]; then
            __eval__="${__eval__} ${__requires_value__}=${__argument__}"
            __requires_value__=''
            continue
        fi
        if [ -n "$(printf '%s' "${__argument__}" | awk '/^--?[a-zA-Z0-9_]+$/')" ]; then
            # check argument is a valid flag (must start with - or --)
            for __flag__ in $(_get_flags "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__flag__}" | awk '{$0=substr($0,1,1); print}')"
                if [ "${__argument__}" = "--${__flag__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    # append argument to the eval stack
                    __eval__="${__eval__} ${__flag__}=true"
                    __is_valid__=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for __option__ in $(_get_options "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__option__}" | awk '{$0=substr($0,1,1); print}')"
                if [ "${__argument__}" = "--${__option__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    __requires_value__="${__option__}"
                    __is_valid__=true
                    break
                fi
            done
            if [ "${__is_valid__}" = false ]; then
                __error__="\"${__argument__}\" is not a valid parameter\n"
                break
            fi
            continue
        fi
        for __function__ in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${__function__}" | awk '{$0=substr($0,1,1); print}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execute__="${__execute__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            __error__="\"${__argument__}\" is not a valid command\n"
            break
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        __error__="\"--${__requires_value__}\" requires value\n"
    fi

    if [ -n "${__error__}" ]; then
        echo_danger "error: ${__error__}"
        exit 1
    fi

    for __option__ in ${__eval__}; do
        # invalid parameters will raise errors
        _validate "${__option__}"
        eval "${__option__}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function__ in ${__execute__}; do
        eval "${__function__}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_kernel "$@"

