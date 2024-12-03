#!/bin/sh

## Print this help (default)
help() {
    alert_primary 'TangoMan Shoe Test'
    echo_warning 'Infos:\n'
    echo_success 'author'  2 10; echo_primary '"Matthias Morin" <mat@tangoman.io>\n'
    echo_success 'version' 2 10; echo_primary '1.0.0-xxs\n'
    echo_success 'link'    2 10; echo_primary 'https://github.com/TangoMan75/shoe\n\n'
    echo_warning 'Description:\n'
    echo_primary 'This is a test.' 2 | fold -w 64 -s
    echo_warning 'Usage:\n'
    echo_info "sh $(basename "${0}") [" 2; echo_success 'command'; echo_info ']\n\n'
    _print_commands 10
}

