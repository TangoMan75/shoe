#!/bin/sh

# Remove scriptcompletion autoload
_remove_completion_autoload() {
    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then
        echo_warning "cannot update \"$1\" : file not found\n"
        return 0
    fi

    if [ "$(uname)" = 'Darwin' ]; then
        echo_info "sed -i '' \"/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d\" \"$1\"\n"
        sed -i '' "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" "$1"

        # collapse blank lines
        sed -i '' '/^$/{N;/^\n$/d;}' "$1"
    else
        echo_info "sed -i \"/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d\" \"$1\"\n"
        sed -i "/^###> $(basename "$0" .sh)$/,/^###< $(basename "$0" .sh)$/d" "$1"

        # collapse blank lines
        sed -i '/^$/{N;/^\n$/d;}' "$1"
    fi
}

