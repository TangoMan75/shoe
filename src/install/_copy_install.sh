#!/bin/sh

## Install script (via copy in /usr/local/bin/ directory)
_copy_install() {
    echo_info "sudo cp -af \"$0\" \"/usr/local/bin/$(basename "$0" .sh)\"\n"
    sudo cp -af "$0" "/usr/local/bin/$(basename "$0" .sh)"
}

