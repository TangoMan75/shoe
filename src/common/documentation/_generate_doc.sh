#!/bin/sh

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <FILE_PATH> [DESTINATION] [FILE_NAME] [GET_PRIVATE]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
    #   GET_PRIVATE:  (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 4 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; return 1; fi

    alert_primary "Generating $3"

    (
        printf '%s\n===\n\n' "$(_get_docbloc_title "$1")"

        printf '## ℹ️ Infos\n\n'
        printf '\055 author:  %s\n' "$(_get_docbloc "$1" 'author')"
        printf '\055 version: %s\n' "$(_get_docbloc "$1" 'version')"
        printf '\055 link:    %s\n' "$(_get_docbloc "$1" 'link')"
        printf '\n'

        printf '## 📑 Description\n\n'
        _get_docbloc_description "$1"
        printf '\n\n'

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_")
            printf "(--%s %s) ",$1,$2
        } { PREV = $0 }' "$1"
        awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0,1,1) != "_")
            printf "(--%s) ",$1
        } { PREV = $0 }' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                printf "%d. **%s**\n  - %s\n  - Value: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## ") next;
                if (GET_PRIVATE == "false" && substr($0,1,1) == "_") next;
                if ($1 != toupper($1)) printf "%d. **`--%s`**\n  - %s\n\n",++i,$1,substr(PREV,4)
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -v GET_PRIVATE="$4" -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## ") next;
                if (GET_PRIVATE == "false" && substr($0,1,1) == "_") next;
                if ($1 != toupper($1) && $2 != "false") {
                    if (match(PREV,/ \/.+\//)) {
                        CONSTRAINT=substr(PREV,RSTART+1,RLENGTH);
                        DESCRIPTION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                        printf "%d. **`--%s`**\n  - Description: %s\n  - Constraint: `%s`\n  - Default: _%s_\n\n",++i,$1,DESCRIPTION,CONSTRAINT,$2
                    } else {
                        printf "%d. **`--%s`**\n  - Description: %s\n  - Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
                    }
                }
            } { PREV = $0 }' "$1"
        fi

        printf '## 🤖 Commands\n\n'
        awk -v GET_PRIVATE="$4" '/^#(##|_) / {
            if (GET_PRIVATE == "false" && substr(PREV,1,4) != "### ") next;
                sub("^#(##|_) ","");
                i=0; printf"### ⚡ %s\n\n",$0
            }
            /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
            if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
            sub("^function ",""); gsub("[ ()]","");
            FUNCTION = substr($0,1,index($0,"{"));
            sub("{$","",FUNCTION);
            if (match(PREV,/^#.+/)) {
                sub("^##? ","",PREV);
                printf "%d. **`%s`**\n  - %s\n\n",++i,FUNCTION,PREV
            } else {
                printf "%d. **`%s`**\n\n",++i,FUNCTION
            }
        } { PREV = $0 }' "$1"
    ) > "$2/$3"

    echo_success "Documentation generated : \"$2/$3\"\n"
}

