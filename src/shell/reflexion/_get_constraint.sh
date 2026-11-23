#!/bin/sh

## Get constaint for given variable from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error.sh
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <VARIABLE_NAME> (required) The variable to validate.
_get_constraint() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath -- "$1")" "$2"

    awk -F '=' -v NAME="$2" '
    function trim(value) {
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        return value
    }

    # The value starts with a "/": return the index of its closing slash,
    # or 0 when the expression is never closed. The closing slash may be
    # followed by flags only, and then by a space or the end of the line:
    # that rule lets a character class contain a space ("/^[a-z ]+$/")
    # without letting a path quoted in a description be read as one.
    function closing_slash(value,    i, tail) {
        for (i = 2; i <= length(value); i++) {
            if (substr(value, i, 1) != "/") continue
            tail = substr(value, i + 1)
            if (tail ~ /^[a-z]*([ \t]|$)/) return i
        }
        return 0
    }

    /^## / {
        body = substr($0, 4)
        if (body ~ /^@constraint([ \t]|$)/) {
            sub(/^@constraint[ \t]*/, "", body)
            CONSTRAINT = trim(body)
        } else if (body ~ /^@(variable|option|constant)[ \t]/) {
            # Only the annotation that declares NAME may contribute its
            # constraint: scanning every line would apply the regular
            # expression of another entry to this value.
            line = body
            sub(/^@[a-zA-Z]+[ \t]+/, "", line)
            sub(/^\{[^}]*\}[ \t]*/, "", line)
            # A declared "<name>" scopes the constraint to that entry; an
            # annotation without one belongs to the assignment that follows.
            if (substr(line, 1, 1) == "<") {
                stop = index(line, ">")
                if (stop > 0 && substr(line, 2, stop - 2) != NAME) next
                line = trim(substr(line, stop + 1))
            }
            # Drop the aliases, then read the constraint that directly
            # follows them.
            if (substr(line, 1, 1) == "[") {
                stop = index(line, "]")
                if (stop > 0) line = trim(substr(line, stop + 1))
            }
            if (substr(line, 1, 1) == "/") {
                stop = closing_slash(line)
                if (stop > 0) CONSTRAINT = substr(line, 1, stop)
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
            if (TITLE != "" && index(TITLE, "/") > 0) {
                line = substr(TITLE, index(TITLE, "/"))
                stop = closing_slash(line)
                if (stop > 0) { print substr(line, 1, stop); exit }
            }
        }
        TITLE = ""
        CONSTRAINT = ""
        next
    }

    { TITLE = ""; CONSTRAINT = "" }
    ' "$1"
}

