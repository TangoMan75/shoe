#!/bin/sh

## Return sed -i system flavour
##
## @namespace src/shell/compatibility
## @requires command printf sed uname
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        printf "sed -i ''"

        return 0
    fi

    printf 'sed -i'
}

