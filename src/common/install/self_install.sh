#!/bin/sh

## Install script and enable completion
self_install() {
    if [ -n "${global}" ] && [ "${global}" = true ]; then
        _copy_install "$0" "${ALIAS}"
        _generate_global_autocomplete "$0" "${ALIAS}"
    else
        _symlink_install "$0" "${ALIAS}"
        _generate_autocomplete "$0" "${ALIAS}"
    fi

    if [ -x "$(command -v zsh)" ]; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$0" "${ALIAS}" || true
    fi

    if [ -x "$(command -v bash)" ]; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            set -- ~/.profile "$0" "${ALIAS}"
        else
            set -- ~/.bashrc "$0" "${ALIAS}"
        fi
        if [ -f "$1" ]; then
            _set_completion_autoload "$1" "$2" "${ALIAS}"
        fi
    fi
}

