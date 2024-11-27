#!/bin/sh

## Set completion script autoload
_set_completion_autoload() {
    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then
        echo_danger "error: cannot update \"$1\" : file not found\n"
        return 1
    fi

    # remove previous install if any
    if [ "$(uname)" = 'Darwin' ]; then
        sed -i '' "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" "$1"
    else
        sed -i "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" "$1"
    fi

    # find completion file path for current or global directory
    if [ -f "/etc/bash_completion.d/$(basename "$0" .sh)" ]; then
        set -- "$1" "/etc/bash_completion.d/$(basename "$0" .sh)"

    elif [ -f "$(dirname "$(realpath "$0")")/$(basename "$0" .sh)-completion.sh" ]; then
        set -- "$1" "$(dirname "$(realpath "$0")")/$(basename "$0" .sh)-completion.sh"

    else
        echo_danger 'error: completion script not found\n'
        return 1
    fi

    echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$(basename "$0" .sh)\" \"$2\" \"$(basename "$0" .sh)\" >> \"$1\"\n"
    printf '\n###> %s\nsource %s\n###< %s\n' "$(basename "$0" .sh)" "$2" "$(basename "$0" .sh)" >> "$1"
}

