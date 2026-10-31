#!/bin/sh

## {
##   "namespace": "src/shell/reflexion",
##   "summary": "Print function synopsis from shoedoc annotations",
##   "requires": [
##     "awk",
##     "grep",
##     "jq",
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FUNCTION_NAME",
##       "description": "The name of the function to document.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "ANNOTATIONS",
##       "description": "The shoedoc annotation block, classic tags or JSON.",
##       "type": "str",
##       "required": true
##     },
##     {
##       "position": 3,
##       "name": "MARKDOWN_FORMAT",
##       "description": "If set to \"true\", returns result as markdown.",
##       "type": "bool",
##       "default": false
##     }
##   ]
## }
_print_synopsis() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_synopsis: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-false}"

    #--------------------------------------------------
    # JSON envelope fallback
    #--------------------------------------------------

    if printf '%s\n' "$2" | grep -q '^[[:space:]]*#*[[:space:]]*{'; then
        set -- "$1" "$(printf '%s\n' "$2" | awk '
            /^[[:space:]]*#*[[:space:]]*\{/ { capture = 1 }
            capture {
                line = $0
                sub(/^[[:space:]]*#+[[:space:]]?/, "", line)
                print line
            }')" "$3"

        if ! command -v jq >/dev/null 2>&1; then
            _echo_error \
                '_print_synopsis: "jq" is required to parse JSON annotations\n'
            return 1
        fi

        if [ -z "$2" ] || ! printf '%s' "$2" | jq empty >/dev/null 2>&1; then
            _echo_error '_print_synopsis: invalid JSON input\n'
            return 1
        fi

        printf '%s' "$2" | jq -r --arg name "$1" --arg markdown "$3" '
            def required:
                (.required == true) or (.nullable == false);

            def aliases:
                [ (if (.short // "") != "" then "-\(.short)" else empty end),
                  (if (.long // "") != "" then "--\(.long)" else empty end) ]
                as $list
                | if ($list | length) > 0 then $list else ["--\(.name)"] end;

            def signature:
                if .__kind == "params" then
                    if required then "<\(.name)>" else "[\(.name)]" end
                else
                    (aliases | join("|")) as $token
                    | (if .__kind == "options" then "\($token) VALUE"
                       else $token end) as $value
                    | if required then $value else "[\($value)]" end
                end;

            def text:
                [ (.summary // ""), (.description // "") ]
                | map(select(length > 0) | gsub("\\s+"; " "))
                | join(" - ");

            def quoted_default:
                "\"\((.default
                    | if type == "string" then . else tostring end))\"";

            def detail($markdown):
                [ (if .__kind != "flags" and ((.type // "") != "") then
                       (if $markdown then
                            "_(type: \"\(.type)\")_"
                        else "(\(.type))" end)
                   else empty end),
                  (if .__kind == "params" and (required | not) then
                       "(optional)"
                   else empty end),
                  (text | select(length > 0)),
                  (if (.constraint // "") != "" then
                       (if $markdown then
                            "_Constraint: `\(.constraint)`._"
                        else "Constraint: \(.constraint)." end)
                   else empty end),
                  (if .__kind != "flags" and has("default") then
                       (if $markdown then
                            "_Defaults to \(quoted_default)._"
                        else "Defaults to \(quoted_default)." end)
                   else empty end) ]
                | join(" ");

            def md_label:
                if .__kind == "params" then "`\(.name)`"
                else (aliases | map("`\(.)`") | join(", ")) end;

            def plain_label:
                if .__kind == "params" then .name
                else (aliases | join("|")) end;

            def entries:
                (.params // .parameters // []
                    | .[] | select((.name // "") != "")
                    | . + {__kind: "params"}),
                (.options // []
                    | .[] | select((.name // "") != "")
                    | . + {__kind: "options"}),
                (.flags // []
                    | .[] | select((.name // "") != "")
                    | . + {__kind: "flags"});

            if $markdown == "true" then
                ([entries | "- \(md_label): \(detail(true))"]
                    | join("\n")) as $details
                | "> Synopsis:",
                  ("> `\($name)"
                   + ([entries | signature]
                      | map(" \(.)") | join("")) + "`"),
                  (if $details != "" then $details, "" else empty end),
                  (if ((.requires // []) | length) > 0 then
                       "- ⚠️ Requires: "
                       + ([.requires[] | "`\(.)`"] | join(", "))
                   else empty end),
                  (if ((.depends // []) | length) > 0 then
                       "- 🔗 Depends: "
                       + ([.depends[] | "`\(.)`"] | join(", "))
                   else empty end),
                  ""
            else
                ([entries | "    \(plain_label): \(detail(false))"]
                    | join("\n")) as $details
                | ("Synopsis: \($name) ("
                   + (if ($name | startswith("_")) then "private"
                      else "public" end) + ")"
                   + ([entries | signature]
                      | map(" \(.)") | join(""))),
                  (if $details != "" then $details else empty end),
                  (if ((.requires // []) | length) > 0 then
                       "    Requires: "
                       + ([.requires[]] | join(", "))
                   else empty end),
                  (if ((.depends // []) | length) > 0 then
                       "    Depends: "
                       + ([.depends[]] | join(", "))
                   else empty end),
                  ""
            end
        '

        return 0
    fi

    #--------------------------------------------------
    # Classic @-tag annotations
    #--------------------------------------------------

    printf '%s' "$2" | awk -v NAME="$1" -v MARKDOWN="$3" '
        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        function add_words(target, value,    count, words, i) {
            count = split(value, words, /[ \t]+/)
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (target == "requires")
                    requires = requires (requires == "" ? "" : " ") words[i]
                else
                    depends = depends (depends == "" ? "" : " ") words[i]
            }
        }

        function add_entry(kind, value,    type, name, short, long_name,
                           constraint, required, has_default, default_value,
                           summary, description, stop, position, aliases,
                           parts, count, i, token, marker) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            required = 0
            has_default = 0
            default_value = ""
            summary = ""
            description = ""

            if (substr(value, 1, 1) == "{") {
                stop = index(value, "}")
                if (stop > 0) {
                    type = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }

            if (substr(value, 1, 1) == "<") {
                stop = index(value, ">")
                if (stop > 0) {
                    name = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }
            if (name == "")
                return

            if (substr(value, 1, 1) == "[") {
                stop = index(value, "]")
                if (stop > 0) {
                    aliases = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                    count = split(aliases, parts, "|")
                    for (i = 1; i <= count && i <= 2; i++) {
                        token = trim(parts[i])
                        if (substr(token, 1, 2) == "--")
                            long_name = substr(token, 3)
                        else if (substr(token, 1, 1) == "-")
                            short = substr(token, 2)
                        else if (long_name == "")
                            long_name = token
                    }
                }
            }

            if (substr(value, 1, 1) == "/") {
                position = index(value, " ")
                if (position == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, position - 1)
                    value = trim(substr(value, position + 1))
                }
            }

            if (substr(value, 1, 1) == "(") {
                stop = index(value, ")")
                if (stop > 0) {
                    marker = trim(substr(value, 2, stop - 2))
                    value = trim(substr(value, stop + 1))
                    if (marker == "required")
                        required = 1
                    else if (substr(marker, 1, 8) == "default:") {
                        has_default = 1
                        default_value = substr(marker, 9)
                    }
                }
            }

            position = index(value, " - ")
            if (position > 0) {
                summary = trim(substr(value, 1, position - 1))
                description = trim(substr(value, position + 3))
            } else {
                description = value
            }
            if (summary != "")
                value = summary " - " description
            else
                value = description

            entry_count++
            entry_kind[entry_count] = kind
            entry_name[entry_count] = name
            entry_type[entry_count] = type
            entry_short[entry_count] = short
            entry_long[entry_count] = long_name
            entry_constraint[entry_count] = constraint
            entry_required[entry_count] = required
            entry_has_default[entry_count] = has_default
            entry_default[entry_count] = default_value
            entry_text[entry_count] = value
        }

        function alias_list(i,    result) {
            result = ""
            if (entry_short[i] != "")
                result = "-" entry_short[i]
            if (entry_long[i] != "") {
                if (result != "")
                    result = result "|"
                result = result "--" entry_long[i]
            }
            if (result == "")
                result = "--" entry_name[i]
            return result
        }

        function signature(i) {
            if (entry_kind[i] == "param") {
                if (entry_required[i])
                    return "<" entry_name[i] ">"
                return "[" entry_name[i] "]"
            }
            if (entry_kind[i] == "option")
                return "[" alias_list(i) " VALUE]"
            return "[" alias_list(i) "]"
        }

        function plain_label(i) {
            if (entry_kind[i] == "param")
                return entry_name[i]
            return alias_list(i)
        }

        function markdown_label(i,    result) {
            if (entry_kind[i] == "param")
                return "`" entry_name[i] "`"
            result = ""
            if (entry_short[i] != "")
                result = "`-" entry_short[i] "`"
            if (entry_long[i] != "") {
                if (result != "")
                    result = result ", "
                result = result "`--" entry_long[i] "`"
            }
            if (result == "")
                result = "`--" entry_name[i] "`"
            return result
        }

        function quote_default(value,    result) {
            result = value
            if (length(result) >= 2 &&
                substr(result, 1, 1) == "\"" &&
                substr(result, length(result), 1) == "\"")
                result = substr(result, 2, length(result) - 2)
            return "\"" result "\""
        }

        function detail(i, markdown,    result, value) {
            result = ""
            if (entry_kind[i] != "flag" && entry_type[i] != "") {
                if (markdown)
                    result = result "_(type: \"" entry_type[i] "\")_ "
                else
                    result = result "(" entry_type[i] ") "
            }
            if (entry_kind[i] == "param" && !entry_required[i])
                result = result "(optional) "
            if (entry_text[i] != "")
                result = result entry_text[i] " "
            if (entry_constraint[i] != "") {
                if (markdown)
                    result = result "_Constraint: `" entry_constraint[i] "`._ "
                else
                    result = result "Constraint: " entry_constraint[i] ". "
            }
            if (entry_kind[i] != "flag" && entry_has_default[i]) {
                value = quote_default(entry_default[i])
                if (markdown)
                    result = result "_Defaults to " value "._ "
                else
                    result = result "Defaults to " value ". "
            }
            return trim(result)
        }

        function word_list(value, markdown,    count, words, i, result) {
            count = split(value, words, " ")
            result = ""
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (result != "")
                    result = result ", "
                result = result (markdown ? "`" words[i] "`" : words[i])
            }
            return result
        }

        {
            line = $0
            sub(/^[ \t]*#+[ \t]?/, "", line)
            line = trim(line)
            if (line == "")
                next
            split(line, tokens, /[ \t]+/)
            tag = tokens[1]
            value = trim(substr(line, length(tag) + 1))
            if (tag == "@requires") {
                add_words("requires", value)
                next
            }
            if (tag == "@depends") {
                add_words("depends", value)
                next
            }
            if (tag == "@private") {
                private_flag = 1
                next
            }
            if (tag == "@public") {
                private_flag = 0
                next
            }
            if (tag == "@param") {
                add_entry("param", value)
                next
            }
            if (tag == "@option") {
                add_entry("option", value)
                next
            }
            if (tag == "@flag") {
                add_entry("flag", value)
            }
        }

        END {
            if (substr(NAME, 1, 1) == "_")
                private_flag = 1
            if (MARKDOWN == "true") {
                printf "> Synopsis:\n> `%s", NAME
                for (i = 1; i <= entry_count; i++)
                    printf " %s", signature(i)
                printf "`\n"
                details = ""
                for (i = 1; i <= entry_count; i++) {
                    line = detail(i, 1)
                    if (details != "")
                        details = details "\n"
                    if (line != "")
                        details = details "- " markdown_label(i) ": " line
                    else
                        details = details "- " markdown_label(i) ":"
                }
                if (details != "")
                    printf "%s\n\n", details
                if (requires != "")
                    printf "- ⚠️ Requires: %s\n", word_list(requires, 1)
                if (depends != "")
                    printf "- 🔗 Depends: %s\n", word_list(depends, 1)
                printf "\n"
                exit
            }
            scope = private_flag ? "private" : "public"
            printf "Synopsis: %s (%s)", NAME, scope
            for (i = 1; i <= entry_count; i++)
                printf " %s", signature(i)
            printf "\n"
            for (i = 1; i <= entry_count; i++) {
                line = detail(i, 0)
                if (line != "")
                    printf "    %s: %s\n", plain_label(i), line
                else
                    printf "    %s:\n", plain_label(i)
            }
            if (requires != "")
                printf "    Requires: %s\n", word_list(requires, 0)
            if (depends != "")
                printf "    Depends: %s\n", word_list(depends, 0)
            printf "\n"
        }
    '
}

