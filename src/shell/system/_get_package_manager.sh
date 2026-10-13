#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Print default package manager",
##   "requires": [
##     "apt",
##     "apt-get",
##     "echo",
##     "snap"
##   ],
##   "depends": [
##     "src/shell/colors/_echo_error",
##     "src/shell/system/_is_installed"
##   ]
## }
_get_package_manager() {
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

    _echo_error '_get_package_manager: No package manager found!\n'

    exit 1
}
