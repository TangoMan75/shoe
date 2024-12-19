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
# * TangoMan Shoe
# *
# * Simplify your shell scripting workflow with self-documenting
# * shell scripts with robust argument validation. Just prefix a
# * comment with two pound signs (##) on the line above any
# * function or variable to generate helpful documentation using
# * the "help" command.
# *
# * Warning: Functions and variables names should not contain dashes.
# *
# * @author       "Matthias Morin" <mat@tangoman.io>
# * @version      1.0.0
# * @license      MIT
# * @link         https://github.com/TangoMan75/shoe
# * @update-link  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoe.sh
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Script alias (the command alias that will be used for invoking the script after installation)
ALIAS=shoe

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Greeting recipient name /^[a-zA-Z-]+$/
who="World"

## How many times to say hello /[1-9]/
count=1

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Example Flag (any variable set to "false" will convert to a flag at runtime)
flag=false

## Install script globally
global=false

#--------------------------------------------------
# Place your private constants after this line
#--------------------------------------------------

## This constant is private (it will not de displayed in the "help" output)
_PRIVATE="I'm a private constant"

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

## This variable is private (it will not de displayed in the "help" output)
_global_variable="I'm a global variable"

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Greets a specified recipient a given number of times (the recipient's name is provided with the "--who" option)
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done
}

## Prints flag status
flag_test() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

# Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
_private() {
    echo "I'm private"
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

## Update script from @update-link
self_update() {
    _update_link="$(_get_docbloc "$0" 'update-link')"
    if [ -z "${_update_link}" ]; then
        echo_danger 'cannot update: "@update-link" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS}" "${global:-false}"
}

##################################################
### Documentation
##################################################

## Generate Markdown documentation for current shoe script
generate_doc() {
    _generate_doc "$0"
}

##################################################
### Makefile
##################################################

## Generate Makefile for current shoe script
generate_makefile() {
    _generate_makefile "$0"
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
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print secondary text with optional indentation and padding
echo_secondary() {
    # Synopsis: echo_secondary <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

# Print success text with optional indentation and padding
echo_success() {
    # Synopsis: echo_success <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print danger text with optional indentation and padding
echo_danger() {
    # Synopsis: echo_danger <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''
}

# Print warning text with optional indentation and padding
echo_warning() {
    # Synopsis: echo_warning <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''
}

# Print info text with optional indentation and padding
echo_info() {
    # Synopsis: echo_info <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''
}

# Print light text with optional indentation and padding
echo_light() {
    # Synopsis: echo_light <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
    printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''
}

# Print dark text with optional indentation and padding
echo_dark() {
    # Synopsis: echo_dark <STRING> [INDENTATION] [PADDING]
    #  STRING:       Text to display.
    #  INDENTATION:  Indentation level (default: 0).
    #  PADDING:      Padding length (default: 0).
    #  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    #                this is why we're calculating the PADDING length on each execution.

    if [ ${#} -eq 1 ]; then
        set -- "$1" 0 0
    elif [ ${#} -eq 2 ]; then
        set -- "$1" "$2" 0
    fi
    set -- "$1" "$2" "$(($3-${#1}))"
    if [ "$3" -lt 0 ]; then
        set -- "$1" "$2" 0
    fi
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
#_ System compatibility
#--------------------------------------------------

# Open with default system handler
_open() {
    # Synopsis: _open

    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

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
#_ Docbloc
#--------------------------------------------------

# Parse docbloc at the top the provided shoe script file
_get_docbloc() {
    # Synopsis: _get_docbloc <FILE_PATH> <TAG_NAME>
    #   FILE_PATH:  The path to the input file.
    #   TAG_NAME:   The name of the docbloc parameter to return.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ ${#} -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_docbloc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_docbloc: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc: \"$1\" file not found\n"; return 1; fi

    # /^#\/\*\*$/,/^# \*\/$/ = Match a range of lines beginning with "#/**" and ending with "# */"
    # for(i=4;i<=NF;++i){printf "%s ",$i} = concat remainig string
    # exit = avoid returning duplicate matches
    awk -v TAG="$2" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}; exit}}' "$(realpath "$1")" | sed -E 's/ +$//'
}

# Get docbloc description at the top the provided shoe script file
_get_docbloc_description() {
    # Synopsis: _get_docbloc_description <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_description: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_description: \"$1\" file not found\n"; return 1; fi

    awk '/^# \* @/ {exit} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$(realpath "$1")"
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
#_ Docker
#--------------------------------------------------

# Build and start container stack with docker-compose
_docker_compose_start() {
    # Synopsis: _docker_compose_start

    _check_installed docker-compose

    if [ ${#} -gt 0 ]; then echo_danger "error: _docker_compose_stop: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker-compose up --detach --remove-orphans\n'
    docker-compose up --detach --remove-orphans
}

# Stop container stack with docker-compose
_docker_compose_stop() {
    # Synopsis: _docker_compose_stop

    _check_installed docker-compose

    if [ ${#} -gt 0 ]; then echo_danger "error: _docker_compose_stop: too many arguments (${#})\n"; return 1; fi

    echo_info 'docker-compose stop\n'
    docker-compose stop
}

# Is container running
_docker_container_is_running() {
    # Synopsis: _is_running <CONTAINER_NAME>
    #   CONTAINER_NAME:  The name of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_container_is_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_container_is_running: too many arguments (${#})\n"; return 1; fi

    if docker ps --format '{{.Names}}' 2>/dev/null | grep -E -q "^$1$"; then

        return 0
    fi

    return 1
}

# Kill all running containers with docker
_docker_kill_all() {
    # Synopsis: _docker_kill_all

    _check_installed docker

    echo_info "docker kill $(docker ps --quiet --format '{{.Names}}' | tr -s "\n" ' ')\n"
    # shellcheck disable=SC2046
    docker kill $(docker ps --quiet --format '{{.Names}}')
}

# Load local sql script
_docker_load_sql() {
    # Synopsis: _docker_load_sql <CONTAINER_NAME> <FILE_PATH>
    #   CONTAINER_NAME:  The name of the docker container.
    #   FILE_PATH:       The path to the sql file.

    _check_installed docker

    if [ ${#} -lt 2 ] || [ -z "$1" ]; then echo_danger 'error: _docker_load_sql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _docker_load_sql: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$1" "$(realpath "$1")"
    if [ ! -f "$2" ]; then echo_danger "error: _docker_load_sql: \"$2\" file not found\n"; return 1; fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\" < \"$2\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}" < "$2"
}

# Open postgres terminal in docker
_docker_psql() {
    # Synopsis: _docker_psql <CONTAINER_NAME>
    #   CONTAINER_NAME:  The name of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_psql: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_psql: too many arguments (${#})\n"; return 1; fi

    _username="--username root"
    _password="--no-password"
    _dbname="--dbname pgsql"

    _docker_wait_for_postgres "$1"

    echo_info "docker exec --interactive \"$1\" psql \"${_username}\" \"${_password}\" \"${_dbname}\"\n"
    docker exec --interactive "$1" psql "${_username}" "${_password}" "${_dbname}"
}

# Print docker status
_docker_status() {
    # Synopsis: _docker_status

    _check_installed docker

    echo_info "docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}

# Wait for postgresql container to start with docker
_docker_wait_for_postgres() {
    # Synopsis: _docker_wait_for_postgres <CONTAINER_NAME> [USERNAME]
    #   CONTAINER_NAME:  The name of the docker container.
    #   USERNAME:        (optional) The psql username. Defaults to "".

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_wait_for_postgres: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _docker_wait_for_postgres: too many arguments (${#})\n"; return 1; fi

    if [ -n "$2" ]; then
        set -- "$1" "--username $2"
    fi

    echo_warning "Waiting for \"$1\" database to start."

    while [ ! "$(docker exec "$1" psql "$2" -l 2>/dev/null)" ]; do
        echo_warning '.'
        sleep 1
    done

    echo_success "\n\"$1\" is runnning.\n"
}

# Wait for rabbitmq container to start with docker
_docker_wait_for_rabbit() {
    # Synopsis: _docker_wait_for_rabbit <CONTAINER_NAME>
    #   CONTAINER_NAME:  The name of the docker container.

    _check_installed docker

    if [ -z "$1" ]; then echo_danger 'error: _docker_wait_for_rabbit: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _docker_wait_for_rabbit: too many arguments (${#})\n"; return 1; fi

    echo_warning "Waiting for \"$1\" to start."

    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        echo_warning '.'
        sleep 1
    done

    echo_success "\n\"$1\" is runnning.\n"
}

#--------------------------------------------------
#_ Documentation
#--------------------------------------------------

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <INPUT_FILE_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
    #   INPUT_FILE_PATH:   The path to the input file.
    #   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME:  (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
    #   GET_PRIVATE:       (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".

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
        printf '%s\n===\n\n' "$(_get_docbloc_title "$1")"

        printf '## ℹ️ Infos\n\n'
        printf '\055 author:  %s\n' "$(_get_docbloc "$1" 'author')"
        printf '\055 version: %s\n' "$(_get_docbloc "$1" 'version')"
        printf '\055 link:    %s\n' "$(_get_docbloc "$1" 'link')"
        printf '\n\n'

        printf '## 📑 Description\n\n'
        printf '%s\n\n' "$(_get_docbloc_description "$1")"

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
            awk -v GET_PRIVATE="$4" -F '=' '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                PRIVATE = "";
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_") PRIVATE = " (private)";
                sub("^#+ ","",PREV);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,PREV,$2
            } {PREV = $0}' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                printf "%d. **`%s` (private)**\n> %s\n  - Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,substr(PREV,4)
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
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
        awk -v GET_PRIVATE="$4" '/^#(##|_) / { # print section / divider
            if (GET_PRIVATE == "false" && substr(PREV,1,4) != "### ") next;
            sub("^#(##|_) ","");
            i=0; printf"### ⚡ %s\n\n",$0
        }
        /^(function )?[a-zA-Z0-9_]+ *\(\) *\{/ { # find function
            if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
            PRINT_SYNOPSIS="true";
            sub("^function ",""); gsub("[ ()]","");
            FUNCTION = substr($0,1,index($0,"{"));
            sub("{$","",FUNCTION);
            PRIVATE = "";
            if (substr(PREV,1,3) != "## " || substr(FUNCTION,1,1) == "_") PRIVATE = " (private)";
            if (match(PREV,/^#.+/)) { # print function
                sub("^##? ","",PREV);
                printf "#### %d. `%s`%s\n\n%s\n",++i,FUNCTION,PRIVATE,PREV
            } else {
                printf "#### %d. `%s`%s\n",++i,FUNCTION,PRIVATE
            }
        }
        /^ +# .+/ { # print synopsis
            if (PRINT_SYNOPSIS == "false") next;
            sub("^ +# ",""); sub("<","\<"); sub(">","\>"); printf "> %s<br>\n",$0
        }
        /^$/ {
            if (PRINT_SYNOPSIS == "true") {
                printf "\n";
                PRINT_SYNOPSIS="false"
            }
        } {PREV = $0}' "$1"
    ) > "$2/$3"

    echo_success "Documentation generated : \"$2/$3\"\n"
}

#--------------------------------------------------
#_ Files
#--------------------------------------------------

# Get file extension
_get_file_extension() {
    # Synopsis: _get_file_extension <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_file_extension: too many arguments (${#})\n"; return 1; fi

    printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$'
}

#--------------------------------------------------
#_ Git
#--------------------------------------------------

# Install git hooks
_git_hooks() {
    # Synopsis: _git_hooks

    if [ ! -d ./.githooks ]; then echo_danger "error: git_hooks: \"./.githooks\" folder not found\n"; return 1; fi

    echo_info "rm -fr \"./.git/hooks\"\n"
    rm -fr "./.git/hooks"

    echo_info "cp -r \"./.githooks\" \"./.git/hooks\"\n"
    cp -r "./.githooks" "./.git/hooks"

    echo_info "chmod +x \"./.git/hooks/*\"\n"
    chmod +x "./.git/hooks/*"
}

# Initialise git submodules
_initialise_submodules() {
    # Synopsis: _initialise_submodules

    _check_installed git

    if [ ! -f "$(_pwd)/.gitmodules" ]; then
        echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    echo_info "git submodule update --init --recursive\n"
    git submodule update --init --recursive
}

#--------------------------------------------------
#_ Help
#--------------------------------------------------

# Print help for provider shoe script
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _help: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _help: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _help: \"$1\" file not found\n"; return 1; fi

    _padding=$(_get_padding "$1")

    alert_primary      "$(_get_docbloc_title "$1")"
    _print_infos
    _print_description "$(_get_docbloc_description "$1")"
    _print_usage
    if [ -n "$(_get_constants "$1")" ]; then
        _print_constants "${_padding}"
    fi
    if [ -n "$(_get_flags "$1")" ]; then
        _print_flags "${_padding}"
    fi
    if [ -n "$(_get_options "$1")" ]; then
        _print_options "${_padding}"
    fi
    _print_commands "${_padding}"
}

# List commands of the of the current shoe script (used by "help" command)
_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  (optional) Padding length (default: 12)
    #  note:     "awk: %*x formats are not supported"

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^### /{printf\"\n%s%s:%s\n\",WARNING,substr(\$0,5),PRIMARY}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\"); # remove leading \"function \", round brackets and extra spaces
        FUNCTION = substr(\$0,1,index(\$0,\"{\"));      # truncate string after opening curly brace
        sub(\"{\$\",\"\",FUNCTION);                     # remove trailing curly brace
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\") # ignore private functions
        printf \"%s  %-$1s %s%s\n\",SUCCESS,FUNCTION,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List constants of the of the current shoe script (used by "help" command)
_print_constants() {
    # Synopsis: _print_constants [PADDING]
    #  PADDING:  (optional) Padding length (default: 12)
    #  note:     "awk: %*x formats are not supported"

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" -v INFO="${INFO}" -v WARNING="${WARNING}" -v EOL="${EOL}" "/^[A-Z0-9_]+=.+\$/ {
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\")
        printf \"%s  %-$1s %s%s%s (value: %s%s%s)%s\",SUCCESS,\$1,PRIMARY,substr(PREV,4),INFO,WARNING,\$2,INFO,EOL
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# Print provided text formatted as a description (used by "help" command)
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION:  A string containing script description.

    echo_warning 'Description:\n'
    echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

# List flags of the of the current shoe script (used by "help" command)
_print_flags() {
    # Synopsis: _print_flags [PADDING]
    #  PADDING:  (optional) Padding length (default: 12)
    #  note:     "awk: %*x formats are not supported"

    if [ -z "$1" ]; then set -- 12; fi
    set -- $(($1-2))
    echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"%s  --%-$1s %s%s\n\",SUCCESS,\$1,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# Print infos of the of the current shoe script (used by "help" command)
_print_infos() {
    # Synopsis: _print_infos

    echo_warning 'Infos:\n'
    echo_success 'author'  2 8; echo_primary "$(_get_docbloc "$0" 'author')\n"
    echo_success 'version' 2 8; echo_primary "$(_get_docbloc "$0" 'version')\n"
    echo_success 'link'    2 8; echo_primary "$(_get_docbloc "$0" 'link')\n"
    printf '\n'
}

# List options of the of the current shoe script (used by "help" command)
_print_options() {
    # Synopsis: _print_options [PADDING]
    #  PADDING:  (optional) Padding length (default: 12)
    #  note:     "awk: %*x formats are not supported"

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

# Print usage of the of the current shoe script (used by "help" command)
_print_usage() {
    # Synopsis: _print_usage

    echo_warning 'Usage:\n'
    echo_info "sh $(basename "$0") <" 2; echo_success 'command'; echo_info '> '
    # options
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v WARNING="${WARNING}" -v DEFAULT="${DEFAULT}" '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s--%s%s]%s ",INFO,SUCCESS,$1,INFO,DEFAULT;next}
        printf "%s[%s--%s %s%s%s]%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0} END {print "\n"}' "$0"
}

#--------------------------------------------------
#_ Install
#--------------------------------------------------

# Install script via copy
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _copy_install: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

# Generates an autocomplete script for the provided file
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file
    #   note:       This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
    #               Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins

    if [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

# Creates a system-wide autocomplete script for the provided file
_generate_global_autocomplete() {
    # Synopsis: _generate_global_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file
    #   note:       This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
    #               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #               It uses sudo for file creation in a system directory, requiring root privileges.

    if [ -z "$1" ]; then echo_danger 'error: _generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_global_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

# Generate comspec string for the provided file
_get_comspec() {
    # Synopsis: _get_comspec <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_comspec: too many arguments (${#})\n"; return 1; fi
    set -- "$(realpath "$1")"

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
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:     (optional) Install globally. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _install: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _install: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"

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
    #   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file

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

# Adds an autoload line for completion script to a shell configuration file
_set_completion_autoload() {
    # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <SCRIPT_FILE_PATH> [ALIAS]
    #   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_FILE_PATH:        The path to the input file.
    #   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file

    if [ -z "$1" ]  || [ -z "$2" ]; then echo_danger 'error: _set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_completion_autoload: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then echo_danger "error: _set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$2" .sh)"}"

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
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ -z "$1" ]; then echo_danger 'error: _symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _symlink_install too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _symlink_install \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    sudo ln -s "$1" "/usr/local/bin/$2"
}

# Uninstall script from system
_uninstall() {
    # Synopsis: _uninstall <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.

    if [ -z "$1" ]; then echo_danger 'error: _uninstall: some mandatory parameter is missing\n'; return 1; fi
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

# Updates given script from the provided URL
_update() {
    # Synopsis: _update <FILE_PATH> <URL> [ALIAS] [GLOBAL]
    #   FILE_PATH:  The path to the input file.
    #   URL:        The URL of the script to download and install.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.
    #   GLOBAL:     (optional) Install globally. Defaults to "false".

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _update: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}"

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
#_ Makefile
#--------------------------------------------------

# Generate Makefile for provided shoe script
_generate_makefile() {
    # Synopsis: _generate_makefile <INPUT_FILE_PATH> [DESTINATION] [OUTPUT_FILE_NAME]
    #   INPUT_FILE_PATH:   The path to the input file.
    #   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME:  (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then echo_danger 'error: _generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_makefile: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_makefile: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then echo_danger 'error: _generate_makefile: file should be type ".sh"\n'; return 1; fi

    alert_primary "Generating $3"

    cat > "$2/$3" <<EOT
#/**
# * $(_get_docbloc_title "$1")
# *
# * $(_get_docbloc_description "$1")
# *
# * @version $(_get_docbloc "$1" version)
# * @author  $(_get_docbloc "$1" author)
# * @license $(_get_docbloc "$1" license)
# * @link    $(_get_docbloc "$1" link)
# */

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
	\$(call alert_primary, "$(_get_docbloc_title "$1")")

	@printf "\${WARNING}Description:\${EOL}"
	@printf "\${PRIMARY}  $(_get_docbloc_description "$1")\${EOL}\n"

	@printf "\${WARNING}Usage:\${EOL}"
	@printf "\${PRIMARY}  make [command]\${EOL}\n"

	@printf "\${WARNING}Commands:\${EOL}"
	@awk '/^### /{printf"\n\${WARNING}%s\${EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${SUCCESS}  %-12s  \${PRIMARY}%s\${EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
	}{PREV=\$\$0}' \${MAKEFILE_LIST}

EOT

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" 'BEGIN {HR="##################################################\n"}
        /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf "## %s\n%s:\n\t@printf \"${INFO}sh %s %s${EOL}\"\n\t@sh %s %s\n\n",substr(PREV,4),FUNCTION,SHELL_SCRIPT,FUNCTION,SHELL_SCRIPT,FUNCTION,FUNCTION
    } {PREV = $0}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    echo_success "Makefile generated : \"$2/$3\"\n"
}

#--------------------------------------------------
#_ Network
#--------------------------------------------------

# Open in default browser
_open_in_default_browser() {
    # Synopsis: _open_in_default_browser [IP] [PORT]
    #   IP:    (optional) Target IP address or domain. (default=127.0.0.1)
    #   PORT:  (optional) Destination port. (default=8080)

    if [ ${#} -gt 2 ]; then echo_danger "error: _open_in_default_browser: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}"

    echo_info "nohup \"$(_open)\" \"http://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "http://$1:$2" >/dev/null 2>&1
}

# Serve given local directory with PHP
_php_serve() {
    # Synopsis: _php_serve <DOCROOT> [IP] [PORT]
    #   DOCROOT: Target directory
    #   IP:      (optional) Local IP address. (default=127.0.0.1)
    #   PORT:    (optional) Destination port. (default=8080)

    _check_installed php

    if [ -z "$1" ]; then echo_danger 'error: _php_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _php_serve: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"

    echo_info "php -d memory-limit=-1 -S \"$2:$3\" -t \"$1\"\n"
    php -d memory-limit=-1 -S "$2:$3" -t "$1"
}

# Serve given local directory with Python 3
_py_serve() {
    # Synopsis: _py_serve <DOCROOT> [IP] [PORT]
    #   DOCROOT: Target directory
    #   IP:      (optional) Local IP address. (default=127.0.0.1)
    #   PORT:    (optional) Destination port. (default=8080)

    _check_installed python3

    if [ -z "$1" ]; then echo_danger 'error: _py_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _py_serve: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"

    echo_info "python3 -m http.server --directory \"$1\" --bind \"$2\" \"$3\"\n"
    python3 -m http.server --directory "$1" --bind "$2" "$3"
}

# Remove hostname from /etc/hosts
_remove_host() {
    # Synopsis: remove_host <HOSTNAME>
    #   HOSTNAME:  The hostame to unset locally.

    if [ -z "$1" ]; then echo_danger 'error: _remove_host: some mandatory parameter is missing\n'; return 1; fi

    echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}

# Set new host in /etc/hosts
_set_host() {
    # Synopsis: set_host <HOSTNAME>
    #   HOSTNAME:  The hostame to set locally.

    if [ -z "$1" ]; then echo_danger 'error: _set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

#--------------------------------------------------
#_ Prompts
#--------------------------------------------------

# Present user with a list of choices and prompt them to select one
_select() {
    # Synopsis: _select <CHOICES>
    #   CHOICES:  Array containing choices

    if [ -z "$1" ]; then echo_danger 'error: _select: some mandatory parameter is missing\n'; return 1; fi

    __item__=0
    for __choice__ in "$@"; do
        __item__=$((__item__ + 1))
        __choices__="${__choices__} ${__item__}"
        echo_success "$__item__)"; echo_warning " ${__choice__}\n"
    done

    echo_success 'Please select your choice : \n'
    __select__=0
    while [ "${__select__}" -gt "$#" ] || [ "${__select__}" -lt 1 ]; do
        # validate selection
        read -r __select__
        for __item__ in ${__choices__}; do
            # find selected item
            if [ "${__item__}" -eq "${__select__}" ]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    echo "$@" | cut -d' ' -f "${__select__}"
}

# Promt user for yes or no
_yes_no() {
    set -- "${1:-Confirm ?} (yes/no): "

    echo_success "$1"; echo_warning "[no] "

    read -r __select__
    if [ "${__select__}" != "$(printf '%s' "${__select__}" | awk '/^[Yy](ES|es)?$/ {print}')" ]; then

        return 1
    fi

    return 0
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

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constants: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

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
    } {PREV = $0}' "$1"
}

# List flags from provided shoe script
_get_flags() {
    # Synopsis: _get_flags <SCRIPT_PATH>
    #   SCRIPT_PATH: The path to the input script.

    if [ -z "$1" ]; then echo_danger 'error: _get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_flags: too many arguments (${#})\n"; return 1; fi

    # set default values
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
    if [ ! -f "$1" ]; then echo_danger "error: _get_function: \"$1\" file not found\n"; return 1; fi

    # this regular expression matches functions with either bash or sh syntax
    awk -v FUNCTION_NAME="$2" '/^(function )?[a-zA-Z0-9_]+ *\(\) *\{.*/ {
        function_name = substr($0,1,index($0,"{"));
        gsub("[ (){]","",function_name);
        sub("^function ","",function_name);
        if (substr(PREV,1,3) == "## ") description=PREV;
        in_function=1;
        if (match($0,/.*\}$/)) print_body=1
    } in_function {
        body = body $0"\n"
    } /^}$/ && in_function {
        print_body=1
    } print_body {
        if (function_name == FUNCTION_NAME) {
            if (description) print description;
            print body
        }
        print_body=0; in_function=0; description=""; body=""
    } {PREV = $0}' "$1"
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
    awk -v GET_PRIVATE="$2" '/^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (GET_PRIVATE == "true") {
            print FUNCTION
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print FUNCTION
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

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_options: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE_ONLY="$2" '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE_ONLY == "true") {
            if ($1 != toupper($1) && $2 != "false" && substr($1,1,1) == "_") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($1,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

# Guess padding length from longest constant, option, flag or command of the provided shoe script
_get_padding() {
    # Synopsis: _get_padding <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_padding: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_padding: \"$1\" file not found\n"; return 1; fi

    # /^[a-zA-Z0-9_]+=.+$/ = matches constants, options and flags
    # /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ = matches commands
    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0,1,index($0,"{"));
        sub("{$","",MATCH);
    } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    {PREV = $0} END {print LENGTH}' "$1"
}

# Get value for given parameter from provided ".env" or ".sh" file
_get_parameter() {
    # Synopsys : _get_parameter <FILE_PATH> <KEY>
    #   FILE_PATH:  The path to the input script.
    #   KEY:        The variable name to get from provided script

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_parameter: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_parameter: \"$1\" file not found\n"; return 1; fi

    echo_info "sed -n 's/^'\"$2\"'=\(.*\)/\1/p' \"$(realpath "$1")\"\n"
    sed -n 's/^'"$2"'=\(.*\)/\1/p' "$(realpath "$1")"
}

# Set value for given parameter into provided file ".env" or ".sh" file
_set_parameter() {
    # Synopsys : _set_parameter <FILE_PATH> <KEY> <VALUE>
    #   FILE_PATH:  The path to the input script.
    #   KEY:        The variable name to set to provided file
    #   VALUE:      The value to be set to provided file

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _set_parameter: too many arguments (${#})\n"; return 1; fi

    # set default values
    # NOTE: sed 's/\\/\\\\/g' => escape backward slashes
    # NOTE: sed 's/\//\\\//g' => escape forward slashes
    # NOTE: sed 's/\$/\\$/g'  => escape dollar signs
    set -- "$(realpath "$1")" "$(echo "$2" | sed 's/\\/\\\\/g' | sed 's/\//\\\//g' | sed 's/\$/\\$/g')"
    if [ ! -f "$1" ]; then echo_danger "error: _set_parameter: \"$1\" file not found\n"; return 1; fi

    if [ -z "$(_get_script_parameter "$1")" ]; then
        echo_danger "error: _set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_script_parameter "$1")" = "$2" ]; then
        echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    echo_info "$(_sed_i) -E s/\"^$2=.*/$2=$3\"/ \"$(realpath "$1")\"\n"
    $(_sed_i) -E s/"^$2=.*/$2=$3"/ "$(realpath "$1")"
}

#--------------------------------------------------
# Strings
#--------------------------------------------------

# Collapse blank lines with "sed"
_collapse_blank_lines() {
    # Synopsis: _collapse_blank_lines <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _collapse_blank_lines: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    echo_info "$(_sed_i) '/^$/{N;s/^\\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

# Generate random 32 bit string
_generate_key() {
    # Synopsis: _generate_key

    _check_installed openssl

    echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
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

# Validate a file checksum
_is_checksum_valid() {
    # Synopsis: _is_checksum_valid <SHA256SUM> <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   SHA256SUM:  A string containing file checksum.

    _check_installed sha256sum

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_checksum_valid: too many arguments (${#})\n"; return 1; fi

    set -- "$2" "$1" "$(mktemp /tmp/XXXXXXXXXX.sha256)"
    echo "$2  $1" > "$3"

    if sha256sum --status -c "$3"; then

        return 0
    fi

    return 1
}

# Check current desktop is gnome
_is_gnome() {
    if [ "${XDG_CURRENT_DESKTOP}" != 'ubuntu:GNOME' ]; then

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

# Check current user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
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

# Install required command
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

# Animate a spinner in the terminal for a given amout of time
_spin() {
    # Synopsis: _spin [DURATION]
    #   DURATION:  Animation duration in miliseconds

    set -- "$((${1:-0}/10))" 0 0

    while [ "$1" -gt "$2" ]; do
        printf '\r%s' "$(printf "|/-\\" | awk -v I="$3" '{print substr($0, I, 1)}')"
        set -- "$1" "$(( $2+1 ))" "$(( $3%4+1 ))"
        sleep 0.1
    done
}

# Check provided user exists
_user_exists() {
    if [ -z "$1" ]; then echo_danger 'error: _user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _user_exists: too many arguments (${#})\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

#--------------------------------------------------
#_ Validation
#--------------------------------------------------

# Checks if variable is valid given regex constraint
_is_valid() {
    # Synopsis: _is_valid <VALUE> <PATTERN>
    #   VALUE:    The string to be compared to regex pattern.
    #   PATTERN:  The regex parttern to apply.

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
#_ kernel
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
