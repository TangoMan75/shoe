#!/bin/sh

# Print default package manager
_get_package_manager() {
    # Synopsis: _get_package_manager

    for __package_manager__ in \
        apt-get \
        apt \
        aptitude \
        nala \
        apk \
        dnf \
        pacman \
        yum \
        zypper \
        flatpak \
        snap \
    ; do
        if _is_installed "${__package_manager__}"; then
            echo "${__package_manager__}"

            return 0
        fi
    done

    echo_danger 'error: "_get_package_manager" No package manager found!\n'

    exit 1
}
