#!/bin/sh

## Compress a file or folder into an archive
##
## Uses 7z when available and falls back to tar.gz. The recursive flag
## creates one archive per direct subfolder.
##
## @namespace src/shell/files
## @requires basename command dirname find grep printf realpath sed sort tar
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @param {path} <SOURCE> (required) The file or folder to compress.
## @param {folder} <DESTINATION> (default:"current folder") The folder receiving the archives.
## @flag <recursive> [-r] Create one archive per direct subfolder.
_compress() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-r' ]; then
            set -- "$@" '--recursive'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_compress\n'
            _echo_success 'description:' 2 14; _echo_primary 'Compress a file or folder into an archive\n'
            _echo_success 'usage:' 2 14; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: recursive flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--recursive'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--recursive' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_compress: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 3 ]; then
        _echo_error "_compress: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Validate arguments
    #--------------------------------------------------

    if [ ! -f "$2" ] && [ ! -d "$2" ]; then
        _echo_error "_compress: \"$2\" is invalid\n"

        return 1
    fi
    if [ ! -d "${3:-.}" ]; then
        _echo_error "_compress: \"${3:-.}\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath -- "$2")" "$(realpath -- "${3:-.}")"

    #--------------------------------------------------
    # Select archiver
    #--------------------------------------------------

    if command -v 7z >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" '7z' '7z'
    else
        set -- "$1" "$2" "$3" 'tar.gz' 'tar'
    fi

    #--------------------------------------------------
    # Collect paths to compress
    #--------------------------------------------------

    # $6: newline separated list of paths left to compress.
    if [ "$1" = 'true' ] && [ -d "$2" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" \
            "$(find "$2" -mindepth 1 -maxdepth 1 -type d | sort)"
    else
        set -- "$1" "$2" "$3" "$4" "$5" "$2"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    while [ -n "$6" ]; do
        # $7: path to compress, $8: archive name.
        set -- "$1" "$2" "$3" "$4" "$5" "$6" \
            "$(printf '%s\n' "$6" | sed -n '1p')"
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "${7##*/}.$4"

        if [ "$5" = '7z' ]; then
            _echo_info "7z a \"$3/$8\" \"$7\"\n"
            7z a "$3/$8" "$7"
        else
            _echo_info "tar -czvf \"$3/$8\" -C \"$(dirname "$7")\" \"$(basename "$7")\"\n"
            tar -czvf "$3/$8" -C "$(dirname "$7")" "$(basename "$7")"
        fi

        # drop the processed path from the list
        set -- "$1" "$2" "$3" "$4" "$5" \
            "$(printf '%s\n' "$6" | sed -e '1d')"
    done
}

