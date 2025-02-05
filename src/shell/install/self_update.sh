#!/bin/sh

## Update script from @update
self_update() {
    _annotations="$(_get_script_shoedoc "$0")"
    _update_link="$(_get_annotation_tags "${_annotations}" 'update')"
    if [ -z "${_update_link}" ]; then
        echo_danger 'cannot update: "@update" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS}" "${global:-false}"
}

