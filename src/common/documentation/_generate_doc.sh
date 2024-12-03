#!/bin/sh

# Generate Markdown documentation for provided shoe script
_generate_doc() {
    # Synopsis: _generate_doc <FILE_PATH> <DESTINATION> [FILE_NAME]
    #   FILE_PATH:    The path to the input file.
    #   DESTINATION:  (optional) The path to the destination folder. Defaults to file parent.
    #   FILE_NAME:    (optional) The name for the documentation file. Defaults to "<BASENAME>.md".

    if [ -z "$1" ]; then echo_danger 'error: _generate_doc: some mandatory parameter is missing\n'; exit 1; fi
    if [ ${#} -gt 3 ]; then echo_danger "error: _generate_doc: too many arguments (${#})\n"; exit 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _generate_doc: \"$1\" file not found\n"; exit 1; fi

    # set default values
    if [ -z "$2" ] && [ -z "$3" ]; then
        set -- "$1" "$(dirname "$1")" "$(basename "$1" .sh).md"
    fi
    if [ -z "$3" ]; then
        set -- "$1" "$2" "$(basename "$1" .sh).md"
    fi

    if [ ! -d "$2" ]; then echo_danger "error: _generate_doc: \"$2\" folder not found\n"; exit 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")" "$3"

    alert_primary "Generating $(basename "$1" .sh) documentation"

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
            if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_")
            printf "(--%s %s) ", $1, $2
        } { PREV = $0 }' "$1"
        awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
            if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 == "false" && substr($0, 1, 1) != "_")
            printf "(--%s) ", $1
        } { PREV = $0 }' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV, 1, 3) == "## " && $1 == toupper($1) && substr($0, 1, 1) != "_")
                printf "%d. **%s**\n  - %s\n  - Value: %s\n\n", ++i, $1, substr(PREV, 4), $2
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
                printf "%d. **--%s**\n  - %s\n\n", ++i, $1, substr(PREV, 4)
            } { PREV = $0 }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0, 1, 1) != "_") {
                    if (match(PREV, / \/.+\//)) {
                        CONSTRAINT=substr(PREV, RSTART+1, RLENGTH);
                        DESCRIPTION=substr(PREV, 4, length(PREV)-length(CONSTRAINT)-3);
                        printf "%d. **--%s**\n  - Description: %s\n  - Constraint: `%s`\n  - Default: %s\n\n", ++i, $1, DESCRIPTION, CONSTRAINT, $2
                    } else {
                        printf "%d. **--%s**\n  - Description: %s\n  - Default: %s\n\n", ++i, $1, substr(PREV, 4), $2
                    }
                }
            } { PREV = $0 }' "$1"
        fi

        printf '## 🤖 Commands\n\n'
        awk '/^### /{i=0; printf"### ⚡ %s\n\n",substr($0,5)}
            /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
            sub("^function ",""); gsub("[ ()]","");
            FUNCTION = substr($0, 1, index($0, "{"));
            sub("{$", "", FUNCTION);
            if (substr(PREV, 1, 3) == "## " && substr($0, 1, 1) != "_")
            printf "%d. **%s**\n  - %s\n\n", ++i, FUNCTION, substr(PREV, 4)
        } { PREV = $0 }' "$1"
    ) > "$2/$3"

    echo_success "Documentation generated in : \"$2\"\n"
}

