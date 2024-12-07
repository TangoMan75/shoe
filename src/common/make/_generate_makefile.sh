#!/bin/sh

# Generate Makefile documentation for provided shoe script
_generate_makefile() {
    # Synopsis: _generate_makefile <FILE_PATH> [DESTINATION] [FILE_NAME]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then echo_danger 'error: _generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_makefile: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_makefile: \"$2\" folder not found\n"; return 1; fi

    alert_primary "Generating $3"

    cat > "$2/$3" <<'EOT'
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

EOT

    # generate .PHONY
    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$", "", FUNCTION);
        if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } { PREV = $0 }' "$1" >> "$2/$3"

    cat >> "$2/$3" <<'EOT'


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

EOT

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" 'BEGIN {HR="##################################################\n"}
        /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf "## %s\n%s:\n\t@printf \"${INFO}sh %s %s${EOL}\"\n\t@sh %s %s\n\n",substr(PREV,4),FUNCTION,SHELL_SCRIPT,FUNCTION,SHELL_SCRIPT,FUNCTION,FUNCTION
    } { PREV = $0 }' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"
}

