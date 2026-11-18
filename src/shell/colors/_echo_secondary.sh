#!/bin/sh

## Print secondary text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _SECONDARY
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_secondary() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

