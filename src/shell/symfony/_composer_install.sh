#!/bin/sh

## {
##   "namespace": "src/shell/symfony",
##   "summary": "Install project dependencies with composer",
##   "requires": [
##     "composer",
##     "install"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_info",
##     "src/shell/system/_check_installed",
##     "src/shell/system/_pwd"
##   ]
## }
_composer_install() {
    _check_installed composer

    _echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(_pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(_pwd)"
}

