#!/bin/sh

## Return current project directory realpath, or "pwd" when installed globally
##
## @namespace src/shell/system
## @requires dirname pwd realpath
## @assumes HOME
_pwd() {
    if [ "$(dirname "$(realpath "$0")")" = '/usr/bin' ] || [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ] || [ "$(dirname "$(realpath "$0")")" = "${HOME}/.local/bin" ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

