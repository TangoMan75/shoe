#!/bin/sh

## Update script from given url
_update() {
    if [ -x "$(command -v curl)" ]; then
        echo_info "curl -sSL \"$1\" > \"$(realpath "$0")\"\n"
        curl -sSL "$1" > "$(realpath "$0")"

    elif [ -x "$(command -v wget)" ]; then
        echo_info "wget -qO - \"$1\" > \"$(realpath "$0")\"\n"
        wget -qO - "$1" > "$(realpath "$0")"

    else
        echo_error 'update requires curl, enter: "sudo apt-get install -y curl" to install\n'
        return 1
    fi

    "$(realpath "$0")" install
}

