#!/bin/sh

# This file is part of the TangoMan package.
#
# (c) "Matthias Morin" <mat@tangoman.io>
#
# This source file is subject to the MIT license that is bundled
# with this source code in the file LICENSE.

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

