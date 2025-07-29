#!/bin/sh

# Generates an autocomplete script for the provided file
_generate_autocomplete() {
    # Synopsis: _generate_autocomplete <FILE_PATH> [ALIAS]
    #   FILE_PATH: The path to the input file.
    #   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file
    #   note:      This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
    #              Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
    #              Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins

    if [ -z "$1" ]; then echo_danger 'error: _generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ ${#} -gt 2 ]; then echo_danger "error: _generate_autocomplete: too many arguments (${#})\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then echo_danger "error: _generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

