#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

