#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

## Dump "build.lst" file
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

    echo_success "Listing functions from \"${file}\" to \"${destination}/$(basename "${file}" .sh).lst\"\n"
    _get_functions_names "${file}" true | sed 's/$/.sh/g' > "${destination}/$(basename "${file}" .sh).lst"
}

