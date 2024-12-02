#!/bin/sh

# generate random 32 bit string
_generate_key() {
    # Synopsis: _generate_key

    # Check openssl installation
    if [ ! -x "$(command -v openssl)" ]; then
        echo_danger "error: \"$(basename "${0}")\" requires openssl, try: 'sudo apt-get install -y openssl'\n"
        return 1
    fi

    echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
}

