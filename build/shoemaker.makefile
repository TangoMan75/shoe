## TangoMan Shoemaker
##
## A versatile developement tool to split a script file into its components, build a script from a build.lst file, generate Makefile or Markdown documentation from a shoe script.
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe


.PHONY: help dump list build build_all remove_json_annotations generate_doc generate_doc_all generate_makefile generate_makefile_all self_install self_uninstall self_update

_PRIMARY = \033[0;34m
_SECONDARY = \033[0;36m
_SUCCESS = \033[0;32m
_DANGER = \033[0;31m
_WARNING = \033[0;33m
_INFO = \033[0;36m
_LIGHT = \033[0;37m
_DARK = \033[0;30m
_DEFAULT = \033[0m
_EOL = \033[0m
_ALERT_PRIMARY = \033[1;34m
_ALERT_SECONDARY = \033[1;36m
_ALERT_SUCCESS = \033[1;32m
_ALERT_DANGER = \033[1;31m
_ALERT_WARNING = \033[1;33m
_ALERT_INFO = \033[1;36m
_ALERT_LIGHT = \033[1;37m
_ALERT_DARK = \033[1;30m

define _echo_primary
	@printf "$(_PRIMARY)%b$(_EOL)" $(1)
endef
define _echo_info
	@printf "$(_INFO)%b$(_EOL)" $(1)
endef
define _echo_success
	@printf "$(_SUCCESS)%b$(_EOL)" $(1)
endef

## Print this help
help:
	@printf '%s\n' 'TangoMan Shoemaker'
	@printf '%s\n' 'A versatile developement tool to split a script file into its components, build a script from a build.lst file, generate Makefile or Markdown documentation from a shoe script.'
	@printf '%s\n' 'Usage: make [command]'
	@printf '%s\n' 'Commands:'
	@printf '  %-20s %s\n' dump 'Dump functions from given script into individual files'
	@printf '  %-20s %s\n' list 'Dump "build.shoe" file'
	@printf '  %-20s %s\n' build 'Build from given "build.shoe" file'
	@printf '  %-20s %s\n' build_all 'Build all scripts'
	@printf '  %-20s %s\n' remove_json_annotations 'Remove json annotations from file'
	@printf '  %-20s %s\n' generate_doc 'Generate Markdown documentation for provided shoe script'
	@printf '  %-20s %s\n' generate_doc_all 'Generate Markdown documentation for all scripts'
	@printf '  %-20s %s\n' generate_makefile 'Generate Markdown documentation for provided shoe script'
	@printf '  %-20s %s\n' generate_makefile_all 'Generate Makefile for all scripts'
	@printf '  %-20s %s\n' self_install 'Install script and enable autocompletion'
	@printf '  %-20s %s\n' self_uninstall 'Uninstall script from system'
	@printf '  %-20s %s\n' self_update 'Update script from @update'
## Dump functions from given script into individual files
dump:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh dump$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh dump

## Dump "build.shoe" file
list:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh list$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh list

## Build from given "build.shoe" file
build:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh build$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh build

## Build all scripts
build_all:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh build_all$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh build_all

## Remove json annotations from file
remove_json_annotations:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh remove_json_annotations$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh remove_json_annotations


##################################################
### Documentation
##################################################

## Generate Markdown documentation for provided shoe script
generate_doc:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_doc$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_doc

## Generate Markdown documentation for all scripts
generate_doc_all:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_doc_all$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_doc_all


##################################################
### Make
##################################################

## Generate Markdown documentation for provided shoe script
generate_makefile:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_makefile$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_makefile

## Generate Makefile for all scripts
generate_makefile_all:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_makefile_all$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh generate_makefile_all


##################################################
### Self Install
##################################################

## Install script and enable autocompletion
self_install:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_install$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_uninstall$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_uninstall

## Update script from @update
self_update:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_update$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoemaker.sh self_update
