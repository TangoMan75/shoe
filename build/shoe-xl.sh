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
# * TangoMan Shoe XL
# *
# * Simplify your shell scripting workflow with self-documenting
# * shell scripts with robust argument validation. Just prefix a
# * comment with two pound signs (##) on the line above any
# * function or variable to generate helpful documentation using
# * the "help" command.
# *
# * Features:
# *   - [X] colors
# *   - [X] commands
# *   - [X] private functions
# *   - [X] help
# *   - [X] docbloc
# *   - [X] options + validation
# *   - [X] flags
# *   - [X] install + autocomplete
# *   - [X] compatibility
# *   - [X] documentation
# *
# * Warning: Functions and variables names should not contain dashes.
# *
# * @author       "Matthias Morin" <mat@tangoman.io>
# * @version      1.0.0-xl
# * @link         https://github.com/TangoMan75/shoe
# * @update-link  https://raw.githubusercontent.com/TangoMan75/shoe/main/shoe-xl.sh
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Script alias
ALIAS=shoe

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Who do you want to say "hello" to ? /^[a-zA-Z-]+$/
who="World"

## How many times to say hello /^[1-9]$/
count=1

## Environment /^(prod|dev|test)$/
env="dev"

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Enable FooBar mode
flag=false

## Install script globally
global=false

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Say hello to arbitrary recipient
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done

    if [ "${flag}" = true ]; then
        echo "FOOBAR MODE ENABLED !"
    fi
}

## Return script version from "@version" parameter in file docbloc
version() {
    _print_infos
}

## Print environment
print_env() {
    echo "env: \"${env}\""
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
    true
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

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n'; 
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
echo_primary()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${PRIMARY}"   "$3" "$1" "${DEFAULT}"; }
echo_secondary() { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${SECONDARY}" "$3" "$1" "${DEFAULT}"; }
echo_success()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${SUCCESS}"   "$3" "$1" "${DEFAULT}"; }
echo_danger()    { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${DANGER}"    "$3" "$1" "${DEFAULT}"; }
echo_warning()   { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${WARNING}"   "$3" "$1" "${DEFAULT}"; }
echo_info()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${INFO}"      "$3" "$1" "${DEFAULT}"; }
echo_light()     { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${LIGHT}"     "$3" "$1" "${DEFAULT}"; }
echo_dark()      { if [ $# -eq 1 ]; then set -- "$1" 0 0; elif [ $# -eq 2 ]; then set -- "$1" "$2" 0; fi; printf '%*b%b%-*b%b' "$2" '' "${DARK}"      "$3" "$1" "${DEFAULT}"; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.
alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }
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

    if [ -x "$(command -v zsh)" ]; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$0" "${ALIAS}" || true
    fi

    if [ -x "$(command -v bash)" ]; then
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

## Update script from @update-link
self_update() {
    _update "$0" "$(_get_docbloc "$0" 'update-link')"
}

# Generate comspec string
_get_comspec() {
    # Synopsis: _get_comspec <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_comspec: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_comspec: too many arguments (${#})\n"; exit 1; fi
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

# Install script via copy
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _copy_install: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

# Remove completion script autoload
_remove_completion_autoload() {
    # Synopsis: _remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _remove_completion_autoload: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_completion_autoload: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _remove_completion_autoload: \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$1" "$(basename "$1" .sh)"
    fi
    set -- "$(realpath "$1")" "$2"

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

# Generates an autocomplete script for the provided file.
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$1" "$(basename "$1" .sh)"
    fi
    set -- "$(realpath "$1")" "$2"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

# Adds an autoload line for completion script to a shell configuration file.
_set_completion_autoload() {
    # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <SCRIPT_FILE_PATH> [ALIAS]
    #   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_FILE_PATH:        The path to the input file.
    #   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file.

    if [ -z "$1" ]  || [ -z "$2" ]; then echo_danger 'error: _set_completion_autoload: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_completion_autoload: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _set_completion_autoload: \"$1\" file not found\n"; exit 1; fi
    if [ ! -f "$2" ]; then echo_danger "error: _set_completion_autoload: \"$2\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$3" ]; then
        set -- "$1" "$2" "$(basename "$2" .sh)"
    fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

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

# Creates a system-wide autocomplete script for the provided file.
_generate_global_autocomplete() {
    # Synopsis: _generate_global_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
    #               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #               It uses sudo for file creation in a system directory, requiring root privileges.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_global_autocomplete: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_global_autocomplete: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_global_autocomplete: \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$1" "$(basename "$1" .sh)"
    fi
    set -- "$(realpath "$1")" "$2"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

# Install script via symlink
_symlink_install(){
    # Synopsis: _symlink_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _symlink_install some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _symlink_install too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _symlink_install \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$(realpath "$1")" "$(basename "$0" .sh)"
    fi

    echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    sudo ln -s "$1" "/usr/local/bin/$2"
}

# Uninstall script from system
_uninstall() {
    # Synopsis: _uninstall <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _uninstall: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _uninstall: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _uninstall: \"$1\" file not found\n"; exit 1; fi

    # set default alias
    if [ -z "$2" ]; then
        set -- "$1" "$(basename "$1" .sh)"
    fi
    set -- "$(realpath "$1")" "$2"

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

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _update: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; exit 1; fi

    if [ -x "$(command -v curl)" ]; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$1")\"\n"
        curl -sSL "$1" > "$(realpath "$1")"

    elif [ -x "$(command -v wget)" ]; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$1")\"\n"
        wget -qO - "$1" > "$(realpath "$1")"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    "$(realpath "$1")" self_install
}

##################################################
### Documentation
##################################################

## Generate Markdown documentation
generate_doc() {
    _generate_doc "$0"
}

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <FILE_PATH> <DESTINATION> [FILE_NAME]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the documentation file. Defaults to "<BASENAME>.md".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; exit 1; fi

    # set default values
    if [ -z "$2" ] && [ -z "$3" ]; then
        set -- "$1" "$(dirname "$1")" "$(basename "$1" .sh).md"
    fi
    if [ -z "$3" ]; then
        set -- "$1" "$2" "$(basename "$1" .sh).md"
    fi

    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; exit 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

    alert_primary "Generating $(basename "$1" .sh) documentation"

    (
        printf '%s\n===\n\n' "$(_get_docbloc_title "$1")"

        printf '## ℹ️ Infos\n\n'
        printf '\055 author:  %s\n' "$(_get_docbloc "$1" 'author')"
        printf '\055 version: %s\n' "$(_get_docbloc "$1" 'version')"
        printf '\055 link:    %s\n' "$(_get_docbloc "$1" 'link')"
        printf '\n'

        printf '## 📑 Description\n\n'
        _get_docbloc_description "$1"
        printf '\n\n'

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
            printf "(--%s %s) ", $1, $2
        } { PREV = $0 }' "$1"
        awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
            if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
            printf "(--%s) ", $1
        } { PREV = $0 }' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
                printf "%d. **%s**\n  - %s\n  - Value: %s\n\n", ++i, $1, substr(PREV, 4), $2
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
                printf "%d. **--%s**\n  - %s\n\n", ++i, $1, substr(PREV, 4)
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_") {
                    if (match(PREV, / \/.+\//)) {
                        CONSTRAINT=substr(PREV, RSTART+1, RLENGTH);
                        DESCRIPTION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                        printf "%d. **--%s**\n  - Description: %s\n  - Constraint: `%s`\n  - Default: %s\n\n", ++i, $1, DESCRIPTION, CONSTRAINT, $2
                    } else {
                        printf "%d. **--%s**\n  - Description: %s\n  - Default: %s\n\n", ++i, $1, substr(PREV, 4), $2
                    }
                }
            } { PREV = $0 }' "$1"
        fi

        printf '## 🤖 Commands\n\n'
        awk '/^### /{i=0; printf"### ⚡ %s\n\n",substr($0,5)}
            /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
            sub("^function ",""); gsub("[ ()]","");
            FUNCTION = substr($0, 1, index($0, "{"));
            sub("{$", "", FUNCTION);
            if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
            printf "%d. **%s**\n  - %s\n\n", ++i, FUNCTION, substr(PREV, 4)
        } { PREV = $0 }' "$1"
    ) > "$2/$3"

    echo_success "Documentation generated in : \"$2\"\n"
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
    _print_constants   "${_padding}"
    _print_flags       "${_padding}"
    _print_options     "${_padding}"
    _print_commands    "${_padding}"
}

_get_padding() {
    # Synopsis: _get_padding

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0,1,index($0,"{"));
        sub("{$","",MATCH);
    } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+3 }' "$0"
}

_print_title() {
    # Synopsis: _print_title <TITLE>
    #   TITLE:  A string containing script title.

    alert_primary "$1"
}

_print_infos() {
    # Synopsis: _print_infos

    echo_warning 'Infos:\n'
    echo_success 'author'  2 9; echo_primary "$(_get_docbloc "$0" 'author')\n"
    echo_success 'version' 2 9; echo_primary "$(_get_docbloc "$0" 'version')\n"
    echo_success 'link'    2 9; echo_primary "$(_get_docbloc "$0" 'link')\n"
    printf '\n'
}

_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION:  A string containing script description.

    echo_warning 'Description:\n'
    echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

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

_print_flags() {
    # Synopsis: _print_flags [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Flags:\n'
    awk -F '=' -v PADDING="$(($1-2))" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-*s %s%s\n",SUCCESS,PADDING,$1,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

_print_constants() {
    # Synopsis: _print_constants [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Constants:\n'
    awk -F '=' -v PADDING="$1" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" -v INFO="${INFO}" -v WARNING="${WARNING}" -v EOL="${EOL}" '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  %-*s %s%s%s (value: %s%s%s)%s",SUCCESS,PADDING,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$0"
    printf '\n'
}

_print_options() {
    # Synopsis: _print_options [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning "Options:\n"
    awk -v PADDING="$(($1-2))" -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v INFO="${INFO}" -v DEFAULT="${DEFAULT}" -v EOL="${EOL}" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (match(PREV,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(PREV,RSTART,RLENGTH);
                ANNOTATION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                printf "%s  --%-*s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,PADDING,$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                ANNOTATION=substr(PREV,4);
                printf "%s  --%-*s %s%s%s (default: %s%s%s)%s",SUCCESS,PADDING,$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } { PREV = $0 }' "$0"
    printf '\n'
}

_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v PADDING="$1" -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" '/^### /{printf"\n%s%s:%s\n",WARNING,substr($0,5),PRIMARY}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") # ignore private functions
        printf "%s  %-*s %s%s\n",SUCCESS,PADDING,FUNCTION,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$0"
    printf '\n'
}

#--------------------------------------------------
# Docbloc parsing
#--------------------------------------------------

_get_docbloc() {
    # Synopsis: _get_docbloc <FILE_PATH> <TAG_NAME>
    #   FILE_PATH:  The path to the input file.
    #   TAG_NAME:   The name of the docbloc parameter to return.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ ${#} -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: \"$1\" file not found\n"; exit 1; fi

    awk -v TAG="$2" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$(realpath "$1")" | sed -E 's/ +$//'
}

_get_docbloc_description() {
    # Synopsis: _get_docbloc_description <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_description: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_description: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_description: \"$1\" file not found\n"; exit 1; fi

    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$(realpath "$1")"
}

_get_docbloc_title() {
    # Synopsis: _get_docbloc_title <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_title: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_title: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_title: \"$1\" file not found\n"; exit 1; fi

    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$(realpath "$1")"
}

#--------------------------------------------------
# System compatibility
#--------------------------------------------------

# Open with default handler
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

# Return sed -i system flavour
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
# Sytem
#--------------------------------------------------

# Check app is installed
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND:  A string containing command name.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _is_installed: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _is_installed: too many arguments (${#})\n"; exit 1; fi

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

# Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
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

# Install required dependency
_require() {
    # Synopsis: _require <COMMAND> [FROM_PACKAGE_NAME] [PACKAGE_MANAGER]
    #   COMMAND:           The command/package to install.
    #   FROM_PACKAGE_NAME: (optional) The package name where the command should be found (if different). Defaults to "COMMAND".
    #   PACKAGE_MANAGER:   (optional) The package manager required to install the package with. Defaults to "apt".
    #   note:              "FROM_PACKAGE_NAME" is required if you need to set "PACKCAGE_MANAGER" parameter.
    #                      eg: `_require curl` will install "curl" with "sudo apt install --yes curl".
    #                      eg: `_require adb android-tools-adb` will install "android-tools-adb" package.
    #                      eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn".

    if [ ${#} -lt 1 ]; then echo_danger 'error: _require: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _require: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-$1}" "${3:-apt}"

    # define inner function
    __require() {
        echo_info "$1\n"
        $1
    }

    if ! _is_installed "$3"; then
        echo_danger "error: \"$(basename "${0}")\" requires $3, try: 'sudo apt-get install -y $3'\n"
        exit 1
    fi

    if ! _is_installed "$1"; then
        if [ "$3" = apt ]; then
            __require "sudo apt install --yes $1"

        elif [ "$3" = apt-get ]; then
            __require "sudo apt-get install --assume-yes $1"

        elif [ "$3" = dnf ]; then
            __require "sudo dnf install --assumeyes --nogpgcheck -y $1"

        elif [ "$3" = flatpak ]; then
            __require "flatpak install --non-interactive $1"

        elif [ "$3" = pacman ]; then
            __require "sudo pacman -Sy $1"

        elif [ "$3" = yum ]; then
            __require "sudo yum install --assumeyes $1"

        elif [ "$3" = zypper ]; then
            __require "sudo zypper install --non-interactive $1"
        fi
    fi
}

#--------------------------------------------------
# Validation
#--------------------------------------------------

_is_valid() {
    # Synopsis: _is_valid VALUE PATTERN
    #   VALUE:    The string to be compared to regex pattern.
    #   PATTERN:  The regex parttern to apply.
    #   TODO:     "nullable=true" ; "nullable=false" : "length=10"

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_valid: too many arguments (${#})\n"; exit 1; fi

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

_validate() {
    # Synopsis: _validate [variable]
    # find constraints and validates a variable from parameter string. e.g: "variable_name=value"
    _validate_variable=$(printf '%s' "$1" | cut -d= -f1)
    _validate_value=$(printf '%s' "$1" | cut -d= -f2)
    _validate_pattern=$(_get_constraint "$0" "${_validate_variable}")

    if ! _is_valid "${_validate_value}" "${_validate_pattern}"; then
        echo_danger "error: invalid \"${_validate_variable}\", expected \"${_validate_pattern}\", \"${_validate_value}\" given\n"
        exit 1
    fi
}

#--------------------------------------------------
# Reflexion
#--------------------------------------------------

_get_constants() {
    # Synopsis: _get_constants <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)

    if [ -z "$1" ]; then echo_danger 'error: _get_constants: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constants: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v GET_PRIVATE="$2" '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

_get_constraint() {
    # Synopsis: _get_constraint [script_path] [variable_name]
    if [ -z "$1" ]; then echo_danger 'error: _get_constraint: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constraint: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    awk -v NAME="$2" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$1"
}

_get_flags() {
    # Synopsis: _get_flags [script_path] (get_private default=false)
    if [ -z "$1" ]; then echo_danger 'error: _get_flags: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_flags: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=false$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1)) print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

_get_functions_names() {
    # Synopsis: _get_functions_names <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. (default=false)

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

_get_options() {
    # Synopsis: _get_options [script_path] (get_private default=false)
    if [ -z "$1" ]; then echo_danger 'error: _get_options: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_options: too many arguments (${#})\n"; exit 1; fi
    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1) && $2 != "false") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Strings
#--------------------------------------------------

# Collapse blank lines with sed
_collapse_blank_lines() {
    # Synopsis: _collapse_blank_lines <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _collapse_blank_lines: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _collapse_blank_lines: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _collapse_blank_lines: \"$1\" file not found\n"; exit 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    echo_info "$(_sed_i) '/^$/{N;s/^\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

#--------------------------------------------------
# shoe-lg main function with hooks
#--------------------------------------------------

_main() {
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [X] options + validation
    #   - [X] flags

    if [ ${#} -lt 1 ]; then help; exit 0; fi

    __error=''
    __eval=''
    __execute=''
    __requires_value=''
    for __argument in "$@"; do
        __is_valid=false
        # check if previous argument requires value
        if [ -n "${__requires_value}" ]; then
            __eval="${__eval} ${__requires_value}=${__argument}"
            __requires_value=''
            continue
        fi
        if [ -n "$(printf '%s' "${__argument}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            # check argument is a valid flag (must start with - or --)
            for __flag in $(_get_flags "$0"); do
                # get shorthand character
                __shorthand="$(printf '%s' "${__flag}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument}" = "--${__flag}" ] || [ "${__argument}" = "-${__shorthand}" ]; then
                    # append argument to the eval stack
                    __eval="${__eval} ${__flag}=true"
                    __is_valid=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for __option in $(_get_options "$0"); do
                # get shorthand character
                __shorthand="$(printf '%s' "${__option}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument}" = "--${__option}" ] || [ "${__argument}" = "-${__shorthand}" ]; then
                    __requires_value="${__option}"
                    __is_valid=true
                    break
                fi
            done
            if [ "${__is_valid}" = false ]; then
                __error="\"${__argument}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument}" = "${_function}" ] || [ "${__argument}" = "${__shorthand}" ]; then
                # append argument to the execute stack
                __execute="${__execute} ${_function}"
                __is_valid=true
                break
            fi
        done
        if [ "${__is_valid}" = false ]; then
            __error="\"${__argument}\" is not a valid command"
            break
        fi
    done

    if [ -n "${__requires_value}" ]; then
        __error="\"--${__requires_value}\" requires value"
    fi

    if [ -n "${__error}" ]; then
        printf "${DANGER}error: %s${EOL}" "${__error}"
        exit 1
    fi

    for __option in ${__eval}; do
        # invalid parameters will raise errors
        _validate "${__option}"
        eval "${__option}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function in ${__execute}; do
        eval "${__function}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
