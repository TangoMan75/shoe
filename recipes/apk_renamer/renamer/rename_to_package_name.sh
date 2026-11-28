#!/bin/sh

## Rename apks to package name
##
## @namespace recipes/apk_renamer/renamer
## @requires dirname file find mv realpath sed sort
## @depends src/shell/android/_get_apk_package_name.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @param {folder} <source> (default:".") The source folder.
## @flag <recursive> [-r|--recursive] Search apks in subfolders.
rename_to_package_name() {
    if [ ! -d "${source}" ]; then _echo_error "rename_to_package_name: \"${source}\" is not a valid directory\n"; return 1; fi

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

