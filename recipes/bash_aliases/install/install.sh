#!/bin/bash

## Install .bash_aliases
##
## @namespace recipes/bash_aliases/install
## @depends recipes/bash_aliases/install/config_bashrc recipes/bash_aliases/install/config_zshrc
install() {
    config_bashrc
    config_zshrc
}

