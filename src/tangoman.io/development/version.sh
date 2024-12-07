#!/bin/sh

## Print version infos
version() {
    # get correct console executable
    _console=$(if [ -f ./app/console ]; then echo './app/console'; elif [ -f ./bin/console ]; then echo './bin/console'; fi)
    # get correct public folder
    _public=$(if [ -d ./web ]; then echo './web'; elif [ -d ./public ]; then echo './public'; else echo './'; fi)
    # get current php version
    _php_version=$(php -v | grep -oE 'PHP\s\d+\.\d+.\d+' | sed s/'PHP '//)
    # symfony version
    _symfony_version=$(${_console} --version --env ${env})

    echo_label 'env       '; echo_primary "${env}\n"
    echo_label 'console   '; echo_primary "${_console}\n"
    echo_label 'public    '; echo_primary "${_public}\n"
    echo_label 'php       '; echo_primary "${_php_version}\n"
    echo_label 'symfony   '; echo_primary "${_symfony_version}\n"
    echo_label 'database  '; echo_primary "$(_get_database_type)\n"
    echo_label 'installed '; echo_primary "$(_is_database_installed)\n"
    echo
}

