#!/bin/sh

## Generate Markdown documentation for provided shoe script
##
## @namespace src/shell/documentation
## @requires awk basename dirname grep printf realpath sed
## @depends src/shell/colors/_alert_primary src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_success src/shell/reflexion/_get_functions_names src/shell/reflexion/_print_synopsis src/shell/shoedoc/_get_function_shoedoc src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_description src/shell/shoedoc/_get_shoedoc_tag src/shell/shoedoc/_get_shoedoc_title
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the documentation file. Defaults to "<BASENAME>.md".
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", documents private constants, options, flags, and commands as well.
_generate_doc() {
    if [ -z "$1" ]; then _echo_error '_generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_generate_doc: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then _echo_error "_generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then _echo_error "_generate_doc: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then _echo_error '_generate_doc: file should be type ".sh"\n'; return 1; fi

    _alert_primary "Generating $3"

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
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,TITLE,$2
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`%s` (private)**\n> %s\n  - 🚩 Default: _%s_\n\n",++i,$1,TITLE,$2
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,TITLE
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(FIRST,RSTART+1,RLENGTH-1);
                    DESCRIPTION=substr(FIRST,4,RSTART-4);
                } else {
                    DESCRIPTION=substr(FIRST,4);
                }
                if (CONSTRAINT != "") {
                    printf "%d. **`--%s`**\n> %s\n  - 🧩 Constraint: `%s`\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`--%s`**\n> %s\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,$2
                }
                printf "\n\n"
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                    if (CONSTRAINT == "" && match($0, / \/[^\/]+\/[a-z]*/)) {
                        CONSTRAINT = substr($0, RSTART + 1, RLENGTH - 1)
                    }
                } else if (substr($0,1,3) == "## ") {
                    body = substr($0,4);
                    if (body ~ /^@constraint([ \t]|$)/) {
                        sub(/^@constraint[ \t]*/, "", body);
                        sub(/[ \t]+$/, "", body);
                        CONSTRAINT = body
                    } else if (substr(body,1,1) != "@") {
                        if (FIRST == "" || FIRST == "##") FIRST = $0
                    }
                } else {
                    FIRST = ""
                    CONSTRAINT = ""
                }
                PREV = $0
            }' "$1"
        fi
    ) > "$2/$3"

    printf '## 🤖 Commands\n\n' >> "$2/$3"

    __index__=0

    for __function_name__ in $(_get_functions_names "$1" true); do
        _echo_info "${__function_name__}\n"

        __annotations__="$(_get_function_shoedoc "$1" "${__function_name__}")"
        if [ -z "${__annotations__}" ]; then
            _echo_error "_generate_doc: no annotation found for function \"${__function_name__}\"\n"
            continue
        fi

        if [ "$4" = false ] && [ "${__function_name__#_}" != "${__function_name__}" ]; then
            continue
        fi

        __namespace__="$(_get_shoedoc_tag "${__annotations__}" 'namespace')"
        if [ -n "${__namespace__}" ] && [ "${__namespace__}" != "${__current_namespace__}" ]; then
            __index__=0
            __current_namespace__="${__namespace__}"
            printf '### ⚡ %s\n\n' "$(printf '%s' "${__namespace__}" | awk '{print toupper($0)}')" >> "$2/$3"
        fi

        __index__=$((__index__ + 1))
        __scope__='public'
        case "${__function_name__}" in
            _*) __scope__='private' ;;
        esac

        (
            # shellcheck disable=SC2016
            printf '#### ⌨️ %d. `%s` %s\n\n' "${__index__}" "${__function_name__}" "(${__scope__})"
            printf '%s\n\n' "$(_get_shoedoc_title "${__annotations__}")"
            # shellcheck disable=SC2016
            printf '%s\n\n' "$(_print_synopsis "${__function_name__}" "${__annotations__}" true)"
        ) >> "$2/$3"
    done

    _echo_success "Documentation generated : \"$2/$3\"\n"
}

