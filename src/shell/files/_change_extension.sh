#!/bin/sh

## Change the extension of a file
##
## Existing destination file is never overwritten.
##
## @namespace src/shell/files
## @requires basename dirname mv
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <SOURCE> (required) The file to rename.
## @param {str} <EXTENSION> /^\.[a-zA-Z0-9]+$/ (required) The extension to apply.
_change_extension() {
    if [ "$#" -lt 2 ]; then
        _echo_error '_change_extension: some mandatory parameter is missing\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_change_extension: too many arguments ($#)\n"

        return 1
    fi

    # Record layout:
    # - $1: source path
    # - $2: new extension
    # - $3: parent folder
    # - $4: base name
    # - $5: base name without extension
    # - $6: target path
    set -- "$1" "${2#.}"

    if [ ! -e "$1" ]; then
        _echo_error "_change_extension: \"$1\" file not found\n"

        return 1
    fi

    set -- "$1" "$2" "$(dirname "$1")" "$(basename "$1")"

    # Strip the last extension, preserving hidden file names.
    if [ "${4#.}" != "$4" ]; then
        # Hidden file: keep the leading dot when there is no extension.
        if [ -z "${4%.*}" ]; then
            set -- "$1" "$2" "$3" "$4" "$4"
        else
            set -- "$1" "$2" "$3" "$4" "${4%.*}"
        fi
    elif [ "${4#*.}" != "$4" ]; then
        set -- "$1" "$2" "$3" "$4" "${4%.*}"
    else
        set -- "$1" "$2" "$3" "$4" "$4"
    fi

    set -- "$1" "$2" "$3" "$4" "$5" "$3/$5.$2"

    # Avoid unnecessary mv if source and target are identical
    if [ "$1" = "$6" ]; then
        return 0
    fi

    _echo_info "mv -i \"$1\" \"$6\"\n"
    mv -i "$1" "$6"
}

