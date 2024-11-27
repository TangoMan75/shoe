#!/bin/sh

## Print this help (default)
help() {
    alert_primary 'TangoMan Shoe XXS'
    echo_warning 'Infos:\n'
    echo_success 'author'  2 10; echo_primary '"Matthias Morin" <mat@tangoman.io>\n'
    echo_success 'version' 2 10; echo_primary '0.13.0-xxs\n'
    echo_success 'link'    2 10; echo_primary 'https://github.com/TangoMan75/shoe\n\n'
    echo_warning 'Description:\n'
    echo_primary '  Create self documented shell scripts with argument validation easily. Prefix a comment with two pound signs on the previous line of any function or variable you want documented with the "help" command.\n\n' | fold -w 64 -s
    echo_warning 'Usage:\n'
    printf "%b  sh $(basename "${0}") [%bcommand%b]\n\n" "${INFO}" "${SUCCESS}" "${INFO}"
    _print_commands 10
}

