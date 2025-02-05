## TangoMan Entrypoint
## Execute Development and Continuous Integration tasks.  
## @version 1.0.0
## @author  "Matthias Morin" <mat@tangoman.io>
## @license MIT
## @link    https://github.com/TangoMan75/shoe

.PHONY: help lint tests git_hooks bash_unit alpine busybox ubuntu

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
	$(call alert_primary, "TangoMan Entrypoint")

	@printf "${WARNING}Description:${EOL}"
	@printf "${PRIMARY}  Execute Development and Continuous Integration tasks.  ${EOL}\n"

	@printf "${WARNING}Usage:${EOL}"
	@printf "${PRIMARY}  make [command]${EOL}\n"

	@printf "${WARNING}Commands:${EOL}"
	@awk '/^### /{printf"\n${WARNING}%s${EOL}",substr($$0,5)} \
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \
		printf "${SUCCESS}  %-12s  ${PRIMARY}%s${EOL}",substr($$1,0,index($$1,":")-1),HELP \
	}{PREV=$$0}' ${MAKEFILE_LIST}

## Sniff errors with linter
lint:
	@printf "${INFO}sh entrypoint.sh lint${EOL}"
	@sh entrypoint.sh lint

## Run tests
tests:
	@printf "${INFO}sh entrypoint.sh tests${EOL}"
	@sh entrypoint.sh tests

## Install git hooks
git_hooks:
	@printf "${INFO}sh entrypoint.sh git_hooks${EOL}"
	@sh entrypoint.sh git_hooks

## Install bash_unit framework
bash_unit:
	@printf "${INFO}sh entrypoint.sh bash_unit${EOL}"
	@sh entrypoint.sh bash_unit

## Run script in Alpine Docker container
alpine:
	@printf "${INFO}sh entrypoint.sh alpine${EOL}"
	@sh entrypoint.sh alpine

## Run script in Busybox Docker container
busybox:
	@printf "${INFO}sh entrypoint.sh busybox${EOL}"
	@sh entrypoint.sh busybox

## Run script in Ubuntu Docker container
ubuntu:
	@printf "${INFO}sh entrypoint.sh ubuntu${EOL}"
	@sh entrypoint.sh ubuntu


