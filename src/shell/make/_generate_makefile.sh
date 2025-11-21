#!/bin/sh

# Generate Makefile for provided shoe script
#
# {
#   "namespace": "make",
#   "requires": [
#     "awk"
#   ],
#   "depends": [
#     "_get_script_shoedoc",
#     "_get_shoedoc_description",
#     "_get_shoedoc_tag",
#     "_get_shoedoc_title",
#     "alert_primary",
#     "echo_danger",
#     "echo_success"
#   ],
#   "assumes": [
#     "ALERT_DANGER",
#     "ALERT_DARK",
#     "ALERT_INFO",
#     "ALERT_LIGHT",
#     "ALERT_PRIMARY",
#     "ALERT_SECONDARY",
#     "ALERT_SUCCESS",
#     "ALERT_WARNING",
#     "DANGER",
#     "DARK",
#     "DEFAULT",
#     "EOL",
#     "INFO",
#     "LIGHT",
#     "PRIMARY",
#     "SECONDARY",
#     "SUCCESS",
#     "WARNING"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "SCRIPT_PATH",
#       "type": "file",
#       "description": "The path to the input script.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "DESTINATION",
#       "type": "folder",
#       "description": "The path to the destination folder. Defaults to file parent."
#     },
#     {
#       "position": 3,
#       "name": "OUTPUT_FILE_NAME",
#       "type": "str",
#       "description": "The name for the generated Makefile. Defaults to \"<BASENAME>.makefile\"."
#     }
#   ]
# }
_generate_makefile() {
    # Synopsis: _generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]
    #   SCRIPT_PATH:      The path to the input script.
    #   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME: (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then echo_danger 'error: _generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then echo_danger "error: _generate_makefile: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_makefile: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then echo_danger 'error: _generate_makefile: file should be type ".sh"\n'; return 1; fi

    alert_primary "Generating $3"

    __annotations__=$(_get_script_shoedoc "$1")

    cat > "$2/$3" <<EOT
## $(printf '%s' "$(_get_shoedoc_title "${__annotations__}")")
##
## $(printf '%s' "$(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')")
##
## @version $(_get_shoedoc_tag "${__annotations__}" 'version')
## @author  $(_get_shoedoc_tag "${__annotations__}" 'author')
## @license $(_get_shoedoc_tag "${__annotations__}" 'license')
## @link    $(_get_shoedoc_tag "${__annotations__}" 'link')

EOT
    # generate .PHONY
    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } {PREV = $0} END {print "\n"}' "$1" >> "$2/$3"

    cat >> "$2/$3" <<EOT
##################################################
# Colors
##################################################

PRIMARY   = ${PRIMARY}
SECONDARY = ${SECONDARY}
SUCCESS   = ${SUCCESS}
DANGER    = ${DANGER}
WARNING   = ${WARNING}
INFO      = ${INFO}
LIGHT     = ${LIGHT}
DARK      = ${DARK}
DEFAULT   = ${DEFAULT}
EOL       = ${EOL}

ALERT_PRIMARY   = ${ALERT_PRIMARY}
ALERT_SECONDARY = ${ALERT_SECONDARY}
ALERT_SUCCESS   = ${ALERT_SUCCESS}
ALERT_DANGER    = ${ALERT_DANGER}
ALERT_WARNING   = ${ALERT_WARNING}
ALERT_INFO      = ${ALERT_INFO}
ALERT_LIGHT     = ${ALERT_LIGHT}
ALERT_DARK      = ${ALERT_DARK}

##################################################
# Color Functions
##################################################

define echo_primary
	@printf "\${PRIMARY}%b\${EOL}" \$(1)
endef
define echo_secondary
	@printf "\${SECONDARY}%b\${EOL}" \$(1)
endef
define echo_success
	@printf "\${SUCCESS}%b\${EOL}" \$(1)
endef
define echo_danger
	@printf "\${DANGER}%b\${EOL}" \$(1)
endef
define echo_warning
	@printf "\${WARNING}%b\${EOL}" \$(1)
endef
define echo_info
	@printf "\${INFO}%b\${EOL}" \$(1)
endef
define echo_light
	@printf "\${LIGHT}%b\${EOL}" \$(1)
endef
define echo_dark
	@printf "\${DARK}%b\${EOL}" \$(1)
endef

define alert_primary
	@printf "\${EOL}\${ALERT_PRIMARY}%64s\${EOL}\${ALERT_PRIMARY} %-63s\${EOL}\${ALERT_PRIMARY}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_secondary
	@printf "\${EOL}\${ALERT_SECONDARY}%64s\${EOL}\${ALERT_SECONDARY} %-63s\${EOL}\${ALERT_SECONDARY}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_success
	@printf "\${EOL}\${ALERT_SUCCESS}%64s\${EOL}\${ALERT_SUCCESS} %-63s\${EOL}\${ALERT_SUCCESS}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_danger
	@printf "\${EOL}\${ALERT_DANGER}%64s\${EOL}\${ALERT_DANGER} %-63s\${EOL}\${ALERT_DANGER}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_warning
	@printf "\${EOL}\${ALERT_WARNING}%64s\${EOL}\${ALERT_WARNING} %-63s\${EOL}\${ALERT_WARNING}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_info
	@printf "\${EOL}\${ALERT_INFO}%64s\${EOL}\${ALERT_INFO} %-63s\${EOL}\${ALERT_INFO}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_light
	@printf "\${EOL}\${ALERT_LIGHT}%64s\${EOL}\${ALERT_LIGHT} %-63s\${EOL}\${ALERT_LIGHT}%64s\${EOL}\n" "" \$(1) ""
endef
define alert_dark
	@printf "\${EOL}\${ALERT_DARK}%64s\${EOL}\${ALERT_DARK} %-63s\${EOL}\${ALERT_DARK}%64s\${EOL}\n" "" \$(1) ""
endef

##################################################
# Help
##################################################

## Print this help
help:
	\$(call alert_primary, "$(_get_shoedoc_title "${__annotations__}")")

	@printf "\${WARNING}Description:\${EOL}"
	@printf "\${PRIMARY}  $(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')\${EOL}\n"

	@printf "\${WARNING}Usage:\${EOL}"
	@printf "\${PRIMARY}  make [command]\${EOL}\n"

	@printf "\${WARNING}Commands:\${EOL}"
	@awk '/^### /{printf"\n\${WARNING}%s\${EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${SUCCESS}  %-12s  \${PRIMARY}%s\${EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
	}{PREV=\$\$0}' \${MAKEFILE_LIST}

EOT

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" \
    'BEGIN {HR="##################################################\n"}
    /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_" && function_name != "help") # ignore private functions and help
        printf "## %s\n%s:\n\t@printf \"${INFO}sh %s %s${EOL}\"\n\t@sh %s %s\n\n",annotation,function_name,SHELL_SCRIPT,function_name,SHELL_SCRIPT,function_name,function_name
    }
    !/^## */{annotation=""}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    echo_success "Makefile generated : \"$2/$3\"\n"
}

