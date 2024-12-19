#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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
        printf "#!/bin/sh\n\n" > "${destination}/${name}.sh"
        _get_function "${file}" "${name}" >> "${destination}/${name}.sh"
    done
}

