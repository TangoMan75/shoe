#!/bin/sh

## Install script (via symlink in /usr/local/bin/ directory)
_symlink_install(){
    # remove previous install if any
    set -- "/usr/local/bin/$(basename "$0" .sh)"
    if [ -f "$1" ] && [ "$1" = "$(realpath "$1")" ]; then
        echo_info "sudo rm -f \"$1\"\n"
        sudo rm -f "$1"
    fi

    echo_info "sudo ln -fs \"$(realpath "$0")\" \"$1\"\n"
    sudo ln -fs "$(realpath "$0")" "$1"
}

