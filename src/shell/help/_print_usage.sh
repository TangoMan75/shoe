#!/bin/sh

## Print usage of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_info",
##     "_echo_success",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "DEFAULT",
##     "INFO",
##     "SUCCESS",
##     "WARNING"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "type": "file",
##       "description": "The path to the input file.",
##       "nullable": false
##     }
##   ]
## }
_print_usage() {
    # Synopsis: _print_usage <FILE_PATH>
    #   FILE_PATH: The path to the input file.

    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Usage:\n'
    _echo_info "sh $(basename "$1") <" 2; _echo_success 'command'; _echo_info '> '
    # options
    awk -F '=' -v INFO="${_INFO}" -v SUCCESS="${_SUCCESS}" -v WARNING="${_WARNING}" -v DEFAULT="${_DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s--%s%s]%s ",INFO,SUCCESS,$1,INFO,DEFAULT;next}
        printf "%s[%s--%s %s%s%s]%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0} END {print "\n"}' "$1"
}

