## TangoMan Entrypoint
##
## Execute Development and Continuous Integration tasks. 
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe

.PHONY: help build build_all replace lint tests git_hooks bash_unit alpine busybox ubuntu

##################################################
## Colors
##################################################

_PRIMARY   = \033[97m
_SECONDARY = \033[94m
_SUCCESS   = \033[32m
_DANGER    = \033[31m
_WARNING   = \033[33m
_INFO      = \033[95m
_LIGHT     = \033[47;90m
_DARK      = \033[40;37m
_DEFAULT   = \033[0m
_EOL       = \033[0m\n

_ALERT_PRIMARY   = \033[1;104;97m
_ALERT_SECONDARY = \033[1;45;97m
_ALERT_SUCCESS   = \033[1;42;97m
_ALERT_DANGER    = \033[1;41;97m
_ALERT_WARNING   = \033[1;43;97m
_ALERT_INFO      = \033[1;44;97m
_ALERT_LIGHT     = \033[1;47;90m
_ALERT_DARK      = \033[1;40;37m

##################################################
## Color Functions
##################################################

define _echo_primary
    @printf "${_PRIMARY}%b${_EOL}" $(1)
endef
define _echo_secondary
    @printf "${_SECONDARY}%b${_EOL}" $(1)
endef
define _echo_success
    @printf "${_SUCCESS}%b${_EOL}" $(1)
endef
define _echo_danger
    @printf "${_DANGER}%b${_EOL}" $(1)
endef
define _echo_warning
    @printf "${_WARNING}%b${_EOL}" $(1)
endef
define _echo_info
    @printf "${_INFO}%b${_EOL}" $(1)
endef
define _echo_light
    @printf "${_LIGHT}%b${_EOL}" $(1)
endef
define _echo_dark
    @printf "${_DARK}%b${_EOL}" $(1)
endef
define _echo_error
    @printf "${_DANGER}error: %b${_EOL}" $(1)
endef

define _alert_primary
    @printf "${_EOL}${_ALERT_PRIMARY}%64s${_EOL}${_ALERT_PRIMARY} %-63s${_EOL}${_ALERT_PRIMARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_secondary
    @printf "${_EOL}${_ALERT_SECONDARY}%64s${_EOL}${_ALERT_SECONDARY} %-63s${_EOL}${_ALERT_SECONDARY}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_success
    @printf "${_EOL}${_ALERT_SUCCESS}%64s${_EOL}${_ALERT_SUCCESS} %-63s${_EOL}${_ALERT_SUCCESS}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_danger
    @printf "${_EOL}${_ALERT_DANGER}%64s${_EOL}${_ALERT_DANGER} %-63s${_EOL}${_ALERT_DANGER}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_warning
    @printf "${_EOL}${_ALERT_WARNING}%64s${_EOL}${_ALERT_WARNING} %-63s${_EOL}${_ALERT_WARNING}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_info
    @printf "${_EOL}${_ALERT_INFO}%64s${_EOL}${_ALERT_INFO} %-63s${_EOL}${_ALERT_INFO}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_light
    @printf "${_EOL}${_ALERT_LIGHT}%64s${_EOL}${_ALERT_LIGHT} %-63s${_EOL}${_ALERT_LIGHT}%64s${_EOL}\n" "" $(1) ""
endef
define _alert_dark
    @printf "${_EOL}${_ALERT_DARK}%64s${_EOL}${_ALERT_DARK} %-63s${_EOL}${_ALERT_DARK}%64s${_EOL}\n" "" $(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
    $(call _alert_primary, "TangoMan Entrypoint")

    @printf "${_WARNING}Description:${_EOL}"
    @printf "${_PRIMARY}  Execute Development and Continuous Integration tasks. ${_EOL}\n"

    @printf "${_WARNING}Usage:${_EOL}"
    @printf "${_PRIMARY}  make [command]${_EOL}\n"

    @printf "${_WARNING}Commands:${_EOL}"
    @awk '/^### /{printf"\n${_WARNING}%s${_EOL}",substr($$0,5)} \
    /^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
        printf "${_SUCCESS}  %-12s  ${_PRIMARY}%s${_EOL}",substr($$1,0,index($$1,":")-1),HELP \
    }{PREV=$$0}' ${MAKEFILE_LIST}

## Build given script from recipe
build:
	@printf "${_INFO}sh entrypoint.sh build${_EOL}"
	@sh entrypoint.sh build

## Build all scripts in recipes folder
build_all:
	@printf "${_INFO}sh entrypoint.sh build_all${_EOL}"
	@sh entrypoint.sh build_all

## Replace shoemaker, entrypoint and Makefile in root directory
replace:
	@printf "${_INFO}sh entrypoint.sh replace${_EOL}"
	@sh entrypoint.sh replace

## Sniff errors with linter
lint:
	@printf "${_INFO}sh entrypoint.sh lint${_EOL}"
	@sh entrypoint.sh lint

## Run tests
tests:
	@printf "${_INFO}sh entrypoint.sh tests${_EOL}"
	@sh entrypoint.sh tests

## Install git hooks
git_hooks:
	@printf "${_INFO}sh entrypoint.sh git_hooks${_EOL}"
	@sh entrypoint.sh git_hooks

## Install bash_unit framework
bash_unit:
	@printf "${_INFO}sh entrypoint.sh bash_unit${_EOL}"
	@sh entrypoint.sh bash_unit

## Run script in Alpine Docker container
alpine:
	@printf "${_INFO}sh entrypoint.sh alpine${_EOL}"
	@sh entrypoint.sh alpine

## Run script in Busybox Docker container
busybox:
	@printf "${_INFO}sh entrypoint.sh busybox${_EOL}"
	@sh entrypoint.sh busybox

## Run script in Ubuntu Docker container
ubuntu:
	@printf "${_INFO}sh entrypoint.sh ubuntu${_EOL}"
	@sh entrypoint.sh ubuntu


