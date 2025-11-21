#!/bin/sh

# Check security issues in project dependencies (symfony-cli)
#
# {
#   "namespace": "symfony",
#   "requires": [
#     "composer",
#     "symfony"
#   ],
#   "depends": [
#     "_check_installed",
#     "echo_info"
#   ]
# }
_security() {
    if "$(_is_installed symfony)"; then
        echo_info 'symfony security:check\n'
        symfony security:check

        return 0
    fi

    if "$(_is_installed composer)"; then
        echo_info 'composer audit\n'
        composer audit

        return 0
    fi

    echo_danger "error: \"$0\" requires symfony or composer.\n"
    return 1
}

