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

.PHONY: help up set_env requirements uninstall open clear backup restore password letsencrypt acme email certs remove_certs network remove_network build start stop lint lint_yaml lint_shell self_install self_uninstall generate_doc
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

## Build and start traefik
up:
	@printf "${INFO}sh traefik.sh up${EOL}"
	@sh traefik.sh up

## Set dev or prod environment
set_env:
	@printf "${INFO}sh traefik.sh set_env${EOL}"
	@sh traefik.sh set_env

## Check requirements
requirements:
	@printf "${INFO}sh traefik.sh requirements${EOL}"
	@sh traefik.sh requirements

## Uninstall Traefik
uninstall:
	@printf "${INFO}sh traefik.sh uninstall${EOL}"
	@sh traefik.sh uninstall

##################################################
### Local
##################################################

## Open traefik and whoami dashboard in default browser
open:
	@printf "${INFO}sh traefik.sh open${EOL}"
	@sh traefik.sh open

## Clear logs
clear:
	@printf "${INFO}sh traefik.sh clear${EOL}"
	@sh traefik.sh clear

## Backup traefik configuration
backup:
	@printf "${INFO}sh traefik.sh backup${EOL}"
	@sh traefik.sh backup

## Restore traefik configuration
restore:
	@printf "${INFO}sh traefik.sh restore${EOL}"
	@sh traefik.sh restore

##################################################
### Security
##################################################

## Set traefik dashboard password
password:
	@printf "${INFO}sh traefik.sh password${EOL}"
	@sh traefik.sh password

##################################################
### Let's Encrypt
##################################################

## Config letsencrypt
letsencrypt:
	@printf "${INFO}sh traefik.sh letsencrypt${EOL}"
	@sh traefik.sh letsencrypt

## Create empty Let's Encrypt acme.json file
acme:
	@printf "${INFO}sh traefik.sh acme${EOL}"
	@sh traefik.sh acme

## Set Let's Encrypt email
email:
	@printf "${INFO}sh traefik.sh email${EOL}"
	@sh traefik.sh email

##################################################
### Local Certificates
##################################################

## Install local SSL certificates
certs:
	@printf "${INFO}sh traefik.sh certs${EOL}"
	@sh traefik.sh certs

## Remove local SSL certificates or acme.json
remove_certs:
	@printf "${INFO}sh traefik.sh remove_certs${EOL}"
	@sh traefik.sh remove_certs

##################################################
### Network
##################################################

## Create network
network:
	@printf "${INFO}sh traefik.sh network${EOL}"
	@sh traefik.sh network

## Remove network
remove_network:
	@printf "${INFO}sh traefik.sh remove_network${EOL}"
	@sh traefik.sh remove_network

##################################################
### Docker
##################################################

## Build docker stack
build:
	@printf "${INFO}sh traefik.sh build${EOL}"
	@sh traefik.sh build

## Start docker stack
start:
	@printf "${INFO}sh traefik.sh start${EOL}"
	@sh traefik.sh start

## Stop docker stack
stop:
	@printf "${INFO}sh traefik.sh stop${EOL}"
	@sh traefik.sh stop

##################################################
### CI
##################################################

## Sniff errors with linters
lint:
	@printf "${INFO}sh traefik.sh lint${EOL}"
	@sh traefik.sh lint

## Sniff errors with yamllint
lint_yaml:
	@printf "${INFO}sh traefik.sh lint_yaml${EOL}"
	@sh traefik.sh lint_yaml

## Sniff errors with shellcheck
lint_shell:
	@printf "${INFO}sh traefik.sh lint_shell${EOL}"
	@sh traefik.sh lint_shell

##################################################
### Self Install
##################################################

## Install script and enable completion
self_install:
	@printf "${INFO}sh traefik.sh self_install${EOL}"
	@sh traefik.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "${INFO}sh traefik.sh self_uninstall${EOL}"
	@sh traefik.sh self_uninstall

##################################################
### Documentation
##################################################

## Generate Markdown documentation for current shoe script
generate_doc:
	@printf "${INFO}sh traefik.sh generate_doc${EOL}"
	@sh traefik.sh generate_doc


