#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

