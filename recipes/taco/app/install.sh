#!/bin/sh

## Install Taco
##
## @namespace recipes/taco/app
## @requires chmod cp diff pwd sh sudo
## @depends src/shell/colors/_echo_error.sh
install() {
    SOURCE="$(pwd)/taco.py"
    DESTINATION="/usr/bin/taco"

    if [ ! -f "${SOURCE}" ]; then
      _echo_error "taco.py not found at ${SOURCE}\n"

      return 1
    fi

    if [ -f "${DESTINATION}" ] && diff -q "${SOURCE}" "${DESTINATION}" >/dev/null 2>&1; then
        _echo_error "taco is already installed and up to date."

        return 1
    fi

    if [ ! -w /usr/bin ]; then
        _echo_error "Installing taco to ${DESTINATION} (requires sudo) ...\n"
        sudo sh -c "cp '${SOURCE}' '${DESTINATION}' && chmod +x '${DESTINATION}'"
    else
        cp "${SOURCE}" "${DESTINATION}"
        chmod +x "${DESTINATION}"

        _echo_succes "Installed taco to ${DESTINATION}"
    fi
}

