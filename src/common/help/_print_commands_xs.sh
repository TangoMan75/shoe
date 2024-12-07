#!/bin/sh

# List commands of the of the current shoe script
_print_commands() {
    # Synopsis: _print_commands [PADDING]
    #  PADDING:  Padding length (default: 12)
    #  note:     xs version includes colors.
    #            `awk: %*x formats are not supported`

    if [ -z "$1" ]; then set -- 12; fi
    echo_warning 'Commands:\n'
    awk "/^### /{printf\"\n\033[33m%s:\033[0m\n\",substr(\$0,5)}
        /^(function )? *[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub(\"^function \",\"\"); gsub(\"[ ()]\",\"\");
        FUNCTION = substr(\$0,1,index(\$0,\"{\"));
        sub(\"{\$\",\"\",FUNCTION);
        if (substr(PREV,1,3) == \"## \" && substr(\$0,1,1) != \"_\")
        printf \"\033[32m  %-$1s \033[0m%s\n\",FUNCTION,substr(PREV,4)
    } { PREV = \$0 }" "$0"
    printf '\n'
}

