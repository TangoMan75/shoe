#!/bin/sh

## Rename apks to package name
rename_to_package_name() {
    _require aapt

    find "${source}" -type f -name '*.apk' | sort -t '\0' -n | while read -r file
    do
        file="$(realpath "${file}")"
        current_directory="$(realpath "$(dirname "${file}")")"

        package_name="$(_get_apk_package_name "${file}" | sed 's/[/\&+]/_/g')"
        new_file_name="${package_name}.apk"

        # ignore if file is the same
        if [ "${file}" = "${current_directory}/${new_file_name}" ]; then
            continue
        fi

        # rename file
        _echo_info "mv -nv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
        mv -nv "${file}" "${current_directory}/${new_file_name}"
    done
}

