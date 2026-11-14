## TangoMan Hello World!
##
## Greets or says goodbye to a specified user a given number of times. Accepts a recipient name, repetition count, ending and output flags. Useful as a smoke test for new installations.
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe


.PHONY: help hello goodbye self_install self_uninstall

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
	@printf '%s\n' 'TangoMan Hello World!'
	@printf '%s\n' 'Greets or says goodbye to a specified user a given number of times. Accepts a recipient name, repetition count, ending and output flags. Useful as a smoke test for new installations.'
	@printf '%s\n' 'Usage: make [command]'
	@printf '%s\n' 'Commands:'
	@printf '  %-20s %s\n' hello 'Hello World!'
	@printf '  %-20s %s\n' goodbye 'Goodbye World!'
	@printf '  %-20s %s\n' self_install 'Install script and enable autocompletion'
	@printf '  %-20s %s\n' self_uninstall 'Uninstall script from system'

##################################################
### App
##################################################

## Hello World!
hello:
	@printf "$(_INFO)sh hello.sh hello$(_EOL)\n"
	@sh hello.sh hello

## Goodbye World!
goodbye:
	@printf "$(_INFO)sh hello.sh goodbye$(_EOL)\n"
	@sh hello.sh goodbye


##################################################
### Self Install
##################################################

## Install script and enable autocompletion
self_install:
	@printf "$(_INFO)sh hello.sh self_install$(_EOL)\n"
	@sh hello.sh self_install

## Uninstall script from system
self_uninstall:
	@printf "$(_INFO)sh hello.sh self_uninstall$(_EOL)\n"
	@sh hello.sh self_uninstall
