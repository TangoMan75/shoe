#!/bin/sh

## Print device infos
infos() {
    if _is_device_connected_with_adb; then
        _echo_success 'connected with adb\n'
        _echo_info 'adb devices -l\n'
        adb devices -l

        _echo_info 'adb get-state\n'
        adb get-state

        _echo_info 'adb get-serialno\n'
        adb get-serialno

        _echo_info 'adb get-devpath\n'
        adb get-devpath

        # deprecated
        # adb shell pm list users

        _echo_info 'adb shell cmd user list --all\n'
        adb shell cmd user list --all

        _echo_warning 'IMEI\n'
        _echo_info "adb shell service call iphonesubinfo 1 | cut -c 52-66 | tr -d \".[:space:]\"\n"
        adb shell service call iphonesubinfo 1 | cut -c 52-66 | tr -d ".[:space:]"

        _echo_warning 'Version\n'
        _echo_info 'adb shell getprop ro.build.version.release\n'
        adb shell getprop ro.build.version.release

        _echo_warning 'Product\n'
        _echo_info 'adb shell getprop ro.product.brand\n'
        adb shell getprop ro.product.brand

        _echo_info 'adb shell getprop ro.product.device\n'
        adb shell getprop ro.product.device

        _echo_info 'adb shell getprop ro.product.model\n'
        adb shell getprop ro.product.model

        echo

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_success 'connected with fastboot\n'
        _echo_info 'fastboot devices\n'
        fastboot devices

        _echo_info 'fastboot oem device-info\n'
        fastboot oem device-info

        _echo_info 'fastboot flashing get_unlock_ability\n'
        fastboot flashing get_unlock_ability

        # echo_info 'fastboot flashing get_unlock_bootloader_nonce\n'
        # fastboot flashing get_unlock_bootloader_nonce

        # https://source.android.com/devices/tech/ota/ab
        # https://www.droidwin.com/check-change-current-active-slot-on-android/

        _echo_info 'fastboot getvar current-slot\n'
        fastboot getvar current-slot

        _echo_info 'fastboot getvar all\n'
        fastboot getvar all

        return 0
    fi

    _echo_warning 'device is not connected with adb nor fastboot\n'
}

