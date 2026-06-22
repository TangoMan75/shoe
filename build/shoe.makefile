## TangoMan Shoe
##
## Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command. Warning: Functions and variables names should not contain dashes.
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe


.PHONY: help hello flag_test generate_doc self_install self_uninstall self_update generate_makefile

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
	@printf '%s\n' 'TangoMan Shoe'
	@printf '%s\n' 'Simplify your shell scripting workflow with self-documenting shell scripts with robust argument validation. Just prefix a comment with two pound signs (##) on the line above any function or variable to generate helpful documentation using the "help" command. Warning: Functions and variables names should not contain dashes.'
	@printf '%s\n' 'Usage: make [command]'
	@printf '%s\n' 'Commands:'
	@printf '  %-20s %s\n' hello 'Hello World!'
	@printf '  %-20s %s\n' flag_test 'Prints flag status'
	@printf '  %-20s %s\n' generate_doc 'Generate Markdown documentation for current shoe script'
	@printf '  %-20s %s\n' self_install 'Install script and enable autocompletion'
	@printf '  %-20s %s\n' self_uninstall 'Uninstall script from system'
	@printf '  %-20s %s\n' self_update 'Update script from @update'
	@printf '  %-20s %s\n' generate_makefile 'Generate Makefile for current shoe script'
## Hello World!
hello:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh hello$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh hello

## Prints flag status
flag_test:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh flag_test$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh flag_test


##################################################
### Documentation
##################################################

## Generate Markdown documentation for current shoe script
generate_doc:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh generate_doc$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh generate_doc


##################################################
### Self Install
##################################################

## Install script and enable autocompletion
self_install:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh self_install$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh self_uninstall$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh self_uninstall

## Update script from @update
self_update:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh self_update$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh self_update


##################################################
### Make
##################################################

## Generate Makefile for current shoe script
generate_makefile:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/shoe.sh generate_makefile$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/shoe.sh generate_makefile
