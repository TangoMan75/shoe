#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

