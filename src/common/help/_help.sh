#!/bin/sh

## Print help for provider shoe script
_help() {
    # Synopsis: _help <FILE_PATH>
    #   FILE_PATH:  The path to the input file.

    if [ -z "$1" ]; then echo_danger 'error: _help: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 1 ]; then echo_danger "error: _help: too many arguments (${#})\n"; return 1; fi
    if [ ! -f "$1" ]; then echo_danger "error: _help: \"$1\" file not found\n"; return 1; fi

    _padding=$(_get_padding "$1")

    alert_primary      "$(_get_docbloc_title "$1")"
    _print_infos
    _print_description "$(_get_docbloc_description "$1")"
    _print_usage
    if [ -n "$(_get_constants "$1")" ]; then
        _print_constants "${_padding}"
    fi
    if [ -n "$(_get_flags "$1")" ]; then
        _print_flags "${_padding}"
    fi
    if [ -n "$(_get_options "$1")" ]; then
        _print_options "${_padding}"
    fi
    _print_commands "${_padding}"
}

