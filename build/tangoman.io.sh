#!/bin/sh

set -e

#/*
# * This script is based on TangoMan Shoe Shell Microframework
# *
# * This file is distributed under to the MIT license.
# *
# * Copyright (c) 2024 "Matthias Morin" <mat@tangoman.io>
# *
# * Permission is hereby granted, free of charge, to any person obtaining a copy
# * of this software and associated documentation files (the "Software"), to deal
# * in the Software without restriction, including without limitation the rights
# * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# * copies of the Software, and to permit persons to whom the Software is
# * furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included in all
# * copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# * SOFTWARE.
# *
# * Source code is available here: https://github.com/TangoMan75/shoe
# */

#/**
# * TangoMan.io
# *
# * This is the main entrypoint for tangoman.io project
# *
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @version 1.0.0-xl
# * @link    https://github.com/TangoMan75/tangoman.io
# */

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Script alias
ALIAS=tangoman

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Environment /^(dev|prod|test)$/
env=dev

## Default port /^[0-9]+$/
port=8000

## Table name /^[a-z0-9_]+$/
table=''

## Container name /^[a-zA-Z0-9_-]+$/
container=''

## Files owner /^[a-z0-9_-]+$/
owner=''

## File to test /^~?[a-zA-Z0-9.\/_-]+$/
file=''

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Execute migrations instead of creating schema
migrate=false

## Import csv data
import=false

## Force
force=false

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

##################################################
### Install
##################################################

## Install app, import data and clear cache
install() {
    alert_primary "Installing project with \"${env}\" environment"

    fix_permissions
    composer_install

    create_db

    if [ "${migrate}" = true ]; then
        migrate
    else
        schema
    fi

    assets_install
    # ckeditor
    # cron_scan

    set_env

    cache
}

## Uninstall
uninstall() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    for _file in \
        ./var/*.db \
        .env.dev.local \
        .env.local \
        .env.prod.local \
        .php-cs-fixer.cache \
        .php_cs.cache \
        .phpcs-cache \
        .phpunit.result.cache \
    ; do
        echo_info "rm -f \"${_file}\"\n"
        rm -f "${_file}"
    done

    for _folder in \
        ./bin/.phpunit \
        ./coverage \
        ./logs/* \
        ./node_modules \
        ./public/bundles \
        ./var/cache \
        ./var/log \
        ./vendor \
        ./volumes/postgres_data \
    ; do
        echo_info "rm -rf \"${_folder}\"\n"
        rm -rf "${_folder}"
    done
}

## Check requirements
requirements() {
    _error=0

    if ! _check_installed awk; then
        _error=1
    fi

    if ! _check_installed sed; then
        _error=1
    fi

    if ! _check_installed php; then
        _error=1
    fi

    if ! _check_installed composer; then
        _error=1
    fi

    if ! _check_installed openssl; then
        _error=1
    fi
}

## Remove ".env.local" and ".env.dev.local" files
rm_env() {
    echo_info "rm -f .env.local\n"
    rm -f .env.local

    echo_info "rm -f .env.dev.local\n"
    rm -f .env.dev.local
}

## Create ".env.local" file
set_env() {
    echo_info "cp -f .env.${env} .env.local\n"
    cp -f .env.${env} .env.local

    generate_app_secret
}

## Update app : git pull, reset database and import (docker)
update() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info 'git remote update origin --prune\n'
    git remote update origin --prune

    if [ "${force}" = true ]; then
        if [ "${env}" = dev ]; then
            echo_info 'git reset --hard origin/dev\n'
            git reset --hard origin/dev
        else
            echo_info 'git reset --hard origin/main\n'
            git reset --hard origin/main
        fi
    else
        echo_info 'git pull\n'
        git pull
    fi

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh reset_db --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh reset_db --env ${env}"

    if [ "${import}" = true ]; then
        echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec -T php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh cache --force --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh cache --force --env ${env}"

    echo_info "docker compose exec -T php sh -c \"sh entrypoint.sh cache --env ${env}\"\n"
    docker compose exec -T php sh -c "sh entrypoint.sh cache --env ${env}"
}

##################################################
### App
##################################################

## Clear export folder
clear_exports() {
    echo_info 'rm ./assets/exports/*\n'
    rm ./assets/exports/*
}

## Export data in csv
export_csv() {
    for _item in \
        article \
        bookmark \
        category \
        certificate \
        event \
        experience \
        organization \
        person \
        portfolio_item \
        postal_address \
        skill \
        study \
        tag \
    ; do
        echo_info "./bin/console app:export -x ${_item}:csv -g read:${_item} --env ${env}\n"
        ./bin/console app:export -x ${_item}:csv -g read:${_item} --env ${env}
    done
}

## Export data in json
export_json() {
    for _item in \
        article \
        bookmark \
        category \
        certificate \
        event \
        experience \
        organization \
        person \
        portfolio_item \
        postal_address \
        skill \
        study \
        tag \
    ; do
        echo_info "./bin/console app:export -x ${_item}:json -g read:${_item} --env ${env}\n"
        ./bin/console app:export -x ${_item}:json -g read:${_item} --env ${env}
    done
}

## Import data
import() {
    # NOTE: imports MUST run in a specific order to avoid "UNIQUE Integrity constraint violation"
    for _item in \
        categories \
        organizations \
        people \
        skills \
        certificates \
        experiences \
        portfolio_items \
        study \
    ; do
        if [ -f ./assets/imports/${_item}.json ]; then

            echo_info "./bin/console app:import -f ${_item}.json --env ${env}\n"
            ./bin/console app:import -f ${_item}.json --env ${env}

        elif [ -f ./assets/imports/${_item}.csv ]; then

            echo_info "./bin/console app:import -f ${_item}.csv --env ${env}\n"
            ./bin/console app:import -f ${_item}.csv --env ${env}
        fi
    done

    echo_info "./bin/console app:import -f diplomas.csv -x certificate:csv --env ${env}\n"
    ./bin/console app:import -f diplomas.csv -x certificate:csv --env ${env}
}

## Scrape data from "Syntec" website
scrape_syntec() {
    echo_info "./bin/console app:scrape:syntec --env ${env}\n"
    ./bin/console app:scrape:syntec --env ${env}
}

## Scrape data from "Welcome to the Jungle" website
scrape_wttj() {
    echo_info "./bin/console app:scrape:wttj --env ${env}\n"
    ./bin/console app:scrape:wttj --env ${env}
}

##################################################
### CI/CD
##################################################

# Get correct PHPUnit binary path
_phpunit() {
    if [ -f ./vendor/bin/phpunit ]; then
        echo ./vendor/bin/phpunit

        return 0
    fi

    if [ -f ./vendor/bin/simple-phpunit ]; then
        echo ./vendor/bin/simple-phpunit

        return 0
    fi

    if [ -f ./vendor/symfony/phpunit-bridge/bin/simple-phpunit ]; then
        echo './vendor/symfony/phpunit-bridge/bin/simple-phpunit'

        return 0
    fi

    if [ -f ./bin/phpunit ]; then
        echo './bin/phpunit'

        return 0
    fi

    echo_danger "error: \"$(basename "${0}")\" requires phpunit, try: 'composer install'\n"

    return 1
}

## Check drivers installation
check_drivers() {
    echo_info './vendor/bin/bdi detect drivers\n'
    ./vendor/bin/bdi detect drivers
}

## Output test coverage (phpunit)
coverage() {
    echo_info 'XDEBUG_MODE=coverage php -d memory-limit=-1 ./vendor/bin/phpunit --coverage-html ./coverage\n'
    XDEBUG_MODE=coverage php -d memory-limit=-1 ./vendor/bin/phpunit --coverage-html ./coverage
}

## Run linter (sniff)
lint() {
    # check composer validity
    echo_info 'composer validate\n'
    composer validate

    # check local requirements
    echo_info "./vendor/bin/requirements-checker\n"
    ./vendor/bin/requirements-checker

    # check php files syntax
    echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r FILE; do
        # echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"${FILE}\"\n"
        php -l -d memory-limit=-1 -d display_errors=0 "${FILE}"
    done

    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    echo_info './vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots\n'
    ./vendor/bin/php-cs-fixer fix --dry-run --diff --allow-risky=yes --verbose --show-progress=dots

    # # squizlabs/php_codesniffer https://github.com/squizlabs/PHP_CodeSniffer
    # echo_info "./vendor/bin/phpcs\n"
    # ./vendor/bin/phpcs

    echo_info "./bin/console lint:container\n"
    ./bin/console lint:container

    echo_info "./bin/console lint:twig ./templates --show-deprecations\n"
    ./bin/console lint:twig ./templates --show-deprecations

    echo_info "./bin/console lint:yaml ./config\n"
    ./bin/console lint:yaml ./config

    echo_info "./bin/console lint:yaml ./fixtures\n"
    ./bin/console lint:yaml ./fixtures
}

## Run linter (php-cs-fixer fix)
lint_fix() {
    # PHP CS Fixer https://cs.symfony.com/doc/usage.html
    echo_info 'php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots\n'
    php -d memory-limit=-1 ./vendor/bin/php-cs-fixer fix --allow-risky=yes --verbose --show-progress=dots
}

## Run grumphp
lint_grump() {
    # exec 'vendor/phpro/grumphp/bin/grumphp' 'git:pre-commit' '--skip-success-output'
    echo_info "php -d memory-limit=-1 ./vendor/phpro/grumphp/bin/grumphp git:pre-commit --skip-success-output\n"
    php -d memory-limit=-1 ./vendor/phpro/grumphp/bin/grumphp git:pre-commit --skip-success-output
}

## Run code analysis with PHPStan
lint_phpstan() {
    echo_info 'php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests\n'
    php -d memory-limit=-1 ./vendor/bin/phpstan analyse -l 0 ./src ./tests
}

## Check security issues in project dependencies (symfony-cli)
security() {
    _check_installed symfony

    echo_info 'symfony security:check\n'
    symfony security:check
}

## Run tests
tests() {
    composer_install

    tests_unit

    drop
    create_db
    schema
    tests_integration

    check_drivers

    drop
    create_db
    schema
    tests_functional
}

## Run behat tests
tests_behat() {
    # force test environment
    env='test'

    echo_info "php -d memory-limit=-1 ./vendor/bin/behat --format=progress\n"
    php -d memory-limit=-1 ./vendor/bin/behat --format=progress

}

## Run functional tests
tests_functional() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox --testdox "${file}"
        return 0
    fi

    echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Functional\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Functional
}

## Run integration tests
tests_integration() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox --testdox "${file}"
        return 0
    fi

    echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Integration\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Integration
}

## Run unit tests
tests_unit() {
    # force test environment
    env='test'

    if [ "${file}" ]; then
        echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox \"${file}\"\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox "${file}"
        return 0
    fi

    echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox tests/Unit\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox tests/Unit

}

##################################################
### Database
##################################################

# Check database type
_get_database_type() {
    _dotenv

    echo "${DATABASE_URL}" | awk -F ':' '{print $1}'
}

# Check if database is installed
_is_database_installed() {
    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ] && [ -f ./var/${env}.db ]; then
        echo true
        return 0
    fi

    # if [ "${_database_type}" = postgresql ]; then
    #     if ./bin/console doctrine:query:sql "SELECT datname FROM pg_catalog.pg_database WHERE datname = '${env}'" | grep -q "${env}"; then
    #         echo true
    #         return 0
    #     fi
    # fi

    # if [ "${_database_type}" = mysql ]; then
    #     if ./bin/console doctrine:query:sql "SELECT schema_name FROM information_schema.schemata WHERE schema_name = '${env}'" | grep -q "${env}"; then
    #         echo true
    #         return 0
    #     fi
    # fi

    echo false
}

## Create database
create_db() {
    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:database:create --env ${env} || true\n"
    ./bin/console doctrine:database:create --env ${env} || true
}

## Import SQL file(s) directly to Database
database_import() {
    echo_info "./bin/console doctrine:database:import ./data/dump.sql --env ${env}\n"
    ./bin/console doctrine:database:import ./data/dump.sql --env ${env}
}

## Drop database
drop() {
    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:database:drop --force --env ${env} || true\n"
    ./bin/console doctrine:database:drop --force --env ${env} || true
}

## Generate schema from yaml (api-platform)
generate_schema() {
    echo_info "php -d memory-limit=-1 ./vendor/bin/schema generate \"$(pwd)/temp/\" ./config/schema.yaml\n"
    php -d memory-limit=-1 ./vendor/bin/schema generate "$(pwd)/temp/" ./config/schema.yaml
}

## Execute migration scripts
migrate() {
    echo_info "./bin/console doctrine:migrations:migrate --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:migrate --no-interaction --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:schema:validate --env ${env} || true\n"
    ./bin/console doctrine:schema:validate --env ${env} || true
}

## Generate migration script
migration_diff() {
    echo_info "./bin/console doctrine:migrations:diff --no-interaction --env ${env}\n"
    ./bin/console doctrine:migrations:diff --no-interaction --env ${env}
}

## Dump MySQL database (docker)
mysqldump() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    echo_info "docker compose exec mysqldump --add-drop-table -u root -ptoor \"${env}\" > \"/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec mysqldump --add-drop-table -u root -ptoor "${env}" > "/data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

## Dump Postgres database (docker)
pg_dump() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    # postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"

    echo_info "docker compose exec postgres pg_dump \"${env}\" > \"./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql\"\n"
    docker compose exec postgres pg_dump "${env}" > "./data/dump_${env}_$(date '+%Y-%m-%d_%H-%M-%S').sql"
}

## Enter Postgres terminal
psql() {
    _check_installed psql

    echo_info 'psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password\n'
    psql --host postgres --port 5432 --dbname tangoman.io --username root --no-password
}

## Reset database (without imports)
reset_db() {
    drop
    create_db

    if [ "${migrate}" = true ]; then
        migrate
    else
        schema
    fi

    force=true; cache
}

## Create schema
schema() {
    echo_info "./bin/console doctrine:schema:create --dump-sql --env ${env}\n"
    ./bin/console doctrine:schema:create --dump-sql --env ${env}

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info "./bin/console doctrine:schema:create --env ${env} || true\n"
    ./bin/console doctrine:schema:create --env ${env} || true
}

## Truncate table
truncate() {
    if [ -z "${table}" ]; then
        echo_error '"table" cannot be empty\n'
        return 1
    fi

    if [ "$(_get_database_type)" = sqlite ]; then
        echo_info "./bin/console doctrine:query:sql \"DELETE FROM \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "DELETE FROM \`${table}\`" --env ${env}

        echo_info "./bin/console doctrine:query:sql 'VACUUM' --env ${env}\n"
        ./bin/console doctrine:query:sql 'VACUUM' --env ${env}
    else
        echo_info "./bin/console doctrine:query:sql \"TRUNCATE TABLE \`${table}\`\" --env ${env}\n"
        ./bin/console doctrine:query:sql "TRUNCATE TABLE \`${table}\`" --env ${env}
    fi
}

##################################################
### Fixtures
##################################################

## Load Alice fixtures
alice() {
    echo_info "./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}\n"
    ./bin/console hautelook:fixtures:load --no-bundles --no-interaction --env ${env}
}

## Load fixtures (doctrine)
fixtures() {
    echo_info "./bin/console doctrine:fixtures:load --no-interaction --env ${env}\n"
    ./bin/console doctrine:fixtures:load --no-interaction --env ${env}
}

##################################################
### Development
##################################################

# Check if symfony app is installed
_are_vendors_installed() {
    if [ -d ./vendor ]; then

        return 0
    fi

    return 1
}

# Load .env variables
_dotenv() {
    if [ -f ".env.${env}.local" ]; then
        eval "$(cat ".env.${env}.local")"
        return 0
    fi

    if [ -f ".env.${env}" ]; then
        eval "$(cat ".env.${env}")"
        return 0
    fi

    if [ -f ".env.local" ]; then
        eval "$(cat ".env.local")"
        return 0
    fi

    if [ -f .env ]; then
        eval "$(cat .env)"
        return 0
    fi

    echo_error '".env" file not found\n'
    exit 1
}

# Returns httpsuser
_get_httpduser() {
    _httpduser=''

    if _check_installed ps; then
        # https://symfony.com/doc/current/setup/file_permissions.html
        # shellcheck disable=SC2009
        _httpduser=$(ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1)
    fi

    if [ -z "${_httpduser}" ]; then
        echo www-data
    else
        echo "${_httpduser}"
    fi
}

## Run shapecode cron
cron() {
    echo_info "./bin/console shapecode:cron:run --env ${env}"
    ./bin/console shapecode:cron:run --env ${env}
}

## Scan shapecode cron
cron_scan() {
    echo_info "./bin/console shapecode:cron:scan --env ${env}"
    ./bin/console shapecode:cron:scan --env ${env}
}

## Generate JWT keys (jwt bundle)
generate_jwt() {
    echo_info 'rm -rf ./config/jwt\n'
    rm -rf ./config/jwt

    echo_info 'mkdir -p ./config/jwt\n'
    mkdir -p ./config/jwt

    echo_info 'grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl genpkey -out ./config/jwt/private.pem -pass stdin -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096\n'
    grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl genpkey -out ./config/jwt/private.pem -pass stdin -aes256 -algorithm rsa -pkeyopt rsa_keygen_bits:4096

    echo_info 'grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl pkey -in ./config/jwt/private.pem -passin stdin -out ./config/jwt/public.pem -pubout\n'
    grep ^JWT_PASSPHRASE .env | cut -f 2 -d= | openssl pkey -in ./config/jwt/private.pem -passin stdin -out ./config/jwt/public.pem -pubout
}

## Own project files
own() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    if [ -z "${owner}" ]; then
        owner=nobody
        group=nogroup
    else
        group="${owner}"
    fi

    for _file in \
        ./assets \
        ./bin \
        ./certs \
        ./logs \
        ./node_modules \
        ./var \
        ./vendor \
        ./volumes \
        .env.dev.local \
        .env.local \
        .env.prod.local \
        .php-cs-fixer.cache \
        composer.lock \
        symfony.lock \
        yarn.lock \
    ; do
        _own "${owner}" "${group}" "${_file}"
    done

    if [ "$(_get_database_type)" = sqlite ]; then
        for _file in \
            ./var/prod.db \
            ./var/dev.db \
            ./var/test.db \
        ; do
            _own "${owner}" "${group}" "${_file}"
        done
    fi
}

## Serve locally with PHP or Symfony
serve() {
    if _check_installed symfony; then
        echo_info "symfony serve --port=${port} --no-tls\n"
        symfony serve --port=${port} --no-tls
    else
        echo_info "php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public\n"
        php -d memory-limit=-1 -S 127.0.0.1:${port} -t ./public
    fi
}

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

##################################################
### Network
##################################################

# Remove hostname from /etc/hosts
_remove_host() {
    # Synopsis: remove_host <HOSTNAME>
    #   HOSTNAME:  The hostame to unset locally.

    if [ -z "$1" ]; then echo_danger 'error: _remove_host: some mandatory parameter is missing\n'; return 1; fi

    echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}

# Set new host in /etc/hosts
_set_host() {
    # Synopsis: set_host <HOSTNAME>
    #   HOSTNAME:  The hostame to set locally.

    if [ -z "$1" ]; then echo_danger 'error: _set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

## Install local SSL certificates
certificates() {
    _check_installed mkcert

    if [ ! -d ./certs ]; then
        echo_info 'mkdir certs\n'
        mkdir certs
    fi

    _install=''
    for domain in \
        ecoter \
        maildev \
        phpmyadmin \
        traefik \
    ; do
        _install="${_install} ${domain}.localhost *.${domain}.localhost"
    done

    if [ ! -f ./certs/local-key.pem ] && [ ! -f ./certs/local-cert.pem ]; then
        echo_info "mkcert -key-file ./certs/local-key.pem -cert-file ./certs/local-cert.pem ${_install}\n"
        # shellcheck disable=SC2086
        mkcert -key-file ./certs/local-key.pem -cert-file ./certs/local-cert.pem ${_install}

        echo_info 'mkcert -install\n'
        mkcert -install
    fi
}

## Remove local SSL certificates
certificates_remove() {
    _check_installed mkcert

    echo_info 'rm -f ./certs/local-key.pem\n'
    rm -f ./certs/local-key.pem

    echo_info 'rm -f ./certs/local-cert.pem\n'
    rm -f ./certs/local-cert.pem

    echo_info 'mkcert -uninstall\n'
    mkcert -uninstall
}

## Set /etc/hosts (local only)
hosts() {
    remove_hosts

    echo_info 'cat <<<EOT | sudo tee -a /etc/hosts\n'
    cat <<EOT | sudo tee -a /etc/hosts
127.0.0.1 dev.tangoman.localhost
127.0.0.1 tangoman.localhost
EOT
    echo_info "EOT\n"
}

## Remove /etc/hosts (local only)
remove_hosts() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    for _host_name in \
        dev.tangoman.io \
        dev.tangoman.localhost \
        tangoman.io \
        tangoman.localhost \
    ; do
        _remove_hosts "${_host_name}"
    done
}

##################################################
### Docker
##################################################

# Is container running
_is_running() {
    # Synopsys: _is_running [container_name]

    _check_installed docker

    if [ ${#} -lt 1 ]; then echo_danger 'error: _is_running: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _is_running: too many arguments (${#})\n"; return 1; fi

    if docker ps --quiet --format '{{.Names}}' 2>/dev/null | grep -E -q "^$1$"; then
        echo true
        return 0
    fi
    echo false
}

# Own files or folders
_own() {
    if [ ${#} -lt 3 ]; then echo_danger 'error: _own: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _own: too many arguments (${#})\n"; return 1; fi

    _owner="$1"
    _group="$2"
    _target="$3"

    if [ -d "${_target}" ];then
        echo_info "chown -R \"${_owner}:${_group}\" \"${_target}\"\n"
        chown -R "${_owner}:${_group}" "${_target}"

        echo_info "chmod 775 -R \"${_target}\"\n"
        chmod 775 -R "${_target}"
    elif [ -f "${_target}" ];then
        echo_info "chown \"${_owner}:${_group}\" \"${_target}\"\n"
        chown "${_owner}:${_group}" "${_target}"

        echo_info "chmod 664 -R \"${_target}\"\n"
        chmod 664 -R "${_target}"
    else
        echo_warning "file not found \"${_target}\"\n"
    fi
}

# Set permissions
_permissions() {
    _check_installed setfacl

    if [ ${#} -lt 2 ]; then echo_danger 'error: _own: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _own: too many arguments (${#})\n"; return 1; fi

    _httpduser="$1"
    _directory="$2"

    if [ -d "${_directory}" ]; then
        # set permissions for future files and folders
        echo_info "setfacl -dR -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -dR -m "u:${_httpduser}:rwX" "${_directory}"

        # set permissions on the existing files and folders
        echo_info "setfacl -R -m \"u:${_httpduser}:rwX\" \"${_directory}\"\n"
        setfacl -R -m "u:${_httpduser}:rwX" "${_directory}"
    else
        echo_warning "directory not found \"${_directory}\"\n"
    fi
}

## Build containers
build() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.prod.yml build\n'
            docker compose -f compose.prod.yml build
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.dev.yml build\n'
            docker compose -f compose.dev.yml build
        else
            echo_info 'docker compose build\n'
            docker compose build
        fi
    fi

    if [ "${_database_type}" = postgresql ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.postgres.prod.yml build\n'
            docker compose -f compose.postgres.prod.yml build
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.postgres.dev.yml build\n'
            docker compose -f compose.postgres.dev.yml build
        else
            echo_info 'docker compose -f compose.postgres.yml build\n'
            docker compose -f compose.postgres.yml build
        fi
    fi

}

## Get running container ip
container_ip() {
    _check_installed docker

    if [ -n "$1" ]; then
        container="$1"
    fi

    if [ -z "${container}" ]; then
        echo_error 'container name cannot be empty\n'
        return 1
    fi

    docker inspect "$(container_name "${container}")" --format '{{range .NetworkSettings.Networks}}{{if .IPAddress}}{{.IPAddress}}{{end}}{{end}}' 2>/dev/null
}

## Get container full name
container_name() {
    _check_installed docker

    if [ -n "$1" ]; then
        container="$1"
    fi

    if [ -z "${container}" ]; then
        echo_error 'container name cannot be empty\n'
        return 1
    fi

    # sed to remove forbidden characters
    _project_name=$(basename "$(pwd)" | sed 's/[^a-zA-Z0-9_-]//g')

    # get container names
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .Name 1}}' $(docker ps --all --quiet) | grep "${_project_name}" | grep "${container}" | head -n1

    # get container names withg docker compose
    # docker compose ps --format '{{.Name}}' | grep "${_project_name}" | grep "${container}" | head -n1
}

## Print Docker log
docker_logs() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info "docker compose logs -f \"$(container_name)\"\n"
    docker compose logs -f "$(container_name)"
}

## Fix permission issue (777 hack)
fix_permissions() {
    _check_installed mkdir
    _check_installed chmod

    for _folder in \
        ./assets \
        ./certs \
        ./drivers \
        ./logs \
        ./migrations \
        ./public \
        ./var \
        ./var/cache \
        ./var/log \
        ./vendor \
        ./volumes \
    ; do
        if [ ! -d ${_folder} ]; then
            echo_info "mkdir ${_folder}\n"
            mkdir ${_folder}
        fi

        echo_info "chmod 777 -R ${_folder}\n"
        chmod -R 777 ${_folder}
    done
}

## Generate APP_SECRET
generate_app_secret() {
    _check_installed openssl

    if [ -f .env.local ]; then
        echo_info "sed -i -r \"/APP_SECRET=/s/[a-z0-9]+/\$(openssl rand -hex 16)/\" \".env.local\"\n"
        sed -i -r "/APP_SECRET=/s/[a-z0-9]+/$(openssl rand -hex 16)/" ".env.local"
    fi
}

## Remove images
images_remove() {
    _check_installed docker

    echo_info "docker rm \"$(container_name nginx)\" || true\n"
    docker rm "$(container_name nginx)" || true

    echo_info "docker rm \"$(container_name php)\" || true\n"
    docker rm "$(container_name php)" || true
}

## Create "traefik" network
network() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network create traefik || true\n'
    docker network create traefik || true
}

## Remove "traefik" network
network_remove() {
    _check_installed docker

    # following command will not break script execution on failure even with `-e` option enabled
    echo_info 'docker network rm traefik || true\n'
    docker network rm traefik || true
}

## Open container in default browser
open() {
    _container_name="$(container_name nginx)"
    _container_ip="$(container_ip "${_container_name}")"

    echo_info "nohup xdg-open \"http://${_container_ip}\" >/dev/null 2>&1\n"
    nohup xdg-open "http://${_container_ip}" >/dev/null 2>&1
}

## Set correct permissions
permissions() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _httpduser=$(_get_httpduser)

    for _directory in \
        ./assets \
        ./bin \
        ./certs \
        ./logs \
        ./node_modules \
        ./var \
        ./vendor \
        ./volumes \
    ; do
        _permissions "${_httpduser}" "${_directory}"
    done
}

## Remove symlink
remove_symlink() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _container_project_directory=/var/www

    echo_info "rm -f \"${_container_project_directory}\"\n"
    rm -f "${_container_project_directory}"
}

## Shell into "php" container
shell() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    clear
    echo_info 'docker compose exec -it php sh\n'
    docker compose exec -it php sh
}

## Build and start container stack
start() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    _database_type=$(_get_database_type)

    if [ "${_database_type}" = sqlite ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.dev.yml up --detach --remove-orphans
        else
            echo_info 'docker compose up --detach --remove-orphans\n'
            docker compose up --detach --remove-orphans
        fi
    fi

    if [ "${_database_type}" = postgresql ]; then
        if [ "${env}" = prod ]; then
            echo_info 'docker compose -f compose.postgres.prod.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.prod.yml up --detach --remove-orphans
        elif [ "${env}" = dev ]; then
            echo_info 'docker compose -f compose.postgres.dev.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.dev.yml up --detach --remove-orphans
        else
            echo_info 'docker compose -f compose.postgres.yml up --detach --remove-orphans\n'
            docker compose -f compose.postgres.yml up --detach --remove-orphans
        fi
    fi
}

## Print app status
status() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    # echo_info "docker inspect --format='{{index .Config.Labels "com.docker.compose.project.config_files"}}' $(docker ps --all --quiet)\n"
    # # shellcheck disable=SC2046
    # docker inspect --format='{{index .Config.Labels "com.docker.compose.project.config_files"}}' $(docker ps --all --quiet)

    echo_info "docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{index .Config.Labels \"com.docker.compose.project.config_files\"}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .ID 0 13}} {{slice .Name 1}} {{index .Config.Labels "com.docker.compose.project.config_files"}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}

## Stop container stack
stop() {
    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    echo_info 'docker compose stop || true\n'
    docker compose stop || true
}

## Create symlink to match container project directory structure
symlink() {
    if ! _is_root; then
        echo_error "\"${USER}\" does not own root privileges\n"
        return 1
    fi

    _host_project_directory="$(pwd)"
    _container_project_directory=/var/www

    echo_info "ln -s \"${_host_project_directory}\" \"${_container_project_directory}\"\n"
    ln -s "${_host_project_directory}" "${_container_project_directory}"
}

## Create network, build container, start docker, composer install, create database, import data
up() {
    alert_primary "Spawning project with \"${env}\" environment"

    if [ -z "$(docker compose -v)" ]; then
        echo_error "\"$(basename "${0}")\" requires docker compose plugin\n"
        return 1
    fi

    network
    build
    start

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh install --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh install --env ${env}"

    if [ "${import}" = true ]; then
        echo_info "docker compose exec php sh -c \"sh entrypoint.sh import --env ${env}\"\n"
        docker compose exec php sh -c "sh entrypoint.sh import --env ${env}"
    fi

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --force --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --force --env ${env}"

    echo_info "docker compose exec php sh -c \"sh entrypoint.sh cache --env ${env}\"\n"
    docker compose exec php sh -c "sh entrypoint.sh cache --env ${env}"
}

##################################################
### Front
##################################################

## Dump app assets
assetic() {
    echo_info "./bin/console assetic:dump --env=\"${env}\"\n"
    ./bin/console assetic:dump --env="${env}"
}

## Install bundle assets
assets_install() {
    echo_info "./bin/console assets:install --env=\"${env}\"\n"
    ./bin/console assets:install --env="${env}"
}

## Install Ck Editor
ckeditor() {
    echo_info "./bin/console ckeditor:install --no-interaction --env ${env}\n"
    ./bin/console ckeditor:install --no-interaction --env ${env}
}

## Run webpack encore
encore() {
    _check_installed yarn

    echo_info 'yarn install\n'
    yarn install

    if [ "${env}" = prod ]; then
        echo_info 'yarn run encore production\n'
        yarn run encore production
    else
        echo_info 'yarn run encore dev\n'
        yarn run encore dev
    fi
}

## Watch with webpack encore
encore_watch() {
    _check_installed yarn

    echo_info 'yarn install\n'
    yarn install

    echo_info 'yarn run encore dev --watch\n'
    yarn run encore dev --watch
}

## Compile scss
sass_build() {
    _check_installed sass

    echo_info 'sass assets/scss/styles.scss public/css/styles.css\n'
    sass assets/scss/styles.scss public/css/styles.css
}

## Watch scss
sass_watch() {
    _check_installed sass

    echo_info 'sass --watch assets/scss:public/css\n'
    sass --watch assets/scss:public/css
}

#--------------------------------------------------
# Symfony
#--------------------------------------------------

# Get Symfony correct console binary path
_console() {
    if [ -f ./app/console ]; then
        echo './app/console'

        return 0
    fi

    if [ -f ./bin/console ]; then
        echo './bin/console'

        return 0
    fi

    echo_danger "error: \"$(basename "${0}")\" requires symfony, try: 'composer install'\n"
    return 1
}

## Install project dependencies with composer
composer_install() {
    echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(pwd)"
}

## Clear cache
cache() {
    echo_info "php -d memory_limit=-1 ./bin/console cache:clear --env ${env}\n"
    php -d memory_limit=-1 ./bin/console cache:clear --env ${env}

    echo_info "php -d memory_limit=-1 ./bin/console cache:warmup --env ${env}\n"
    php -d memory_limit=-1 ./bin/console cache:warmup --env ${env}
}

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

# Place here commands you need executed by default
_default() {
    help
}

# Place here commands you need executed first every time
_before() {
    if ! requirements; then
        return 1
    fi

    # this will resolve to current project directory
    # or to "pwd" when script is installed globally via copy
    # remove if you don't need script to change to project directory
    cd "$(_pwd)" || return 1
}

# Place here commands you need executed last every time
_after() {
    true
}

###################################################
# TangoMan Shoe Shell Microframework
###################################################

#--------------------------------------------------
# Generated code : Do not edit below this line
#--------------------------------------------------

#--------------------------------------------------
#_ Colors
#--------------------------------------------------

# shellcheck disable=SC2034
{
    PRIMARY='\033[97m'; SECONDARY='\033[94m'; SUCCESS='\033[32m'; DANGER='\033[31m'; WARNING='\033[33m'; INFO='\033[95m'; LIGHT='\033[47;90m'; DARK='\033[40;37m'; DEFAULT='\033[0m'; EOL='\033[0m\n'; 
    ALERT_PRIMARY='\033[1;104;97m'; ALERT_SECONDARY='\033[1;45;97m'; ALERT_SUCCESS='\033[1;42;97m'; ALERT_DANGER='\033[1;41;97m'; ALERT_WARNING='\033[1;43;97m'; ALERT_INFO='\033[1;44;97m'; ALERT_LIGHT='\033[1;47;90m'; ALERT_DARK='\033[1;40;37m';
}

# Synopsis: echo_* <STRING> [INDENTATION] [PADDING]
#  STRING:       Text to display.
#  INDENTATION:  Indentation level (default: 0).
#  PADDING:      Padding length (default: 0).
#  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
#                this is why we're calculating the PADDING length on each execution.

# Print primary (bright white text)
echo_primary()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${PRIMARY}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print secondary (bright blue text)
echo_secondary() { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SECONDARY}%b${DEFAULT}%*s" "$2" '' "$1" "$3" ''; }

# Print success (bright green text)
echo_success()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${SUCCESS}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print danger (red text)
echo_danger()    { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DANGER}%b${DEFAULT}%*s"    "$2" '' "$1" "$3" ''; }

# Print warning (orange text)
echo_warning()   { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${WARNING}%b${DEFAULT}%*s"   "$2" '' "$1" "$3" ''; }

# Print info (bright purple text)
echo_info()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${INFO}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Print light (black text over white background)
echo_light()     { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${LIGHT}%b${DEFAULT}%*s"     "$2" '' "$1" "$3" ''; }

# Print dark (white text over black background)
echo_dark()      { if [ ${#} -eq 1 ]; then set -- "$1" 0 0; elif [ ${#} -eq 2 ]; then set -- "$1" "$2" 0; fi; set -- "$1" "$2" "$(($3-${#1}))"; if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi; printf "%*s${DARK}%b${DEFAULT}%*s"      "$2" '' "$1" "$3" ''; }

# Synopsis: alert_* <STRING>
#  STRING:  Text to display.

# Print primary alert (bold white text over bright blue background)
alert_primary()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_PRIMARY}"   '' "${ALERT_PRIMARY}"   "$1" "${ALERT_PRIMARY}"   ''; }

# Print secondary alert (bold white text over bright purple background)
alert_secondary() { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SECONDARY}" '' "${ALERT_SECONDARY}" "$1" "${ALERT_SECONDARY}" ''; }

# Print success alert (bold white text over bright green background)
alert_success()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_SUCCESS}"   '' "${ALERT_SUCCESS}"   "$1" "${ALERT_SUCCESS}"   ''; }

# Print danger alert (bold white text over bright red background)
alert_danger()    { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DANGER}"    '' "${ALERT_DANGER}"    "$1" "${ALERT_DANGER}"    ''; }

# Print warning alert (bold white text over bright orange background)
alert_warning()   { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_WARNING}"   '' "${ALERT_WARNING}"   "$1" "${ALERT_WARNING}"   ''; }

# Print info alert (bold white text over bright blue background)
alert_info()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_INFO}"      '' "${ALERT_INFO}"      "$1" "${ALERT_INFO}"      ''; }

# Print light alert (black text over white background)
alert_light()     { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_LIGHT}"     '' "${ALERT_LIGHT}"     "$1" "${ALERT_LIGHT}"     ''; }

# Print dark alert (bold white text over black background)
alert_dark()      { printf "${EOL}%b%64s${EOL}%b %-63s${EOL}%b%64s${EOL}\n" "${ALERT_DARK}"      '' "${ALERT_DARK}"      "$1" "${ALERT_DARK}"      ''; }

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install() {
    if [ -n "${global}" ] && [ "${global}" = true ]; then
        _copy_install "$0" "${ALIAS}"
        _generate_global_autocomplete "$0" "${ALIAS}"
    else
        _symlink_install "$0" "${ALIAS}"
        _generate_autocomplete "$0" "${ALIAS}"
    fi

    if _check_installed zsh; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$0" "${ALIAS}" || true
    fi

    if _check_installed bash; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            set -- ~/.profile "$0" "${ALIAS}"
        else
            set -- ~/.bashrc "$0" "${ALIAS}"
        fi
        if [ -f "$1" ]; then
            _set_completion_autoload "$1" "$2" "${ALIAS}"
        fi
    fi
}

## Uninstall script from system
self_uninstall() {
    _uninstall "$0" "${ALIAS}"
}

## Update script from @update-link
self_update() {
    _update "$0" "$(_get_docbloc "$0" 'update-link')"
}

# Generate comspec string
_get_comspec() {
    # Synopsis: _get_comspec <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_comspec: too many arguments (${#})\n"; return 1; fi
    set -- "$(realpath "$1")"

    awk '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s ",FUNCTION,substr(PREV,4)
    } { PREV = $0 }' "$1"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") {
            printf "--%s ",$1
        }
    } { PREV = $0 }' "$1"
}

# Install script via copy (beta)
_copy_install() {
    # Synopsis: _copy_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _copy_install: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _copy_install: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo cp -a \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -a "$1" "/usr/local/bin/$2"
}

# Remove completion script autoload
_remove_completion_autoload() {
    # Synopsis: _remove_completion_autoload <SHELL_CONFIG_FILE> [ALIAS]
    # Removes an autoload line for a completion script from a shell configuration file.
    #   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
    #   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _remove_completion_autoload: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

# Generates an autocomplete script for the provided file.
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

# Adds an autoload line for completion script to a shell configuration file.
_set_completion_autoload() {
    # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <SCRIPT_FILE_PATH> [ALIAS]
    #   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).
    #   SCRIPT_FILE_PATH:        The path to the input file.
    #   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file.

    if [ -z "$1" ]  || [ -z "$2" ]; then echo_danger 'error: _set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _set_completion_autoload: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then echo_danger "error: _set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$1" .sh)"}"

    # declare inner function
    __set_completion_autoload() {
        # Synopsis: _set_completion_autoload <SHELL_CONFIG_FILE_PATH> <COMPLETION_FILE_PATH> <ALIAS>
        # remove previous install if any
        $(_sed_i) "/^###> $3$/,/^###< $3$/d" "$1"

        echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$3\" \"$2\" \"$3\" >> \"$1\"\n"
        printf '\n###> %s\nsource %s\n###< %s\n' "$3" "$2" "$3" >> "$1"

        _collapse_blank_lines "$1"
    }

    # set global completion file path
    if [ -f "/etc/bash_completion.d/$3" ]; then
        __set_completion_autoload "$1" "/etc/bash_completion.d/$3" "$3"
    fi

    # set completion file path
    if [ -f "$(dirname "$2")/$3-completion.sh" ]; then
        __set_completion_autoload "$1" "$(dirname "$2")/$3-completion.sh" "$3"
    fi
}

# Creates a system-wide autocomplete script for the provided file.
_generate_global_autocomplete() {
    # Synopsis: _generate_global_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file.
    #   note:       This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
    #               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
    #               It uses sudo for file creation in a system directory, requiring root privileges.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_global_autocomplete: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

# Install script via symlink
_symlink_install(){
    # Synopsis: _symlink_install <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file.
    #   note:       Creates a symbolic link in the /usr/local/bin/ directory.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _symlink_install too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _symlink_install \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    sudo ln -s "$1" "/usr/local/bin/$2"
}

# Uninstall script from system
_uninstall() {
    # Synopsis: _uninstall <FILE_PATH> [ALIAS]
    #   FILE_PATH:  The path to the input file.
    #   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the current script.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _uninstall: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _uninstall: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    if [ -f "$1" ]; then
        echo_info "sudo rm -f \"/usr/local/bin/$2\"\n"
        sudo rm -f "/usr/local/bin/$2"
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

# Updates the script from the provided URL.
_update() {
    # Synopsis: _update <FILE_PATH> <URL>
    #   FILE_PATH:  The path to the input file.
    #   URL:        The URL of the script to download and install.

    if [ ${#} -lt 1 ] || [ -z "$1" ]; then echo_danger 'error: _update: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _update: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _update: \"$1\" file not found\n"; return 1; fi

    if _check_installed curl; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$1")\"\n"
        curl -sSL "$1" > "$(realpath "$1")"

    elif _check_installed  wget; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$1")\"\n"
        wget -qO - "$1" > "$(realpath "$1")"

    else
        echo_danger "error: \"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    "$(realpath "$1")" self_install
}

##################################################
### Documentation
##################################################

## Generate Markdown documentation for current shoe script
generate_doc() {
    _generate_doc "$0"
}

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <FILE_PATH> [DESTINATION] [FILE_NAME] [GET_PRIVATE]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
    #   GET_PRIVATE:  (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; return 1; fi

    alert_primary "Generating $3"

    (
        printf '%s\n===\n\n' "$(_get_docbloc_title "$1")"

        printf '## ℹ️ Infos\n\n'
        printf '\055 author:  %s\n' "$(_get_docbloc "$1" 'author')"
        printf '\055 version: %s\n' "$(_get_docbloc "$1" 'version')"
        printf '\055 link:    %s\n' "$(_get_docbloc "$1" 'link')"
        printf '\n'

        printf '## 📑 Description\n\n'
        _get_docbloc_description "$1"
        printf '\n\n'

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_")
            printf "(--%s %s) ",$1,$2
        } { PREV = $0 }' "$1"
        awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0,1,1) != "_")
            printf "(--%s) ",$1
        } { PREV = $0 }' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                printf "%d. **%s**\n  - %s\n  - Value: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## ") next;
                if (GET_PRIVATE == "false" && substr($0,1,1) == "_") next;
                if ($1 != toupper($1)) printf "%d. **`--%s`**\n  - %s\n\n",++i,$1,substr(PREV,4)
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## ") next;
                if (GET_PRIVATE == "false" && substr($0,1,1) == "_") next;
                if ($1 != toupper($1) && $2 != "false") {
                    if (match(PREV,/ \/.+\//)) {
                        CONSTRAINT=substr(PREV,RSTART+1,RLENGTH);
                        DESCRIPTION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                        printf "%d. **`--%s`**\n  - Description: %s\n  - Constraint: `%s`\n  - Default: _%s_\n\n",++i,$1,DESCRIPTION,CONSTRAINT,$2
                    } else {
                        printf "%d. **`--%s`**\n  - Description: %s\n  - Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
                    }
                }
            } { PREV = $0 }' "$1"
        fi

        printf '## 🤖 Commands\n\n'
        awk -v GET_PRIVATE="$4" '/^#(##|_) / {
            if (GET_PRIVATE == "false" && substr(PREV,1,4) != "### ") next;
                sub("^#(##|_) ","");
                i=0; printf"### ⚡ %s\n\n",$0
            }
            /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
            if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
            sub("^function ",""); gsub("[ ()]","");
            FUNCTION = substr($0,1,index($0,"{"));
            sub("{$","",FUNCTION);
            if (match(PREV,/^#.+/)) {
                sub("^##? ","",PREV);
                printf "%d. **`%s`**\n  - %s\n\n",++i,FUNCTION,PREV
            } else {
                printf "%d. **`%s`**\n\n",++i,FUNCTION
            }
        } { PREV = $0 }' "$1"
    ) > "$2/$3"

    echo_success "Documentation generated : \"$2/$3\"\n"
}

##################################################
### Makefile
##################################################

## Generate Makefile documentation for current shoe script
generate_makefile() {
    _generate_makefile "$0"
}

# Generate Makefile documentation for provided shoe script
_generate_makefile() {
    # Synopsis: _generate_makefile <FILE_PATH> [DESTINATION] [FILE_NAME]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then echo_danger 'error: _generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_makefile: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_makefile: \"$2\" folder not found\n"; return 1; fi

    alert_primary "Generating $3"

    cat > "$2/$3" <<'EOT'
#/**
# * TangoMan shoe
# *
# * Run "make" to print help
# * If you want to add a help message for your rule, 
# * just add : "## My help for this rule", on the previous line
# * use : "### " to group rules by categories
# * You can give "make" arguments with this syntax: PARAMETER=VALUE
# *
# * @version 1.0.0
# * @author  "Matthias Morin" <mat@tangoman.io>
# * @license MIT
# * @link    https://github.com/TangoMan75/shoe
# */

EOT

    # generate .PHONY
    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } { PREV = $0 }' "$1" >> "$2/$3"

    cat >> "$2/$3" <<'EOT'

##################################################
# Colors
##################################################

PRIMARY   = \033[97m
SECONDARY = \033[94m
SUCCESS   = \033[32m
DANGER    = \033[31m
WARNING   = \033[33m
INFO      = \033[95m
LIGHT     = \033[47;90m
DARK      = \033[40;37m
DEFAULT   = \033[0m
EOL       = \033[0m\n

ALERT_PRIMARY   = \033[1;104;97m
ALERT_SECONDARY = \033[1;45;97m
ALERT_SUCCESS   = \033[1;42;97m
ALERT_DANGER    = \033[1;41;97m
ALERT_WARNING   = \033[1;43;97m
ALERT_INFO      = \033[1;44;97m
ALERT_LIGHT     = \033[1;47;90m
ALERT_DARK      = \033[1;40;37m

##################################################
# Color Functions
##################################################

define echo_primary
	@printf "${PRIMARY}%b${EOL}" $(1)
endef
define echo_secondary
	@printf "${SECONDARY}%b${EOL}" $(1)
endef
define echo_success
	@printf "${SUCCESS}%b${EOL}" $(1)
endef
define echo_danger
	@printf "${DANGER}%b${EOL}" $(1)
endef
define echo_warning
	@printf "${WARNING}%b${EOL}" $(1)
endef
define echo_info
	@printf "${INFO}%b${EOL}" $(1)
endef
define echo_light
	@printf "${LIGHT}%b${EOL}" $(1)
endef
define echo_dark
	@printf "${DARK}%b${EOL}" $(1)
endef

define alert_primary
	@printf "${EOL}${ALERT_PRIMARY}%64s${EOL}${ALERT_PRIMARY} %-63s${EOL}${ALERT_PRIMARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_secondary
	@printf "${EOL}${ALERT_SECONDARY}%64s${EOL}${ALERT_SECONDARY} %-63s${EOL}${ALERT_SECONDARY}%64s${EOL}\n" "" $(1) ""
endef
define alert_success
	@printf "${EOL}${ALERT_SUCCESS}%64s${EOL}${ALERT_SUCCESS} %-63s${EOL}${ALERT_SUCCESS}%64s${EOL}\n" "" $(1) ""
endef
define alert_danger
	@printf "${EOL}${ALERT_DANGER}%64s${EOL}${ALERT_DANGER} %-63s${EOL}${ALERT_DANGER}%64s${EOL}\n" "" $(1) ""
endef
define alert_warning
	@printf "${EOL}${ALERT_WARNING}%64s${EOL}${ALERT_WARNING} %-63s${EOL}${ALERT_WARNING}%64s${EOL}\n" "" $(1) ""
endef
define alert_info
	@printf "${EOL}${ALERT_INFO}%64s${EOL}${ALERT_INFO} %-63s${EOL}${ALERT_INFO}%64s${EOL}\n" "" $(1) ""
endef
define alert_light
	@printf "${EOL}${ALERT_LIGHT}%64s${EOL}${ALERT_LIGHT} %-63s${EOL}${ALERT_LIGHT}%64s${EOL}\n" "" $(1) ""
endef
define alert_dark
	@printf "${EOL}${ALERT_DARK}%64s${EOL}${ALERT_DARK} %-63s${EOL}${ALERT_DARK}%64s${EOL}\n" "" $(1) ""
endef

##################################################
# Help
##################################################

## Print this help
help:
	$(call alert_primary, "TangoMan $(shell basename ${CURDIR})")

	@printf "${WARNING}Description:${EOL}"
	@printf "${PRIMARY}  Place desired .sh files inside ./src folder${EOL}"
	@printf "${PRIMARY}  Add your .sh files to ./config/build.lst to concatenate them${EOL}\n"

	@printf "${WARNING}Usage:${EOL}"
	@printf "${PRIMARY}  make [command]${EOL}\n"

	@printf "${WARNING}Commands:${EOL}"
	@awk '/^### /{printf"\n${WARNING}%s${EOL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
		printf "${SUCCESS}  %-12s  ${PRIMARY}%s${EOL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

EOT

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" 'BEGIN {HR="##################################################\n"}
        /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf "## %s\n%s:\n\t@printf \"${INFO}sh %s %s${EOL}\"\n\t@sh %s %s\n\n",substr(PREV,4),FUNCTION,SHELL_SCRIPT,FUNCTION,SHELL_SCRIPT,FUNCTION,FUNCTION
    } { PREV = $0 }' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"
}

##################################################
### Help
##################################################

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title "$0")"
    _print_infos
    _print_description "$(_get_docbloc_description "$0")"
    _print_usage
    _print_constants   "${_padding}"
    _print_flags       "${_padding}"
    _print_options     "${_padding}"
    _print_commands    "${_padding}"
}

# Guess padding length from longest command of the current shoe script
_get_padding() {
    # Synopsis: _get_padding

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ { MATCH = $1 }
    /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        MATCH = substr($0,1,index($0,"{"));
        sub("{$","",MATCH);
    } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
    { PREV = $0 } END { print LENGTH+1 }' "$0"
}

# Print provided text formatted as a description
_print_title() {
    # Synopsis: _print_title <TITLE>
    #   TITLE:  A string containing script title.

    alert_primary "$1"
}

# Print infos of the of the current shoe script
_print_infos() {
    # Synopsis: _print_infos

    echo_warning 'Infos:\n'
    echo_success 'author'  2 9; echo_primary "$(_get_docbloc "$0" 'author')\n"
    echo_success 'version' 2 9; echo_primary "$(_get_docbloc "$0" 'version')\n"
    echo_success 'link'    2 9; echo_primary "$(_get_docbloc "$0" 'link')\n"
    printf '\n'
}

# Print provided text formatted as a description
_print_description() {
    # Synopsis: _print_description <DESCRIPTION>
    #   DESCRIPTION:  A string containing script description.

    echo_warning 'Description:\n'
    echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

# Print usage of the of the current shoe script
_print_usage() {
    # Synopsis: _print_usage

    echo_warning 'Usage:\n'
    echo_info "sh $(basename "$0") [" 2; echo_success 'command'; echo_info '] '
    # options
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v WARNING="${WARNING}" -v DEFAULT="${DEFAULT}" '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
        printf "%s(%s--%s %s%s%s)%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } { PREV = $0 }' "$0"
    # flags
    awk -F '=' -v INFO="${INFO}" -v SUCCESS="${SUCCESS}" -v DEFAULT="${DEFAULT}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
        printf "%s(%s--%s%s)%s ",INFO,SUCCESS,$1,INFO,DEFAULT
    } { PREV = $0 }' "$0"
    printf '\n\n'
}

# List flags of the of the current shoe script
_print_flags() {
    # Synopsis: _print_flags [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    set -- $(($1-2))
    echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^[a-zA-Z0-9_]+=false\$/ {
        if (substr(PREV, 1, 3) == \"## \" && \$1 != toupper(\$1) && substr(\$0, 1, 1) != \"_\")
        printf \"%s  --%-$1s %s%s\n\",SUCCESS,\$1,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List constants of the of the current shoe script
_print_constants() {
    # Synopsis: _print_constants [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" -v INFO="${INFO}" -v WARNING="${WARNING}" -v EOL="${EOL}" "/^[A-Z0-9_]+=.+\$/ {
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\")
        printf \"%s  %-$1s %s%s%s (value: %s%s%s)%s\",SUCCESS,\$1,PRIMARY,substr(PREV,4),INFO,WARNING,\$2,INFO,EOL
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List options of the of the current shoe script
_print_options() {
    # Synopsis: _print_options [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    set -- $(($1-2))
    echo_warning "Options:\n"
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v INFO="${INFO}" -v DEFAULT="${DEFAULT}" -v EOL="${EOL}" -F '=' "/^[a-zA-Z0-9_]+=.+\$/ {
        if (substr(PREV,1,3) == \"## \" && \$1 != toupper(\$1) && \$2 != \"false\" && substr(\$0,1,1) != \"_\") {
            if (match(PREV,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(PREV,RSTART,RLENGTH);
                ANNOTATION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                printf \"%s  --%-$1s %s%s%s %s%s (default: %s%s%s)%s\",SUCCESS,\$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,\$2,INFO,EOL
            } else {
                ANNOTATION=substr(PREV,4);
                printf \"%s  --%-$1s %s%s%s (default: %s%s%s)%s\",SUCCESS,\$1,DEFAULT,ANNOTATION,INFO,WARNING,\$2,INFO,EOL
            }
        }
    } { PREV = \$0 }" "$0"
    printf '\n'
}

# List commands of the of the current shoe script
_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^### /{printf\"\n%s%s:%s\n\",WARNING,substr(\$0,5),PRIMARY}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\"); # remove leading \"function \", round brackets and extra spaces
        FUNCTION = substr(\$0,1,index(\$0,\"{\"));      # truncate string after opening curly brace
        sub(\"{\$\",\"\",FUNCTION);                     # remove trailing curly brace
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\") # ignore private functions
        printf \"%s  %-$1s %s%s\n\",SUCCESS,FUNCTION,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

#--------------------------------------------------
#_ Docbloc
#--------------------------------------------------

# Get docbloc at the top the provided shoe script file
_get_docbloc() {
    # Synopsis: _get_docbloc <FILE_PATH> <TAG_NAME>
    #   FILE_PATH:  The path to the input file.
    #   TAG_NAME:   The name of the docbloc parameter to return.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ ${#} -lt 2 ] || [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: \"$1\" file not found\n"; return 1; fi

    awk -v TAG="$2" '/^#\/\*\*$/,/^# \*\/$/{if($3=="@"TAG){for(i=4;i<=NF;++i){printf "%s ",$i}}}' "$(realpath "$1")" | sed -E 's/ +$//'
}

# Get docbloc description at the top the provided shoe script file
_get_docbloc_description() {
    # Synopsis: _get_docbloc_description <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_description: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_description: \"$1\" file not found\n"; return 1; fi

    awk '/^# \* @/ {i=2} /^#\/\*\*$/,/^# \*\/$/{i+=1; if (i>3) printf "%s ", substr($0, 5)}' "$(realpath "$1")"
}

# Get docbloc title at the top the provided shoe script file
_get_docbloc_title() {
    # Synopsis: _get_docbloc_title <FILE_PATH>
    #   FILE_PATH:  The path to the input file.
    #   note:       To change displayed items, edit docblock infos at the top of the file.

    if [ -z "$1" ]; then echo_danger 'error: _get_docbloc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _get_docbloc_title: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _get_docbloc_title: \"$1\" file not found\n"; return 1; fi

    awk '/^#\/\*\*$/,/^# \*\/$/{i+=1; if (i==2) print substr($0, 5)}' "$(realpath "$1")"
}

#--------------------------------------------------
#_ System compatibility
#--------------------------------------------------

# Open with default handler
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

# Return sed -i system flavour
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
#_ Sytem
#--------------------------------------------------

# Print error message if provided command is missing
_check_installed() {
    # Synopsis: _check_installed <COMMAND>
    #   COMMAND:  A string containing command name.

    if [ -z "$1" ]; then echo_danger 'error: _check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _check_installed: too many arguments (${#})\n"; return 1; fi

    if ! _is_installed "$1"; then
        echo_danger "error: \"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $1'\n"

        return 1
    fi

    return 0
}

# Check provided command is installed
_is_installed() {
    # Synopsis: _is_installed <COMMAND>
    #   COMMAND:  A string containing command name.

    if [ ${#} -lt 1 ]; then echo_danger 'error: _is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _is_installed: too many arguments (${#})\n"; return 1; fi

    if [ -x "$(command -v "$1")" ]; then

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x "/home/linuxbrew/.linuxbrew/bin/$1" ]; then

        return 0
    fi

    return 1
}

# Check user is root
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        return 0
    fi

    return 1
}

# Return current project directory path, or "pwd" when installed globally
_pwd() {
    # Synopsis: _pwd

    if [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

# Install required command
_require() {
    # Synopsis: _require <COMMAND> [FROM_PACKAGE_NAME] [PACKAGE_MANAGER]
    #   COMMAND:           The command/package to install.
    #   FROM_PACKAGE_NAME: (optional) The package name where the command should be found (if different). Defaults to "COMMAND".
    #   PACKAGE_MANAGER:   (optional) The package manager required to install the package with. Defaults to "apt".
    #   note:              "FROM_PACKAGE_NAME" is required if you need to set "PACKCAGE_MANAGER" parameter.
    #                      eg: `_require curl` will install "curl" with "sudo apt install --yes curl".
    #                      eg: `_require adb android-tools-adb` will install "android-tools-adb" package.
    #                      eg: `_require node-sass node-sass "yarn global add"` will install "node-sass" with "yarn".

    if [ ${#} -lt 1 ]; then echo_danger 'error: _require: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _require: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-$1}" "${3:-apt}"

    # define inner function
    __require() {
        echo_info "$1\n"
        $1
    }

    if ! _is_installed "$3"; then
        echo_danger "error: \"$(basename "${0}")\" requires $3, try: 'sudo apt-get install -y $3'\n"
        exit 1
    fi

    if ! _is_installed "$1"; then
        if [ "$3" = apt ]; then
            __require "sudo apt install --yes $1"

        elif [ "$3" = apt-get ]; then
            __require "sudo apt-get install --assume-yes $1"

        elif [ "$3" = dnf ]; then
            __require "sudo dnf install --assumeyes --nogpgcheck -y $1"

        elif [ "$3" = flatpak ]; then
            __require "flatpak install --non-interactive $1"

        elif [ "$3" = pacman ]; then
            __require "sudo pacman -Sy $1"

        elif [ "$3" = yum ]; then
            __require "sudo yum install --assumeyes $1"

        elif [ "$3" = zypper ]; then
            __require "sudo zypper install --non-interactive $1"
        fi
    fi
}

# Check user exists
_user_exists() {
    if [ -z "$1" ]; then echo_danger 'error: _user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _user_exists: too many arguments (${#})\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

#--------------------------------------------------
#_ Validation
#--------------------------------------------------

# Checks if variable is valid given regex constraint
_is_valid() {
    # Synopsis: _is_valid <VALUE> <PATTERN>
    #   VALUE:    The string to be compared to regex pattern.
    #   PATTERN:  The regex parttern to apply.
    #   TODO:     "nullable=true" ; "nullable=false" : "length=10"

    if [ ${#} -lt 2 ]; then echo_danger 'error: _is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _is_valid: too many arguments (${#})\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # if [ "$1" != "$(tr -dc "$2" < printf '%s' "$1" | fold -w "${length}" | head -n 1)" ]; then
    if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then

        return 1
    fi

    return 0
}

# Find constraints and validates a variable
_validate() {
    # Synopsis: _validate <VARIABLE>
    #   VARIABLE: The variable to validate in the followling format : variable_name=value.

    if [ -z "$1" ]; then echo_danger 'error: _validate: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _validate: too many arguments (${#})\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2)" "$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")"

    if ! _is_valid "$2" "$3"; then
        echo_danger "error: invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

#--------------------------------------------------
#_ Reflexion
#--------------------------------------------------

# List constants from provided shoe script
_get_constants() {
    # Synopsis: _get_constants <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)

    if [ -z "$1" ]; then echo_danger 'error: _get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constants: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

# List constaints from provided shoe script
_get_constraint() {
    # Synopsis: _get_constraint <SCRIPT_PATH> <VARIABLE_NAME>
    #   SCRIPT_PATH:   The path to the input script.
    #   VARIABLE_NAME: The variable to validate.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_constraint: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -v NAME="$2" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV, 1, 3) == "## " && $1 == NAME) {match(PREV, /\/.+\//); print substr(PREV, RSTART, RLENGTH)}
    } { PREV = $0 }' "$1"
}

# List flags from provided shoe script
_get_flags() {
    # Synopsis: _get_flags <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_flags: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_flags: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=false$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1)) print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

# List functions names from provided shoe script
_get_functions_names() {
    # Synopsis: _get_functions_names <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_functions_names: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _get_functions_names: \"$1\" file not found\n"; return 1; fi

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" '/^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]",""); # remove leading "function ", round brackets and extra spaces
        FUNCTION = substr($0,1,index($0,"{"));  # truncate string after opening curly brace
        sub("{$","",FUNCTION);                  # remove trailing curly brace
        if (GET_PRIVATE == "true") {
            print FUNCTION
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print FUNCTION
        }
    } { PREV = $0 }' "$1"
}

# List options from provided shoe script
_get_options() {
    # Synopsis: _get_options <SCRIPT_PATH> [GET_PRIVATE]
    #   SCRIPT_PATH: The path to the input script.
    #   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _get_options: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _get_options: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v GET_PRIVATE="$2" '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            if ($1 != toupper($1) && $2 != "false") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") print $1
        }
    } { PREV = $0 }' "$1"
}

#--------------------------------------------------
# Strings
#--------------------------------------------------

# Collapse blank lines with sed
_collapse_blank_lines() {
    # Synopsis: _collapse_blank_lines <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _collapse_blank_lines: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    echo_info "$(_sed_i) '/^$/{N;s/^\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

## shoe-lg main function with hooks
_main() {
    # Features:
    #   - [X] hooks
    #   - [X] commands
    #   - [X] options + validation
    #   - [X] flags

    if [ ${#} -lt 1 ]; then _default; exit 0; fi

    __error__=''
    __eval__=''
    __execute__=''
    __requires_value__=''
    for __argument__ in "$@"; do
        __is_valid__=false
        # check if previous argument requires value
        if [ -n "${__requires_value__}" ]; then
            __eval__="${__eval__} ${__requires_value__}=${__argument__}"
            __requires_value__=''
            continue
        fi
        if [ -n "$(printf '%s' "${__argument__}" | awk '/^--?[a-zA-Z0-9_]+$/{print}')" ]; then
            # check argument is a valid flag (must start with - or --)
            for __flag__ in $(_get_flags "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__flag__}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument__}" = "--${__flag__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    # append argument to the eval stack
                    __eval__="${__eval__} ${__flag__}=true"
                    __is_valid__=true
                    break
                fi
            done
            # check argument is a valid option (must start with - or --)
            for __option__ in $(_get_options "$0"); do
                # get shorthand character
                __shorthand__="$(printf '%s' "${__option__}" | awk '{$0=substr($0, 1, 1); print}')"
                if [ "${__argument__}" = "--${__option__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                    __requires_value__="${__option__}"
                    __is_valid__=true
                    break
                fi
            done
            if [ "${__is_valid__}" = false ]; then
                __error__="\"${__argument__}\" is not a valid option"
                break
            fi
            continue
        fi
        for _function in $(_get_functions_names "$0"); do
            # get shorthand character
            __shorthand__="$(printf '%s' "${_function}" | awk '{$0=substr($0, 1, 1); print}')"
            if [ "${__argument__}" = "${_function}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                # append argument to the execute stack
                __execute__="${__execute__} ${_function}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            __error__="\"${__argument__}\" is not a valid command"
            break
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        __error__="\"--${__requires_value__}\" requires value"
    fi

    if [ -n "${__error__}" ]; then
        echo_danger "error: ${__error__}"
        exit 1
    fi

    for __option__ in ${__eval__}; do
        # invalid parameters will raise errors
        _validate "${__option__}"
        eval "${__option__}"
    done

    if [ -n "$(command -v _before)" ]; then _before; fi

    for __function__ in ${__execute__}; do
        eval "${__function__}"
    done

    if [ -n "$(command -v _after)" ]; then _after; fi
}

_main "$@"
