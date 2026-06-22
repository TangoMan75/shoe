## TangoMan Shoemaker
##
## A versatile linter and build tool for Shoedoc shell scripts.
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe

.PHONY: help lint test dump tree build generate_doc generate_makefile

###################################################
# TangoMan Shoemaker Python tool path
###################################################

SHOEMAKER ?= python3 shoemaker.py

# The '.sh' file the dump/tree/generate_doc/generate_makefile targets
# operate on, eg: make dump FILE=recipes/colors/colors.sh
FILE ?=
DESTINATION ?=
# Build interpreter, one of: bash (default), sh
TYPE ?= bash

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
	@printf "$(_PRIMARY)%b$(_EOL)" $(1)
endef
define _echo_secondary
	@printf "$(_SECONDARY)%b$(_EOL)" $(1)
endef
define _echo_success
	@printf "$(_SUCCESS)%b$(_EOL)" $(1)
endef
define _echo_danger
	@printf "$(_DANGER)%b$(_EOL)" $(1)
endef
define _echo_warning
	@printf "$(_WARNING)%b$(_EOL)" $(1)
endef
define _echo_info
	@printf "$(_INFO)%b$(_EOL)" $(1)
endef
define _echo_light
	@printf "$(_LIGHT)%b$(_EOL)" $(1)
endef
define _echo_dark
	@printf "$(_DARK)%b$(_EOL)" $(1)
endef
define _echo_error
	@printf "$(_DANGER)error: %b$(_EOL)" $(1)
endef

define _alert_primary
	@printf "$(_EOL)$(_ALERT_PRIMARY)%64s$(_EOL)$(_ALERT_PRIMARY) %-63s$(_EOL)$(_ALERT_PRIMARY)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_secondary
	@printf "$(_EOL)$(_ALERT_SECONDARY)%64s$(_EOL)$(_ALERT_SECONDARY) %-63s$(_EOL)$(_ALERT_SECONDARY)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_success
	@printf "$(_EOL)$(_ALERT_SUCCESS)%64s$(_EOL)$(_ALERT_SUCCESS) %-63s$(_EOL)$(_ALERT_SUCCESS)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_danger
	@printf "$(_EOL)$(_ALERT_DANGER)%64s$(_EOL)$(_ALERT_DANGER) %-63s$(_EOL)$(_ALERT_DANGER)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_warning
	@printf "$(_EOL)$(_ALERT_WARNING)%64s$(_EOL)$(_ALERT_WARNING) %-63s$(_EOL)$(_ALERT_WARNING)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_info
	@printf "$(_EOL)$(_ALERT_INFO)%64s$(_EOL)$(_ALERT_INFO) %-63s$(_EOL)$(_ALERT_INFO)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_light
	@printf "$(_EOL)$(_ALERT_LIGHT)%64s$(_EOL)$(_ALERT_LIGHT) %-63s$(_EOL)$(_ALERT_LIGHT)%64s$(_EOL)\n" "" $(1) ""
endef
define _alert_dark
	@printf "$(_EOL)$(_ALERT_DARK)%64s$(_EOL)$(_ALERT_DARK) %-63s$(_EOL)$(_ALERT_DARK)%64s$(_EOL)\n" "" $(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
	$(call _alert_primary, "TangoMan Shoemaker")

	@printf "$(_WARNING)Description:$(_EOL)"
	@printf "$(_PRIMARY)  Lint, convert and build Shoedoc shell scripts. $(_EOL)\n"

	@printf "$(_WARNING)Usage:$(_EOL)"
	@printf "$(_PRIMARY)  make [command] FILE=path/to/script.sh$(_EOL)\n"

	@printf "$(_WARNING)Commands:$(_EOL)"
	@awk '/^### /{printf"\n$(_WARNING)%s$(_EOL)",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
		printf "$(_SUCCESS)  %-12s  $(_PRIMARY)%s$(_EOL)",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

## Check FILE is provided
_check_file:
	@if [ -z "$(FILE)" ]; then \
		$(call _echo_error, "dump/tree/generate_doc/generate_makefile expect FILE=path/to/script.sh"); \
		exit 1; \
	fi

##################################################
### Quality
###################################################

## Lint src with the shoemaker linter
lint:
	@printf "$(_INFO)python3 shoemaker.py lint src$(_EOL)"
	@python3 shoemaker.py lint src

## Dump functions from given script into individual files, organised by namespace, and write the matching .shoe recipe
#
dump: _check_file
	@printf "$(_INFO)python3 shoemaker.py dump --file $(FILE)$(_EOL)"
	@python3 shoemaker.py dump --file $(FILE) $(if $(DESTINATION),--destination $(DESTINATION))

## Print the raw list of shell files a script depends on, transitively
tree: _check_file
	@printf "$(_INFO)python3 shoemaker.py tree --file $(FILE)$(_EOL)"
	@python3 shoemaker.py tree --file $(FILE) $(if $(DESTINATION),--destination $(DESTINATION))

## Build a script from a ".shoe" recipe and its script dependencies
build:
	@if [ -z "$(FILE)" ]; then $(_echo_error) 'build expects FILE=path/to/recipe.shoe'; exit 1; fi
	@printf "$(_INFO)python3 shoemaker.py build --file $(FILE)$(_EOL)"
	@python3 shoemaker.py build --file $(FILE) $(if $(DESTINATION),--destination $(DESTINATION)) $(if $(TYPE),--$(TYPE))

##################################################
### Documentation
###################################################

## Generate Markdown documentation for provided shoe script
generate_doc: _check_file
	@printf "$(_INFO)python3 shoemaker.py generate_doc --file $(FILE)$(_EOL)"
	@python3 shoemaker.py generate_doc --file $(FILE) $(if $(DESTINATION),--destination $(DESTINATION))

##################################################
### Make
###################################################

## Generate a Makefile for provided shoe script
generate_makefile: _check_file
	@printf "$(_INFO)python3 shoemaker.py generate_makefile --file $(FILE)$(_EOL)"
	@python3 shoemaker.py generate_makefile --file $(FILE) $(if $(DESTINATION),--destination $(DESTINATION))
