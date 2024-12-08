#!/bin/sh

## Update script from @update-link
self_update() {
    _update_link="$(_get_docbloc "$0" 'update-link')"
    if [ -z "${_update_link}" ]; then
        echo_danger 'cannot update: "@update-link" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS}" "${global:-false}"
}

