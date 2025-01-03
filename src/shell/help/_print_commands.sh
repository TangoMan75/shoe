#!/bin/sh

# List commands of the provided shoe script (used by "help" command)
_print_commands() {
    # Synopsis: _print_commands <FILE_PATH> [PADDING]
    #   FILE_PATH:  The path to the input file.
    #   PADDING:    (optional) Padding length (default: 12)
    #   note:       "awk: %*x formats are not supported"

    if [ -z "$1" ]; then echo_danger 'error: _print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _print_commands: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then echo_danger "error: _print_commands: \"$1\" file not found\n"; return 1; fi

    echo_warning 'Commands:\n'
    awk -v WARNING="${WARNING}" -v SUCCESS="${SUCCESS}" -v PRIMARY="${PRIMARY}" "/^### /{printf\"\n%s%s:%s\n\",WARNING,substr(\$0,5),PRIMARY}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\"); # remove leading \"function \", round brackets and extra spaces
        FUNCTION = substr(\$0,1,index(\$0,\"{\"));      # truncate string after opening curly brace
        sub(\"{\$\",\"\",FUNCTION);                     # remove trailing curly brace
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\") # ignore private functions
        printf \"%s  %-$2s %s%s\n\",SUCCESS,FUNCTION,PRIMARY,substr(PREV,4)
    } { PREV = \$0 }" "$1"
    printf '\n'
}

