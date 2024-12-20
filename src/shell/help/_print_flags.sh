#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

