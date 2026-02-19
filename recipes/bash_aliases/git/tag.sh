#!/bin/bash
 
## {
##   "namespace": "recipes/bash_aliases/git",
##   "summary": "Create, list or return latest tag",
##   "requires": [
##     "date",
##     "false",
##     "git",
##     "true"
##   ],
##   "depends": [
##     "recipes/bash_aliases/git/fetch",
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ],
##   "assumes": [
##     "LBOUND"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TAG",
##       "type": "str",
##       "description": "Tag name (defaults to current latest tag).",
##       "nullable": true
##     },
##     {
##       "name": "commit",
##       "flag": "-c",
##       "type": "str",
##       "description": "Commit hash to tag.",
##       "nullable": true
##     },
##     {
##       "name": "message",
##       "flag": "-m",
##       "type": "str",
##       "description": "Tag message (defaulted to last commit message).",
##       "nullable": true
##     },
##     {
##       "name": "delete_remote",
##       "flag": "-D",
##       "type": "bool",
##       "description": "Delete tag locally and from remote.",
##       "default": "false"
##     },
##     {
##       "name": "delete",
##       "flag": "-d",
##       "type": "bool",
##       "description": "Delete tag locally.",
##       "default": "false"
##     },
##     {
##       "name": "fetch",
##       "flag": "-f",
##       "type": "bool",
##       "description": "Fetch tags from remote.",
##       "default": "false"
##     },
##     {
##       "name": "list",
##       "flag": "-l",
##       "type": "bool",
##       "description": "List tags.",
##       "default": "false"
##     },
##     {
##       "name": "push",
##       "flag": "-p",
##       "type": "bool",
##       "description": "Push tags to remote.",
##       "default": "false"
##     }
##   ]
## }
function tag() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'tag [tag] [-m message] -c (commit) -f (fetch) -l (list) -p (push) -d (delete) -D (delete remote) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit
    local delete=false
    local delete_remote=false
    local fetch=false
    local last_commit_message
    local list=false
    local message
    local push=false
    local tag

    #--------------------------------------------------
    # Parse parameters
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :c:m::Ddflph option; do
            case "${option}" in
                c) commit="${OPTARG}";;
                m) message="${OPTARG}";;
                D) delete=true; delete_remote=true;;
                d) delete=true;;
                f) fetch=true;;
                l) list=true;;
                p) push=true;;
                h) _echo_warning 'tag\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Create, list or return latest tag\n'
                    _usage 2 14
                    return 0;;
                :) _echo_danger "error: \"${OPTARG}\" requires value\n"
                    return 1;;
                \?) _echo_danger "error: invalid option \"${OPTARG}\"\n"
                    return 1;;
            esac
        done
        if [ "${OPTIND}" -gt 1 ]; then
            shift $(( OPTIND-1 ))
        fi
        if [ "${OPTIND}" -eq 1 ]; then
            arguments+=("$1")
            shift
        fi
    done

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if [ ! -x "$(command -v git)" ]; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'
        return 1
    fi

    #--------------------------------------------------
    # check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'
        return 1
    fi

    #--------------------------------------------------
    # Validate argument count
    #--------------------------------------------------

    if [ "${#arguments[@]}" -gt 1 ]; then
        _echo_danger "error: too many arguments (${#arguments[@]})\n"
        _usage 2 8
        return 1
    fi

    #--------------------------------------------------
    # Get argument
    #--------------------------------------------------

    # tag is the only valid argument
    tag="${arguments[${LBOUND}]}"

    #--------------------------------------------------

    last_commit_message=$(git log -1 --pretty=%B)

    # make sure we list all existing tags
    if [ -z "${tag}" ] || [ "${delete_remote}" = true ] || [ "${fetch}" = true ] || [ "${list}" = true ]; then
        fetch -t
    fi

    if [ -n "${tag}" ]; then
        # delete tag
        if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
            if [ "${delete}" = true ]; then
                _echo_info "git tag --delete \"${tag}\"\n"
                git tag --delete "${tag}"
            fi

            # delete remote tag
            if [ "${delete_remote}" = true ]; then
                _echo_info "git push --delete origin \"${tag}\"\n"
                git push --delete origin "${tag}"
            fi
        else
            # set default message value
            if [ -z "${message}" ]; then
                if [ -n "${last_commit_message}" ]; then
                    message="${last_commit_message}"
                else
                    message=$(date -I)
                fi
            fi
            # create tag
            if [ -z "${commit}" ]; then
                _echo_info "git tag --force -a \"${tag}\" -m \"${message}\"\n"
                git tag --force -a "${tag}" -m "${message}"
            else
                _echo_info "git tag  --force -a \"${tag}\" -m \"${message}\" \"${commit}\"\n"
                git tag  --force -a "${tag}" -m "${message}" "${commit}"
            fi
        fi
    fi

    if [ -z "${tag}" ]; then
        if [ "${delete}" = true ] || [ "${delete_remote}" = true ]; then
            # delete all remote tags
            if [ "${delete_remote}" = true ]; then
                for tag in $(git tag);
                do
                    _echo_info "git push --delete origin \"${tag}\"\n"
                    git push --delete origin "${tag}"
                done
            fi

            # delete all local tags
            if [ "${delete}" = true ]; then
                for tag in $(git tag);
                do
                    _echo_info "git tag --delete \"${tag}\"\n"
                    git tag --delete "${tag}"
                done
            fi
        else
            # returns latest tag, fetch or list tags
            if [ "${list}" = true ]; then
                _echo_info 'git --no-pager tag --list\n'
                git --no-pager tag --list
            else
                # return latest tag
                _echo_info 'git describe --exact-match --abbrev=0\n'
                git describe --exact-match --abbrev=0
            fi
        fi
    fi

    # push all tags
    if [ "${push}" = true ]; then
        _echo_info 'git push --tags\n'
        git push --tags
    fi
}
