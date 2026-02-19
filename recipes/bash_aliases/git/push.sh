#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/git",
##   "summary": "Update remote git repository",
##   "requires": [
##     "HEAD",
##     "date",
##     "echo",
##     "false",
##     "git",
##     "tr",
##     "true"
##   ],
##   "depends": [
##     "recipes/bash_aliases/git/branch",
##     "recipes/bash_aliases/git/gstatus",
##     "recipes/bash_aliases/git/guser",
##     "recipes/bash_aliases/git/lremote",
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ],
##   "assumes": [
##     "LBOUND",
##     "RANDOM"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "MESSAGE",
##       "description": "Commit message (defaulted to random emoji and date).",
##       "type": "str"
##     }
##   ],
##   "flags": [
##     {
##       "name": "commit",
##       "description": "Commit all local changes before pushing.",
##       "short": "a"
##     },
##     {
##       "name": "force",
##       "description": "Force push to overwrite remote branch (skips pull).",
##       "short": "f"
##     },
##     {
##       "name": "tags",
##       "description": "Push all tags to remote.",
##       "short": "t"
##     }
##   ]
## }
function push() {
    function _usage() {
        _echo_success 'usage:' "$1" "$2"; _echo_primary 'push (message) -a (commit_all) -f (force) -t (tags) -h (help)\n'
    }

    #--------------------------------------------------
    # Variables
    #--------------------------------------------------

    local commit=false
    local current_branch
    local force=false
    local message
    local set_upstream
    local tags=false

    #--------------------------------------------------
    # Parse parameters
    #--------------------------------------------------

    local arguments=()
    local OPTARG
    local option
    while [ "$#" -gt 0 ]; do
        OPTIND=0
        while getopts :afth option; do
            case "${option}" in
                a) commit=true;;
                f) force=true;;
                t) tags=true;;
                h) _echo_warning 'push\n';
                    _echo_success 'description:' 2 14; _echo_primary 'Update remote git repository\n'
                    _usage 2 14
                    return 0;;
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
    # check git user configured
    #--------------------------------------------------

    if [ -z "$(git config --global user.username)" ] && [ -z "$(git config --global user.email)" ]; then
        _echo_danger 'error: Missing git default account identity\n'
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

    # message is the only valid argument
    if [ "${#arguments[@]}" -eq 0 ]; then
        emojis=(☕ ⚡ ✌ ✨ ⭐ 🌟 🌶 🍩 🍬 🍭 🍰 🎉 🎊 🎯 🎷 🎸 🎺 🏁 🏅 🏆 🐀 🐁 🐄 🐅 🐇 🐈 🐕 🐝 🐠 🐧 🐰 🐱 🐼 👋 👍 👑 💙 💡 🔥 🚀 🛸 🤖 🤟 🥇 🦄 🦖)
        message="${emojis[ $((RANDOM % ${#emojis[@]})) ]} $(date '+%Y-%m-%d %H:%M:%S')"
    else
        message="${arguments[${LBOUND}]}"
    fi

    #--------------------------------------------------

    guser
    echo
    lremote
    branch -l

    #--------------------------------------------------

    # no pull when forcing push (overwriting)
    if [ "${force}" = false ]; then
        _echo_info 'git pull\n'
        git pull
        echo
    fi

    #--------------------------------------------------

    # only when we have changes and commit = true
    if [ -n "$(git status -s)" ] && [ "${commit}" = true ]; then
        _echo_info 'git add .\n'
        git add .
        echo

        gstatus

        _echo_info "git commit -m \"${message}\"\n"
        git commit -m "${message}"
        echo
    else
        gstatus
    fi

    #--------------------------------------------------

    current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

    # if upstream is not set or remote branch doesn't exist
    if [ -z "$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null)" ] || [ -z "$(git --no-pager branch --list -r "origin/${current_branch}")" ]; then
        set_upstream="--set-upstream origin \"${current_branch}\""
    fi

    if [ "${force}" = true ]; then
        force='--force '
    else
        force=''
    fi

    _echo_info "$(echo "git push ${force}${set_upstream}" | tr -s ' ')\n"
    eval "git push ${force}${set_upstream}"

    if [ "${tags}" = true ]; then
        _echo_info 'git push --tags\n'
        git push --tags
    fi
}

