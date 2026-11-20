#!/bin/sh

## Set a variable in a ".env" or ".sh" file
##
## Replaces the value when the variable exists or fails.
## when the variable does not exist, and the FORCE parameter is "true", 
## appends a new assignment at the end of the file.
##
## @namespace src/shell/env
## @requires awk chmod dirname grep mktemp mv rm stat
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The ".env" file to update.
## @param {str} <KEY> (required) The variable name to set.
## @param {str} <VALUE> (required) The value to assign.
## @param {bool} <FORCE> (default:false) Append the variable when missing.
_set_parameter() {
    if [ $# -lt 3 ]; then _echo_error '_set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_set_parameter: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "$3" "${4:-false}"

    if [ ! -f "$1" ]; then
        _echo_error "_set_parameter: \"$1\" file not found\n"

        return 1
    fi

    # A parameter name is an identifier: a letter or "_" followed by
    # letters, digits or "_" (the expansions below only differ when a
    # character falls outside those classes)
    if [ -z "$2" ] \
        || [ "$2" != "${2#[!A-Za-z_]}" ] \
        || [ "$2" != "${2#*[!A-Za-z0-9_]*}" ]; then
        _echo_error "_set_parameter: invalid parameter name \"$2\"\n"

        return 1
    fi

    if [ "$4" != 'true' ] && ! grep -q "^$2=" "$1"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    # Values are handed over through the environment because, unlike "-v",
    # awk does not interpret backslash escapes in ENVIRON values.
    # The template keeps mktemp portable to BusyBox.
    __tmp__=$(mktemp "$(dirname "$1")/.set_parameter.XXXXXX") || return 1
    if ! __KEY__="$2" __VALUE__="$3" __FORCE__="$4" awk '
        BEGIN { key = ENVIRON["__KEY__"]; value = ENVIRON["__VALUE__"]; found = 0 }
        index($0, key "=") == 1 { print key "=" value; found = 1; next }
        { print }
        END { if (!found && ENVIRON["__FORCE__"] == "true") print key "=" value }
    ' "$1" > "$__tmp__"; then
        rm -f "$__tmp__"
        _echo_error "_set_parameter: could not update \"$1\"\n"

        return 1
    fi

    # Replace the target atomically, restoring the original mode. The
    # numeric form is accepted by both GNU and BSD stat.
    if ! __mode__=$(stat -c '%a' "$1" 2>/dev/null); then
        __mode__=$(stat -f '%Lp' "$1" 2>/dev/null)
    fi
    if ! mv "$__tmp__" "$1"; then
        rm -f "$__tmp__"
        _echo_error "_set_parameter: could not replace \"$1\"\n"

        return 1
    fi
    if [ -n "${__mode__}" ]; then
        chmod "$__mode__" "$1"
    fi
}

