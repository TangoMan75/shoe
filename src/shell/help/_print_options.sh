#!/bin/sh

## List options of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_primary src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/reflexion/_get_function_parameters src/shell/reflexion/_get_options
## @assumes _DEFAULT _EOL _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose options should be added.
_print_options() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"
    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    __separator__=$(printf '\037')
    __global_options__=$(_get_options "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_options__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^option${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v INFO="${_INFO}" -v DEFAULT="${_DEFAULT}" -v EOL="${_EOL}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(FIRST,RSTART,RLENGTH);
                ANNOTATION=substr(FIRST,4,length(FIRST)-length(CONSTRAINT)-3);
            } else {
                ANNOTATION=substr(FIRST,4);
            }
            if (CONSTRAINT != "") {
                printf "%s  --%-'"$2"'s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                printf "%s  --%-'"$2"'s %s%s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0,4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
            if (CONSTRAINT == "" && match($0, / \/[^\/]+\/[a-z]*/)) {
                CONSTRAINT = " " substr($0, RSTART + 1, RLENGTH - 1)
            }
        } else if (substr($0,1,3) == "## ") {
            if ($0 ~ /^## @constraint([ \t]|$)/) {
                CONSTRAINT=substr($0,4);
                sub(/^@constraint[ \t]*/, "", CONSTRAINT);
                CONSTRAINT=" " CONSTRAINT;
            } else if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) {
                FIRST = $0
            }
        } else {
            FIRST = ""
            CONSTRAINT = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'option' ]; then
                continue
            fi
            case " ${__global_options__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  --%-*s' "$2" "${__long__}")"
            _echo_primary "${__description__}"
            if [ -n "${__constraint__}" ]; then
                _echo_success "  ${__constraint__}"
            fi
            if [ -n "${__default__}" ]; then
                _echo_info " (default: ${__default__})"
            fi
            printf '\n'
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

