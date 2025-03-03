#!/bin/sh

# Return current project directory realpath, or "pwd" when installed globally
#
# {
#   "namespace": "system",
#   "returns": "str"
# }
_pwd() {
    # Synopsis: _pwd

    if [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

