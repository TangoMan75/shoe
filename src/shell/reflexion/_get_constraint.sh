#!/bin/sh

## Get constaint for given variable from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <VARIABLE_NAME> (required) The variable to validate.
_get_constraint() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v NAME="$2" '
    function trim(value) {
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        return value
    }

    /^## / {
        body = substr($0, 4)
        if (body ~ /^@constraint([ \t]|$)/) {
            sub(/^@constraint[ \t]*/, "", body)
            CONSTRAINT = trim(body)
        } else if (body ~ /^@(variable|option|constant)[ \t]/) {
            if (match(body, /\/.+\//)) {
                if (CONSTRAINT == "") {
                    CONSTRAINT = substr(body, RSTART, RLENGTH)
                }
            } else if (TITLE == "") {
                TITLE = body
            }
        } else if (TITLE == "" && substr(body, 1, 1) != "@") {
            TITLE = body
        }
        next
    }

    $0 == "##" { next }

    /^[a-zA-Z0-9_]+=.+$/ {
        if ($1 == NAME) {
            if (CONSTRAINT != "") { print CONSTRAINT; exit }
            if (TITLE != "" && match(TITLE, /\/.+\//)) {
                print substr(TITLE, RSTART, RLENGTH); exit
            }
        }
        TITLE = ""
        CONSTRAINT = ""
        next
    }

    { TITLE = ""; CONSTRAINT = "" }
    ' "$1"
}

