#!/bin/sh

## {
##   "namespace": "src/shell/strings",
##   "summary": "Collapse blank lines with \"sed\"",
##   "requires": [
##     "realpath"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/compatibility/_sed_i"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     }
##   ]
## }
_collapse_blank_lines() {
    if [ -z "$1" ]; then _echo_error '_collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_collapse_blank_lines: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space.
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    _echo_info "$(_sed_i) '/^$/{N;s/^\\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

