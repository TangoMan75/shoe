#!/bin/sh

## Print this help (default)
help() {
    _padding=$(_get_padding)

    _print_title       "$(_get_docbloc_title "$0")"
    _print_infos
    _print_description "$(_get_docbloc_description "$0")"
    _print_usage
    _print_flags       "${_padding}"
    _print_options     "${_padding}"
    _print_commands    "${_padding}"
}

