#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

