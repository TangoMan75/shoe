#!/bin/sh

## Uninstall script from system
_uninstall() {
    _remove_completion_autoload ~/.zshrc
    _remove_completion_autoload ~/.bashrc
    _remove_completion_autoload ~/.profile

    echo_info "rm -f \"$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh\"\n"
    rm -f "$(realpath "$(dirname "$0")")/$(basename "$0" .sh)-completion.sh"

    if [ -f "/usr/local/bin/$(basename "$0" .sh)" ]; then
        echo_info "sudo rm -f /usr/local/bin/$(basename "$0" .sh)\n"
        sudo rm -f /usr/local/bin/"$(basename "$0" .sh)"
    fi

    if [ -f "/etc/bash_completion.d/$(basename "$0" .sh)" ]; then
        echo_info "sudo rm -f /etc/bash_completion.d/$(basename "$0" .sh)\n"
        sudo rm -f /etc/bash_completion.d/"$(basename "$0" .sh)"
    fi
}

