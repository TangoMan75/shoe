#!/bin/sh

## Unlock the bootloader and flashing capability
##
## WARNING: unlocking the bootloader erases all user data.
## Complete the Android setup wizard and enable USB debugging again
## before running "root" command.
##
## @namespace recipes/android/root
## @requires adb fastboot reboot tr true
## @depends recipes/android/root/_is_unlocked.sh
## @depends recipes/android/root/_wait_for_fastboot.sh
## @depends src/shell/android/_fastboot_unlock.sh
## @depends src/shell/android/_is_device_connected_with_adb.sh
## @depends src/shell/android/_is_device_connected_with_fastboot.sh
## @depends src/shell/colors/_alert_danger.sh
## @depends src/shell/colors/_alert_success.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @depends src/shell/prompts/_yes_no.sh
## @depends src/shell/system/_require.sh
unlock() {
    _require adb
    _require fastboot

    if ! _is_device_connected_with_adb && ! _is_device_connected_with_fastboot; then
        _echo_error 'unlock: device not connected\n'

        return 1
    fi

    if _is_unlocked; then
        _echo_warning 'Bootloader is already unlocked.\n'

        return 0
    fi

    if _is_device_connected_with_adb; then
        oem_unlock="$(adb shell getprop sys.oem_unlock_allowed 2>/dev/null | tr -d '\r')"

        if [ -n "${oem_unlock}" ] && [ "${oem_unlock}" != '1' ]
        then
            _echo_warning 'Enable "OEM unlocking" in Developer options first.\n'

            return 1
        fi
    fi

    _alert_danger 'Unlocking the bootloader erases all user data.'
    _echo_warning 'Back up your photos, messages and files first.\n'

    if ! _yes_no 'Unlock the bootloader now?'; then
        _echo_info 'Aborted.\n'

        return 1
    fi

    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot bootloader\n'
        adb reboot bootloader || true
    fi

    _wait_for_fastboot 60 || return 1

    _echo_info 'On the device, choose UNLOCK THE BOOTLOADER and confirm.\n'
    _fastboot_unlock

    _alert_success 'Bootloader unlock requested.'
    _echo_info 'When Android starts, complete the setup wizard and enable\n'
    _echo_info 'Developer options and USB debugging.\n'
}

