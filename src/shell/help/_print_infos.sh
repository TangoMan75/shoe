#!/bin/sh

# Print infos of the of the current shoe script (used by "help" command)
_print_infos() {
    # Synopsis: _print_infos

    echo_warning 'Infos:\n'
    echo_success 'author'  2 8; echo_primary "$(_get_docbloc "$0" 'author')\n"
    echo_success 'version' 2 8; echo_primary "$(_get_docbloc "$0" 'version')\n"
    echo_success 'link'    2 8; echo_primary "$(_get_docbloc "$0" 'link')\n"
    printf '\n'
}

