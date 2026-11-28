#!/bin/sh

## Check if the connected device grants root access
##
## Runs "id -u" through the "su" binary installed by Magisk and checks
## that the returned user id is 0. Returns 1 when the device is not
## connected or when root access is denied.
##
## @namespace recipes/android/root
## @requires adb tr
## @depends src/shell/android/_is_device_connected_with_adb.sh
_is_rooted() {
    if ! _is_device_connected_with_adb; then

        return 1
    fi

    if [ "$(adb shell 'su -c "id -u"' 2>/dev/null | tr -d '\r')" = '0' ]; then

        return 0
    fi

    return 1
}

