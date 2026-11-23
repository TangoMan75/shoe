#!/bin/sh

## Print the web URL of a git remote
##
## Converts the ssh or https URL returned by "git remote get-url" into a
## browsable https URL and removes the trailing ".git" suffix.
##
## @namespace src/shell/git
## @requires git printf
## @depends src/shell/colors/_echo_error.sh
## @param {str} <REMOTE> (default:"origin") The name of the git remote.
_get_git_remote_url() {
    if [ "$#" -gt 1 ]; then _echo_error "_get_git_remote_url: too many arguments ($#)\n"; return 1; fi

    set -- "${1:-origin}"

    if ! git remote get-url "$1" >/dev/null 2>&1; then
        _echo_error "_get_git_remote_url: remote \"$1\" not found\n"

        return 1
    fi

    # $2: repository url.
    set -- "$1" "$(git remote get-url "$1" 2>/dev/null)"

    if [ "${2#git@}" != "$2" ] && [ "${2#*:}" != "$2" ]; then
        # $2: server, $3: repository path.
        set -- "$1" "${2#git@}"
        set -- "$1" "${2%%:*}" "${2#*:}"
        printf 'https://%s/%s\n' "$2" "${3%.git}"
    elif [ "${2#ssh://git@}" != "$2" ]; then
        set -- "$1" "${2#ssh://git@}"
        printf 'https://%s\n' "${2%.git}"
    elif [ "${2#http://}" != "$2" ] || [ "${2#https://}" != "$2" ]; then
        printf '%s\n' "${2%.git}"
    else
        _echo_error "_get_git_remote_url: unsupported url \"$2\"\n"

        return 1
    fi
}

