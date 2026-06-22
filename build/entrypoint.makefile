## TangoMan Entrypoint
##
## Execute Development and Continuous Integration tasks.
##
## @version 0.1.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe


.PHONY: help build build_all lint tests git_hooks bash_unit alpine busybox ubuntu

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
	@printf '%s\n' 'TangoMan Entrypoint'
	@printf '%s\n' 'Execute Development and Continuous Integration tasks.'
	@printf '%s\n' 'Usage: make [command]'
	@printf '%s\n' 'Commands:'
	@printf '  %-20s %s\n' build 'Build given script from recipe'
	@printf '  %-20s %s\n' build_all 'Build all scripts in recipes folder'
	@printf '  %-20s %s\n' lint 'Sniff errors with linter'
	@printf '  %-20s %s\n' tests 'Run tests'
	@printf '  %-20s %s\n' git_hooks 'Install git hooks'
	@printf '  %-20s %s\n' bash_unit 'Install bash_unit framework'
	@printf '  %-20s %s\n' alpine 'Run script in Alpine Docker container'
	@printf '  %-20s %s\n' busybox 'Run script in Busybox Docker container'
	@printf '  %-20s %s\n' ubuntu 'Run script in Ubuntu Docker container'
## Build given script from recipe
build:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh build$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh build

## Build all scripts in recipes folder
build_all:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh build_all$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh build_all

## Sniff errors with linter
lint:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh lint$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh lint

## Run tests
tests:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh tests$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh tests

## Install git hooks
git_hooks:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh git_hooks$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh git_hooks

## Install bash_unit framework
bash_unit:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh bash_unit$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh bash_unit

## Run script in Alpine Docker container
alpine:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh alpine$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh alpine

## Run script in Busybox Docker container
busybox:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh busybox$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh busybox

## Run script in Ubuntu Docker container
ubuntu:
	@printf "$(_INFO)sh /home/tangoman75/Documents/shoe/build/entrypoint.sh ubuntu$(_EOL)\n"
	@sh /home/tangoman75/Documents/shoe/build/entrypoint.sh ubuntu
