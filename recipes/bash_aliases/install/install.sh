#!/bin/bash

## {
##   "namespace": "recipes/bash_aliases/install",
##   "summary": "Install .bash_aliases",
##   "depends": [
##     "recipes/bash_aliases/install/config_bashrc",
##     "recipes/bash_aliases/install/config_zshrc"
##   ]
## }
install() {
    config_bashrc
    config_zshrc
}

