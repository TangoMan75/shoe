#!/bin/sh

## Rename apks with label
##
## @namespace recipes/android/renamer
## @requires dirname file find mv realpath sort
## @depends src/shell/android/_get_apk_label src/shell/colors/_echo_info src/shell/system/_require
## @assumes source
rename_to_label() {
    _require aapt

    find "${source}" -type f -name '*.apk' | sort -t '\0' -n | while read -r file
    do
        file="$(realpath "${file}")"
        current_directory="$(realpath "$(dirname "${file}")")"

        label="$(_get_apk_label "${file}")"
        new_file_name="${label}.apk"

        # ignore if file is the same
        if [ "${file}" = "${current_directory}/${new_file_name}" ]; then
            continue
        fi

        # rename file
        _echo_info "mv -nv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
        mv -nv "${file}" "${current_directory}/${new_file_name}"
    done
}

