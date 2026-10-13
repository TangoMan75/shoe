#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Parse commit scope",
##   "description": "Parse the commit scope from a conventional commit message, eg: feat(foobar): FooBar (FOO-01) => foobar.",
##   "requires": [
##     "awk",
##     "command",
##     "echo"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "COMMIT_MESSAGE",
##       "type": "str",
##       "description": "The conventional commit message to parse.",
##       "required": true
##     }
##   ]
## }
function _parse_commit_scope() {
    # Check awk installation
    if [ ! -x "$(command -v awk)" ]; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'
        return 1
    fi

    echo -n "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}
