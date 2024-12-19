#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

