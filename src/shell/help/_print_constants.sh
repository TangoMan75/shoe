#!/bin/sh

## List constants of the provided shoe script (used by "help" command)
##
## {
##   "namespace": "help",
##   "requires": [
##     "awk"
##   ],
##   "depends": [
##     "_echo_error",
##     "_echo_warning"
##   ],
##   "assumes": [
##     "EOL",
##     "INFO",
##     "PRIMARY",
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
##     },
##     {
##       "position": 2,
##       "name": "PADDING",
##       "type": "int",
##       "description": "Padding length.",
##       "default": 12
##     }
##   ]
## }
_print_constants() {
    # Synopsis: _print_constants <FILE_PATH> [PADDING]
    #   FILE_PATH: The path to the input file.
    #   PADDING:   (optional) Padding length (default: 12)
    #   note:      "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" -v INFO="${_INFO}" -v WARNING="${_WARNING}" -v EOL="${_EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$1"
    printf '\n'
}

