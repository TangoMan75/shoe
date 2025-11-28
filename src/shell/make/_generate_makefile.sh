#!/bin/sh

## Generate Makefile for provided shoe script
##
## {
##   "namespace": "make",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_get_script_shoedoc",
##     "_get_shoedoc_description",
##     "_get_shoedoc_tag",
##     "_get_shoedoc_title",
##     "_alert_primary",
##     "_echo_error",
##     "_echo_success"
##   ],
##   "assumes": [
##     "_ALERT_DANGER",
##     "_ALERT_INFO",
##     "_ALERT_PRIMARY",
##     "_ALERT_SECONDARY",
##     "_ALERT_SUCCESS",
##     "_ALERT_WARNING",
##     "_DANGER",
##     "_DEFAULT",
##     "_EOL",
##     "_INFO",
##     "_PRIMARY",
##     "_SECONDARY",
##     "_SUCCESS",
##     "_WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "type": "file",
##       "description": "The path to the input script.",
##       "nullable": false
##     },
##     {
##       "position": 2,
##       "name": "DESTINATION",
##       "type": "folder",
##       "description": "The path to the destination folder. Defaults to file parent."
##     },
##     {
##       "position": 3,
##       "name": "OUTPUT_FILE_NAME",
##       "type": "str",
##       "description": "The name for the generated Makefile. Defaults to \"<BASENAME>.makefile\"."
##     }
##   ]
## }
_generate_makefile() {
    # Synopsis: _generate_makefile <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME]
    #   SCRIPT_PATH:      The path to the input script.
    #   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME: (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

    if [ -z "$1" ]; then _echo_error '_generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_generate_makefile: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then _echo_error "_generate_makefile: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then _echo_error '_generate_makefile: file should be type ".sh"\n'; return 1; fi

    _alert_primary "Generating $3"

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
## Colors
##################################################

_PRIMARY   = ${_PRIMARY}
_SECONDARY = ${_SECONDARY}
_SUCCESS   = ${_SUCCESS}
_DANGER    = ${_DANGER}
_WARNING   = ${_WARNING}
_INFO      = ${_INFO}
_LIGHT     = ${_LIGHT}
_DARK      = ${_DARK}
_DEFAULT   = ${_DEFAULT}
_EOL       = ${_EOL}

_ALERT_PRIMARY   = ${_ALERT_PRIMARY}
_ALERT_SECONDARY = ${_ALERT_SECONDARY}
_ALERT_SUCCESS   = ${_ALERT_SUCCESS}
_ALERT_DANGER    = ${_ALERT_DANGER}
_ALERT_WARNING   = ${_ALERT_WARNING}
_ALERT_INFO      = ${_ALERT_INFO}
_ALERT_LIGHT     = ${_ALERT_LIGHT}
_ALERT_DARK      = ${_ALERT_DARK}

##################################################
## Color Functions
##################################################

define _echo_primary
	@printf "\${_PRIMARY}%b\${_EOL}" \$(1)
endef
define _echo_secondary
	@printf "\${_SECONDARY}%b\${_EOL}" \$(1)
endef
define _echo_success
	@printf "\${_SUCCESS}%b\${_EOL}" \$(1)
endef
define _echo_danger
	@printf "\${_DANGER}%b\${_EOL}" \$(1)
endef
define _echo_warning
	@printf "\${_WARNING}%b\${_EOL}" \$(1)
endef
define _echo_info
	@printf "\${_INFO}%b\${_EOL}" \$(1)
endef
define _echo_light
	@printf "\${_LIGHT}%b\${_EOL}" \$(1)
endef
define _echo_dark
	@printf "\${_DARK}%b\${_EOL}" \$(1)
endef
define _echo_error
	@printf "\${_DANGER}error: %b\${_EOL}" \$(1)
endef

define _alert_primary
	@printf "\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\${_ALERT_PRIMARY} %-63s\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_secondary
	@printf "\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\${_ALERT_SECONDARY} %-63s\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_success
	@printf "\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\${_ALERT_SUCCESS} %-63s\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_danger
	@printf "\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\${_ALERT_DANGER} %-63s\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_warning
	@printf "\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\${_ALERT_WARNING} %-63s\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_info
	@printf "\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\${_ALERT_INFO} %-63s\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_light
	@printf "\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\${_ALERT_LIGHT} %-63s\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_dark
	@printf "\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\${_ALERT_DARK} %-63s\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\n" "" \$(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
	\$(call _alert_primary, "$(_get_shoedoc_title "${__annotations__}")")

	@printf "\${_WARNING}Description:\${_EOL}"
	@printf "\${_PRIMARY}  $(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')\${_EOL}\n"

	@printf "\${_WARNING}Usage:\${_EOL}"
	@printf "\${_PRIMARY}  make [command]\${_EOL}\n"

	@printf "\${_WARNING}Commands:\${_EOL}"
	@awk '/^### /{printf"\n\${_WARNING}%s\${_EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${_SUCCESS}  %-12s  \${_PRIMARY}%s\${_EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
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
        printf "## %s\n%s:\n\t@printf \"${_INFO}sh %s %s${_EOL}\"\n\t@sh %s %s\n\n",annotation,function_name,SHELL_SCRIPT,function_name,SHELL_SCRIPT,function_name,function_name
    }
    !/^## */{annotation=""}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    _echo_success "Makefile generated : \"$2/$3\"\n"
}

