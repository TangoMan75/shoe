#!/bin/sh

## Return the command that copies stdin to the system clipboard
##
## @namespace src/shell/compatibility
## @requires command printf wl-copy xclip xsel
## @depends src/shell/colors/_echo_error
_clipboard() {
    set -- pbcopy wl-copy xclip xsel clip

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                xclip) printf 'xclip -selection clipboard' ;;
                xsel) printf 'xsel --clipboard --input' ;;
                *) printf '%s' "$1" ;;
            esac

            return 0
        fi

        shift
    done

    _echo_error '_clipboard: no clipboard command found\n'

    return 1
}

