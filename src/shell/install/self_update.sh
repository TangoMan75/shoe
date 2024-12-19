#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

## Update script from @update-link
self_update() {
    _update_link="$(_get_docbloc "$0" 'update-link')"
    if [ -z "${_update_link}" ]; then
        echo_danger 'cannot update: "@update-link" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS}" "${global:-false}"
}

