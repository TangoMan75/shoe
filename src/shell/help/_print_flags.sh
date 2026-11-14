#!/bin/sh

## List flags of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_primary src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/reflexion/_get_flags src/shell/reflexion/_get_function_parameters
## @assumes _PRIMARY _SUCCESS
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose flags should be added.
_print_flags() {
    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"
    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    __separator__=$(printf '\037')
    __global_flags__=$(_get_flags "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_flags__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^flag${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-'"$2"'s %s%s\n",SUCCESS,$1,PRIMARY,substr(FIRST,4)
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0, 4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
        } else if (substr($0, 1, 3) == "## ") {
            if (substr($0, 1, 4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
        } else {
            FIRST = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'flag' ]; then
                continue
            fi
            case " ${__global_flags__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  --%-*s' "$2" "${__long__}")"
            _echo_primary " ${__description__}\n"
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

