#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Update script from @update",
##   "requires": [
##     "basename"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_danger",
##     "src/shell/install/_update",
##     "src/shell/shoedoc/_get_script_shoedoc",
##     "src/shell/shoedoc/_get_shoedoc_tag"
##   ],
##   "assumes": [
##     "ALIAS",
##     "global"
##   ]
## }
self_update() {
    _annotations="$(_get_script_shoedoc "$0")"
    _update_link="$(_get_shoedoc_tag "${_annotations}" 'update')"
    if [ -z "${_update_link}" ]; then
        _echo_danger 'cannot update: "@update" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

