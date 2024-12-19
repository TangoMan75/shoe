#!/bin/sh

# Initialise git submodules
_initialise_submodules() {
    # Synopsis: _initialise_submodules

    _check_installed git

    if [ ! -f "$(_pwd)/.gitmodules" ]; then
        echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    echo_info "git submodule update --init --recursive\n"
    git submodule update --init --recursive
}

