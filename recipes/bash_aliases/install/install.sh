#!/bin/bash

## Install .bash_aliases
##
## @namespace recipes/bash_aliases/install
## @depends recipes/bash_aliases/install/config_bashrc.sh
## @depends recipes/bash_aliases/install/config_zshrc.sh
install() {
    config_bashrc
    config_zshrc
}

