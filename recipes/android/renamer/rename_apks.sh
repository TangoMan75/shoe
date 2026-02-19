#!/bin/sh

## Rename apks like "%label%_%package_name%_%version%.apk"
rename_apks() {
    _require aapt

    find "${source}" -type f -name '*.apk' | sort -t '\0' -n | while read -r file
    do
        file="$(realpath "${file}")"
        current_directory="$(realpath "$(dirname "${file}")")"

        label="$(_get_apk_label "${file}" | sed 's/[/\&+]/_/g')"
        package_name="$(_get_apk_package_name "${file}")"
        version="$(_get_apk_version "${file}")"
        new_file_name="${label}_${package_name}_${version}.apk"

        # ignore if file is the same
        if [ "${file}" = "${current_directory}/${new_file_name}" ]; then
            continue
        fi

        # rename file
        if [ "${force}" = true ]; then
            _echo_info "mv -fv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
            mv -fv "${file}" "${current_directory}/${new_file_name}"
        else
            _echo_info "mv -nv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
            mv -nv "${file}" "${current_directory}/${new_file_name}"
        fi
    done
}

