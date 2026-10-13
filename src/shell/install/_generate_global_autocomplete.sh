#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Creates a system-wide autocomplete script for the provided file",
##   "description": "This function creates a completion script named \"<ALIAS>\" (where \"<ALIAS>\" is the basename of the provided file)\nin the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.\nIt uses sudo for file creation in a system directory, requiring root privileges.",
##   "requires": [
##     "basename",
##     "printf",
##     "realpath",
##     "sudo",
##     "tee"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/install/_get_comspec"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "FILE_PATH",
##       "description": "The path to the input file.",
##       "type": "file",
##       "required": true
##     },
##     {
##       "position": 2,
##       "name": "ALIAS",
##       "description": "The alias of the script to install. Defaults to the basename of the provided file.",
##       "type": "str"
##     }
##   ]
## }
_generate_global_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_global_autocomplete: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    _echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

