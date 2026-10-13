#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Update project dependencies with composer",
##   "requires": [
##     "composer"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed"
##   ]
## }
_composer_update() {
    _check_installed composer

    _echo_info "composer update --with-dependencies\n"
    composer update --with-dependencies
}

