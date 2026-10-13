#!/bin/sh

## {
##   "namespace": "src/shell/compatibility",
##   "summary": "Return sed -i system flavour",
##   "requires": [
##     "command",
##     "echo",
##     "sed",
##     "uname"
##   ]
## }
_sed_i() {
    # Synopsis: _sed_i

    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

