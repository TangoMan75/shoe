#!/bin/sh

## Install dconf-editor
install_dconf_editor() {
    alert_success 'install dconf-editor'

    # check system uses gnome
    if ! _is_gnome; then
        _echo_danger "error: \"$(lsb_release -cs 2>/dev/null)\" not supported\n"

        return 1
    fi

    _echo_info 'sudo apt-get install --assume-yes dconf-editor\n'
    sudo apt-get install --assume-yes dconf-editor
}
