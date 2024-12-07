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
# * TangoMan Test
# *
# * This is a test
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 1.0.0-sm
# * @link    https://github.com/TangoMan75/shoe
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

global=true

## Execute test
test() {
    if _test1; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi

    if _test2; then
        echo_success "success !\n"
    else
        echo_danger "failed !\n"
    fi
}

_test1() {
    echo "_test1: should succeed."
    return 0
}

_test2() {
    echo "_test1b: should fail."
    return 1
}

## Print pathes
path() {
    echo_info "_project_directory: .\n"
    echo_info "_pwd: $(_pwd)\n"
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

# Place here commands you need executed by default
_default() {
    help
}

# Place here commands you need executed first every time
_before() {
    _check_installed awk
    _check_installed sed

    # this will resolve to current project directory
    # or to "pwd" when script is installed globally via copy
    # remove if you don't need script to change to project directory
    cd "$(_pwd)" || return 1
}

# Place here commands you need executed last every time
_after() {
    true
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

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n'; 
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
#  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
#                this is why we're calculating the PADDING length on each execution.

# Print primary (bright white text)
echo_primary()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print secondary (bright blue text)
echo_secondary() { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''; }

# Print success (bright green text)
echo_success()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print danger (red text)
echo_danger()    { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''; }

# Print warning (orange text)
echo_warning()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print info (bright purple text)
echo_info()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Print light (black text over white background)
echo_light()     { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''; }

# Print dark (white text over black background)
echo_dark()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DARK}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.

# Print primary alert (bold white text over bright blue background)
alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }

# Print secondary alert (bold white text over bright purple background)
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }

# Print success alert (bold white text over bright green background)
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }

# Print danger alert (bold white text over bright red background)
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }

# Print warning alert (bold white text over bright orange background)
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }

# Print info alert (bold white text over bright blue background)
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }

# Print light alert (black text over white background)
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }

# Print dark alert (bold white text over black background)
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install() {
    if [ -n "${global}" ] && [ "${global}" = true ]; then
        _copy_install "$0" "${ALIAS}"
        _generate_global_autocomplete "$0" "${ALIAS}"
    else
        _symlink_install "$0" "${ALIAS}"
        _generate_autocomplete "$0" "${ALIAS}"
    fi

    if _check_installed zsh; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$0" "${ALIAS}" || true
    fi

    if _check_installed bash; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            set -- ~/.profile "$0" "${ALIAS}"
        else
            set -- ~/.bashrc "$0" "${ALIAS}"
        fi
        if [ -f "$1" ]; then
            _set_completion_autoload "$1" "$2" "${ALIAS}"
        fi
    fi
}

## Uninstall script from system
self_uninstall() {
    _uninstall "$0" "${ALIAS}"
}

# Install script via symlink
_symlink_install(){
    # Synopsis: _symlink_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _symlink_install too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _symlink_install \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    sudo ln -s "$1" "/usr/local/bin/$2"
}

# Install script via copy (beta)
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _copy_install: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

# Generates an autocomplete script for the provided file.
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

# Creates a system-wide autocomplete script for the provided file.
_generate_global_autocomplete() {
    # Synopsis: _generate_global_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
    #               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #               It uses sudo for file creation in a system directory, requiring root privileges.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_global_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

# Generate comspec string
_get_comspec() {
    # Synopsis: _get_comspec <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_comspec: too many arguments (${#})\n"; return 1; fi
    set -- "$(realpath "$1")"

    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s ",FUNCTION,substr(PREV,4)
    } { PREV = $0 }' "$1"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") {
            printf "--%s ",$1
        }
    } { PREV = $0 }' "$1"
}

# Remove completion script autoload
_remove_completion_autoload() {
    # Synopsis: _remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_completion_autoload: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

# Adds an autoload line for completion script to a shell configuration file.
_set_completion_autoload() {
    # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <SCRIPT_FILE_PATH> [ALIAS]
    #   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_FILE_PATH:        The path to the input file.
    #   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file.

    if [ -z "$1" ]  || [ -z "$2" ]; then echo_danger 'error: _set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_completion_autoload: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then echo_danger "error: _set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$1" .sh)"}"

    # declare inner function
    __set_completion_autoload() {
        # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <COMPLETION_FILE_PATH> <ALIAS>
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

# Uninstall script from system
_uninstall() {
    # Synopsis: _uninstall <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _uninstall: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _uninstall: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

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

# Updates the script from the provided URL.
_update() {
    # Synopsis: _update <FILE_PATH> <URL>
    #   FILE_PATH:  The path to the input file.
    #   URL:        The URL of the script to download and install.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _update: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    if _check_installed curl; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$1")\"\n"
        curl -sSL "$1" > "$(realpath "$1")"

    elif _check_installed  wget; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$1")\"\n"
        wget -qO - "$1" > "$(realpath "$1")"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    "$(realpath "$1")" self_install
}

##################################################
### Help
##################################################

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title "$0")"
    _print_infos
    _print_description "$(_get_docbloc_description "$0")"
    _print_usage
    _print_commands    "${_padding}"
}

# Guess padding length from longest command of the current shoe script
_get_padding() {
    # Synopsis: _get_padding

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0,1,index($0,"{"));
        sub("{$","",MATCH);
    } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+1 }' "$0"
}

# Print provided text formatted as a description
_print_title() {
    # Synopsis: _print_title <TITLE>
    #   TITLE:  A string containing script title.

    alert_primary "$1"
}

# Print infos of the of the current shoe script
_print_infos() {
    # Synopsis: _print_infos

    echo_warning 'Infos:\n'
    echo_success 'author'  2 9; echo_primary "$(_get_docbloc "$0" 'author')\n"
    echo_success 'version' 2 9; echo_primary "$(_get_docbloc "$0" 'version')\n"
    echo_success 'link'    2 9; echo_primary "$(_get_docbloc "$0" 'link')\n"
    printf '\n'
}

# Print provided text formatted as a description
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION:  A string containing script description.

    echo_warning 'Description:\n'
    echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

# Print usage of the of the current shoe script
_print_usage() {
    # Synopsis: _print_usage

    echo_warning 'Usage:\n'
    echo_info "sh $(basename "$0") [" 2; echo_success 'command'; echo_info '] '
    # options
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v WARNING="${WARNING}" -v DEFAULT="${DEFAULT}" '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
        printf "%s(%s--%s %s%s%s)%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } { PREV = $0 }' "$0"
    # flags
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v DEFAULT="${DEFAULT}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
        printf "%s(%s--%s%s)%s ",INFO,SUCCESS,$1,INFO,DEFAULT
    } { PREV = $0 }' "$0"
    printf '\n\n'
}

# List flags of the of the current shoe script
_print_flags() {
    # Synopsis: _print_flags [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    set -- $(($1-2))
    echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"%s  --%-$1s %s%s\n\",SUCCESS,\$1,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List options of the of the current shoe script
_print_options() {
    # Synopsis: _print_options [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    set -- $(($1-2))
    echo_warning "Options:\n"
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v INFO="${INFO}" -v DEFAULT="${DEFAULT}" -v EOL="${EOL}" -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV,1,3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0,1,1) != \"_\") {
            if (match(PREV,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(PREV,RSTART,RLENGTH);
                ANNOTATION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                printf \"%s  --%-$1s %s%s%s %s%s (default: %s%s%s)%s\",SUCCESS,\$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,\$2,INFO,EOL
            } else {
                ANNOTATION=substr(PREV,4);
                printf \"%s  --%-$1s %s%s%s (default: %s%s%s)%s\",SUCCESS,\$1,DEFAULT,ANNOTATION,INFO,WARNING,\$2,INFO,EOL
            }
        }
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List commands of the of the current shoe script
_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^### /{printf\"\n%s%s:%s\n\",WARNING,substr(\$0,5),PRIMARY}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\"); # remove leading \"function \", round brackets and extra spaces
        FUNCTION = substr(\$0,1,index(\$0,\"{\"));      # truncate string after opening curly brace
        sub(\"{\$\",\"\",FUNCTION);                     # remove trailing curly brace
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\") # ignore private functions
        printf \"%s  %-$1s %s%s\n\",SUCCESS,FUNCTION,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

#--------------------------------------------------
#_ Docbloc
#--------------------------------------------------

# Get docbloc at the top the provided shoe script file
_get_docbloc() {
    # Synopsis: _get_docbloc <FILE_PATH> <TAG_NAME>
    #   FILE_PATH:  The path to the input file.
    #   TAG_NAME:   The name of the docbloc parameter to return.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ ${#} -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: \"$1\" file not found\n"; return 1; fi

    awk -v TAG="$2" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$(realpath "$1")" | sed -E 's/ +$//'
}

# Get docbloc description at the top the provided shoe script file
_get_docbloc_description() {
    # Synopsis: _get_docbloc_description <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_description: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_description: \"$1\" file not found\n"; return 1; fi

    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$(realpath "$1")"
}

# Get docbloc title at the top the provided shoe script file
_get_docbloc_title() {
    # Synopsis: _get_docbloc_title <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_title: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_title: \"$1\" file not found\n"; return 1; fi

    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$(realpath "$1")"
}

#--------------------------------------------------
#_ System compatibility
#--------------------------------------------------

# Return sed -i system flavour
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
#_ Sytem
#--------------------------------------------------

# Print error message if provided command is missing
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND:  A string containing command name.

    if [ -z "$1" ]; then echo_danger 'error: _check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _check_installed: too many arguments (${#})\n"; return 1; fi

    if ! _is_installed "$1"; then
        echo_danger "error: \"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $1'\n"

        return 1
    fi

    return 0
}

# Check provided command is installed
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND:  A string containing command name.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _is_installed: too many arguments (${#})\n"; return 1; fi

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

# Return current project directory path, or "pwd" when installed globally
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
    #   VALUE:    The string to be compared to regex pattern.
    #   PATTERN:  The regex parttern to apply.
    #   TODO:     "nullable=true" ; "nullable=false" : "length=10"

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_valid: too many arguments (${#})\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # if [ "$1" != "$(tr -dc "$2" < printf '%s' "$1" | fold -w "${length}" | head -n 1)" ]; then
    if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then

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
#_ Reflexion
#--------------------------------------------------

# List constaints from provided shoe script
_get_constraint() {
    # Synopsis: _get_constraint <SCRIPT_PATH> <VARIABLE_NAME>
    #   SCRIPT_PATH:   The path to the input script.
    #   VARIABLE_NAME: The variable to validate.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constraint: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -v NAME="$2" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$1"
}

# List functions names from provided shoe script
_get_functions_names() {
    # Synopsis: _get_functions_names <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_functions_names: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_functions_names: \"$1\" file not found\n"; return 1; fi

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

# List options from provided shoe script
_get_options() {
    # Synopsis: _get_options <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_options: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_options: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1) && $2 != "false") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

## shoe-sm main function with hooks
_main() {
    # small version is optimized for performance, does not handle flags, options and validation.
    #
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [ ] options + validation
    #   - [ ] flags

    if [ ${#} -lt 1 ]; then _default; exit 0; fi

    __execute__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        for __function__ in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${__function__}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execute__="${__execute__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        # unknown parameters will raise errors
        if [ "${__is_valid__}" = false ]; then
            echo_danger "error: \"${__argument__}\" is not a valid command\n"
            exit 1
        fi
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function__ in ${__execute__}; do
        eval "${__function__}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
