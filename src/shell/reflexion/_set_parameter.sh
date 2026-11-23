#!/bin/sh

## Set a variable in a ".env" or ".sh" file
##
## Replaces the value when the variable exists or fails.
## when the variable does not exist, and the FORCE parameter is "true",
## appends a new assignment at the end of the file.
## The value is stored single-quoted, so a sourced file never executes
## its own contents. An unchanged value is left byte-identical.
##
## @namespace src/shell/env
## @requires awk chmod dirname grep mktemp mv printf rm sed stat
## @depends src/shell/colors/_echo_error.sh
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

    if [ "$4" != 'true' ] \
        && ! grep -q "^[[:space:]]*\(export[[:space:]]\{1,\}\)\{0,1\}$2=" "$1"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    # Leave the file byte-identical when it already holds this value, so a
    # no-op update never rewrites line endings or a missing trailing byte.
    if __KEY__="$2" __RAW__="$3" awk '
        BEGIN {
            key = ENVIRON["__KEY__"]
            raw = ENVIRON["__RAW__"]
            found = 0
        }
        {
            line = $0
            rest = line
            if (match(line, /^[ \t]*(export[ \t]+)?/)) {
                rest = substr(line, RLENGTH + 1)
            }
            if (index(rest, key "=") == 1) {
                current = substr(rest, length(key) + 2)
                sub(/\r$/, "", current)
                gsub(/^'"'"'|'"'"'$/, "", current)
                if (current == raw) { found = 1 }
            }
        }
        END { exit(found ? 0 : 1) }
    ' "$1"; then
        return 0
    fi

    # Values are handed over through the environment because, unlike "-v",
    # awk does not interpret backslash escapes in ENVIRON values.
    # The template keeps mktemp portable to BusyBox.
    # The stored value is single-quoted so the file stays valid shell when
    # it is sourced later; each embedded quote becomes the '\'' sequence.
    __value__=$(printf '%s' "$3" | sed "s/'/'\\\\''/g") || return 1
    __tmp__=$(mktemp "$(dirname "$1")/.set_parameter.XXXXXX") || return 1
    if ! __KEY__="$2" __VALUE__="'${__value__}'" __RAW__="$3" __FORCE__="$4" awk '
        BEGIN { key = ENVIRON["__KEY__"]; value = ENVIRON["__VALUE__"]; found = 0 }
        {
            # Match indented assignments and "export KEY=value" forms while
            # preserving their prefix, so a second assignment is not appended.
            line = $0
            prefix = ""
            rest = line
            if (match(line, /^[ \t]*(export[ \t]+)?/)) {
                prefix = substr(line, 1, RLENGTH)
                rest = substr(line, RLENGTH + 1)
            }
            if (index(rest, key "=") == 1) {
                # Leave the line untouched when it already holds this value,
                # so the update stays idempotent.
                current = substr(rest, length(key) + 2)
                sub(/\r$/, "", current)
                gsub(/^'"'"'|'"'"'$/, "", current)
                if (current == ENVIRON["__RAW__"]) { print; found = 1; next }
                print prefix key "=" value
                found = 1
                next
            }
            print
        }
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

