#!/bin/sh

## {
##   "namespace": "src/shell/install",
##   "summary": "Generates an autocomplete script for the provided file",
##   "description": "This function creates a completion script named \"<ALIAS>-completion.sh\" in the same directory as the script itself.\nRefer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.\nOr read the official docmentation for \"complete\" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins",
##   "requires": [
##     "basename",
##     "dirname",
##     "printf",
##     "realpath"
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
_generate_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_autocomplete: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    _echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

