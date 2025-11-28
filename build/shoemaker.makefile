## TangoMan Shoemaker
##
## A versatile developement tool to split a script file into its components, build a script from a build.lst file, generate Makefile or Markdown documentation from a shoe script. 
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe

.PHONY: help dump list build build_all remove_json_annotations generate_doc generate_doc_all generate_makefile generate_makefile_all self_install self_uninstall self_update

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
    $(call _alert_primary, "TangoMan Shoemaker")

    @printf "${_WARNING}Description:${_EOL}"
    @printf "${_PRIMARY}  A versatile developement tool to split a script file into its components, build a script from a build.lst file, generate Makefile or Markdown documentation from a shoe script. ${_EOL}\n"

    @printf "${_WARNING}Usage:${_EOL}"
    @printf "${_PRIMARY}  make [command]${_EOL}\n"

    @printf "${_WARNING}Commands:${_EOL}"
    @awk '/^### /{printf"\n${_WARNING}%s${_EOL}",substr($$0,5)} \
    /^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
        printf "${_SUCCESS}  %-12s  ${_PRIMARY}%s${_EOL}",substr($$1,0,index($$1,":")-1),HELP \
    }{PREV=$$0}' ${MAKEFILE_LIST}

## Dump functions from given script into individual files
dump:
	@printf "${_INFO}sh shoemaker.sh dump${_EOL}"
	@sh shoemaker.sh dump

## Dump "build.shoe" file
list:
	@printf "${_INFO}sh shoemaker.sh list${_EOL}"
	@sh shoemaker.sh list

## Build from given "build.shoe" file
build:
	@printf "${_INFO}sh shoemaker.sh build${_EOL}"
	@sh shoemaker.sh build

## Build all scripts
build_all:
	@printf "${_INFO}sh shoemaker.sh build_all${_EOL}"
	@sh shoemaker.sh build_all

## Remove json annotations from file
remove_json_annotations:
	@printf "${_INFO}sh shoemaker.sh remove_json_annotations${_EOL}"
	@sh shoemaker.sh remove_json_annotations

##################################################
### Documentation
##################################################

## Generate Markdown documentation for provided shoe script
generate_doc:
	@printf "${_INFO}sh shoemaker.sh generate_doc${_EOL}"
	@sh shoemaker.sh generate_doc

## Generate Markdown documentation for all scripts
generate_doc_all:
	@printf "${_INFO}sh shoemaker.sh generate_doc_all${_EOL}"
	@sh shoemaker.sh generate_doc_all

##################################################
### Make
##################################################

## Generate Markdown documentation for provided shoe script
generate_makefile:
	@printf "${_INFO}sh shoemaker.sh generate_makefile${_EOL}"
	@sh shoemaker.sh generate_makefile

## Generate Makefile for all scripts
generate_makefile_all:
	@printf "${_INFO}sh shoemaker.sh generate_makefile_all${_EOL}"
	@sh shoemaker.sh generate_makefile_all

##################################################
### Self Install
##################################################

## Install script and enable autocompletion
self_install:
	@printf "${_INFO}sh shoemaker.sh self_install${_EOL}"
	@sh shoemaker.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "${_INFO}sh shoemaker.sh self_uninstall${_EOL}"
	@sh shoemaker.sh self_uninstall

## Update script from @update
self_update:
	@printf "${_INFO}sh shoemaker.sh self_update${_EOL}"
	@sh shoemaker.sh self_update


