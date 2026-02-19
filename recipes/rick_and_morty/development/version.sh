#!/bin/sh

## {
##   "namespace": "recipes/rick_and_morty/development",
##   "summary": "Print version infos",
##   "requires": [
##     "echo",
##     "grep",
##     "php",
##     "sed"
##   ],
##   "depends": [
##     "recipes/rick_and_morty/database/_get_database_type",
##     "recipes/rick_and_morty/database/_is_database_installed",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success"
##   ]
## }
version() {
    # get correct console executable
    _console=$(if [ -f ./app/console ]; then echo './app/console'; elif [ -f ./bin/console ]; then echo './bin/console'; fi)
    # get correct public folder
    _public=$(if [ -d ./web ]; then echo './web'; elif [ -d ./public ]; then echo './public'; else echo './'; fi)
    # get current php version
    _php_version=$(php -v | grep -oE 'PHP\s\d+\.\d+.\d+' | sed s/'PHP '//)
    # symfony version
    _symfony_version=$(${_console} --version --env ${env})

    _echo_success 'env'       2 10; _echo_primary "${env}\n"
    _echo_success 'console'   2 10; _echo_primary "${_console}\n"
    _echo_success 'public'    2 10; _echo_primary "${_public}\n"
    _echo_success 'php'       2 10; _echo_primary "${_php_version}\n"
    _echo_success 'symfony'   2 10; _echo_primary "${_symfony_version}\n"
    _echo_success 'database'  2 10; _echo_primary "$(_get_database_type)\n"
    _echo_success 'installed' 2 10; _echo_primary "$(_is_database_installed)\n"
    echo
}

