#!/bin/sh

# Generate Markdown documentation for provided shoe script
#
# {
#   "namespace": "documentation",
#   "requires": [
#     "awk"
#   ],
#   "depends": [
#     "_get_script_shoedoc",
#     "_get_shoedoc_description",
#     "_get_shoedoc_tag",
#     "_get_shoedoc_title",
#     "_print_synopsis",
#     "alert_primary",
#     "echo_danger",
#     "echo_success"
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
#       "description": "The name for the documentation file. Defaults to \"<BASENAME>.md\"."
#     },
#     {
#       "position": 4,
#       "name": "GET_PRIVATE",
#       "type": "bool",
#       "description": "If set to \"true\", documents private constants, options, flags, and commands as well.",
#       "default": false
#     }
#   ]
# }
_generate_doc() {
    # Synopsis: _generate_doc <SCRIPT_PATH> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
    #   SCRIPT_PATH:      The path to the input file.
    #   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.
    #   OUTPUT_FILE_NAME: (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
    #   GET_PRIVATE:      (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then echo_danger 'error: _generate_doc: file should be type ".sh"\n'; return 1; fi

    alert_primary "Generating $3"

    (
        __annotations__=$(_get_script_shoedoc "$1")

        printf '%s\n===\n\n' "$(_get_shoedoc_title "${__annotations__}")"

        printf '## ℹ️ Infos\n\n'
        # \055 is escape code for dash character within printf
        printf '\055 author:  %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'author')"
        printf '\055 version: %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'version')"
        printf '\055 link:    %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'link' )"
        printf '\n\n'

        printf '## 📑 Description\n\n'
        printf '%s\n\n' "$(_get_shoedoc_description "${__annotations__}")"

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
            if ($2 == "false") {printf "(--%s) ",$1;next}
            printf "(--%s %s) ",$1,$2
        } {PREV = $0}' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -F '=' -v GET_PRIVATE="$4" \
            '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                PRIVATE = "";
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_") PRIVATE = " (private)";
                sub("^#+ ","",PREV);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,PREV,$2
            } {PREV = $0}' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                printf "%d. **`%s` (private)**\n> %s\n  - 🚩 Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,substr(PREV,4)
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (match(PREV,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(PREV,RSTART+1,RLENGTH);
                    DESCRIPTION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                    printf "%d. **`--%s`**\n> %s\n  - 🧩 Constraint: `%s`\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`%s`**\n> %s\n  - 🚩 Default: _%s_",++i,$1,substr(PREV,4),$2
                }
                printf "\n\n"
            } {PREV = $0}' "$1"
        fi
    ) > "$2/$3"

    printf '## 🤖 Commands\n\n' >> "$2/$3"

    if _is_installed jq; then
        __index__=0
        for __function_name__ in $(_get_functions_names "$1" true); do
            echo_info "${__function_name__}\n"

            __json__="$(_parse_annotation "$1" "${__function_name__}")"
            if [ -z "${__json__}" ]; then
                echo_danger "error: _generate_doc: no annotation found for function \"${__function_name__}\"\n"
                continue
            fi

            if [ "$4" = false ] && [ "$(printf '%s' "${__json__}" | jq -r '.scope')" = 'private' ]; then
                continue
            fi

            __namespace__="$(printf '%s' "${__json__}" | jq -r '.namespace')"
            if [ "${__namespace__}" != "${__current_namespace__}" ] && [ "${__namespace__}" != null ]; then
                __index__=0
                __current_namespace__="${__namespace__}"
                (
                    printf '### ⚡ %s\n\n' "$(printf '%s' "${__namespace__}" | awk '{print toupper($0)}')"
                ) >> "$2/$3"
            fi

            __index__=$((__index__ + 1))
            (
                # shellcheck disable=SC2016
                printf '#### ⌨️ %d. `%s` %s\n\n' ${__index__} "${__function_name__}" "($(printf '%s\n' "${__json__}" | jq -r '.scope'))"
                printf '%s\n\n' "$(printf '%s\n' "${__json__}" | jq -r '.summary')"
                # shellcheck disable=SC2016
                printf '%s\n\n' "$(_print_synopsis "${__json__}" true)"
            ) >> "$2/$3"
        done

        echo_success "Documentation generated : \"$2/$3\"\n"

        return 0
    fi

    (
        awk -v GET_PRIVATE="$4" '/^#+/ {
                if (summary=="") {
                    summary=$0
                } else {
                    annotation=substr($0,length($1)+2);
                    if (annotation!="") annotations=annotations"\n"annotation
                }
            }
            /^#(##|_) / { # print section / divider
                if (GET_PRIVATE == "false" && $1 == "#_") next;
                sub("^#(##|_) +","");
                i=0; printf"### ⚡ %s\n\n",$0
            }
            in_function {
                # print comments
                if (sub("^ +# ","&")<1) {
                    print ""; in_function=0; next;
                }
                sub("^ +# ",""); gsub("<","\&lt;"); gsub(">","\&gt;"); printf "> %s<br>\n",$0;
            }
            /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
                function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
                sub("^function ","",function_name);         # remove leading "function " if present
                gsub(" +","",function_name);                # trim whitespaces
                is_private="";
                if (substr(summary,1,3) != "## " || substr(function_name,1,1) == "_") is_private=" (private)";
                if (GET_PRIVATE == "false" && is_private != "") next;
                in_function=1;
                printf "#### %d. `%s`%s\n\n",++i,function_name,is_private
                if (summary!="") {
                    sub("^##? ","",summary);
                    printf "%s\n\n",summary
                }
                if (annotations!="") {
                    sub("^\n","",annotations); # remove all leading "\n";
                    printf "```json\n%s\n```\n\n",annotations
                }
            }
            !/^#+/ { summary=""; annotations="" }' "$1"
    ) >> "$2/$3"

    echo_success "Documentation generated : \"$2/$3\"\n"
}

