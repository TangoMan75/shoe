#!/bin/sh

## Rename apks like "%label%_%package_name%_%version%.apk"
##
## @namespace recipes/apk_renamer/renamer
## @requires dirname file find mv realpath sed sort
## @depends src/shell/android/_get_apk_label.sh
## @depends src/shell/android/_get_apk_package_name.sh
## @depends src/shell/android/_get_apk_version.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {folder} <source> (default:".") The source folder.
## @flag <force> [-f|--force] Force rename.
## @flag <recursive> [-r|--recursive] Search apks in subfolders.
rename_apks() {
    if [ ! -d "${source}" ]; then _echo_error "rename_apks: \"${source}\" is not a valid directory\n"; return 1; fi

    # Prevent find from parsing a leading dash as an option.
    case "${source}" in
        -*) source="./${source}" ;;
    esac

    if [ "${recursive}" = 'true' ]; then
        find "${source}" -type f -name '*.apk'
    else
        find "${source}" -maxdepth 1 -type f -name '*.apk'
    fi | sort -t '\0' -n | while read -r file
    do
        file="$(realpath "${file}")"
        current_directory="$(realpath "$(dirname "${file}")")"

        label="$(_get_apk_label "${file}" | sed 's/[/\&+]/_/g')"
        package_name="$(_get_apk_package_name "${file}")"
        version="$(_get_apk_version "${file}")"
        new_file_name="${label}_${package_name}_${version}.apk"

        # ignore if file is the same
        if [ "${file}" = "${current_directory}/${new_file_name}" ]; then
            _echo_warning "skipping: \"${file}\" already exists.\n"
            continue
        fi

        # rename file
        if [ "${force}" = 'true' ]; then
            _echo_info "mv -fv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
            mv -fv "${file}" "${current_directory}/${new_file_name}"
        else
            _echo_info "mv -nv \"${file}\" \"${current_directory}/${new_file_name}\"\n"
            mv -nv "${file}" "${current_directory}/${new_file_name}"
        fi
    done
}

