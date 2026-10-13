#!/bin/sh

## {
##   "namespace": "src/shell/shoedoc",
##   "summary": "Return function shoedoc as json",
##   "requires": [
##     "cut",
##     "head",
##     "jq",
##     "printf",
##     "realpath",
##     "sed"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/shoedoc/_get_function_shoedoc"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "SCRIPT_PATH",
##       "description": "The path to the input script.",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "FUNCTION_NAME",
##       "description": "The name of the function to retrieve.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_parse_shoedoc() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_parse_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_parse_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_parse_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$1" "$2" "$(printf '%s' "$(_get_function_shoedoc "$1" "$2" | sed -nE 's/^ *#+ *//p')")"
    set -- "$1" "$2" "$3" "$(printf '%s' "$3" | sed -n '/^{/,$p')" "$(printf '%s' "$3" | head -n 1)"

    if [ "$(printf '%s' "$2" | cut -c1)" = "_" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" 'private'
    else
        set -- "$1" "$2" "$3" "$4" "$5" 'public'
    fi
    # $1: SCRIPT_PATH, $2: FUNCTION_NAME, $3: annotation, $4 json, $5: summary, $6: scope

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

