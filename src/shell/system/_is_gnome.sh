#!/bin/sh

# Check current desktop is gnome
#
# {
#   "namespace": "system",
#   "assumes": [
#     "XDG_CURRENT_DESKTOP"
#   ]
# }
_is_gnome() {
    # Synopsis: _is_gnome

    if [ "${XDG_CURRENT_DESKTOP}" != 'ubuntu:GNOME' ]; then

        return 1
    fi

    return 0
}

