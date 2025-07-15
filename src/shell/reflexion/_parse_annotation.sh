#!/bin/sh

# Return function annotation as json
#
# {
#   "namespace": "reflexion",
#   "requires": [
#     "awk",
#     "jq",
#     "sed"
#   ],
#   "depends": [
#     "_get_function_annotation",
#     "echo_danger"
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
#       "name": "FUNCTION_NAME",
#       "type": "str",
#       "description": "The name of the function to retrieve.",
#       "nullable": false
#     }
#   ]
# }
_parse_annotation() {
    # Synopsis: _parse_annotation <SCRIPT_PATH> <FUNCTION_NAME>
    #   SCRIPT_PATH:   The path to the input file.
    #   FUNCTION_NAME: The name of the function to retrieve.

    if [ -z "$1" ] || [ -z "$2" ]; then echo_danger 'error: _parse_annotation: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _parse_annotation: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then echo_danger "error: _parse_annotation: \"$1\" file not found\n"; return 1; fi

    set -- "$1" "$2" "$(printf '%s' "$(_get_function_annotation "$1" "$2")" | sed -E 's/^ *#+ ?//g')"

    set -- "$1" "$2" "$3" "$(printf '%s' "$3" | awk 'function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }{
        temp=$0;
        open+=count_occurrences($0,"{");
        if (open > closed) print temp;
        closed+=count_occurrences($0,"}");
    }')"

    set -- "$1" "$2" "$3" "$4" "$(printf '%s' "$3" | head -n 1)"

    if [ "${2:0:1}" = "_" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" "private"
    else
        set -- "$1" "$2" "$3" "$4" "$5" "public"
    fi
    # $1: SCRIPT_PATH, $2: FUNCTION_NAME, $3: annotation, $4: json, $5: summary, $6: scope

    if [ -z "$4" ]; then
        jq --null-input \
            --arg name "$2" \
            --arg summary "$5" \
            --arg scope "$6" \
            '$ARGS.named'

        return 0
    fi

    jq --null-input \
    --arg name "$2" \
    --arg summary "$5" \
    --arg scope "$6" \
    '$ARGS.named + '"$4"
}

