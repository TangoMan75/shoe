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

.PHONY: help install uninstall requirements rm_env set_env update clear_exports export_csv export_json import scrape_syntec scrape_wttj check_drivers coverage lint lint_fix lint_grump lint_phpstan security tests tests_behat tests_functional tests_integration tests_unit create_db database_import drop generate_schema migrate migration_diff mysqldump pg_dump psql reset_db schema truncate alice fixtures cron cron_scan generate_jwt own serve version certificates certificates_remove hosts remove_hosts build container_ip container_name docker_logs fix_permissions generate_app_secret images_remove network network_remove open permissions remove_symlink shell start status stop symlink up assetic assets_install ckeditor encore encore_watch sass_build sass_watch composer_install cache self_install self_uninstall self_update generate_doc generate_makefile
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

##################################################
### Install
##################################################

## Install app, import data and clear cache
install:
	@printf "${INFO}sh tangoman.io.sh install${EOL}"
	@sh tangoman.io.sh install

## Uninstall
uninstall:
	@printf "${INFO}sh tangoman.io.sh uninstall${EOL}"
	@sh tangoman.io.sh uninstall

## Check requirements
requirements:
	@printf "${INFO}sh tangoman.io.sh requirements${EOL}"
	@sh tangoman.io.sh requirements

## Remove ".env.local" and ".env.dev.local" files
rm_env:
	@printf "${INFO}sh tangoman.io.sh rm_env${EOL}"
	@sh tangoman.io.sh rm_env

## Create ".env.local" file
set_env:
	@printf "${INFO}sh tangoman.io.sh set_env${EOL}"
	@sh tangoman.io.sh set_env

## Update app : git pull, reset database and import (docker)
update:
	@printf "${INFO}sh tangoman.io.sh update${EOL}"
	@sh tangoman.io.sh update

##################################################
### App
##################################################

## Clear export folder
clear_exports:
	@printf "${INFO}sh tangoman.io.sh clear_exports${EOL}"
	@sh tangoman.io.sh clear_exports

## Export data in csv
export_csv:
	@printf "${INFO}sh tangoman.io.sh export_csv${EOL}"
	@sh tangoman.io.sh export_csv

## Export data in json
export_json:
	@printf "${INFO}sh tangoman.io.sh export_json${EOL}"
	@sh tangoman.io.sh export_json

## Import data
import:
	@printf "${INFO}sh tangoman.io.sh import${EOL}"
	@sh tangoman.io.sh import

## Scrape data from "Syntec" website
scrape_syntec:
	@printf "${INFO}sh tangoman.io.sh scrape_syntec${EOL}"
	@sh tangoman.io.sh scrape_syntec

## Scrape data from "Welcome to the Jungle" website
scrape_wttj:
	@printf "${INFO}sh tangoman.io.sh scrape_wttj${EOL}"
	@sh tangoman.io.sh scrape_wttj

##################################################
### CI/CD
##################################################

## Check drivers installation
check_drivers:
	@printf "${INFO}sh tangoman.io.sh check_drivers${EOL}"
	@sh tangoman.io.sh check_drivers

## Output test coverage (phpunit)
coverage:
	@printf "${INFO}sh tangoman.io.sh coverage${EOL}"
	@sh tangoman.io.sh coverage

## Run linter (sniff)
lint:
	@printf "${INFO}sh tangoman.io.sh lint${EOL}"
	@sh tangoman.io.sh lint

## Run linter (php-cs-fixer fix)
lint_fix:
	@printf "${INFO}sh tangoman.io.sh lint_fix${EOL}"
	@sh tangoman.io.sh lint_fix

## Run grumphp
lint_grump:
	@printf "${INFO}sh tangoman.io.sh lint_grump${EOL}"
	@sh tangoman.io.sh lint_grump

## Run code analysis with PHPStan
lint_phpstan:
	@printf "${INFO}sh tangoman.io.sh lint_phpstan${EOL}"
	@sh tangoman.io.sh lint_phpstan

## Check security issues in project dependencies (symfony-cli)
security:
	@printf "${INFO}sh tangoman.io.sh security${EOL}"
	@sh tangoman.io.sh security

## Run tests
tests:
	@printf "${INFO}sh tangoman.io.sh tests${EOL}"
	@sh tangoman.io.sh tests

## Run behat tests
tests_behat:
	@printf "${INFO}sh tangoman.io.sh tests_behat${EOL}"
	@sh tangoman.io.sh tests_behat

## Run functional tests
tests_functional:
	@printf "${INFO}sh tangoman.io.sh tests_functional${EOL}"
	@sh tangoman.io.sh tests_functional

## Run integration tests
tests_integration:
	@printf "${INFO}sh tangoman.io.sh tests_integration${EOL}"
	@sh tangoman.io.sh tests_integration

## Run unit tests
tests_unit:
	@printf "${INFO}sh tangoman.io.sh tests_unit${EOL}"
	@sh tangoman.io.sh tests_unit

##################################################
### Database
##################################################

## Create database
create_db:
	@printf "${INFO}sh tangoman.io.sh create_db${EOL}"
	@sh tangoman.io.sh create_db

## Import SQL file(s) directly to Database
database_import:
	@printf "${INFO}sh tangoman.io.sh database_import${EOL}"
	@sh tangoman.io.sh database_import

## Drop database
drop:
	@printf "${INFO}sh tangoman.io.sh drop${EOL}"
	@sh tangoman.io.sh drop

## Generate schema from yaml (api-platform)
generate_schema:
	@printf "${INFO}sh tangoman.io.sh generate_schema${EOL}"
	@sh tangoman.io.sh generate_schema

## Execute migration scripts
migrate:
	@printf "${INFO}sh tangoman.io.sh migrate${EOL}"
	@sh tangoman.io.sh migrate

## Generate migration script
migration_diff:
	@printf "${INFO}sh tangoman.io.sh migration_diff${EOL}"
	@sh tangoman.io.sh migration_diff

## Dump MySQL database (docker)
mysqldump:
	@printf "${INFO}sh tangoman.io.sh mysqldump${EOL}"
	@sh tangoman.io.sh mysqldump

## Dump Postgres database (docker)
pg_dump:
	@printf "${INFO}sh tangoman.io.sh pg_dump${EOL}"
	@sh tangoman.io.sh pg_dump

## Enter Postgres terminal
psql:
	@printf "${INFO}sh tangoman.io.sh psql${EOL}"
	@sh tangoman.io.sh psql

## Reset database (without imports)
reset_db:
	@printf "${INFO}sh tangoman.io.sh reset_db${EOL}"
	@sh tangoman.io.sh reset_db

## Create schema
schema:
	@printf "${INFO}sh tangoman.io.sh schema${EOL}"
	@sh tangoman.io.sh schema

## Truncate table
truncate:
	@printf "${INFO}sh tangoman.io.sh truncate${EOL}"
	@sh tangoman.io.sh truncate

##################################################
### Fixtures
##################################################

## Load Alice fixtures
alice:
	@printf "${INFO}sh tangoman.io.sh alice${EOL}"
	@sh tangoman.io.sh alice

## Load fixtures (doctrine)
fixtures:
	@printf "${INFO}sh tangoman.io.sh fixtures${EOL}"
	@sh tangoman.io.sh fixtures

##################################################
### Development
##################################################

## Run shapecode cron
cron:
	@printf "${INFO}sh tangoman.io.sh cron${EOL}"
	@sh tangoman.io.sh cron

## Scan shapecode cron
cron_scan:
	@printf "${INFO}sh tangoman.io.sh cron_scan${EOL}"
	@sh tangoman.io.sh cron_scan

## Generate JWT keys (jwt bundle)
generate_jwt:
	@printf "${INFO}sh tangoman.io.sh generate_jwt${EOL}"
	@sh tangoman.io.sh generate_jwt

## Own project files
own:
	@printf "${INFO}sh tangoman.io.sh own${EOL}"
	@sh tangoman.io.sh own

## Serve locally with PHP or Symfony
serve:
	@printf "${INFO}sh tangoman.io.sh serve${EOL}"
	@sh tangoman.io.sh serve

## Print version infos
version:
	@printf "${INFO}sh tangoman.io.sh version${EOL}"
	@sh tangoman.io.sh version

##################################################
### Network
##################################################

## Install local SSL certificates
certificates:
	@printf "${INFO}sh tangoman.io.sh certificates${EOL}"
	@sh tangoman.io.sh certificates

## Remove local SSL certificates
certificates_remove:
	@printf "${INFO}sh tangoman.io.sh certificates_remove${EOL}"
	@sh tangoman.io.sh certificates_remove

## Set /etc/hosts (local only)
hosts:
	@printf "${INFO}sh tangoman.io.sh hosts${EOL}"
	@sh tangoman.io.sh hosts

## Remove /etc/hosts (local only)
remove_hosts:
	@printf "${INFO}sh tangoman.io.sh remove_hosts${EOL}"
	@sh tangoman.io.sh remove_hosts

##################################################
### Docker
##################################################

## Build containers
build:
	@printf "${INFO}sh tangoman.io.sh build${EOL}"
	@sh tangoman.io.sh build

## Get running container ip
container_ip:
	@printf "${INFO}sh tangoman.io.sh container_ip${EOL}"
	@sh tangoman.io.sh container_ip

## Get container full name
container_name:
	@printf "${INFO}sh tangoman.io.sh container_name${EOL}"
	@sh tangoman.io.sh container_name

## Print Docker log
docker_logs:
	@printf "${INFO}sh tangoman.io.sh docker_logs${EOL}"
	@sh tangoman.io.sh docker_logs

## Fix permission issue (777 hack)
fix_permissions:
	@printf "${INFO}sh tangoman.io.sh fix_permissions${EOL}"
	@sh tangoman.io.sh fix_permissions

## Generate APP_SECRET
generate_app_secret:
	@printf "${INFO}sh tangoman.io.sh generate_app_secret${EOL}"
	@sh tangoman.io.sh generate_app_secret

## Remove images
images_remove:
	@printf "${INFO}sh tangoman.io.sh images_remove${EOL}"
	@sh tangoman.io.sh images_remove

## Create "traefik" network
network:
	@printf "${INFO}sh tangoman.io.sh network${EOL}"
	@sh tangoman.io.sh network

## Remove "traefik" network
network_remove:
	@printf "${INFO}sh tangoman.io.sh network_remove${EOL}"
	@sh tangoman.io.sh network_remove

## Open container in default browser
open:
	@printf "${INFO}sh tangoman.io.sh open${EOL}"
	@sh tangoman.io.sh open

## Set correct permissions
permissions:
	@printf "${INFO}sh tangoman.io.sh permissions${EOL}"
	@sh tangoman.io.sh permissions

## Remove symlink
remove_symlink:
	@printf "${INFO}sh tangoman.io.sh remove_symlink${EOL}"
	@sh tangoman.io.sh remove_symlink

## Shell into "php" container
shell:
	@printf "${INFO}sh tangoman.io.sh shell${EOL}"
	@sh tangoman.io.sh shell

## Build and start container stack
start:
	@printf "${INFO}sh tangoman.io.sh start${EOL}"
	@sh tangoman.io.sh start

## Print app status
status:
	@printf "${INFO}sh tangoman.io.sh status${EOL}"
	@sh tangoman.io.sh status

## Stop container stack
stop:
	@printf "${INFO}sh tangoman.io.sh stop${EOL}"
	@sh tangoman.io.sh stop

## Create symlink to match container project directory structure
symlink:
	@printf "${INFO}sh tangoman.io.sh symlink${EOL}"
	@sh tangoman.io.sh symlink

## Create network, build container, start docker, composer install, create database, import data
up:
	@printf "${INFO}sh tangoman.io.sh up${EOL}"
	@sh tangoman.io.sh up

##################################################
### Front
##################################################

## Dump app assets
assetic:
	@printf "${INFO}sh tangoman.io.sh assetic${EOL}"
	@sh tangoman.io.sh assetic

## Install bundle assets
assets_install:
	@printf "${INFO}sh tangoman.io.sh assets_install${EOL}"
	@sh tangoman.io.sh assets_install

## Install Ck Editor
ckeditor:
	@printf "${INFO}sh tangoman.io.sh ckeditor${EOL}"
	@sh tangoman.io.sh ckeditor

## Run webpack encore
encore:
	@printf "${INFO}sh tangoman.io.sh encore${EOL}"
	@sh tangoman.io.sh encore

## Watch with webpack encore
encore_watch:
	@printf "${INFO}sh tangoman.io.sh encore_watch${EOL}"
	@sh tangoman.io.sh encore_watch

## Compile scss
sass_build:
	@printf "${INFO}sh tangoman.io.sh sass_build${EOL}"
	@sh tangoman.io.sh sass_build

## Watch scss
sass_watch:
	@printf "${INFO}sh tangoman.io.sh sass_watch${EOL}"
	@sh tangoman.io.sh sass_watch

## Install project dependencies with composer
composer_install:
	@printf "${INFO}sh tangoman.io.sh composer_install${EOL}"
	@sh tangoman.io.sh composer_install

## Clear cache
cache:
	@printf "${INFO}sh tangoman.io.sh cache${EOL}"
	@sh tangoman.io.sh cache

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install:
	@printf "${INFO}sh tangoman.io.sh self_install${EOL}"
	@sh tangoman.io.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "${INFO}sh tangoman.io.sh self_uninstall${EOL}"
	@sh tangoman.io.sh self_uninstall

## Update script from @update-link
self_update:
	@printf "${INFO}sh tangoman.io.sh self_update${EOL}"
	@sh tangoman.io.sh self_update

##################################################
### Documentation
##################################################

## Generate Markdown documentation for current shoe script
generate_doc:
	@printf "${INFO}sh tangoman.io.sh generate_doc${EOL}"
	@sh tangoman.io.sh generate_doc

##################################################
### Makefile
##################################################

## Generate Makefile documentation for current shoe script
generate_makefile:
	@printf "${INFO}sh tangoman.io.sh generate_makefile${EOL}"
	@sh tangoman.io.sh generate_makefile


