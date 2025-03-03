#!/bin/sh

# Print function synopsis from a JSON string.
#
# {
#   "namespace": "reflexion",
#   "requires": [
#     "jq"
#   ],
#   "depends": [
#     "echo_danger"
#   ],
#   "parameters": [
#     {
#       "position": 1,
#       "name": "JSON",
#       "type": "json",
#       "description": "The input string containing raw JSON.",
#       "nullable": false
#     },
#     {
#       "position": 2,
#       "name": "MARKDOWN_FORMAT",
#       "type": "bool",
#       "description": "If set to \"true\", returns result as markdown.",
#       "default": false
#     }
#   ]
# }
_print_synopsis() {
    # Synopsis: _print_synopsis <JSON> [MARKDOWN_FORMAT]
    #   JSON: The input string containing raw JSON.
    #   MARKDOWN_FORMAT: (Optional) If set to 'true', returns result as markdown. Defaults to "false".

    if [ -z "$1" ]; then echo_danger 'error: _print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_synopsis: too many arguments (${#})\n"; return 1; fi
    if ! printf '%s' "$1" | jq empty >/dev/null 2>&1; then echo_danger "error: _print_synopsis: invalid JSON input\n"; return 1; fi

    if [ "${2:-false}" = "true" ]; then
        printf '> Synopsis:\n> '
    else
        printf 'Synopsis: '
    fi

    printf '%s' "$1" | jq -rj '.name'

    if [ "${2:-false}" = "true" ]; then
        printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then " &lt;\(.name)&gt;" else " [\(.name)]" end] | join("")'
        printf '\n'
        printf '%s' "$1" | jq -r '.parameters // [] | .[] | "`\(.name)`: \(if .type then "_(type: \"\(.type)\")_ " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " _Defaults to \"\(.default|tostring)\"._" else "" end)"' | while read -r line; do
            printf '%s\n' "- ${line}"
        done
        printf '\n'
        printf '%s' "$1" | jq -rj '[.requires // [] | .[] | "`\(.)`"] | if length > 0 then "- ⚠️ Requires: \(.|join(", "))\n" else "" end'
        printf '%s' "$1" | jq -rj '[.depends // [] | .[] | "`\(.)`"] | if length > 0 then "- 🔗 Depends: \(.|join(", "))\n" else "" end'
        printf '\n'
        return 0
    fi

    printf '%s' "$1" | jq -rj 'if .scope then " (\(.scope)) " else "" end'
    printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then "<\(.name)>" else "[\(.name)]" end] | join(" ")'
    printf '\n'
    printf '%s' "$1" | jq -r '.parameters // [] | .[] | "\(.name): \(if .type then "(\(.type)) " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " Defaults to \"\(.default|tostring)\"." else "" end)"' | while read -r line; do
        printf '    %s\n' "${line}"
    done
    printf '%s' "$1" | jq -rj '[.requires // [] | .[]] | if length > 0 then "    Requires: \(.|join(", "))\n" else "" end'
    printf '%s' "$1" | jq -rj '[.depends // [] | .[]] | if length > 0 then "    Depends: \(.|join(", "))\n" else "" end'
    printf '\n'
}

