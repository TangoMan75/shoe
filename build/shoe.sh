#!/usr/bin/env sh

set -e

# This script is based on TangoMan Shoe Shell Microframework
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Source code is available here: https://github.com/TangoMan75/shoe

## TangoMan Shoe
##
## Simplify your shell scripting workflow with self-documenting
## shell scripts with robust argument validation. Just prefix a
## comment with two pound signs (##) on the line above any
## function or variable to generate helpful documentation using
## the "help" command.
##
## Warning: Functions and variables names should not contain dashes.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/build/shoe.sh

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

#--------------------------------------------------
#_ Android
#--------------------------------------------------

## Connect to device with adb via wifi (not recommended when flashing images)
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {str} <IP> /^([0-9]{1,3}\\.){3}[0-9]{1,3}$/ (required) Device IP address.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:5555) Destination port.
_adb_connect() {
    _check_installed adb

    if [ -z "$1" ]; then _echo_error '_adb_connect: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_adb_connect: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-5555}"

    _echo_info "adb connect \"$1:$2\"\n"
    adb connect "$1:$2"
}

## Sideload given full OTA package to connected device
##
## @namespace src/shell/android
## @requires adb realpath
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
_adb_sideload() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_adb_sideload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_adb_sideload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_adb_sideload: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "adb sideload \"$1\"\n"
    adb sideload "$1"
}

## Start local adb server
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_adb_start_server() {
    _check_installed adb

    _echo_info 'adb start-server\n'
    adb start-server
}

## Lock bootloader and flashing
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_fastboot_lock() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot oem lock\n'
    fastboot oem lock

    _echo_info 'fastboot flashing lock\n'
    fastboot flashing lock

    # _echo_info 'fastboot flashing lock_critical\n'
    # fastboot flashing lock_critical
}

## Unlock bootloader and flashing
##
## @namespace src/shell/android
## @requires fastboot true
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_fastboot_unlock() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot oem unlock || true\n'
    fastboot oem unlock || true

    _echo_info 'fastboot flashing unlock || true\n'
    fastboot flashing unlock || true

    _echo_info 'fastboot flashing unlock_critical || true\n'
    fastboot flashing unlock_critical || true
}

## Wipe userdata on connected device
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_fastboot_wipe() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot -w\n'
    fastboot -w
}

## Flash img file to connected device provided partition
##
## @namespace src/shell/android
## @requires fastboot realpath true
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <PARTITION> (required) The name of the target partition.
## @param {bool} <FORCE> (default:false) Force install.
_flash_img() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_flash_img: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_flash_img: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_flash_img: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-false}"

    if [ "$3" = true ]; then
        # fastboot flash <partition> [ <filename> ]
        # -S0 disable sparse
        _echo_info "fastboot --verbose --disable-verity --disable-verification flash \"$2\" \"$1\"\n"
        fastboot --verbose --disable-verity --disable-verification flash "$2" "$1"

        return 0
    fi

    _echo_info "fastboot --verbose flash \"$2\" \"$1\"\n"
    fastboot --verbose flash "$2" "$1"
}

## Get APK label
##
## @namespace src/shell/android
## @requires aapt awk realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_label() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_label: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_label: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_apk_label: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    aapt dump badging "$1" 2>/dev/null | awk -F "'" '/application-label:/{print $2}'
}

## Get APK package_name
##
## @namespace src/shell/android
## @requires aapt awk realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_package_name() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_package_name: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_apk_package_name: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("name=|'"'"'","");  print $2}'
}

## Get installed APK path on connected device from package name
##
## @namespace src/shell/android
## @requires adb awk
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
_get_apk_path() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_get_apk_path: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_path: too many arguments ($#)\n"; return 1; fi

    # deprecated
    # adb shell pm path "$1" | awk -F ':' '{print $2}'
    adb shell cmd package path "$1" | awk -F ':' '{print $2}'
}

## Get APK version
##
## @namespace src/shell/android
## @requires aapt awk realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_version() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_version: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_version: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_apk_version: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    # adb shell dumpsys package "${apk_package}" | awk -F '=' '/versionName/{print $2}' | tr ' ' _ | head -n1
    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("versionName=|'"'"'","");  print $4}'
}

## Install APK on connected device
##
## @namespace src/shell/android
## @requires adb install realpath true
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {bool} <FORCE> (default:false) Force install.
_install_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_install_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_install_apk: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_install_apk: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    if [ "$2" = true ]; then
        # -r: replace existing application
        _echo_info "adb install -r -g \"$1\" || true\n"
        adb install -r -g "$1" || true

        return 0
    fi

    # -g: grant all runtime permissions
    _echo_info "adb install -g \"$1\" || true\n"
    adb install -g "$1" || true
}

## Check if package is installed on connected device
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
_is_apk_installed() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_is_apk_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_apk_installed: too many arguments ($#)\n"; return 1; fi

    if [ -z "$(adb shell cmd package path "$1")" ]; then

        return 1
    fi

    return 0
}

## Check device is connected with adb
##
## @namespace src/shell/android
## @requires adb tail
## @depends src/shell/system/_check_installed
_is_device_connected_with_adb() {
    _check_installed adb

    if [ "$(adb devices | tail -n2)" = 'List of devices attached' ]; then

        return 1
    fi

    return 0
}

## Check device is connected with fastboot
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/system/_check_installed
_is_device_connected_with_fastboot() {
    _check_installed fastboot

    if [ -z "$(fastboot devices)" ]; then

        return 1
    fi

    return 0
}

## List installed packages on connected device
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
_list_installed_apks() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    # deprecated
    # adb shell pm list packages -f
    adb shell cmd package list packages -f
}

## Copy APK from connected device to local folder
##
## @namespace src/shell/android
## @requires adb realpath
## @depends src/shell/android/_get_apk_path
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_pull_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_pull_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_pull_apk: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$2" ]; then _echo_error "_pull_apk: \"$2\" folder not found\n"; return 1; fi

    set -- "$1" "$(_get_apk_path "$1")" "$(realpath "$2")"

    _echo_info "adb pull \"$2\" \"$3/$1.apk\"\n"
    adb pull "$2" "$3/$1.apk"
}

## Reboot connected device to bootloader
##
## @namespace src/shell/android
## @requires adb fastboot reboot
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_reboot_bootloader() {
    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot bootloader\n'
        adb reboot bootloader

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot bootloader\n'
        fastboot reboot bootloader

        return 0
    fi

    _echo_error '"_reboot_bootloader" device not found.\n'

    return 1
}

## Reboot connected device to recovery
##
## @namespace src/shell/android
## @requires adb fastboot reboot
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_reboot_recovery() {
    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot recovery\n'
        adb reboot recovery

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot recovery\n'
        fastboot reboot recovery

        return 0
    fi

    _echo_error '"_reboot_recovery" device not found.\n'

    return 1
}

## Reboot connected device to system
##
## @namespace src/shell/android
## @requires adb fastboot reboot
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_reboot_system() {
    if _is_device_connected_with_adb; then
        _echo_info 'adb reboot system\n'
        adb reboot system

        return 0
    fi

    if _is_device_connected_with_fastboot; then
        _echo_info 'fastboot reboot\n'
        fastboot reboot

        return 0
    fi

    _echo_error '"_reboot_system" device not found.\n'

    return 1
}

## Boot connected device with given image temporarily
##
## @namespace src/shell/android
## @requires fastboot realpath
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
_reboot_with_img() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_reboot_with_img: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_reboot_with_img: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_reboot_with_img: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "fastboot --verbose boot \"$1\"\n"
    fastboot --verbose boot "$1"
}

## Remove APK from connected device
##
## @namespace src/shell/android
## @requires adb true
## @depends src/shell/android/_is_device_connected_with_adb
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {bool} <FORCE> (default:false) Force install.
_remove_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_remove_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_apk: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-false}"

    if [ "$2" = true ]; then
        # deprecated
        # adb shell pm uninstall --user 0 "$1" || true

        _echo_info "adb shell cmd package uninstall --user 0 \"$1\" || true\n"
        adb shell cmd package uninstall --user 0 "$1" || true

        return 0
    fi

    _echo_info "adb uninstall \"$1\" || true\n"
    adb uninstall "$1" || true
}

## Toggle connected device active slot
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/android/_is_device_connected_with_fastboot
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_toggle_active_slot() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

###################################################
# TangoMan Shoe Shell Microframework
###################################################

#--------------------------------------------------
# Generated code : Do not edit below this line
#--------------------------------------------------

#--------------------------------------------------
#_ Colors
#--------------------------------------------------

#--------------------------------------------------
#_ Colors
#--------------------------------------------------

## Print danger alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_DANGER _EOL
## @param {str} <STRING> (required) Text to display.
_alert_danger()    {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}

## Print dark alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_DARK _EOL
## @param {str} <STRING> (required) Text to display.
_alert_dark()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}

## Print info alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_INFO _EOL
## @param {str} <STRING> (required) Text to display.
_alert_info()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

## Print light alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_LIGHT _EOL
## @param {str} <STRING> (required) Text to display.
_alert_light()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}

## Print muted alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_MUTED _EOL
## @param {str} <STRING> (required) Text to display.
_alert_muted()     {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_MUTED}" '' "${_ALERT_MUTED}" "$1" "${_ALERT_MUTED}" ''
}

## Print primary alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_PRIMARY _EOL
## @param {str} <STRING> (required) Text to display.
_alert_primary()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" ''
}

## Print secondary alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_SECONDARY _EOL
## @param {str} <STRING> (required) Text to display.
_alert_secondary() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}

## Print success alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_SUCCESS _EOL
## @param {str} <STRING> (required) Text to display.
_alert_success()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}

## Print warning alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_WARNING _EOL
## @param {str} <STRING> (required) Text to display.
_alert_warning()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" ''
}

## bold white text over bright blue background
_ALERT_PRIMARY='\033[1;104;97m'

## bold white text over bright purple background
_ALERT_SECONDARY='\033[1;45;97m'

## bold white text over bright green background
_ALERT_SUCCESS='\033[1;42;97m'

## bold white text over bright red background
_ALERT_DANGER='\033[1;41;97m'

## bold white text over bright orange background
_ALERT_WARNING='\033[1;43;97m'

## bold white text over blue background
_ALERT_INFO='\033[1;44;97m'

## bold white text over dark gray background
_ALERT_MUTED='\033[1;100;97m'

## bold dark gray text over light gray background
_ALERT_LIGHT='\033[1;47;90m'

## bold white text over black background
_ALERT_DARK='\033[1;40;37m'

## bright white text
_PRIMARY='\033[97m'

## bright blue text
_SECONDARY='\033[94m'

## bright green text
_SUCCESS='\033[32m'

## red text
_DANGER='\033[31m'

## orange text
_WARNING='\033[33m'

## bright purple text
_INFO='\033[95m'

## gray text
_MUTED='\033[90m'

## light gray background with dark gray text
_LIGHT='\033[47;90m'

## black background with light gray text
_DARK='\033[40;37m'

## reset formatting
_DEFAULT='\033[0m'

## reset formatting and carriage return
_EOL='\033[0m\n'

## Print danger text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DANGER _DEFAULT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_danger() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DANGER}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print dark text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DARK _DEFAULT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_dark() {
    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_DARK}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print error message to STDERR, prefixed with "error: "
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DANGER _DEFAULT
## @param {str} <MESSAGE> (required) Error message to display.
_echo_error() {
    printf "${_DANGER}error: %b${_DEFAULT}" "$1" >&2
}

## Print info text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _INFO
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_info() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_INFO}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print light text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _LIGHT
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_light() {
    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_LIGHT}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print muted text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _MUTED
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_muted() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_MUTED}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print primary text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _PRIMARY
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_primary() {
    # Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),
    # this is why we're calculating the PADDING length on each execution.

    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_PRIMARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print secondary text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _SECONDARY
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_secondary() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SECONDARY}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print success text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _SUCCESS
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_success() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_SUCCESS}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

## Print warning text with optional indentation and padding
##
## @namespace src/shell/colors
## @requires printf
## @assumes _DEFAULT _WARNING
## @param {str} <STRING> (required) Text to display.
## @param {int} <INDENTATION> (default:0) Indentation level.
## @param {int} <PADDING> (default:0) Padding length.
_echo_warning() {
    set -- "$1" "${2:-0}" "$((${3:-0}-${#1}))"
    if [ "$3" -lt 0 ]; then set -- "$1" "$2" 0; fi
    printf "%*s${_WARNING}%b${_DEFAULT}%*s" "$2" '' "$1" "$3" ''
}

#--------------------------------------------------
#_ Compatibility
#--------------------------------------------------

## Return the command that copies stdin to the system clipboard
##
## @namespace src/shell/compatibility
## @requires command printf wl-copy xclip xsel
## @depends src/shell/colors/_echo_error
_clipboard() {
    set -- pbcopy wl-copy xclip xsel clip

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                xclip) printf 'xclip -selection clipboard' ;;
                xsel) printf 'xsel --clipboard --input' ;;
                *) printf '%s' "$1" ;;
            esac

            return 0
        fi

        shift
    done

    _echo_error '_clipboard: no clipboard command found\n'

    return 1
}

## Check current system is Android
##
## @namespace src/shell/compatibility
## @requires uname
## @assumes ANDROID_DATA ANDROID_ROOT
_is_android() {
    if [ -n "${ANDROID_DATA}" ] || [ -n "${ANDROID_ROOT}" ]; then

        return 0
    fi

    if [ "$(uname -o 2>/dev/null)" = 'Android' ]; then

        return 0
    fi

    return 1
}

## Check current system is BSD
##
## @namespace src/shell/compatibility
## @requires uname
_is_bsd() {
    case "$(uname -s)" in
        FreeBSD|OpenBSD|NetBSD|DragonFly) return 0 ;;
    esac

    return 1
}

## Check current system is Cygwin
##
## @namespace src/shell/compatibility
## @requires uname
_is_cygwin() {
    case "$(uname -s)" in
        CYGWIN*) return 0 ;;
    esac

    return 1
}

## Check current system is Darwin
##
## @namespace src/shell/compatibility
## @requires uname
_is_darwin() {
    if [ "$(uname -s)" != 'Darwin' ]; then

        return 1
    fi

    return 0
}

## Check current desktop is gnome
##
## @namespace src/shell/compatibility
## @assumes XDG_CURRENT_DESKTOP
_is_gnome() {
    if [ "${XDG_CURRENT_DESKTOP}" != 'ubuntu:GNOME' ]; then

        return 1
    fi

    return 0
}

## Check current system is Linux
##
## Android and WSL also report a Linux kernel
##
## @namespace src/shell/compatibility
## @requires uname
_is_linux() {
    if [ "$(uname -s)" != 'Linux' ]; then

        return 1
    fi

    return 0
}

## Check current system is MSYS or MINGW
##
## @namespace src/shell/compatibility
## @requires uname
_is_msys() {
    case "$(uname -s)" in
        MSYS*|MINGW*) return 0 ;;
    esac

    return 1
}

## Check current environment is Termux
##
## @namespace src/shell/compatibility
_is_termux() {
    if [ ! -d '/data/data/com.termux' ]; then

        return 1
    fi

    return 0
}

## Check current system is Windows Subsystem for Linux
##
## @namespace src/shell/compatibility
## @requires grep
## @assumes WSL_DISTRO_NAME WSL_INTEROP
_is_wsl() {
    if [ -n "${WSL_DISTRO_NAME}" ] || [ -n "${WSL_INTEROP}" ]; then

        return 0
    fi

    if [ -r '/proc/version' ]; then
        if grep -qi 'microsoft' '/proc/version' 2>/dev/null; then

            return 0
        fi
    fi

    return 1
}

## Return the command that opens a file or URL with the default handler
##
## The operating system type is resolved by _os_type, which prefers
## the kernel name reported by uname and falls back to OSTYPE. When the
## type cannot be resolved, _os_type reports the error and _open
## only propagates the failure.
##
## @namespace src/shell/compatibility
## @requires printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/compatibility/_os_type
_open() {
    set -- "$(_os_type)"

    if [ -z "$1" ]; then

        return 1
    fi

    case "$1" in
        cygwin|msys) printf 'start' ; return 0 ;;
        darwin) printf 'open' ; return 0 ;;
        linux) printf 'xdg-open' ; return 0 ;;
    esac

    _echo_error "_open: no default handler for os type: \"$1\"\n"

    return 1
}

## Print the current operating system type
##
## The kernel name reported by uname is normalised to a short lower case
## identifier: bsd, cygwin, darwin, linux or msys. Android, Termux and
## WSL all report a Linux kernel and are therefore reported as linux;
## use the _is_android, _is_termux and _is_wsl helpers when those
## environments need to be distinguished.
## uname is part of POSIX and is preferred over OSTYPE, which is a bash
## variable that is not always set and may hold an unexpected value.
##
## @namespace src/shell/compatibility
## @requires printf uname
## @depends src/shell/colors/_echo_error
## @assumes OSTYPE
_os_type() {
    if command -v uname >/dev/null 2>&1; then
        set -- "$(uname -s 2>/dev/null)"
    else
        # (warning): In POSIX sh, OSTYPE is undefined.
        # shellcheck disable=SC3028
        set -- "${OSTYPE:-}"
    fi

    case "$1" in
        Linux*|linux*)
            printf 'linux'
            return 0
            ;;
        Darwin*|darwin*)
            printf 'darwin'
            return 0
            ;;
        FreeBSD*|OpenBSD*|NetBSD*|DragonFly*|freebsd*|openbsd*|netbsd*|dragonfly*)
            printf 'bsd'
            return 0
            ;;
        CYGWIN*|cygwin*)
            printf 'cygwin'
            return 0
            ;;
        MSYS*|MINGW*|msys*|mingw*)
            printf 'msys'
            return 0
            ;;
    esac

    _echo_error "_os_type: unknown os type: \"$1\"\n"

    return 1
}

## Print the default package manager for the current operating system
##
## The operating system type is resolved by _os_type. Linux
## distributions do not share a single package manager, so the first
## command found among the common ones is printed. Termux is detected
## separately because it reports a Linux kernel but provides its own
## "pkg" wrapper.
##
## @namespace src/shell/compatibility
## @requires apt apt-get command printf snap
## @depends src/shell/colors/_echo_error
## @depends src/shell/compatibility/_is_termux
## @depends src/shell/compatibility/_os_type
_package_manager() {
    set -- "$(_os_type)"

    if [ -z "$1" ]; then

        return 1
    fi

    if [ "$1" = 'linux' ]; then
        if _is_termux; then
            printf 'pkg'

            return 0
        fi

        set -- apt-get apt aptitude snap flatpak nala apk dnf pacman yum zypper
        while [ $# -gt 0 ]; do
            if command -v "$1" >/dev/null 2>&1; then
                printf '%s' "$1"

                return 0
            fi

            shift
        done

        _echo_error '_package_manager: no package manager found\n'

        return 1
    fi

    case "$1" in
        bsd) printf 'pkg' ; return 0 ;;
        cygwin) printf 'apt-cyg' ; return 0 ;;
        darwin) printf 'brew' ; return 0 ;;
        msys) printf 'pacman' ; return 0 ;;
    esac

    return 1
}

## Return the command that resolves a canonical path
##
## @namespace src/shell/compatibility
## @requires command printf readlink realpath
## @depends src/shell/colors/_echo_error
_readlink() {
    set -- realpath greadlink readlink

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                greadlink) set -- 'greadlink -f' ;;
                readlink)
                    if "$1" -f '/' >/dev/null 2>&1; then
                        set -- 'readlink -f'
                    else
                        shift
                        continue
                    fi
                    ;;
            esac

            printf '%s' "$1"

            return 0
        fi

        shift
    done

    _echo_error '_readlink: no canonical path command found\n'

    return 1
}

## Return sed -i system flavour
##
## @namespace src/shell/compatibility
## @requires command printf sed uname
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        printf "sed -i ''"

        return 0
    fi

    printf 'sed -i'
}

## Return the command that computes a SHA-256 digest
##
## @namespace src/shell/compatibility
## @requires command openssl printf sha256sum shasum
## @depends src/shell/colors/_echo_error
_sha256() {
    set -- sha256sum shasum openssl

    while [ $# -gt 0 ]; do
        if command -v "$1" >/dev/null 2>&1; then
            case "$1" in
                shasum) set -- 'shasum -a 256' ;;
                openssl) set -- 'openssl dgst -sha256' ;;
            esac

            printf '%s\n' "$1"

            return 0
        fi

        shift
    done

    _echo_error '_sha256: no SHA-256 command found\n'

    return 1
}

#--------------------------------------------------
#_ Ides
#--------------------------------------------------

## List installed ides
##
## @namespace src/shell/dev
## @requires code command nano phpstorm printf subl vim
_list_ides() {
    set -- antigravity atom clion code codium cursor intellij-idea-community micro nano nvim phpstorm pycharm pycharm-community subl vim webstorm windsurf zed
    while [ "$#" -gt 0 ]; do
        if [ -n "$(command -v "$1")" ]; then
            printf '%s ' "$1"
        fi
        shift
    done
}

#--------------------------------------------------
#_ Docker
#--------------------------------------------------

## Return docker compose command
##
## @namespace src/shell/docker
## @requires basename command docker docker-compose printf
## @depends src/shell/colors/_echo_error
_docker_compose() {
    if docker compose >/dev/null 2>&1; then
        printf 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        printf 'docker-compose'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"

    exit 1
}

## Build container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/docker/_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_build() {
    if [ $# -gt 1 ]; then _echo_error "_docker_compose_build: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_docker_compose) build\n"
        $(_docker_compose) build

        return 0
    fi

    if [ ! -f "$1" ]; then _echo_error "_docker_compose_build: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "$(_docker_compose) --file \"$1\" build\n"
    $(_docker_compose) --file "$1" build
}

## Build and start container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/docker/_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
## @param {file} <ENV_FILE> The path to the env file.
_docker_compose_start() {
    if [ $# -gt 2 ]; then _echo_error "_docker_compose_start: too many arguments ($#)\n"; return 1; fi

    if [ $# -eq 2 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        if [ ! -f "$2" ]; then _echo_error "_docker_compose_start: \"$2\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")" "$(realpath "$2")"

        _echo_info "$(_docker_compose) --file \"$1\" --env-file \"$2\" up --detach --remove-orphans\n"
        $(_docker_compose) --file "$1" --env-file "$2" up --detach --remove-orphans

        return 0
    fi

    if [ $# -eq 1 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")"

        _echo_info "$(_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
        $(_docker_compose) --file "$1" up --detach --remove-orphans

        return 0
    fi

    _echo_info "$(_docker_compose) up --detach --remove-orphans\n"
    $(_docker_compose) up --detach --remove-orphans
}

## Stop container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/docker/_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_stop() {
    if [ $# -gt 1 ]; then _echo_error "_docker_compose_stop: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_docker_compose) stop\n"
        $(_docker_compose) stop

        return 0
    fi

    if [ ! -f "$1" ]; then _echo_error "_docker_compose_stop: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "$(_docker_compose) --file \"$1\" stop\n"
    $(_docker_compose) --file "$1" stop
}

## Execute command in the given docker container
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
## @param {str} <COMMAND> (required) The command to execute.
## @param {str} <USER> The user name.
_docker_exec() {
    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_docker_exec: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_docker_exec: too many arguments ($#)\n"; return 1; fi

    if [ -z "$3" ]; then
        _echo_info "docker exec --interactive --tty \"$1\" $2\n"
        # shellcheck disable=SC2086
        docker exec --interactive --tty "$1" $2

        return 0
    fi

    _echo_info "docker exec --interactive --tty --user \"$3\" \"$1\" $2\n"
    # shellcheck disable=SC2086
    docker exec --interactive --tty --user "$3" "$1" $2
}

## Kill all running containers with docker
##
## @namespace src/shell/docker
## @requires docker kill ps tr
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_docker_kill_all() {
    _check_installed docker

    _echo_info "docker kill $(docker ps --quiet --format '{{.Names}}' | tr -s "\n" ' ')\n"
    # shellcheck disable=SC2046
    docker kill $(docker ps --quiet --format '{{.Names}}')
}

## Remove given docker container
##
## @namespace src/shell/docker
## @requires docker rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
_docker_rm() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_docker_rm: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_docker_rm: too many arguments ($#)\n"; return 1; fi

    _echo_info "docker rm \"$1\"\n"
    docker rm "$1"
}

## Spawn a new container with given image, name, command and volume
##
## @namespace src/shell/docker
## @requires docker realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {str} <IMAGE> (required) The name of the container image to run.
## @param {str} <NAME> (required) Assign a name to the container.
## @param {str} <COMMAND> (required) The command to run inside provided container.
## @param {folder} <FOLDER_PATH> The path to the volume folder.
_docker_run() {
    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_docker_run: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_docker_run: too many arguments ($#)\n"; return 1; fi

    if [ -z "$4" ]; then
        _echo_info "docker run --detach --rm --interactive --tty --name \"$2\" \"$1\" $3\n"
        # shellcheck disable=SC2086
        docker run --detach --rm --interactive --tty --name "$2" "$1" $3

        return 0
    fi

    if [ ! -d "$4" ]; then _echo_error "_docker_run: \"$4\" folder not found\n"; return 1; fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"

    _echo_info "docker run --detach --rm --interactive --tty --volume=\"$4:/home\" --workdir=\"/home\" --name \"$2\" \"$1\" $3\n"
    # shellcheck disable=SC2086
    docker run --detach --rm --interactive --tty --volume="$4:/home" --workdir="/home" --name "$2" "$1" $3
}

## Run local atmoz_sftp server
##
## @namespace src/shell/docker
## @requires docker realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {str} <USERNAME> (required) The name of the container to run.
## @param {str} <PASSWORD> (required) The password for the sftp server access.
## @param {str} <NETWORK_MODE> /^(bridge|host)$/ The user name.
## @param {folder} <FOLDER_PATH> The path to the volume folder.
_docker_run_atmoz_sftp() {
    # note: atmoz_sftp documentation: https://github.com/atmoz/sftp

    _check_installed docker

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_docker_run_atmoz_sftp: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_docker_run_atmoz_sftp: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-bridge}" "$4"

    if [ -z "$4" ]; then
        _echo_info "docker run --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
        docker run --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"

        return 0
    fi

    if [ ! -d "$4" ]; then _echo_error "_docker_run_atmoz_sftp: \"$4\" folder not found\n"; return 1; fi

    set -- "$1" "$2" "$3" "$(realpath "$4")"

    _echo_info "docker run --volume=\"$4:/home/shared\" --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
    docker run --volume="$4:/home/shared" --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"
}

## Run local whoami server
##
## @namespace src/shell/docker
## @requires docker whoami
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_docker_run_whoami() {
    # note: traefik_whoami documentation: https://github.com/traefik/whoami

    _check_installed docker

    if [ $# -gt 0 ]; then _echo_error "_docker_run_whoami: too many arguments ($#)\n"; return 1; fi

    _echo_info "docker run --detach --publish-all --rm --name whoami traefik/whoami\n"
    docker run --detach --publish-all --rm --name whoami traefik/whoami
}

## Print docker status
##
## @namespace src/shell/docker
## @requires column docker ps
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_docker_status() {
    _check_installed docker

    _echo_info "docker inspect --format '{{truncate .ID 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range \$p, \$c := .NetworkSettings.Ports}}{{\$p}} {{end}}' \$(docker ps --all --quiet) | column -t\n"
    # shellcheck disable=SC2046
    docker inspect --format '{{truncate .ID 13}} {{slice .Name 1}} {{range .NetworkSettings.Networks}}{{if .IPAddress}}http://{{.IPAddress}} {{end}}{{end}}{{range $p, $c := .NetworkSettings.Ports}}{{$p}} {{end}}' $(docker ps --all --quiet) | column -t
}

## Find container name from string
##
## @namespace src/shell/docker
## @requires docker grep head printf ps sed
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {str} <STRING> (required) The string to find among running containers.
_find_container_name() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_find_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_find_container_name: too many arguments ($#)\n"; return 1; fi

    # sanitize input
    set -- "$(printf '%s' "$1" | sed 's/[^a-zA-Z0-9_-]//g')"

    # get container names
    # shellcheck disable=SC2046
    docker inspect --format '{{slice .Name 1}}' $(docker ps --all --quiet) | grep "$1" | head -n1
}

## Get container id from name
##
## @namespace src/shell/docker
## @requires docker false
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME> (required) The name of the container to run.
## @param {bool} <TRUNCATE> (default:true) Truncate id to 12 characters long.
_get_container_id() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_id: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_container_id: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "${2:-true}"

    if [ "$2" = false ]; then
        docker inspect "$1" --format='{{.Id}}' || return 1

        return 0
    fi

    docker inspect "$1" --format='{{truncate .Id 13}}'
}

## Get running container ip
##
## @namespace src/shell/docker
## @requires docker printf true
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME|CONTAINER_ID> (required) The name or the id of the docker container.
_get_container_ip() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_ip: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_container_ip: too many arguments ($#)\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" != true ]; then

        return 1
    fi

    set -- "$1" "$(docker inspect "$1" --format '{{.NetworkSettings.Networks.IPAddress}}' 2>/dev/null)"

    if [ "$2" = '<no value>' ]; then
        set -- "$1" "$(docker inspect "$1" --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' 2>/dev/null)"
    fi

    if [ -z "$2" ]; then
        printf '%s' 127.0.0.1

        return 0
    fi

    printf '%s' "$2"
}

## Get container name from id
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_ID> (required) The container id.
_get_container_name() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_container_name: too many arguments ($#)\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

## Checks if given container is running
##
## @namespace src/shell/docker
## @requires docker true
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {str} <CONTAINER_NAME|CONTAINER_ID> (required) The name or the id of the docker container.
_is_container_running() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_is_container_running: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_container_running: too many arguments ($#)\n"; return 1; fi

    if [ "$(docker inspect "$1" --format '{{.State.Running}}' 2>/dev/null)" = true ]; then

        return 0
    fi

    return 1
}

## Wait for postgresql container to start with docker
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/system/_check_installed
## @depends src/shell/system/_spin
## @param {str} <CONTAINER_NAME> (required) The name of the docker container.
## @param {str} <USERNAME> (default:"") The psql username.
_wait_for_postgres() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_postgres: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_wait_for_postgres: too many arguments ($#)\n"; return 1; fi

    if [ -n "$2" ]; then
        set -- "$1" "--username $2"
    fi

    _echo_warning "Waiting for \"$1\" database to start."

    while [ ! "$(docker exec "$1" psql "$2" -l 2>/dev/null)" ]; do
        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

## Wait for rabbitmq container to start with docker
##
## @namespace src/shell/docker
## @requires docker grep
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/system/_check_installed
## @depends src/shell/system/_spin
## @param {str} <CONTAINER_NAME> (required) The name of the docker container.
_wait_for_rabbit() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_wait_for_rabbit: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_wait_for_rabbit: too many arguments ($#)\n"; return 1; fi

    _echo_warning "Waiting for \"$1\" to start."

    while ! docker exec "$1" rabbitmqctl wait --pid 1 --timeout 1 2>/dev/null | grep -q "Applications 'rabbit_and_plugins' are running"; do
        _spin 600
    done

    _echo_success "\n\"$1\" is runnning.\n"
}

##################################################
### Documentation
##################################################

#--------------------------------------------------
#_ Documentation
#--------------------------------------------------

## Generate Markdown documentation for provided shoe script
##
## @namespace src/shell/documentation
## @requires awk basename dirname printf realpath sed
## @depends src/shell/colors/_alert_primary
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_success
## @depends src/shell/reflexion/_get_constants
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/reflexion/_get_options
## @depends src/shell/reflexion/_print_synopsis
## @depends src/shell/shoedoc/_get_function_shoedoc
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the documentation file. Defaults to "<BASENAME>.md".
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", documents private constants, options, flags, and commands as well.
_generate_doc() {
    if [ -z "$1" ]; then _echo_error '_generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_generate_doc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ -n "$2" ] && [ ! -d "$2" ]; then _echo_error "_generate_doc: \"$2\" folder not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"

    # check valid input file type
    case "$1" in
        *.sh) ;;
        *) _echo_error '_generate_doc: file should be type ".sh"\n'; return 1 ;;
    esac

    _alert_primary "Generating $3"

    (
        __annotations__=$(_get_script_shoedoc "$1")

        printf '%s\n===\n\n' "$(_get_shoedoc_title "${__annotations__}")"

        printf '## ℹ️ Infos\n\n'
        # \055 is escape code for dash character within printf
        printf '\055 author:  %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'author')"
        printf '\055 version: %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'version')"
        printf '\055 link:    %s\n' "$(_get_shoedoc_tag "${__annotations__}" 'link' )"
        printf '\n\n'

        printf '## 📑 Description\n\n'
        printf '%s\n\n' "$(_get_shoedoc_description "${__annotations__}")"

        printf '## 🔥 Usage\n\n'
        printf '`sh %s [command] ' "$(basename "$1")"
        awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
            if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
            if ($2 == "false") {printf "(--%s) ",$1;next}
            printf "(--%s %s) ",$1,$2
        } {PREV = $0}' "$1" | sed 's/ $//'
        printf '`\n\n'

        if [ -n "$(_get_constants "$1")" ]; then
            printf '## 🧱 Constants\n\n'
            awk -F '=' -v GET_PRIVATE="$4" \
            '/^[A-Z0-9_]+=.+$/ {
                if (GET_PRIVATE == "false" && (substr(PREV,1,3) != "## " || substr($0,1,1) == "_")) next;
                PRIVATE = "";
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_") PRIVATE = " (private)";
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,TITLE,$2
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`%s` (private)**\n> %s\n  - 🚩 Default: _%s_\n\n",++i,$1,TITLE,$2
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                TITLE = FIRST;
                sub("^#+ ","",TITLE);
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,TITLE
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                } else if (substr($0,1,3) == "## ") {
                    if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
                } else {
                    FIRST = ""
                }
                PREV = $0
            }' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(FIRST,RSTART+1,RLENGTH-1);
                    DESCRIPTION=substr(FIRST,4,RSTART-4);
                } else {
                    DESCRIPTION=substr(FIRST,4);
                }
                if (CONSTRAINT != "") {
                    printf "%d. **`--%s`**\n> %s\n  - 🧩 Constraint: `%s`\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`--%s`**\n> %s\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,$2
                }
                printf "\n\n"
            } {
                if ($0 == "##") {
                    if (FIRST == "" || FIRST == "##") FIRST = $0
                } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
                    if (FIRST == "" || FIRST == "##") {
                        TITLE = substr($0,4)
                        sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                        sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                        sub(/^<[^>]*>[ \t]*/, "", TITLE)
                        sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                        sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                        sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                        FIRST = "## " TITLE
                    }
                    if (CONSTRAINT == "" && match($0, / \/[^\/]+\/[a-z]*/)) {
                        CONSTRAINT = substr($0, RSTART + 1, RLENGTH - 1)
                    }
                } else if (substr($0,1,3) == "## ") {
                    body = substr($0,4);
                    if (body ~ /^@constraint([ \t]|$)/) {
                        sub(/^@constraint[ \t]*/, "", body);
                        sub(/[ \t]+$/, "", body);
                        CONSTRAINT = body
                    } else if (substr(body,1,1) != "@") {
                        if (FIRST == "" || FIRST == "##") FIRST = $0
                    }
                } else {
                    FIRST = ""
                    CONSTRAINT = ""
                }
                PREV = $0
            }' "$1"
        fi
    ) > "$2/$3"

    printf '## 🤖 Commands\n\n' >> "$2/$3"

    __index__=0
    __current_namespace__=''

    for __function_name__ in $(_get_functions_names "$1" true); do
        _echo_info "${__function_name__}\n"

        __annotations__="$(_get_function_shoedoc "$1" "${__function_name__}")"
        if [ -z "${__annotations__}" ]; then
            _echo_error "_generate_doc: no annotation found for function \"${__function_name__}\"\n"
            continue
        fi

        if [ "$4" = false ] && [ "${__function_name__#_}" != "${__function_name__}" ]; then
            continue
        fi

        __namespace__="$(_get_shoedoc_tag "${__annotations__}" 'namespace')"
        if [ -n "${__namespace__}" ] && [ "${__namespace__}" != "${__current_namespace__}" ]; then
            __index__=0
            __current_namespace__="${__namespace__}"
            printf '### ⚡ %s\n\n' "$(printf '%s' "${__namespace__}" | awk '{print toupper($0)}')" >> "$2/$3"
        fi

        __index__=$((__index__ + 1))
        __scope__='public'
        case "${__function_name__}" in
            _*) __scope__='private' ;;
        esac

        (
            # shellcheck disable=SC2016
            printf '#### ⌨️ %d. `%s` %s\n\n' "${__index__}" "${__function_name__}" "(${__scope__})"
            printf '%s\n\n' "$(_get_shoedoc_title "${__annotations__}")"
            # shellcheck disable=SC2016
            printf '%s\n\n' "$(_print_synopsis "${__function_name__}" "${__annotations__}" true)"
        ) >> "$2/$3"
    done

    _echo_success "Documentation generated : \"$2/$3\"\n"
}

## Generate Markdown documentation for current shoe script
##
## @namespace src/shell/documentation
## @depends src/shell/documentation/_generate_doc
generate_doc() {
    _generate_doc "$0"
}

#--------------------------------------------------
#_ Env
#--------------------------------------------------

## Create a ".env" file when missing
##
## Creates the parent folder as needed. When a template file is provided
## its contents are copied into the new file.
##
## @namespace src/shell/env
## @requires cp dirname mkdir
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path of the ".env" file to create.
## @param {file} <TEMPLATE> Optional template file to copy into the new file.
_create_env() {
    if [ -z "$1" ]; then _echo_error '_create_env: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_create_env: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$(dirname "$1")" ]; then
        _echo_info "mkdir -p \"$(dirname "$1")\"\n"
        mkdir -p "$(dirname "$1")"
    fi

    if [ -f "$1" ]; then

        return 0
    fi

    if [ -n "$2" ]; then
        if [ ! -f "$2" ]; then _echo_error "_create_env: \"$2\" template not found\n"; return 1; fi

        _echo_info "cp \"$2\" \"$1\"\n"
        cp "$2" "$1"

        return 0
    fi

    : > "$1"
}

## Load the first dotenv file found for an environment
##
## Looks for ".env.<ENV>.local", ".env.<ENV>", ".env.local" and ".env"
## in this order and loads the first file that exists.
##
## @namespace src/shell/env
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/env/_load_env
## @param {str} <ENV> (required) The application environment name.
## @param {folder} <DIRECTORY> (default:".") The folder containing the dotenv files.
_load_dotenv() {
    if [ -z "$1" ]; then _echo_error '_load_dotenv: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_load_dotenv: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "${2:-.}" ]; then
        _echo_error "_load_dotenv: \"${2:-.}\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath "${2:-.}")"

    if [ -f "$2/.env.$1.local" ]; then
        _load_env "$2/.env.$1.local"

        return 0
    fi

    if [ -f "$2/.env.$1" ]; then
        _load_env "$2/.env.$1"

        return 0
    fi

    if [ -f "$2/.env.local" ]; then
        _load_env "$2/.env.local"

        return 0
    fi

    if [ -f "$2/.env" ]; then
        _load_env "$2/.env"

        return 0
    fi

    _echo_error "_load_dotenv: no dotenv file found in \"$2\"\n"

    return 1
}

## Load environment variables from a ".env" file
##
## Safely loads environment variables from a specified .env file
## into the current shell environment while preserving the
## caller's previous export settings.
##
## @namespace src/shell/env
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path of the ".env" file to load.
_load_env() {
    if [ -z "$1" ]; then _echo_error '_load_env: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_load_env: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_load_env: \"$1\" file not found\n"; return 1; fi

    # "$-" equals "${-%%a*}" when the "a" (allexport) flag is not set
    if [ "$-" = "${-%%a*}" ]; then
        set -a
        # shellcheck source=/dev/null
        if . "$1"; then
            set +a

            return 0
        fi
        set +a

        return 1
    fi

    # Allexport is already enabled: leave it as is
    # shellcheck source=/dev/null
    if . "$1"; then
        return 0
    fi

    return 1
}

#--------------------------------------------------
#_ Files
#--------------------------------------------------

## Change the extension of a file
##
## Existing destination file is never overwritten.
##
## @namespace src/shell/files
## @requires basename dirname mv
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <SOURCE> (required) The file to rename.
## @param {str} <EXTENSION> /^\.[a-zA-Z0-9]+$/ (required) The extension to apply.
_change_extension() {
    if [ "$#" -lt 2 ]; then
        _echo_error '_change_extension: some mandatory parameter is missing\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_change_extension: too many arguments ($#)\n"

        return 1
    fi

    # Record layout:
    # - $1: source path
    # - $2: new extension
    # - $3: parent folder
    # - $4: base name
    # - $5: base name without extension
    # - $6: target path
    set -- "$1" "${2#.}"

    if [ ! -e "$1" ]; then
        _echo_error "_change_extension: \"$1\" file not found\n"

        return 1
    fi

    set -- "$1" "$2" "$(dirname "$1")" "$(basename "$1")"

    # Strip the last extension, preserving hidden file names.
    if [ "${4#.}" != "$4" ]; then
        # Hidden file: keep the leading dot when there is no extension.
        if [ -z "${4%.*}" ]; then
            set -- "$1" "$2" "$3" "$4" "$4"
        else
            set -- "$1" "$2" "$3" "$4" "${4%.*}"
        fi
    elif [ "${4#*.}" != "$4" ]; then
        set -- "$1" "$2" "$3" "$4" "${4%.*}"
    else
        set -- "$1" "$2" "$3" "$4" "$4"
    fi

    set -- "$1" "$2" "$3" "$4" "$5" "$3/$5.$2"

    # Avoid unnecessary mv if source and target are identical
    if [ "$1" = "$6" ]; then
        return 0
    fi

    _echo_info "mv -i \"$1\" \"$6\"\n"
    mv -i "$1" "$6"
}

## Recursively delete common junk files and folders
##
## Removes "__MACOSX" and "__pycache__" folders, "desktop.ini",
## "Thumbs.db", "*.log", ".DS_Store" and undo scripts.
##
## @namespace src/shell/files
## @requires find realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {folder} <SOURCE> (required) The folder to clean.
_clean_folder() {
    if [ -z "$1" ]; then _echo_error '_clean_folder: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_clean_folder: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$1" ]; then
        _echo_error "_clean_folder: \"$1\" is not a valid directory\n"

        return 1
    fi

    set -- "$(realpath "$1")"

    _echo_info "find \"$1\" -type d -name \"__MACOSX\" -exec rm -rf '{}' +\n"
    find "$1" -type d -name "__MACOSX" -exec rm -rf {} +

    _echo_info "find \"$1\" -type d -name \"__pycache__\" -exec rm -rf '{}' +\n"
    find "$1" -type d -name "__pycache__" -exec rm -rf {} +

    _echo_info "find \"$1\" -type f -iname desktop.ini -exec rm -f {} +\n"
    find "$1" -type f -iname desktop.ini -exec rm -f {} +

    _echo_info "find \"$1\" -type f -iname thumbs.db -exec rm -f {} +\n"
    find "$1" -type f -iname thumbs.db -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name '*.log' -exec rm -f {} +\n"
    find "$1" -type f -name '*.log' -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name .DS_Store -exec rm -f {} +\n"
    find "$1" -type f -name .DS_Store -exec rm -f {} +

    _echo_info "find \"$1\" -type f -name '*_undo.sh' -exec rm -f {} +\n"
    find "$1" -type f -name "*_undo.sh" -exec rm -f {} +
}

## Compress a file or folder into an archive
##
## Uses 7z when available and falls back to tar.gz. The recursive flag
## creates one archive per direct subfolder.
##
## @namespace src/shell/files
## @requires basename command dirname find grep printf realpath sed sort tar
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {path} <SOURCE> (required) The file or folder to compress.
## @param {folder} <DESTINATION> (default:"current folder") The folder receiving the archives.
## @flag <recursive> [-r] Create one archive per direct subfolder.
_compress() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-r' ]; then
            set -- "$@" '--recursive'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_compress\n'
            _echo_success 'description:' 2 14; _echo_primary 'Compress a file or folder into an archive\n'
            _echo_success 'usage:' 2 14; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: recursive flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--recursive'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--recursive' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_compress: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 3 ]; then
        _echo_error "_compress: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_compress [source] [destination] -r (recursive) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Validate arguments
    #--------------------------------------------------

    if [ ! -f "$2" ] && [ ! -d "$2" ]; then
        _echo_error "_compress: \"$2\" is invalid\n"

        return 1
    fi
    if [ ! -d "${3:-.}" ]; then
        _echo_error "_compress: \"${3:-.}\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath "$2")" "$(realpath "${3:-.}")"

    #--------------------------------------------------
    # Select archiver
    #--------------------------------------------------

    if command -v 7z >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" '7z' '7z'
    else
        set -- "$1" "$2" "$3" 'tar.gz' 'tar'
    fi

    #--------------------------------------------------
    # Collect paths to compress
    #--------------------------------------------------

    # $6: newline separated list of paths left to compress.
    if [ "$1" = 'true' ] && [ -d "$2" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" \
            "$(find "$2" -mindepth 1 -maxdepth 1 -type d | sort)"
    else
        set -- "$1" "$2" "$3" "$4" "$5" "$2"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    while [ -n "$6" ]; do
        # $7: path to compress, $8: archive name.
        set -- "$1" "$2" "$3" "$4" "$5" "$6" \
            "$(printf '%s\n' "$6" | sed -n '1p')"
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "${7##*/}.$4"

        if [ "$5" = '7z' ]; then
            _echo_info "7z a \"$3/$8\" \"$7\"\n"
            7z a "$3/$8" "$7"
        else
            _echo_info "tar -czvf \"$3/$8\" -C \"$(dirname "$7")\" \"$(basename "$7")\"\n"
            tar -czvf "$3/$8" -C "$(dirname "$7")" "$(basename "$7")"
        fi

        # drop the processed path from the list
        set -- "$1" "$2" "$3" "$4" "$5" \
            "$(printf '%s\n' "$6" | sed -e '1d')"
    done
}

## Extract file based on its extension
##
## @namespace src/shell/files
## @requires dirname realpath tar unzip zip
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
_extract() {
    if [ -z "$1" ]; then _echo_error '_extract: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_extract: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_extract: \"$1\" file not found\n"; return 1; fi
    if [ -n "$2" ] && [ ! -d "$2" ]; then _echo_error "_extract: \"$2\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}"

    # ${1##*.} : This is a parameter expansion expression
    #       ## : Removes the shortest pattern that matches the entire string from the end of the value
    #        * : Matches zero or more characters
    #        . : Matches a literal dot (.)
    if [ "${1##*.}" = gz ]; then
        _check_installed tar

        # extract with tar
        # -x, --extract
        # -v, --verbose
        # -z, --gzip, --gunzip --ungzip
        # -f, --file [ARCHIVE]
        # -C, --directory [DIR] : destination directory
        _echo_info "tar -xvzf \"$1\" -C \"$2\"\n"
        tar -xvzf "$1" -C "$2"

        return 0
    fi

    if [ "${1##*.}" = zip ]; then
        _check_installed unzip

        _echo_info "unzip \"$1\" -d \"$2\"\n"
        unzip "$1" -d "$2"

        return 0
    fi

    _echo_error "Unsupported archive format \"${1##*.}\".\n"
}

## Get file extension
##
## @namespace src/shell/files
## @requires printf
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_file_extension() {
    if [ -z "$1" ]; then _echo_error '_get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_file_extension: too many arguments ($#)\n"; return 1; fi

    # Only the basename takes part in the extension, and a dotfile such
    # as ".bashrc" keeps its whole name.
    set -- "${1##*/}"
    case "$1" in
        *.*) printf '.%s\n' "${1##*.}" ;;
        *) return 1 ;;
    esac
}

## Print the human readable size of a file or folder
##
## @namespace src/shell/files
## @requires du realpath
## @depends src/shell/colors/_echo_error
## @param {path} <SOURCE> (required) The file or folder to measure.
_get_size() {
    if [ -z "$1" ]; then _echo_error '_get_size: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_get_size: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ] && [ ! -d "$1" ]; then
        _echo_error "_get_size: \"$1\" is invalid\n"

        return 1
    fi

    set -- "$(realpath "$1")"

    du -sh "$1"
}

## Move file or folder to destination (creates folder when missing)
##
## @namespace src/shell/files
## @requires cp mkdir mv realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {path} <SOURCE> (required) The path to the input file or folder.
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_move() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_move: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_move: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ] && [ ! -d "$1" ]; then _echo_error "_move: \"$1\" no such file or directory\n"; return 1; fi
    # create destination folder
    if [ ! -d "$2" ]; then _echo_info "mkdir -p \"$2\"\n"; mkdir -p "$2"; fi

    set -- "$(realpath "$1")" "$2"
    if [ -f "$1" ]; then
        _echo_info "mv \"$1\" \"$2\"\n"
        mv "$1" "$2"

        return 0
    fi

    # Refuse a destination that is the source itself or one of its
    # descendants: copying a folder into itself would recurse forever and
    # the source is removed afterwards.
    case "$(realpath "$2")" in
        "$1"|"$1"/*)
            _echo_error "_move: destination \"$2\" is inside source \"$1\"\n"

            return 1
            ;;
    esac

    # `cp -R SOURCE/. DESTINATION`
    # will effectively merge folders when destination exists without leaving dotfiles behind
    # (files in destination will overwriten)
    _echo_info "cp -R \"$1/.\" \"$2\"\n"
    if ! cp -R "$1/." "$2"; then
        _echo_error "_move: could not copy \"$1\" to \"$2\"\n"

        return 1
    fi

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"
}

#--------------------------------------------------
#_ Git
#--------------------------------------------------

## Check if a git blob exists in the repository
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <BLOB_HASH> (required) The git blob hash to check.
## @flag <verbose> [-v] Print the command before execution.
_blob_exists() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_blob_exists\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check blob exists\n'
            _echo_success 'usage:' 2 14; _echo_primary '_blob_exists [blob_hash] -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_blob_exists: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_blob_exists [blob_hash] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_blob_exists: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_blob_exists [blob_hash] -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info "git cat-file -e \"$2^{blob}\"\n"
    fi

    if git cat-file -e "$2^{blob}" 2>/dev/null; then
        printf 'true\n'

        return 0
    fi

    printf 'false\n'
}

## Check if a git branch exists in the local or remote repository
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <BRANCH> (required) The branch name to check.
## @flag <all> [-a] Search all references.
## @flag <remotes> [-r] Search remote branches only.
## @flag <verbose> [-v] Print the command before execution.
_branch_exists() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-a' ]; then
            set -- "$@" '--all'
            shift
        elif [ "$1" = '-r' ]; then
            set -- "$@" '--remotes'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_branch_exists\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check branch exists\n'
            _echo_success 'usage:' 2 14; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: all flag, $2: remotes flag, $3: verbose flag,
    # $4..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--remotes'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--all'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--all' ] || [ "$1" = '--remotes' ] \
            || [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$4" ]; then
        _echo_error '_branch_exists: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 4 ]; then
        _echo_error "_branch_exists: too many arguments ($(( $# - 3 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_branch_exists [branch name] -a (list all) -r (remotes only) -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$3" = 'true' ]; then
        if [ "$1" = 'true' ]; then
            _echo_info "git show-ref --quiet $4 && echo true || echo false\n"
        elif [ "$2" = 'true' ]; then
            _echo_info "git show-ref --verify --quiet refs/remotes/origin/$4 && echo true || echo false\n"
        else
            _echo_info "git show-ref --quiet --heads $4 && echo true || echo false\n"
        fi
    fi

    if [ "$1" = 'true' ]; then
        if git show-ref --quiet "$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    elif [ "$2" = 'true' ]; then
        if git show-ref --verify --quiet \
            "refs/remotes/origin/$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    else
        if git show-ref --quiet --heads "$4" >/dev/null 2>&1; then
            printf 'true\n'

            return 0
        fi
    fi

    printf 'false\n'
}

## Check if a git branch name is valid
##
## Check if a git branch name is valid (alphanumeric, slash, underscore
## and dash characters only).
##
## @namespace src/shell/git
## @requires printf tr
## @param {str} <BRANCH> (required) The branch name to validate.
_check_branch_is_valid() {
    if [ -z "$1" ] \
        || [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '[:alnum:]/_-')" ]; then
        printf 'false\n'
    else
        printf 'true\n'
    fi
}

## Check if a commit hash is valid
##
## @namespace src/shell/git
## @requires grep printf tr
## @param {str} <COMMIT> (required) The commit hash to validate.
_check_commit_is_valid() {
    if [ "$1" = 'HEAD' ]; then
        printf 'true\n'

        return 0
    fi
    if [ "${1#HEAD~}" != "$1" ] \
        && printf '%s' "${1#HEAD~}" | LC_ALL=C grep -q '^[0-9]'; then
        printf 'true\n'

        return 0
    fi
    if [ -z "$1" ] \
        || [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '0-9a-f')" ]; then
        printf 'false\n'

        return 0
    fi

    printf 'true\n'
}

## Check if a git commit exists in the repository
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <COMMIT_HASH> (required) The commit hash to check.
## @flag <verbose> [-v] Print the command before execution.
_commit_exists() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_commit_exists\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check commit exists\n'
            _echo_success 'usage:' 2 14; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_commit_exists: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_commit_exists: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_commit_exists [commit_hash] -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info "git cat-file commit $2 >/dev/null 2>&1 && echo true || echo false\n"
    fi

    if git cat-file commit "$2" >/dev/null 2>&1; then
        printf 'true\n'

        return 0
    fi

    printf 'false\n'
}

## Format a branch subject
##
## Formats a branch subject by removing type prefix, removing ticket
## prefix, converting to lowercase, replacing special characters with
## underscores, and removing trailing underscores.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <SUBJECT> (required) The branch subject to format.
_format_branch_subject() {
    printf '%s' "$1" \
        | tr -s ' ' \
        | sed -e 's/^build\///' \
              -e 's/^chore\///' \
              -e 's/^ci\///' \
              -e 's/^docs\///' \
              -e 's/^feat\///' \
              -e 's/^fix\///' \
              -e 's/^perf\///' \
              -e 's/^refactor\///' \
              -e 's/^style\///' \
              -e 's/^test\///' \
        | sed -e 's/[A-Z]\{1,\}-[0-9]\{1,\}\///' \
        | tr '[:upper:]' '[:lower:]' \
        | sed -e 's/[^a-z0-9_\/-]/_/g' \
        | sed -e 's/_*$//'
}

## Format a commit subject
##
## Formats a commit subject by removing type, scope, ticket, and PR
## number prefixes, then trimming whitespace.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <SUBJECT> (required) The commit subject to format.
_format_commit_subject() {
    printf '%s' "$1" \
        | sed -e 's/^[a-z()_]\{1,\}!\{0,1\}: //' \
        | sed -e 's/([A-Z]\{1,\}-[0-9]\{1,\})//g' \
        | sed -e 's/(#[0-9]\{1,\})//g' \
        | tr -s ' ' \
        | sed -e 's/ *$//'
}

## Format a ticket identifier
##
## Formats a ticket identifier to uppercase, trims whitespace, and
## removes special characters and spaces while preserving dashes and
## underscores.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <TICKET> (required) The ticket identifier to format.
_format_ticket() {
    printf '%s' "$1" \
        | tr '[:lower:]' '[:upper:]' \
        | tr -s ' ' \
        | sed -e 's/[^A-Z0-9_-]//g'
}

## Format a conventional commit type
##
## Formats a conventional commit type to lowercase, trims whitespace,
## replaces special characters and spaces with underscores, and removes
## trailing underscores.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <TYPE> (required) The commit type to format.
_format_type() {
    printf '%s' "$1" \
        | tr '[:upper:]' '[:lower:]' \
        | tr -s ' ' \
        | sed -e 's/[^a-z0-9_-]/_/g' \
        | sed -e 's/_\{1,\}$//'
}

## Get branch subject
##
## Get the subject from the current git branch, removing type and ticket
## from it.
##
## @namespace src/shell/git
## @requires HEAD command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_branch_subject
_get_branch_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    _parse_branch_subject "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

## Get branch ticket
##
## Get the ticket identifier from the current git branch.
##
## @namespace src/shell/git
## @requires HEAD command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_branch_ticket
_get_branch_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    _parse_branch_ticket "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

## Get branch type
##
## Get the conventional type from the current git branch.
##
## @namespace src/shell/git
## @requires HEAD command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_branch_type
_get_branch_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    _parse_branch_type "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}

## Get commit body
##
## Get the commit body from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/strings/_trim
_get_commit_body() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _trim "$(git --no-pager log -1 --pretty="format:%b")"
}

## Get commit pull request
##
## Get the pull request number from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_commit_pull_request
_get_commit_pull_request() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_pull_request "$(git --no-pager log -1 --pretty="format:%s")"
}

## Get commit scope
##
## Get the commit scope from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_commit_scope
_get_commit_scope() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_scope "$(git --no-pager log -1 --pretty="format:%s")"
}

## Get commit subject
##
## Get the commit subject from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_parse_commit_subject
_get_commit_subject() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    # remove type and scope from subject
    _parse_commit_subject "$(git --no-pager log -1 --pretty="format:%s")"
}

## Get commit ticket id
##
## Get the ticket identifier from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_get_branch_ticket
## @depends src/shell/git/_parse_commit_ticket
_get_commit_ticket() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    set -- "$(_get_branch_ticket)"
    if [ -n "$1" ]; then
        printf '%s' "$1"

        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_ticket "$(git --no-pager log -1 --pretty="format:%s")"
}

## Get commit type
##
## Get the commit type from the current HEAD commit.
##
## @namespace src/shell/git
## @requires command git printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/git/_get_branch_type
## @depends src/shell/git/_parse_commit_type
_get_commit_type() {
    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    set -- "$(_get_branch_type)"
    if [ -n "$1" ]; then
        printf '%s' "$1"

        return 0
    fi

    # https://git-scm.com/docs/pretty-formats/2.21.0
    _parse_commit_type "$(git --no-pager log -1 --pretty="format:%s")"
}

## Get the current git branch name
##
## @namespace src/shell/git
## @requires HEAD command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @flag <verbose> [-v] Print the command before execution.
_get_current_branch() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_get_current_branch\n'
            _echo_success 'description:' 2 14; _echo_primary 'Get current branch name\n'
            _echo_success 'usage:' 2 14; _echo_primary '_get_current_branch -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_get_current_branch -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info 'git rev-parse --abbrev-ref HEAD 2>/dev/null\n'
    fi

    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

## Print the web URL of a git remote
##
## Converts the ssh or https URL returned by "git remote get-url" into a
## browsable https URL and removes the trailing ".git" suffix.
##
## @namespace src/shell/git
## @requires git printf
## @depends src/shell/colors/_echo_error
## @param {str} <REMOTE> (default:"origin") The name of the git remote.
_get_git_remote_url() {
    if [ "$#" -gt 1 ]; then _echo_error "_get_git_remote_url: too many arguments ($#)\n"; return 1; fi

    set -- "${1:-origin}"

    if ! git remote get-url "$1" >/dev/null 2>&1; then
        _echo_error "_get_git_remote_url: remote \"$1\" not found\n"

        return 1
    fi

    # $2: repository url.
    set -- "$1" "$(git remote get-url "$1" 2>/dev/null)"

    if [ "${2#git@}" != "$2" ] && [ "${2#*:}" != "$2" ]; then
        # $2: server, $3: repository path.
        set -- "$1" "${2#git@}"
        set -- "$1" "${2%%:*}" "${2#*:}"
        printf 'https://%s/%s\n' "$2" "${3%.git}"
    elif [ "${2#ssh://git@}" != "$2" ]; then
        set -- "$1" "${2#ssh://git@}"
        printf 'https://%s\n' "${2%.git}"
    elif [ "${2#http://}" != "$2" ] || [ "${2#https://}" != "$2" ]; then
        printf '%s\n' "${2%.git}"
    else
        _echo_error "_get_git_remote_url: unsupported url \"$2\"\n"

        return 1
    fi
}

## Get repository latest release version from github
##
## @namespace src/shell/git
## @requires command curl grep sed
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <REPOSITORY> (required) Owner and repository name in the form: owner/repository.
_get_latest_release() {
    if ! command -v curl >/dev/null 2>&1; then
        _echo_danger 'error: curl required, try: "sudo apt-get install -y curl"\n'

        return 1
    fi

    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-h' ]; then
            _echo_warning '_get_latest_release\n'
            _echo_success 'description:' 2 14; _echo_primary 'Get repository latest release\n'
            _echo_success 'usage:' 2 14; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$1" ]; then
        _echo_error '_get_latest_release: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 1 ]; then
        _echo_error "_get_latest_release: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary '_get_latest_release [owner/repository] -h (help)\n'

        return 1
    fi

    curl --silent "https://api.github.com/repos/$1/releases/latest" \
        | grep '"tag_name":' \
        | sed -e 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/' \
        | sed -e 's/^[vV]ersion//' -e 's/^[vV]//'
}

## Get main branch name
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @flag <verbose> [-v] Print the git command before executing it.
_get_main_branch() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_get_main_branch\n'
            _echo_success 'description:' 2 14; _echo_primary 'Get main branch name\n'
            _echo_success 'usage:' 2 14; _echo_primary '_get_main_branch -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_get_main_branch -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info 'git show-ref --heads --quiet main'
        _echo_info ' || git show-ref --quiet refs/remotes/origin/main'
        _echo_info ' || git show-ref --heads --quiet master'
        _echo_info ' || git show-ref --quiet refs/remotes/origin/master\n'
    fi

    if git show-ref --heads --quiet main >/dev/null 2>&1; then
        printf 'main\n'
    elif git show-ref --quiet refs/remotes/origin/main >/dev/null 2>&1; then
        printf 'main\n'
    elif git show-ref --heads --quiet master >/dev/null 2>&1; then
        printf 'master\n'
    elif git show-ref --quiet refs/remotes/origin/master >/dev/null 2>&1; then
        printf 'master\n'
    fi
}

## Update .git/hooks folder
##
## @namespace src/shell/git
## @requires chmod cp git realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {folder} <SOURCE> (required) The source directory.
_git_hooks() {
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_git_hooks: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_git_hooks: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "${1:-.githooks}" ]; then _echo_error "_git_hooks: \"${1:-.githooks}\" folder not found\n"; return 1; fi

    set -- "$(realpath "${1:-.githooks}")" '.git/hooks'

    _echo_info "rm -rf \"$2\"\n"
    rm -rf "$2"

    _echo_info "cp -R \"$1\" \"$2\"\n"
    cp -R "$1" "$2"

    _echo_info "chmod +x \"$2\"/*\n"
    chmod +x "$2"/*
}

## Initialise git submodules
##
## @namespace src/shell/git
## @requires git
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_initialise_submodules() {
    _check_installed git

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi

    _echo_info 'git submodule update --init --recursive\n'
    git submodule update --init --recursive
}

## Check if a git cherry-pick is in progress
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @flag <verbose> [-v] Print the test command before executing it.
_is_cherry_pick_in_progress() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_is_cherry_pick_in_progress\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check cherry-pick is in progress\n'
            _echo_success 'usage:' 2 14; _echo_primary '_is_cherry_pick_in_progress -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_is_cherry_pick_in_progress -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    set -- "$1" "$(git rev-parse --git-dir)/CHERRY_PICK_HEAD"
    if [ "$1" = 'true' ]; then
        _echo_info "test -f \"$2\"\n"
    fi

    if [ -f "$2" ]; then
        printf 'true\n'

        return 0
    fi

    printf 'false\n'
}

## Check if a git rebase is in progress
##
## @namespace src/shell/git
## @requires command git grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @flag <verbose> [-v] Print the test command before executing it.
_is_rebase_in_progress() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_is_rebase_in_progress\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check rebase is in progress\n'
            _echo_success 'usage:' 2 14; _echo_primary '_is_rebase_in_progress -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 1 ]; then
        _echo_danger "error: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_is_rebase_in_progress -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    set -- "$1" \
        "$(git rev-parse --git-dir)/rebase-merge" \
        "$(git rev-parse --git-dir)/rebase-apply"
    if [ "$1" = 'true' ]; then
        _echo_info "test -d \"$2\" || test -d \"$3\"\n"
    fi

    if [ -d "$2" ] || [ -d "$3" ]; then
        printf 'true\n'

        return 0
    fi

    printf 'false\n'
}

## Lists user's GitHub repositories
##
## @namespace src/shell/git
## @requires command curl grep jq printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <OWNER> (required) GitHub owner name.
## @flag <verbose> [-v] Print command before execution.
_list_github() {
    #--------------------------------------------------
    # Check curl installation
    #--------------------------------------------------

    if ! command -v curl >/dev/null 2>&1; then
        _echo_danger 'error: curl required, enter: "sudo apt-get install -y curl" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check jq installation
    #--------------------------------------------------

    if ! command -v jq >/dev/null 2>&1; then
        _echo_danger 'error: jq required, enter: "sudo apt-get install -y jq" to install\n'

        return 1
    fi

    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_list_github\n'
            _echo_success 'description:' 2 14; _echo_primary "Lists user's GitHub repositories\n"
            _echo_success 'usage:' 2 14; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: verbose flag, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$2" ]; then
        _echo_error '_list_github: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_list_github: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_list_github [owner] -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        _echo_info "curl -s \"https://api.github.com/users/$2/repos\" | jq -r '.[].html_url'\n"
    fi

    curl -s "https://api.github.com/users/$2/repos" | jq -r '.[].html_url'
}

## Parse branch subject
##
## Parse the subject from a git branch name, removing type and ticket
## from it, eg: feat/FOO-01/foobar => foobar.
##
## @namespace src/shell/git
## @requires grep printf
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_subject() {
    if [ "${1%%/*}" = 'build' ] \
        || [ "${1%%/*}" = 'chore' ] \
        || [ "${1%%/*}" = 'ci' ] \
        || [ "${1%%/*}" = 'docs' ] \
        || [ "${1%%/*}" = 'feat' ] \
        || [ "${1%%/*}" = 'fix' ] \
        || [ "${1%%/*}" = 'perf' ] \
        || [ "${1%%/*}" = 'refactor' ] \
        || [ "${1%%/*}" = 'style' ] \
        || [ "${1%%/*}" = 'test' ]; then
        set -- "${1#*/}"
    fi

    if printf '%s' "$1" | LC_ALL=C grep -q -x -e '[A-Z].*-[0-9].*/.*'; then
        set -- "${1#*/}"
    fi

    printf '%s' "$1"
}

## Parse branch ticket
##
## Parse the ticket identifier from a git branch name,
## eg: feat/FOO-01/foobar => FOO-01.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_ticket() {
    printf '%s' "$1" | sed -n 's/^.*\/\([A-Z]\{1,\}-[0-9]\{1,\}\)\/.*$/\1/p'
}

## Parse branch type
##
## Parse the conventional type from a git branch name,
## eg: feat/FOO-01/foobar => feat.
##
## @namespace src/shell/git
## @requires printf
## @param {str} <BRANCH> (required) The conventional branch name to parse.
_parse_branch_type() {
    if [ "${1#*/}" = "$1" ]; then

        return 0
    fi

    if [ "${1%%/*}" = 'build' ]; then
        printf 'build'
    elif [ "${1%%/*}" = 'chore' ]; then
        printf 'chore'
    elif [ "${1%%/*}" = 'ci' ]; then
        printf 'ci'
    elif [ "${1%%/*}" = 'docs' ]; then
        printf 'docs'
    elif [ "${1%%/*}" = 'feat' ]; then
        printf 'feat'
    elif [ "${1%%/*}" = 'fix' ]; then
        printf 'fix'
    elif [ "${1%%/*}" = 'perf' ]; then
        printf 'perf'
    elif [ "${1%%/*}" = 'refactor' ]; then
        printf 'refactor'
    elif [ "${1%%/*}" = 'style' ]; then
        printf 'style'
    elif [ "${1%%/*}" = 'test' ]; then
        printf 'test'
    fi
}

## Parse commit pull request number
##
## Parse the pull request number from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) (#4321) => 4321.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_pull_request() {
    printf '%s' "$1" | sed -n 's/.*(#\([0-9]\{1,\}\)).*/\1/p'
}

## Parse commit scope
##
## Parse the commit scope from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => foobar.
##
## @namespace src/shell/git
## @requires awk command printf
## @depends src/shell/colors/_echo_danger
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_scope() {
    # Check awk installation
    if ! command -v awk >/dev/null 2>&1; then
        _echo_danger 'error: awk required, enter: "sudo apt-get install -y awk" to install\n'

        return 1
    fi

    printf '%s' "$1" | awk -F '[^a-z_-]' '/^[a-z()_-]*!?: /{print $2}'
}

## Parse commit subject
##
## Parse the commit subject from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => FooBar.
##
## @namespace src/shell/git
## @requires printf sed tr
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_subject() {
    # remove type, scope, ticket and pull request from subject
    printf '%s' "$1" \
        | sed -e 's/^[a-z()_]\{1,\}!\{0,1\}: //' \
        | sed -e 's/([A-Z]\{1,\}-[0-9]\{1,\})//g' \
        | sed -e 's/(#[0-9]\{1,\})//g' \
        | tr -s ' ' \
        | sed -e 's/ *$//'
}

## Parse commit ticket
##
## Parse the ticket identifier from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => FOO-01.
##
## @namespace src/shell/git
## @requires printf sed
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_ticket() {
    printf '%s' "$1" | sed -n 's/.*(\([A-Z]\{1,\}-[0-9]\{1,\}\)).*/\1/p'
}

## Parse commit type
##
## Parse the commit type from a conventional commit message,
## eg: feat(foobar): FooBar (FOO-01) => feat.
##
## @namespace src/shell/git
## @requires awk printf
## @param {str} <COMMIT_MESSAGE> (required) The conventional commit message to parse.
_parse_commit_type() {
    printf '%s' "$1" | awk -F '[^a-z_]' '/^[a-z()_]*!?: /{print $1}'
}

## Select a branch interactively from a list of git branches
##
## @namespace src/shell/git
## @requires HEAD awk command git grep mktemp printf rm sed true
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/git/_get_main_branch
## @assumes TMPDIR
## @option {str} <FILTER> [-F] Grep filter applied to the branch list.
## @flag <all> [-a] List all branches.
## @flag <current> [-c] Include the current branch.
## @flag <main> [-m] Include the main branch.
## @flag <verbose> [-v] Print the command before execution.
_pick_branch() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-a' ]; then
            set -- "$@" '--all'
            shift
        elif [ "$1" = '-c' ]; then
            set -- "$@" '--current'
            shift
        elif [ "$1" = '-F' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-F" requires value\n'

                return 1
            fi
            set -- "$@" '--filter' "$2"
            shift 2
        elif [ "$1" = '-m' ]; then
            set -- "$@" '--main'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_pick_branch\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a branch among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: filter, $2: all flag, $3: current flag, $4: main flag,
    # $5: verbose flag, $6..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--main'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--current'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--all'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--filter'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--filter$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--all' ] || [ "$1" = '--current' ] \
            || [ "$1" = '--main' ] || [ "$1" = '--verbose' ]; then
            shift
        elif [ "$1" = '--filter' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 5 ]; then
        _echo_danger "error: too many arguments ($(( $# - 5 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_branch -F [file type filter] -a (list all) -m (list main) -c (list current) -v (verbose) -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Collect branches
    #--------------------------------------------------

    # $6: branch file, $7: main branch, $8: current branch.
    __branch_file__=$(mktemp "${TMPDIR:-/tmp}/pick_branch.XXXXXX") \
        || return 1
    set -- "$1" "$2" "$3" "$4" "$5" "$__branch_file__" \
        "$(_get_main_branch)" "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [ -z "$6" ]; then
        _echo_error '_pick_branch: could not create temporary file\n'

        return 1
    fi

    # main branch and current branch always first options
    if [ -n "$7" ] && [ "$8" != "$7" ] && [ "$4" = 'true' ]; then
        printf '%s\n' "$7" >> "$6"
    fi

    if [ "$3" = 'true' ]; then
        printf '%s\n' "$8" >> "$6"
    fi

    # $9: newline separated branch list, $10: display command.
    if [ "$2" = 'true' ]; then
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" \
            "$(git --no-pager branch --all --format='%(refname:short)')" \
            'git --no-pager branch --all'
    else
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" \
            "$(git --no-pager branch --format='%(refname:short)')" \
            'git --no-pager branch'
    fi
    set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" \
        "${10} --format=\"%(refname:short)\""
    if [ -n "$1" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" \
            "${10} | grep $1"
    fi

    if [ "$5" = 'true' ]; then
        _echo_info "${10}\n"
    fi

    if [ -n "$9" ]; then
        if [ -n "$1" ]; then
            printf '%s\n' "$9" | grep "$1" | sed -e 's/^origin\///' \
                | grep -F -v -x -e "$7" -e "$8" -e 'HEAD' >> "$6" || true
        else
            printf '%s\n' "$9" | sed -e 's/^origin\///' \
                | grep -F -v -x -e "$7" -e "$8" -e 'HEAD' >> "$6" || true
        fi
    fi

    if [ ! -s "$6" ]; then
        rm -f "$6"
        _echo_danger 'error: No branches found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$6"
    _echo_success 'Please select branch : \n'

    # $1: branch file, $2: branch count, $3: selection.
    set -- "$6" "$(awk 'END { print NR }' "$6")" 0
    while [ "$3" -lt 1 ] || [ "$3" -gt "$2" ]; do
        set -- "$1" "$2" \
            "$(awk 'NR == 1 { gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }')"
        if [ -z "$3" ]; then
            rm -f "$1"

            return 1
        fi
        if printf '%s' "$3" | grep -q -x -e '[0-9][0-9]*'; then
            :
        else
            set -- "$1" "$2" 0
        fi
    done

    sed -n "$3p" "$1"
    rm -f "$1"
}

## Select a commit interactively from a list of git commits
##
## @namespace src/shell/git
## @requires awk command cut git grep head mktemp printf rm sed true
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @assumes TMPDIR
## @param {str} <BRANCH> The branch to list commits from.
## @option {int} <COUNT> [-n] (default:16) The number of commits to list.
## @flag <verbose> [-v] Print the command before execution.
_pick_commit() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-n' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-n" requires value\n'

                return 1
            fi
            set -- "$@" '--count' "$2"
            shift 2
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_pick_commit\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a commit among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: count, $2: verbose flag, $3..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--count'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--count$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '16' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--verbose' ]; then
            shift
        elif [ "$1" = '--count' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 3 ]; then
        _echo_danger "error: too many arguments ($(( $# - 2 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_commit (branch) -n [count] -v (verbose) -h (help)\n'

        return 1
    fi
    if [ "$#" -lt 3 ]; then
        set -- "$1" "$2" ''
    fi

    #--------------------------------------------------
    # Check git installation
    #--------------------------------------------------

    if ! command -v git >/dev/null 2>&1; then
        _echo_danger 'error: git required, enter: "sudo apt-get install -y git" to install\n'

        return 1
    fi

    #--------------------------------------------------
    # Check git directory
    #--------------------------------------------------

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
        _echo_danger 'error: Not a git repository (or any of the parent directories)\n'

        return 1
    fi

    #--------------------------------------------------
    # Collect commits
    #--------------------------------------------------

    # $4: commit file.
    __commit_file__=$(mktemp "${TMPDIR:-/tmp}/pick_commit.XXXXXX") \
        || return 1
    set -- "$1" "$2" "$3" "$__commit_file__"
    if [ -z "$4" ]; then
        _echo_error '_pick_commit: could not create temporary file\n'

        return 1
    fi

    if [ -z "$3" ]; then
        # lists commits from current branch by default
        if [ "$2" = 'true' ]; then
            _echo_info "git --no-pager log --no-decorate --oneline -n $1\n"
        fi
        git --no-pager log --no-decorate --oneline -n "$1" \
            2>/dev/null > "$4" || true
    else
        if [ "$2" = 'true' ]; then
            _echo_info "git --no-pager log $3 --no-decorate --oneline -n $1\n"
        fi
        git --no-pager log "$3" --no-decorate --oneline \
            -n "$1" -- 2>/dev/null > "$4" || true
    fi

    if [ ! -s "$4" ]; then
        rm -f "$4"
        _echo_danger 'error: No commits found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$4"
    _echo_success 'Please select commit : \n'

    # $1: commit file, $2: commit count, $3: selection.
    set -- "$4" "$(awk 'END { print NR }' "$4")" 0
    while [ "$3" -lt 1 ] || [ "$3" -gt "$2" ]; do
        set -- "$1" "$2" \
            "$(awk 'NR == 1 { gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }')"
        if [ -z "$3" ]; then
            rm -f "$1"

            return 1
        fi
        if printf '%s' "$3" | grep -q -x -e '[0-9][0-9]*'; then
            :
        else
            set -- "$1" "$2" 0
        fi
    done

    # get fully qualified hash
    # $4: selected line, $5: short hash, $6: commit hash.
    set -- "$1" "$2" "$3" "$(sed -n "$3p" "$1")"
    set -- "$1" "$2" "$3" "$4" "${4%% *}"
    set -- "$1" "$2" "$3" "$4" "$5" \
        "$(git --no-pager show -q --no-decorate "$5" \
            | head -n 1 | cut -d' ' -f2)"

    rm -f "$1"
    printf '%s' "$6"
}

## Select a repository interactively from a GitHub user's repositories
##
## @namespace src/shell/git
## @requires awk grep mktemp printf rm sed true
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/git/_list_github
## @assumes TMPDIR
## @param {str} <OWNER> (required) The GitHub user name.
_pick_repository() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-h' ]; then
            _echo_warning '_pick_repository\n'
            _echo_success 'description:' 2 14; _echo_primary 'Select a repository among multiple options\n'
            _echo_success 'usage:' 2 14; _echo_primary '_pick_repository [user_name] -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$1" ]; then
        _echo_error '_pick_repository: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_pick_repository [user_name] -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 1 ]; then
        _echo_error "_pick_repository: too many arguments ($#)\n"
        _echo_success 'usage:' 2 8; _echo_primary '_pick_repository [user_name] -h (help)\n'

        return 1
    fi

    #--------------------------------------------------
    # Collect repositories
    #--------------------------------------------------

    # $2: repository file.
    __repository_file__=$(mktemp "${TMPDIR:-/tmp}/pick_repository.XXXXXX") \
        || return 1
    set -- "$1" "$__repository_file__"
    if [ -z "$2" ]; then
        _echo_error '_pick_repository: could not create temporary file\n'

        return 1
    fi

    _list_github "$1" > "$2" || true

    if [ ! -s "$2" ]; then
        rm -f "$2"
        _echo_danger 'error: No repositories found\n'

        return 1
    fi

    #--------------------------------------------------
    # Prompt user
    #--------------------------------------------------

    awk '{ printf "%d) %s\n", NR, $0 }' "$2"
    _echo_success 'Please select repository : \n'

    # $1: repository file, $2: repository count, $3: selection.
    set -- "$2" "$(awk 'END { print NR }' "$2")" 0
    while [ "$3" -lt 1 ] || [ "$3" -gt "$2" ]; do
        set -- "$1" "$2" \
            "$(awk 'NR == 1 { gsub(/^[ \t]+|[ \t]+$/, ""); print; exit }')"
        if [ -z "$3" ]; then
            rm -f "$1"

            return 1
        fi
        if printf '%s' "$3" | grep -q -x -e '[0-9][0-9]*'; then
            :
        else
            set -- "$1" "$2" 0
        fi
    done

    sed -n "$3p" "$1"
    rm -f "$1"
}

## Print Jira URL
##
## Print the Jira URL for a given ticket identifier.
##
## @namespace src/shell/git
## @requires printf
## @depends src/shell/colors/_echo_error
## @assumes JIRA_SERVER
## @param {str} <TICKET> (required) The Jira ticket identifier (e.g., FOO-123).
_print_jira_url() {
    if [ -z "$1" ]; then _echo_error '_print_jira_url: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_jira_url: too many arguments ($#)\n"; return 1; fi

    printf 'https://%s/browse/%s' "${JIRA_SERVER}" "$1"
}

#--------------------------------------------------
#_ Github
#--------------------------------------------------

## Deploy source folder to "gh-pages"
##
## @namespace src/shell/github
## @requires HEAD git split
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {folder} <SOURCE> (required) The source directory.
_deploy() {
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_deploy: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_deploy: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_deploy: \"$1\" folder not found\n"; return 1; fi

    # `git subtree split --prefix dist main`: create a temporary commit history from the "dist" subdirectory of the "main" branch.
    _echo_info "git push origin \"\$(git subtree split --prefix \"$1\" HEAD)\":refs/heads/gh-pages --force\n"
    git push origin "$(git subtree split --prefix "$1" HEAD)":refs/heads/gh-pages --force
}

##################################################
### Help
##################################################

#--------------------------------------------------
#_ Help
#--------------------------------------------------

## Print help for a shoe script or one of its commands
##
## @namespace src/shell/help
## @requires realpath
## @depends src/shell/colors/_alert_primary
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/help/_print_command_details
## @depends src/shell/help/_print_commands
## @depends src/shell/help/_print_constants
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_infos
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_constants
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_options
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_function_shoedoc
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> The command name to get detailed help for.
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    if [ -z "$2" ]; then
        __padding__=$(_get_padding "$1")
        __annotations__=$(_get_script_shoedoc "$1")

        _alert_primary "$(_get_shoedoc_title "${__annotations__}")"

        _print_infos "$1"
        _print_description "$(_get_shoedoc_description "${__annotations__}")"
        _print_usage "$1"

        if [ -n "$(_get_constants "$1")" ]; then
            _print_constants "$1" "${__padding__}"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            _print_flags "$1" "${__padding__}"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            _print_options "$1" "${__padding__}"
        fi

        _print_commands "$1" "${__padding__}"
        exit 0
    fi

    _alert_primary "$2"
    __annotations__="$(_get_function_shoedoc "$1" "$2")"
    if [ -n "${__annotations__}" ]; then
        _print_command_details "$1" "$2" "${__annotations__}"
        exit 0
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

## Print this help
##
## @namespace src/shell/help
## @depends src/shell/colors/_echo_error
## @depends src/shell/help/_help
## @param {str} <COMMAND_NAME> The command name to print detailed help for.
help() {
    if [ $# -gt 1 ]; then _echo_error "help: too many arguments ($#)\n"; return 1; fi

    _help "$0" "$1"
}

## Print detailed help for a given command
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_warning
## @depends src/shell/help/_print_description
## @depends src/shell/help/_print_flags
## @depends src/shell/help/_print_options
## @depends src/shell/help/_print_usage
## @depends src/shell/reflexion/_get_padding
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @depends src/shell/shoedoc/_get_shoedoc_title
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> (required) The command name to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
_print_command_details() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_print_command_details: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_command_details: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_command_details: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "$3"

    _echo_primary "$(_get_shoedoc_title "$3")\n\n"

    __description__=$(_get_shoedoc_description "$3")
    if [ -n "${__description__}" ]; then
        _print_description "${__description__}"
    fi

    _print_usage "$1" "$2"

    __examples__=$(_get_shoedoc_tag "$3" 'example')
    if [ -n "${__examples__}" ]; then
        _echo_warning 'Examples:\n'
        _echo_primary "${__examples__}\n" 2
        printf '\n'
    fi

    __assumes__=$(_get_shoedoc_tag "$3" 'assumes')
    if [ -n "${__assumes__}" ]; then
        _echo_warning 'Assumes:\n'
        _echo_primary "${__assumes__}\n" 2
        printf '\n'
    fi

    __stdin__=$(_get_shoedoc_tag "$3" 'stdin')
    if [ -n "${__stdin__}" ]; then
        _echo_warning 'Stdin:\n'
        _echo_primary "${__stdin__}\n" 2
        printf '\n'
    fi

    __stdout__=$(_get_shoedoc_tag "$3" 'stdout')
    if [ -n "${__stdout__}" ]; then
        _echo_warning 'Stdout:\n'
        _echo_primary "${__stdout__}\n" 2
        printf '\n'
    fi

    __padding__=$(_get_padding "$1")

    _print_flags "$1" "${__padding__}" "$2"
    _print_options "$1" "${__padding__}" "$2"
}

## List commands of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_warning
## @assumes _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_commands() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_commands: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_commands: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"

    _echo_warning 'Commands:\n'
    awk -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" \
    '/^### /{printf"\n%s%s:%s\n",WARNING,substr($0,5),PRIMARY}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_") # ignore private functions
        printf "%s  %-'"$2"'s %s%s\n",SUCCESS,function_name,PRIMARY,annotation;
    } !/^## */{annotation=""}' "$1"
    printf '\n'

}

## List constants of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_warning
## @assumes _EOL _INFO _PRIMARY _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_constants() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"

    _echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" -v INFO="${_INFO}" -v WARNING="${_WARNING}" -v EOL="${_EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(FIRST,4),INFO,WARNING,$2,INFO,EOL
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0,4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
        } else if (substr($0,1,3) == "## ") {
            if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
        } else {
            FIRST = ""
        }
        PREV = $0
    }' "$1"
    printf '\n'
}

## Print provided text formatted as a description (used by "help" command)
##
## @namespace src/shell/help
## @requires fold printf
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_warning
## @param {str} <DESCRIPTION> (required) A string containing script description.
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

## List flags of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_function_parameters
## @assumes _PRIMARY _SUCCESS
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose flags should be added.
_print_flags() {
    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"

    __separator__=$(printf '\037')
    __global_flags__=$(_get_flags "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_flags__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^flag${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  -%s, --%-'"$2"'s %s%s\n",SUCCESS,substr($1,1,1),$1,PRIMARY,substr(FIRST,4)
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0, 4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
        } else if (substr($0, 1, 3) == "## ") {
            if (substr($0, 1, 4) != "## @" && (FIRST == "" || FIRST == "##")) FIRST = $0
        } else {
            FIRST = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'flag' ]; then
                continue
            fi
            case " ${__global_flags__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __short__="${__short__:-${__name__%"${__name__#?}"}}"
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  -%s, --%-*s' "${__short__}" "$2" "${__long__}")"
            _echo_primary " ${__description__}\n"
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

## Print infos of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @param {file} <FILE_PATH> (required) The path to the input file.
_print_infos() {
    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    __annotations__=$(_get_script_shoedoc "$1")

    _echo_warning 'Infos:\n'
    _echo_success 'author'  2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'author')\n"
    _echo_success 'version' 2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'version')\n"
    _echo_success 'link'    2 8; _echo_primary "$(_get_shoedoc_tag "${__annotations__}" 'link')\n"
    printf '\n'
}

## List options of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk grep printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/reflexion/_get_options
## @assumes _DEFAULT _EOL _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
## @param {str} <COMMAND_NAME> Optional command whose options should be added.
_print_options() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2)) "${3:-}"

    __separator__=$(printf '\037')
    __global_options__=$(_get_options "$1")
    __records__=''
    if [ -n "$3" ]; then
        __records__=$(_get_function_parameters "$1" "$3")
    fi

    if [ -z "${__global_options__}" ]; then
        if ! printf '%s\n' "${__records__}" | grep -q "^option${__separator__}"; then
            return 0
        fi
    fi

    _echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v INFO="${_INFO}" -v DEFAULT="${_DEFAULT}" -v EOL="${_EOL}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (CONSTRAINT == "" && match(FIRST,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(FIRST,RSTART,RLENGTH);
                ANNOTATION=substr(FIRST,4,length(FIRST)-length(CONSTRAINT)-3);
            } else {
                ANNOTATION=substr(FIRST,4);
            }
            if (CONSTRAINT != "") {
                printf "%s  -%s, --%-'"$2"'s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,substr($1,1,1),$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                printf "%s  -%s, --%-'"$2"'s %s%s%s (default: %s%s%s)%s",SUCCESS,substr($1,1,1),$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } {
        # keep the first line of the comment block, it holds the summary
        if ($0 == "##") {
            if (FIRST == "" || FIRST == "##") FIRST = $0
        } else if ($0 ~ /^## @(constant|variable|option|flag)[ \t]/) {
            if (FIRST == "" || FIRST == "##") {
                TITLE = substr($0,4)
                sub(/^@(constant|variable|option|flag)[ \t]+/, "", TITLE)
                sub(/^\{[^}]*\}[ \t]*/, "", TITLE)
                sub(/^<[^>]*>[ \t]*/, "", TITLE)
                sub(/^\[[^]]*\][ \t]*/, "", TITLE)
                sub(/^\/[^\/]+\/[a-z]*[ \t]*/, "", TITLE)
                sub(/^\([^)]*\)[ \t]*/, "", TITLE)
                FIRST = "## " TITLE
            }
            if (CONSTRAINT == "" && match($0, / \/[^\/]+\/[a-z]*/)) {
                CONSTRAINT = " " substr($0, RSTART + 1, RLENGTH - 1)
            }
        } else if (substr($0,1,3) == "## ") {
            if ($0 ~ /^## @constraint([ \t]|$)/) {
                CONSTRAINT=substr($0,4);
                sub(/^@constraint[ \t]*/, "", CONSTRAINT);
                CONSTRAINT=" " CONSTRAINT;
            } else if (substr($0,1,4) != "## @" && (FIRST == "" || FIRST == "##")) {
                FIRST = $0
            }
        } else {
            FIRST = ""
            CONSTRAINT = ""
        }
        PREV = $0
    }' "$1"

    if [ -n "${__records__}" ]; then
        while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
              __long__ __constraint__ __default__ __description__; do
            if [ "${__kind__}" != 'option' ]; then
                continue
            fi
            case " ${__global_options__} " in
                *" ${__name__} "*)
                    continue
                    ;;
            esac
            __short__="${__short__:-${__name__%"${__name__#?}"}}"
            __long__="${__long__:-${__name__}}"
            _echo_success "$(printf '  -%s, --%-*s' "${__short__}" "$2" "${__long__}")"
            _echo_primary "${__description__}"
            if [ -n "${__constraint__}" ]; then
                _echo_success "  ${__constraint__}"
            fi
            if [ -n "${__default__}" ]; then
                _echo_info " (default: ${__default__})"
            fi
            printf '\n'
        done <<EOF
${__records__}
EOF
    fi

    printf '\n'
}

## Print usage of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk basename realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/reflexion/_get_flags
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/reflexion/_get_options
## @assumes _DEFAULT _INFO _SUCCESS _WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <COMMAND_NAME> Optional command whose parameters should be added.
_print_usage() {
    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-}"

    _echo_warning 'Usage:\n'
    if [ -z "$2" ]; then
        _echo_info "sh $(basename "$1") <" 2
        _echo_success 'command'
        _echo_info '> '
    else
        _echo_info "sh $(basename "$1") " 2
        _echo_success "$2"
        _echo_info ' '
    fi
    # options
    awk -F '=' -v INFO="${_INFO}" -v SUCCESS="${_SUCCESS}" -v WARNING="${_WARNING}" -v DEFAULT="${_DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s-%s|--%s%s]%s ",INFO,SUCCESS,substr($1,1,1),$1,INFO,DEFAULT;next}
        printf "%s[%s-%s|--%s %s%s%s]%s ",INFO,SUCCESS,substr($1,1,1),$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0}' "$1"

    if [ -n "$2" ]; then
        __separator__=$(printf '\037')
        __global_parameters__="$(_get_flags "$1") $(_get_options "$1")"
        __records__=$(_get_function_parameters "$1" "$2")

        if [ -n "${__records__}" ]; then
            while IFS="${__separator__}" read -r __kind__ __name__ __short__ \
                  __long__ __constraint__ __default__ __description__; do
                case " ${__global_parameters__} " in
                    *" ${__name__} "*)
                        continue
                        ;;
                esac
                if [ "${__kind__}" = 'param' ]; then
                    _echo_info '<'
                    _echo_success "${__name__}"
                    _echo_info '> '

                    continue
                fi

                __short__="${__short__:-${__name__%"${__name__#?}"}}"
                __long__="${__long__:-${__name__}}"

                _echo_info '['
                _echo_success "-${__short__}|--${__long__}"
                if [ "${__kind__}" = 'option' ]; then
                    if [ -n "${__default__}" ]; then
                        _echo_warning " ${__default__}"
                    else
                        _echo_warning ' VALUE'
                    fi
                fi
                _echo_info '] '
            done <<EOF
${__records__}
EOF
        fi
    fi

    printf '\n\n'
}

#--------------------------------------------------
#_ Hooks
#--------------------------------------------------

## Place here commands you need executed last every time (optional)
##
## @namespace src/shell/hooks
_after() {
    return 0
}

## Place here commands you need executed first every time (optional)
##
## @namespace src/shell/hooks
## @requires awk sed
## @depends src/shell/system/_check_installed
_before() {
    _check_installed awk
    _check_installed sed
}

## Place here commands you need executed by default (optional)
##
## @namespace src/shell/hooks
## @depends src/shell/help/help
_default() {
    help ''
}
##################################################
### Self Install
##################################################

#--------------------------------------------------
#_ Install
#--------------------------------------------------

## Install script via copy
##
## Creates a symbolic link in the /usr/local/bin/ directory
##
## @namespace src/shell/install
## @requires basename cp realpath sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_copy_install() {
    if [ -z "$1" ]; then _echo_error '_copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_copy_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_copy_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    # -a, --archive    same as -dR --preserve=all
    _echo_info "sudo cp -R -p \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp -R -p "$1" "/usr/local/bin/$2"
}

## Generates an autocomplete script for the provided file
##
## This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
## Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
## Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
##
## @namespace src/shell/install
## @requires basename dirname printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/install/_get_comspec
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_autocomplete: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_autocomplete: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _echo_info "printf '#!/bin/bash\\\ncomplete -f -d -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" > \"$(dirname "$1")/$2-completion.sh\"\n"
    printf '#!/bin/bash\ncomplete -f -d -W "%s" "%s"' "$(_get_comspec "$1")" "$2" > "$(dirname "$1")/$2-completion.sh"
}

## Creates a system-wide autocomplete script for the provided file
##
## This function creates a completion script named "<ALIAS>" (where "<ALIAS>" is the basename of the provided file)
## in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.
## It uses sudo for file creation in a system directory, requiring root privileges.
##
## @namespace src/shell/install
## @requires basename printf realpath sudo tee
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/install/_get_comspec
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_global_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_global_autocomplete: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _echo_info "printf '#!/bin/bash\\\ncomplete -W \"%s\" \"%s\"' \"$(_get_comspec "$1")\" \"$2\" | sudo tee \"/etc/bash_completion.d/$2\"\n"
    printf '#!/bin/bash\ncomplete -W "%s" "%s"' "$(_get_comspec "$1")" "$2" | sudo tee "/etc/bash_completion.d/$2"
}

## Generate comspec string for the provided file
##
## @namespace src/shell/install
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_comspec() {
    if [ -z "$1" ]; then _echo_error '_get_comspec: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_comspec: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_comspec: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk '/^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0,1,index($0,"{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s ",FUNCTION,substr(PREV,4)
    } {PREV = $0}' "$1"

    awk -F '=' '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") {
            printf "--%s ",$1
        }
    } {PREV = $0}' "$1"
}

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename bash realpath touch true uname zsh
## @depends src/shell/colors/_echo_error
## @depends src/shell/install/_copy_install
## @depends src/shell/install/_generate_autocomplete
## @depends src/shell/install/_generate_global_autocomplete
## @depends src/shell/install/_set_completion_autoload
## @depends src/shell/install/_symlink_install
## @depends src/shell/system/_is_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_install() {
    if [ -z "$1" ]; then _echo_error '_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_install: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_install: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"

    if [ "$3" = true ]; then
        _copy_install "$1" "$2"
        _generate_global_autocomplete "$1" "$2"
    else
        _symlink_install "$1" "$2"
        _generate_autocomplete "$1" "$2"
    fi

    if _is_installed zsh; then
        # https://superuser.com/questions/886132/where-is-the-zshrc-file-on-mac
        if [ "$(uname)" = 'Darwin' ]; then
            touch ~/.zshrc
        fi
        _set_completion_autoload ~/.zshrc "$1" "$2" || true
    fi

    if _is_installed bash; then
        # set default bash profile
        if [ ! -f ~/.bashrc ] || [ "$(uname)" = 'Darwin' ]; then
            _set_completion_autoload ~/.profile "$1" "$2"
        else
            _set_completion_autoload ~/.bashrc "$1" "$2"
        fi
    fi
}

## Remove completion script autoload
##
## Removes an autoload line for a completion script from a shell rc configuration file
##
## @namespace src/shell/install
## @requires basename realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_sed_i
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_remove_completion_autoload() {
    if [ $# -lt 1 ]; then _echo_error '_remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_completion_autoload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _echo_info "$(_sed_i) \"/^###> $2$/,/^###< $2$/d\" \"$1\"\n"
    $(_sed_i) "/^###> $2$/,/^###< $2$/d" "$1"

    # collapse blank lines
    # The N command reads the next line into the pattern space (the line being processed).
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

## Install script and enable autocompletion
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/install/_install
## @assumes ALIAS global
self_install() {
    _install "$0" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/install/_uninstall
## @assumes ALIAS
self_uninstall() {
    _uninstall "$0" "${ALIAS:-$(basename "$0" .sh)}"
}

## Update script from @update
##
## @namespace src/shell/install
## @requires basename
## @depends src/shell/colors/_echo_danger
## @depends src/shell/install/_update
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @assumes ALIAS global
self_update() {
    _annotations="$(_get_script_shoedoc "$0")"
    _update_link="$(_get_shoedoc_tag "${_annotations}" 'update')"
    if [ -z "${_update_link}" ]; then
        _echo_danger 'cannot update: "@update" missing\n'

        return 1
    fi

    _update "$0" "${_update_link}" "${ALIAS:-$(basename "$0" .sh)}" "${global:-false}"
}

## Adds an autoload line for completion script to a shell configuration file
##
## @namespace src/shell/install
## @requires basename dirname printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_sed_i
## @depends src/shell/strings/_collapse_blank_lines
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {file} <SCRIPT_FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_set_completion_autoload() {
    if [ -z "$1" ]  || [ -z "$2" ]; then _echo_error '_set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_completion_autoload: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_set_completion_autoload: \"$2\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$2" .sh)"}"

    # declare inner function
    __set_completion_autoload() {
        # Synopsis: __set_completion_autoload <SHELL_CONFIG_FILE_PATH> <COMPLETION_FILE_PATH> <ALIAS>
        # remove previous install if any
        $(_sed_i) "/^###> $3$/,/^###< $3$/d" "$1"

        _echo_info "printf '\\\n###> %s\\\nsource %s\\\n###< %s\\\n' \"$3\" \"$2\" \"$3\" >> \"$1\"\n"
        printf '\n###> %s\nsource %s\n###< %s\n' "$3" "$2" "$3" >> "$1"

        _collapse_blank_lines "$1"
    }

    # set global completion file path
    if [ -f "/etc/bash_completion.d/$3" ]; then
        __set_completion_autoload "$1" "/etc/bash_completion.d/$3" "$3"
    fi

    # set completion file path
    if [ -f "$(dirname "$2")/$3-completion.sh" ]; then
        __set_completion_autoload "$1" "$(dirname "$2")/$3-completion.sh" "$3"
    fi
}

## Install script via symlink
##
## @namespace src/shell/install
## @requires basename ln realpath rm sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_symlink_install(){
    if [ -z "$1" ]; then _echo_error '_symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_symlink_install too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_symlink_install \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    if [ -L "/usr/local/bin/$2" ]; then
        _echo_info "sudo rm -f \"/usr/local/bin/$2\"\n"
        if ! sudo rm -f "/usr/local/bin/$2"; then
            _echo_error "_symlink_install: could not remove \"/usr/local/bin/$2\"\n"

            return 1
        fi
    fi

    _echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\"\n"
    if ! sudo ln -s "$1" "/usr/local/bin/$2"; then
        _echo_error "_symlink_install: could not link \"$1\" to \"/usr/local/bin/$2\"\n"

        return 1
    fi
}

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename dirname realpath rm sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/install/_remove_completion_autoload
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_uninstall() {
    if [ -z "$1" ]; then _echo_error '_uninstall: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_uninstall: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_uninstall: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _remove_completion_autoload ~/.zshrc "$2"
    _remove_completion_autoload ~/.bashrc "$2"
    _remove_completion_autoload ~/.profile "$2"

    _echo_info "rm -f \"$(dirname "$1")/$2-completion.sh\"\n"
    rm -f "$(dirname "$1")/$2-completion.sh"

    if [ -f "$1" ]; then
        _echo_info "sudo rm -f \"/usr/local/bin/$2\"\n"
        sudo rm -f "/usr/local/bin/$2"
    fi

    if [ -f "/etc/bash_completion.d/$2" ]; then
        _echo_info "sudo rm -f /etc/bash_completion.d/$2\n"
        sudo rm -f /etc/bash_completion.d/"$2"
    fi
}

## Updates given script from the provided URL
##
## @namespace src/shell/install
## @requires basename chmod curl realpath stat wget
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/install/_install
## @depends src/shell/install/_uninstall
## @depends src/shell/system/_is_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <URL> (required) The URL of the script to download and install.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_update() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_update: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_update: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_update: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}" "${1}.download.$$"

    # Keep the mode of the installed script: the downloaded temporary is
    # created with the default umask.
    __mode__=$(stat -c '%a' "$1" 2>/dev/null || stat -f '%Lp' "$1" 2>/dev/null)

    # Download to a temporary file first: a failed transfer (404, DNS
    # error, interrupted connection) must never overwrite the installed
    # script.
    if _is_installed curl; then
        _echo_info "curl -fsSL \"$2\" > \"$5\"\n"
        if ! curl -fsSL "$2" > "$5"; then
            rm -f "$5"
            _echo_error "_update: could not download \"$2\"\n"

            return 1
        fi

    elif _is_installed wget; then
        _echo_info "wget -qO \"$5\" \"$2\"\n"
        if ! wget -qO "$5" "$2"; then
            rm -f "$5"
            _echo_error "_update: could not download \"$2\"\n"

            return 1
        fi

    else
        _echo_error "\"$0\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
    fi

    if [ ! -s "$5" ]; then
        rm -f "$5"
        _echo_error "_update: downloaded file is empty\n"

        return 1
    fi

    mv "$5" "$1"
    if [ -n "${__mode__}" ]; then
        chmod "${__mode__}" "$1"
    fi

    _uninstall "$1" "$3"
    _install "$1" "$3" "$4"
}

##################################################
### Make
##################################################

#--------------------------------------------------
#_ Make
#--------------------------------------------------

## Generate Makefile for provided shoe script
##
## @namespace src/shell/make
## @requires awk basename cat dirname printf realpath tr
## @depends src/shell/colors/_alert_primary
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_success
## @depends src/shell/shoedoc/_get_script_shoedoc
## @depends src/shell/shoedoc/_get_shoedoc_description
## @depends src/shell/shoedoc/_get_shoedoc_tag
## @depends src/shell/shoedoc/_get_shoedoc_title
## @assumes _ALERT_DANGER _ALERT_DARK _ALERT_INFO _ALERT_LIGHT _ALERT_MUTED _ALERT_PRIMARY _ALERT_SECONDARY _ALERT_SUCCESS _ALERT_WARNING _DANGER _DARK _DEFAULT _EOL _INFO _LIGHT _MUTED _PRIMARY _SECONDARY _SUCCESS _WARNING
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the generated Makefile. Defaults to "<BASENAME>.makefile".
_generate_makefile() {
    if [ -z "$1" ]; then _echo_error '_generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_generate_makefile: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ -n "$2" ] && [ ! -d "$2" ]; then _echo_error "_generate_makefile: \"$2\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"

    # check valid input file type
    case "$1" in
        *.sh) ;;
        *) _echo_error '_generate_makefile: file should be type ".sh"\n'; return 1 ;;
    esac

    _alert_primary "Generating $3"

    __annotations__=$(_get_script_shoedoc "$1")

    cat > "$2/$3" <<EOT
## $(printf '%s' "$(_get_shoedoc_title "${__annotations__}")")
##
## $(printf '%s' "$(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')")
##
## @version $(_get_shoedoc_tag "${__annotations__}" 'version')
## @author  $(_get_shoedoc_tag "${__annotations__}" 'author')
## @license $(_get_shoedoc_tag "${__annotations__}" 'license')
## @link    $(_get_shoedoc_tag "${__annotations__}" 'link')

EOT
    # generate .PHONY
    # shellcheck disable=SC2129
    awk 'BEGIN {printf ".PHONY: help"}
        /^(function *)?[a-zA-Z0-9_]+ *\(\) *\{/ {
        sub("^function ",""); gsub("[ ()]","");
        FUNCTION = substr($0, 1, index($0, "{"));
        sub("{$","",FUNCTION);
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_" && FUNCTION != "help")
        printf " %s", FUNCTION
    } {PREV = $0} END {print "\n"}' "$1" >> "$2/$3"

    cat >> "$2/$3" <<EOT
##################################################
## Colors
##################################################

_PRIMARY   = ${_PRIMARY}
_SECONDARY = ${_SECONDARY}
_SUCCESS   = ${_SUCCESS}
_DANGER    = ${_DANGER}
_WARNING   = ${_WARNING}
_INFO      = ${_INFO}
_MUTED     = ${_MUTED}
_LIGHT     = ${_LIGHT}
_DARK      = ${_DARK}
_DEFAULT   = ${_DEFAULT}
_EOL       = ${_EOL}

_ALERT_PRIMARY   = ${_ALERT_PRIMARY}
_ALERT_SECONDARY = ${_ALERT_SECONDARY}
_ALERT_SUCCESS   = ${_ALERT_SUCCESS}
_ALERT_DANGER    = ${_ALERT_DANGER}
_ALERT_WARNING   = ${_ALERT_WARNING}
_ALERT_INFO      = ${_ALERT_INFO}
_ALERT_MUTED     = ${_ALERT_MUTED}
_ALERT_LIGHT     = ${_ALERT_LIGHT}
_ALERT_DARK      = ${_ALERT_DARK}

##################################################
## Color Functions
##################################################

define _echo_primary
	@printf "\${_PRIMARY}%b\${_EOL}" \$(1)
endef
define _echo_secondary
	@printf "\${_SECONDARY}%b\${_EOL}" \$(1)
endef
define _echo_success
	@printf "\${_SUCCESS}%b\${_EOL}" \$(1)
endef
define _echo_danger
	@printf "\${_DANGER}%b\${_EOL}" \$(1)
endef
define _echo_warning
	@printf "\${_WARNING}%b\${_EOL}" \$(1)
endef
define _echo_info
	@printf "\${_INFO}%b\${_EOL}" \$(1)
endef
define _echo_muted
	@printf "\${_MUTED}%b\${_EOL}" \$(1)
endef
define _echo_light
	@printf "\${_LIGHT}%b\${_EOL}" \$(1)
endef
define _echo_dark
	@printf "\${_DARK}%b\${_EOL}" \$(1)
endef
define _echo_error
	@printf "\${_DANGER}error: %b\${_EOL}" \$(1)
endef

define _alert_primary
	@printf "\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\${_ALERT_PRIMARY} %-63s\${_EOL}\${_ALERT_PRIMARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_secondary
	@printf "\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\${_ALERT_SECONDARY} %-63s\${_EOL}\${_ALERT_SECONDARY}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_success
	@printf "\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\${_ALERT_SUCCESS} %-63s\${_EOL}\${_ALERT_SUCCESS}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_danger
	@printf "\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\${_ALERT_DANGER} %-63s\${_EOL}\${_ALERT_DANGER}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_warning
	@printf "\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\${_ALERT_WARNING} %-63s\${_EOL}\${_ALERT_WARNING}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_info
	@printf "\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\${_ALERT_INFO} %-63s\${_EOL}\${_ALERT_INFO}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_muted
	@printf "\${_EOL}\${_ALERT_MUTED}%64s\${_EOL}\${_ALERT_MUTED} %-63s\${_EOL}\${_ALERT_MUTED}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_light
	@printf "\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\${_ALERT_LIGHT} %-63s\${_EOL}\${_ALERT_LIGHT}%64s\${_EOL}\n" "" \$(1) ""
endef
define _alert_dark
	@printf "\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\${_ALERT_DARK} %-63s\${_EOL}\${_ALERT_DARK}%64s\${_EOL}\n" "" \$(1) ""
endef

##################################################
## Help
##################################################

## Print this help
help:
	\$(call _alert_primary, "$(_get_shoedoc_title "${__annotations__}")")

	@printf "\${_WARNING}Description:\${_EOL}"
	@printf "\${_PRIMARY}  $(_get_shoedoc_description "${__annotations__}" | tr '\n' ' ')\${_EOL}\n"

	@printf "\${_WARNING}Usage:\${_EOL}"
	@printf "\${_PRIMARY}  make [command]\${_EOL}\n"

	@printf "\${_WARNING}Commands:\${_EOL}"
	@awk '/^### /{printf"\n\${_WARNING}%s\${_EOL}",substr(\$\$0,5)} \\
	/^[a-zA-Z0-9_-]+:/{HELP="";if( match(PREV,/^## /))HELP=substr(PREV,4); \\
		printf "\${_SUCCESS}  %-12s  \${_PRIMARY}%s\${_EOL}",substr(\$\$1,0,index(\$\$1,":")-1),HELP \\
	}{PREV=\$\$0}' \${MAKEFILE_LIST}

EOT

    # Reference the script by its path relative to the Makefile so the
    # generated targets run from the folder that holds the Makefile.
    case "$1" in
        "$2"/*) __script_ref__="${1#"$2"/}" ;;
        *)      __script_ref__="$1" ;;
    esac

    # generate rules
    awk -v SHELL_SCRIPT="$__script_ref__" \
    'BEGIN {HR="##################################################\n"}
    /^### /{SECTION=substr($0,5); if (tolower(SECTION) != "help") printf"%s### %s\n%s\n",HR,SECTION,HR}
    /^## /{if (annotation=="") annotation=substr($0,4)}
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {            # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1);  # truncate string at opening round bracket
        sub("^function ","",function_name);          # remove leading "function " if present
        gsub(" +","",function_name);                 # trim whitespaces
        if (annotation!="" && substr($0,1,1) != "_" && function_name != "help") # ignore private functions and help
        printf "## %s\n%s:\n\t@printf \"${_INFO}sh %s %s${_EOL}\"\n\t@sh %s %s\n\n",annotation,function_name,SHELL_SCRIPT,function_name,SHELL_SCRIPT,function_name,function_name
    }
    !/^## */{annotation=""}' "$1" >> "$2/$3"

    printf '\n' >> "$2/$3"

    _echo_success "Makefile generated : \"$2/$3\"\n"
}

## Generate Makefile for current shoe script
##
## @namespace src/shell/make
## @depends src/shell/make/_generate_makefile
generate_makefile() {
    _generate_makefile "$0"
}

#--------------------------------------------------
#_ Network
#--------------------------------------------------

## Print the DNS records of a domain
##
## @namespace src/shell/network
## @requires awk command dig grep printf
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <DOMAIN> (required) The domain to check.
## @option {str} <RECORD_TYPE> [-t] (default:"A") The DNS record type to query.
_check_dns() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-t' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-t" requires value\n'

                return 1
            fi
            set -- "$@" '--type' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_check_dns\n'
            _echo_success 'description:' 2 14; _echo_primary 'Check DNS records\n'
            _echo_success 'usage:' 2 14; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: record type, $2..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--type'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--type$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- 'A' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--type' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    #--------------------------------------------------
    # Check dig installation
    #--------------------------------------------------

    if ! command -v dig >/dev/null 2>&1; then
        _echo_error '_check_dns: dig required, try "sudo apt-get install -y dnsutils"\n'

        return 1
    fi

    if [ -z "$2" ]; then
        _echo_error '_check_dns: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_check_dns: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_check_dns [domain] -t (record type) -h (help)\n'

        return 1
    fi

    _echo_info "dig \"$2\" \"$1\" +nostats +nocomments +nocmd\n"
    dig "$2" "$1" +nostats +nocomments +nocmd
}

## Downloads file with either curl or wget
##
## @namespace src/shell/network
## @requires curl dirname grep head mkdir wget
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_is_installed
## @param {str} <URL> (required) The URL of the file to download.
## @param {file} <FILE_PATH> (required) The path to the output file.
_download() {
    if [ -z "$1" ]; then _echo_error '_download: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_download: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$1" "${2:-"$0"}"
    # create destination folder
    if [ ! -d "$(dirname "$2")" ]; then _echo_info "mkdir -p \"$(dirname "$2")\"\n"; mkdir -p "$(dirname "$2")"; fi

    if _is_installed curl; then
        _echo_info "curl -sSLf \"$1\" -o \"$2\"\n"
        curl -sSLf "$1" -o "$2"

    elif _is_installed wget; then
        _echo_info "wget -q \"$1\" -O \"$2\"\n"
        wget -q "$1" -O "$2"

    else
        _echo_error 'Neither curl nor wget is available for downloading files.\n'

        return 1
    fi

    # Check if the downloaded file is valid (not empty and not an HTML error page)
    if [ ! -s "$2" ] || head -n 1 "$2" | grep -q "<!DOCTYPE html>"; then
        _echo_error 'Downloaded file is invalid or not found.\n'

        return 1
    fi
}

## Print the external IPv4 address of the current connection
##
## Tries curl first and falls back to wget. The icanhazip service is used
## first, then ipify when the first service cannot be reached.
##
## @namespace src/shell/network
## @requires command curl printf wget
## @depends src/shell/colors/_echo_error
_get_external_ip() {
    if [ "$#" -gt 0 ]; then _echo_error "_get_external_ip: too many arguments ($#)\n"; return 1; fi

    if command -v curl >/dev/null 2>&1; then
        set -- "$(curl -fsSL 'https://ipv4.icanhazip.com' \
            || curl -fsSL 'https://api.ipify.org')"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi

        _echo_error '_get_external_ip: could not reach the ip service\n'

        return 1
    fi

    if command -v wget >/dev/null 2>&1; then
        set -- "$(wget -qO- 'https://ipv4.icanhazip.com' \
            || wget -qO- 'https://api.ipify.org')"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi

        _echo_error '_get_external_ip: could not reach the ip service\n'

        return 1
    fi

    _echo_error '_get_external_ip: curl or wget required\n'

    return 1
}

## List the network adapters available on the system
##
## @namespace src/shell/network
## @requires arp command cut grep ifconfig ip iwconfig printf sed sort tr true uniq
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @flag <connected> [-c] Only list adapters with a connected peer.
## @flag <wifi> [-w] Only list wireless adapters.
## @flag <verbose> [-v] Print the command before execution.
_list_adapters() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-c' ]; then
            set -- "$@" '--connected'
            shift
        elif [ "$1" = '-w' ]; then
            set -- "$@" '--wifi'
            shift
        elif [ "$1" = '-v' ]; then
            set -- "$@" '--verbose'
            shift
        elif [ "$1" = '-h' ]; then
            _echo_warning '_list_adapters\n'
            _echo_success 'description:' 2 14; _echo_primary 'List network adapters\n'
            _echo_success 'usage:' 2 14; _echo_primary '_list_adapters -c (connected) -w (wifi) -v (verbose) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: connected flag, $2: wifi flag, $3: verbose flag,
    # $4..: positional parameters.
    if printf '%s\n' "$@" | grep -Fq -x -e '--verbose'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--wifi'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | grep -Fq -x -e '--connected'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--connected' ] || [ "$1" = '--wifi' ] \
            || [ "$1" = '--verbose' ]; then
            shift
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ "$#" -gt 3 ]; then
        _echo_error "_list_adapters: too many arguments ($(( $# - 3 )))\n"

        return 1
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        if ! command -v arp >/dev/null 2>&1; then
            _echo_error '_list_adapters: arp required, try "sudo apt-get install -y net-tools"\n'

            return 1
        fi

        if [ "$2" = 'true' ]; then
            # $4: adapters, $5: display command.
            set -- "$1" "$2" "$3" \
                "$(arp -a \
                    | cut -d' ' -f7 \
                    | uniq \
                    | sort \
                    | sed -n 's/^\(w[[:alnum:]_]*\).*/\1/p' || true)" \
                "arp -a | cut -d' ' -f7 | uniq | sort | sed -n 's/^\(w[[:alnum:]_]*\).*/\1/p'"
        else
            set -- "$1" "$2" "$3" \
                "$(arp -a | cut -d' ' -f7 | uniq | sort)" \
                "arp -a | cut -d' ' -f7 | uniq | sort"
        fi
    elif [ "$2" = 'true' ]; then
        if ! command -v iwconfig >/dev/null 2>&1; then
            _echo_error '_list_adapters: iwconfig required, try "sudo apt-get install -y wireless-tools"\n'

            return 1
        fi

        set -- "$1" "$2" "$3" \
            "$(iwconfig 2>/dev/null \
                | sed -n 's/^\([[:alnum:]_]*\).*/\1/p' | sort || true)" \
            "iwconfig 2>/dev/null | sed -n 's/^\([[:alnum:]_]*\).*/\1/p' | sort"
    elif command -v ip >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" \
            "$(ip token | cut -d' ' -f4 | sort)" \
            "ip token | cut -d' ' -f4 | sort"
    elif command -v ifconfig >/dev/null 2>&1; then
        set -- "$1" "$2" "$3" \
            "$(ifconfig \
                | sed -n 's/^\([[:alnum:]_-]*\).*/\1/p' | sort || true)" \
            "ifconfig | sed -n 's/^\([[:alnum:]_-]*\).*/\1/p' | sort"
    else
        _echo_error '_list_adapters: no network adapter utility found\n'

        return 1
    fi

    set -- "$1" "$2" "$3" \
        "$(printf '%s' "$4" | tr '\n' ' ' | sed -e 's/ *$//')" "$5"

    #--------------------------------------------------
    # Print result
    #--------------------------------------------------

    if [ "$3" = 'true' ]; then
        _echo_info "$5\n"
    fi

    printf '%s\n' "$4"
}

## Open in default browser
##
## @namespace src/shell/network
## @requires nohup
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_open
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
## @param {str} <SCHEME> (default:"http") scheme - e.g. http.
_open_in_default_browser() {
    if [ $# -gt 3 ]; then _echo_error "_open_in_default_browser: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "${1:-127.0.0.1}" "${2:-80}" "${3:-http}"

    _echo_info "nohup \"$(_open)\" \"$3://$1:$2\" >/dev/null 2>&1\n"
    nohup "$(_open)" "$3://$1:$2" >/dev/null 2>&1
}

## Serve given local directory with PHP
##
## @namespace src/shell/network
## @requires php realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {folder} <DOCROOT> (required) The path to the root directory.
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
_php_serve() {
    _check_installed php

    if [ -z "$1" ]; then _echo_error '_php_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_php_serve: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$1" ]; then _echo_error "_php_serve: \"$1\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"

    _echo_info "php -d memory-limit=-1 -S \"$2:$3\" -t \"$1\"\n"
    php -d memory-limit=-1 -S "$2:$3" -t "$1"
}

## Serve given local directory with Python 3
##
## @namespace src/shell/network
## @requires python3 realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {folder} <DOCROOT> (required) The path to the root directory.
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
_py_serve() {
    _check_installed python3

    if [ -z "$1" ]; then _echo_error '_py_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_py_serve: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "$1" ]; then _echo_error "_py_serve: \"$1\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"

    _echo_info "python3 -m http.server --directory \"$1\" --bind \"$2\" \"$3\"\n"
    python3 -m http.server --directory "$1" --bind "$2" "$3"
}

## Remove hostname from the local hosts file
##
## The hostname is matched against every alias of each entry, and the
## hosts file is replaced atomically through a temporary copy.
##
## @namespace src/shell/network
## @requires awk cp mktemp rm sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes HOSTS_FILE TMPDIR
## @param {str} <HOSTNAME> (required) The hostname to unset locally.
_remove_host() {
    if [ -z "$1" ]; then _echo_error '_remove_host: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_remove_host: too many arguments ($#)\n"; return 1; fi

    # Reject characters that could be interpreted by the hosts file
    # parsers or by the shell.
    case "$1" in
        *[!A-Za-z0-9.-]*)
            _echo_error "_remove_host: invalid hostname \"$1\"\n"

            return 1
            ;;
    esac

    set -- "$1" "${HOSTS_FILE:-/etc/hosts}"

    if [ ! -f "$2" ]; then
        _echo_error "_remove_host: \"$2\" file not found\n"

        return 1
    fi

    __tmp__=$(mktemp "${TMPDIR:-/tmp}/remove_host.XXXXXX") || {
        _echo_error '_remove_host: could not create a temporary file\n'

        return 1
    }
    set -- "$1" "$2" "$__tmp__"
    if ! awk -v host="$1" '
        {
            keep = 1
            for (field = 2; field <= NF; field++) {
                if ($field == host) keep = 0
            }
            if (keep) print
        }
    ' "$2" > "$3"; then
        rm -f "$3"
        _echo_error "_remove_host: could not read \"$2\"\n"

        return 1
    fi

    _echo_info "sudo cp \"$3\" \"$2\"\n"
    if ! sudo cp "$3" "$2"; then
        rm -f "$3"
        _echo_error "_remove_host: could not update \"$2\"\n"

        return 1
    fi

    rm -f "$3"
}

## Set new host in the local hosts file
##
## The hostname is validated before use, and the entry is appended
## without going through a nested shell.
##
## @namespace src/shell/network
## @requires printf sudo tee
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/network/_remove_host
## @assumes HOSTS_FILE
## @param {str} <HOSTNAME> (required) The hostname to set locally.
_set_host() {
    if [ -z "$1" ]; then _echo_error '_set_host: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_set_host: too many arguments ($#)\n"; return 1; fi

    case "$1" in
        *[!A-Za-z0-9.-]*)
            _echo_error "_set_host: invalid hostname \"$1\"\n"

            return 1
            ;;
    esac

    _remove_host "$1"

    set -- "$1" "${HOSTS_FILE:-/etc/hosts}"

    _echo_info "printf '127.0.0.1    %s\\n' \"$1\" | sudo tee -a \"$2\"\n"
    if ! printf '127.0.0.1    %s\n' "$1" | sudo tee -a "$2" >/dev/null; then
        _echo_error "_set_host: could not update \"$2\"\n"

        return 1
    fi
}

#--------------------------------------------------
#_ Npm
#--------------------------------------------------

## Build app to destination folder
##
## @namespace src/shell/npm
## @requires npm realpath rm
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_npm_build() {
    _check_installed npm

    if [ -z "$1" ]; then _echo_error '_npm_build: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_npm_build: too many arguments ($#)\n"; return 1; fi
    if [ ! -d "$1" ]; then _echo_error "_npm_build: \"$1\" folder not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"

    _echo_info 'npm run build\n'
    npm run build
}

## Lint source files
##
## @namespace src/shell/npm
## @requires npm
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_npm_lint() {
    _check_installed npm

    _echo_info 'npm run lint\n'
    npm run lint
}

## Run tests
##
## @namespace src/shell/npm
## @requires npm test
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_npm_test() {
    _check_installed npm

    _echo_info 'npm test\n'
    npm test
}

## Watch source folder for changes
##
## @namespace src/shell/npm
## @requires npm watch
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_npm_watch() {
    _check_installed npm

    _echo_info 'npm run watch\n'
    npm run watch
}

#--------------------------------------------------
#_ Prompts
#--------------------------------------------------

## Present user with a list of choices and prompt them to select one
##
## @namespace src/shell/prompts
## @requires cut echo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <CHOICES> (required) Array containing choices.
_select() {
    if [ -z "$1" ]; then _echo_error '_select: some mandatory parameter is missing\n'; return 1; fi

    __item__=0
    for __choice__ in "$@"; do
        __item__=$((__item__ + 1))
        __choices__="${__choices__} ${__item__}"
        _echo_success "$__item__)"; _echo_warning " ${__choice__}\n"
    done

    _echo_success 'Please select your choice : \n'
    __select__=0
    while [ "${__select__}" -gt "$#" ] || [ "${__select__}" -lt 1 ]; do
        # validate selection
        read -r __select__
        for __item__ in ${__choices__}; do
            # find selected item
            if [ "${__item__}" -eq "${__select__}" ]; then
                # break two encapsulation levels
                break 2;
            fi
        done
    done

    echo "$@" | cut -d' ' -f "${__select__}"
}

## Promt user for yes or no
##
## @namespace src/shell/prompts
## @requires echo grep
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {str} <QUESTION> (default:"Confirm ?") A string containing the question.
_yes_no() {
    set -- "${1:-Confirm ?} (yes/no): "

    _echo_success "$1"; _echo_warning "[no] "
    read -r __select__

    if echo "${__select__}" | grep -qi '^[Yy]\(es\)\?$'; then

        return 0
    fi

    return 1
}

#--------------------------------------------------
#_ Reflexion
#--------------------------------------------------

## List constants from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private constants as well.
_get_constants() {
    if [ -z "$1" ]; then _echo_error '_get_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constants: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constants: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    awk -F '=' -v GET_PRIVATE="$2" \
    '/^[A-Z0-9_]+=.+$/ {
        if (GET_PRIVATE == "true") {
            print $1
        } else {
            if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

## Get constaint for given variable from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <VARIABLE_NAME> (required) The variable to validate.
_get_constraint() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_constraint: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_constraint: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    awk -F '=' -v NAME="$2" '
    function trim(value) {
        sub(/^[ \t]+/, "", value)
        sub(/[ \t]+$/, "", value)
        return value
    }

    /^## / {
        body = substr($0, 4)
        if (body ~ /^@constraint([ \t]|$)/) {
            sub(/^@constraint[ \t]*/, "", body)
            CONSTRAINT = trim(body)
        } else if (body ~ /^@(variable|option|constant)[ \t]/) {
            if (match(body, /\/.+\//)) {
                if (CONSTRAINT == "") {
                    CONSTRAINT = substr(body, RSTART, RLENGTH)
                }
            } else if (TITLE == "") {
                TITLE = body
            }
        } else if (TITLE == "" && substr(body, 1, 1) != "@") {
            TITLE = body
        }
        next
    }

    $0 == "##" { next }

    /^[a-zA-Z0-9_]+=.+$/ {
        if ($1 == NAME) {
            if (CONSTRAINT != "") { print CONSTRAINT; exit }
            if (TITLE != "" && match(TITLE, /\/.+\//)) {
                print substr(TITLE, RSTART, RLENGTH); exit
            }
        }
        TITLE = ""
        CONSTRAINT = ""
        next
    }

    { TITLE = ""; CONSTRAINT = "" }
    ' "$1"
}

## List flags from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_flags() {
    if [ -z "$1" ]; then _echo_error '_get_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_flags: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_flags: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk -F '=' '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && substr($0,1,1) != "_") print $1
    } {PREV = $0}' "$1"
}

## Get function by name
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to retrieve.
_get_function() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    awk -v FUNCTION_NAME="$2" '
    function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }
    /^#/ { annotation=annotation"\n"$0 }
    in_function {
        print $0;
        count=count_occurrences($0,"{")-count_occurrences($0,"}");
        # count+=gsub("{","&")-gsub("}","&");
        if (count==0) exit
    }
    /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (function_name==FUNCTION_NAME) {
            if (annotation!="") print substr(annotation,2); # print annotation (without leading "\n")
            print $0;
            in_function=1;
            count=count_occurrences($0,"{")-count_occurrences($0,"}"); # count opened and closed curly braces on current line
            # count=gsub("{","&")-gsub("}","&"); # count opened and closed curly braces on current line
        }
    }
    !/^#/ { annotation="" }' "$1"
}

## List parameters, options and flags declared in a function shoedoc annotation
##
## Outputs one record per entry with fields separated by the ASCII unit
## separator: kind, name, short alias, long alias, constraint, default
## value and description. Parameters are emitted in declaration order, so
## their position is implied by the order of their records.
##
## @namespace src/shell/reflexion
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/shoedoc/_get_function_shoedoc
## @stdout one record per option or flag, fields separated by ASCII 31.
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to inspect.
_get_function_parameters() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_parameters: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_parameters: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_parameters: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    printf '%s\n' "$(_get_function_shoedoc "$1" "$2")" | awk '
        BEGIN {
            separator = sprintf("%c", 31)
        }

        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        function emit(kind, value,    type, name, short, long_name,
                      constraint, default_value, stop, position, aliases,
                      parts, count, i, token) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            default_value = ""

            if (substr(value, 1, 1) == "{") {
                stop = index(value, "}")
                if (stop > 0) {
                    type = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }

            if (substr(value, 1, 1) == "<") {
                stop = index(value, ">")
                if (stop > 0) {
                    name = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }
            if (name == "")
                return

            if (substr(value, 1, 1) == "[") {
                stop = index(value, "]")
                if (stop > 0) {
                    aliases = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                    count = split(aliases, parts, "|")
                    for (i = 1; i <= count; i++) {
                        token = trim(parts[i])
                        if (substr(token, 1, 2) == "--")
                            long_name = substr(token, 3)
                        else if (substr(token, 1, 1) == "-")
                            short = substr(token, 2)
                        else if (long_name == "")
                            long_name = token
                    }
                }
            }

            if ((kind == "option" || kind == "param") \
                && substr(value, 1, 1) == "/") {
                position = index(value, " ")
                if (position == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, position - 1)
                    value = trim(substr(value, position + 1))
                }
            }

            if ((kind == "option" || kind == "param") \
                && substr(value, 1, 1) == "(") {
                stop = index(value, ")")
                if (stop > 0) {
                    token = trim(substr(value, 2, stop - 2))
                    value = trim(substr(value, stop + 1))
                    if (substr(token, 1, 8) == "default:")
                        default_value = substr(token, 9)
                }
            }

            printf "%s%s%s%s%s%s%s%s%s%s%s%s%s\n", kind, separator,
                name, separator, short, separator, long_name, separator,
                constraint, separator, default_value, separator, value
        }

        {
            line = $0
            sub(/^##[ \t]?/, "", line)
            line = trim(line)
            if (line ~ /^@param[ \t]/) {
                sub(/^@param[ \t]+/, "", line)
                emit("param", line)
            } else if (line ~ /^@option[ \t]/) {
                sub(/^@option[ \t]+/, "", line)
                emit("option", line)
            } else if (line ~ /^@flag[ \t]/) {
                sub(/^@flag[ \t]+/, "", line)
                emit("flag", line)
            }
        }
    '
}

## List functions names from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", retrieves private functions as well.
_get_functions_names() {
    if [ -z "$1" ]; then _echo_error '_get_functions_names: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_functions_names: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    # this regular expression matches functions with either bash or sh syntax
    awk -v GET_PRIVATE="$2" \
    '/^(function +)?[a-zA-Z0-9_]+ *\(\)/ {          # matches a function (ignoring curly braces)
        function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
        sub("^function ","",function_name);         # remove leading "function " if present
        gsub(" +","",function_name);                # trim whitespaces
        if (GET_PRIVATE == "true") {
            print function_name
        } else {
            if (substr($0,1,1) != "_") print function_name
        }
    } {PREV = $0}' "$1"
}

## List options from provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {bool} <GET_PRIVATE_ONLY> (default:false) If set to "true", retrieves private options only.
_get_options() {
    if [ -z "$1" ]; then _echo_error '_get_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_options: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_options: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"

    awk -F '=' -v GET_PRIVATE_ONLY="$2" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (GET_PRIVATE_ONLY == "true") {
            if ($1 != toupper($1) && $2 != "false" && substr($1,1,1) == "_") print $1
        } else {
            if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($1,1,1) != "_") print $1
        }
    } {PREV = $0}' "$1"
}

## Guess padding length from longest constant, option, flag or command of the provided shoe script
##
## @namespace src/shell/reflexion
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_padding() {
    if [ -z "$1" ]; then _echo_error '_get_padding: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_padding: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_padding: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk -F '=' '
        /^[a-zA-Z0-9_]+=.+$/ { MATCH=$1 }       # matches constants, options and flags
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {   # matches a function (ignoring curly braces)
            MATCH=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
            sub("^function ","",MATCH);         # remove leading "function " if present
            gsub(" +","",MATCH);                # trim whitespaces
        } { if (substr(PREV,1,3) == "## " && substr(MATCH,1,1) != "_" && length(MATCH) > LENGTH) LENGTH = length(MATCH) }
        {PREV = $0} END {print LENGTH}
    ' "$1"
}

## Get value for given parameter from provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires realpath sed
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_get_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_get_parameter: \"$1\" file not found\n"; return 1; fi

    # The key is interpolated into a sed pattern: reject anything that is
    # not a shell identifier first.
    if [ -z "$2" ] \
        || [ "$2" != "${2#[!A-Za-z_]}" ] \
        || [ "$2" != "${2#*[!A-Za-z0-9_]*}" ]; then
        _echo_error "_get_parameter: invalid parameter name \"$2\"\n"

        return 1
    fi

    set -- "$(realpath "$1")" "$2"
    sed -n "s/^$2=\(.*\)/\1/p" "$1" | sed 's/^"//; s/"$//' # remove leading and trailing quotes
}

## Tests if parameter exists in provided ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires grep realpath
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
_has_parameter() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_has_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_has_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_has_parameter: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    grep -q "^${2}=" "$1"
}

## Print function synopsis from shoedoc annotations
##
## @namespace src/shell/reflexion
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <FUNCTION_NAME> (required) The name of the function to document.
## @param {str} <ANNOTATIONS> (required) The shoedoc annotation block, classic @-tags.
## @param {bool} <MARKDOWN_FORMAT> (default:false) If set to "true", returns result as markdown.
_print_synopsis() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_print_synopsis: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "${3:-false}"

    #--------------------------------------------------
    # Classic @-tag annotations
    #--------------------------------------------------

    printf '%s' "$2" | awk -v NAME="$1" -v MARKDOWN="$3" '
        function trim(value) {
            sub(/^[ \t]+/, "", value)
            sub(/[ \t]+$/, "", value)
            return value
        }

        function add_words(target, value,    count, words, i) {
            count = split(value, words, /[ \t]+/)
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (target == "requires")
                    requires = requires (requires == "" ? "" : " ") words[i]
                else
                    depends = depends (depends == "" ? "" : " ") words[i]
            }
        }

        function add_entry(kind, value,    type, name, short, long_name,
                           constraint, required, has_default, default_value,
                           summary, description, stop, position, aliases,
                           parts, count, i, token, marker) {
            value = trim(value)
            type = ""
            name = ""
            short = ""
            long_name = ""
            constraint = ""
            required = 0
            has_default = 0
            default_value = ""
            summary = ""
            description = ""

            if (substr(value, 1, 1) == "{") {
                stop = index(value, "}")
                if (stop > 0) {
                    type = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }

            if (substr(value, 1, 1) == "<") {
                stop = index(value, ">")
                if (stop > 0) {
                    name = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                }
            }
            if (name == "")
                return

            if (substr(value, 1, 1) == "[") {
                stop = index(value, "]")
                if (stop > 0) {
                    aliases = substr(value, 2, stop - 2)
                    value = trim(substr(value, stop + 1))
                    count = split(aliases, parts, "|")
                    for (i = 1; i <= count && i <= 2; i++) {
                        token = trim(parts[i])
                        if (substr(token, 1, 2) == "--")
                            long_name = substr(token, 3)
                        else if (substr(token, 1, 1) == "-")
                            short = substr(token, 2)
                        else if (long_name == "")
                            long_name = token
                    }
                }
            }

            if (substr(value, 1, 1) == "/") {
                position = index(value, " ")
                if (position == 0) {
                    constraint = value
                    value = ""
                } else {
                    constraint = substr(value, 1, position - 1)
                    value = trim(substr(value, position + 1))
                }
            }

            if (substr(value, 1, 1) == "(") {
                stop = index(value, ")")
                if (stop > 0) {
                    marker = trim(substr(value, 2, stop - 2))
                    value = trim(substr(value, stop + 1))
                    if (marker == "required")
                        required = 1
                    else if (substr(marker, 1, 8) == "default:") {
                        has_default = 1
                        default_value = substr(marker, 9)
                    }
                }
            }

            position = index(value, " - ")
            if (position > 0) {
                summary = trim(substr(value, 1, position - 1))
                description = trim(substr(value, position + 3))
            } else {
                description = value
            }
            if (summary != "")
                value = summary " - " description
            else
                value = description

            entry_count++
            entry_kind[entry_count] = kind
            entry_name[entry_count] = name
            entry_type[entry_count] = type
            entry_short[entry_count] = short
            entry_long[entry_count] = long_name
            entry_constraint[entry_count] = constraint
            entry_required[entry_count] = required
            entry_has_default[entry_count] = has_default
            entry_default[entry_count] = default_value
            entry_text[entry_count] = value
        }

        function alias_list(i,    result) {
            result = ""
            if (entry_short[i] != "")
                result = "-" entry_short[i]
            if (entry_long[i] != "") {
                if (result != "")
                    result = result "|"
                result = result "--" entry_long[i]
            }
            if (result == "")
                result = "--" entry_name[i]
            return result
        }

        function signature(i) {
            if (entry_kind[i] == "param") {
                if (entry_required[i])
                    return "<" entry_name[i] ">"
                return "[" entry_name[i] "]"
            }
            if (entry_kind[i] == "option")
                return "[" alias_list(i) " VALUE]"
            return "[" alias_list(i) "]"
        }

        function plain_label(i) {
            if (entry_kind[i] == "param")
                return entry_name[i]
            return alias_list(i)
        }

        function markdown_label(i,    result) {
            if (entry_kind[i] == "param")
                return "`" entry_name[i] "`"
            result = ""
            if (entry_short[i] != "")
                result = "`-" entry_short[i] "`"
            if (entry_long[i] != "") {
                if (result != "")
                    result = result ", "
                result = result "`--" entry_long[i] "`"
            }
            if (result == "")
                result = "`--" entry_name[i] "`"
            return result
        }

        function quote_default(value,    result) {
            result = value
            if (length(result) >= 2 &&
                substr(result, 1, 1) == "\"" &&
                substr(result, length(result), 1) == "\"")
                result = substr(result, 2, length(result) - 2)
            return "\"" result "\""
        }

        function detail(i, markdown,    result, value) {
            result = ""
            if (entry_kind[i] != "flag" && entry_type[i] != "") {
                if (markdown)
                    result = result "_(type: \"" entry_type[i] "\")_ "
                else
                    result = result "(" entry_type[i] ") "
            }
            if (entry_kind[i] == "param" && !entry_required[i])
                result = result "(optional) "
            if (entry_text[i] != "")
                result = result entry_text[i] " "
            if (entry_constraint[i] != "") {
                if (markdown)
                    result = result "_Constraint: `" entry_constraint[i] "`._ "
                else
                    result = result "Constraint: " entry_constraint[i] ". "
            }
            if (entry_kind[i] != "flag" && entry_has_default[i]) {
                value = quote_default(entry_default[i])
                if (markdown)
                    result = result "_Defaults to " value "._ "
                else
                    result = result "Defaults to " value ". "
            }
            return trim(result)
        }

        function word_list(value, markdown,    count, words, i, result) {
            count = split(value, words, " ")
            result = ""
            for (i = 1; i <= count; i++) {
                if (words[i] == "")
                    continue
                if (result != "")
                    result = result ", "
                result = result (markdown ? "`" words[i] "`" : words[i])
            }
            return result
        }

        {
            line = $0
            sub(/^[ \t]*#+[ \t]?/, "", line)
            line = trim(line)
            if (line == "")
                next
            split(line, tokens, /[ \t]+/)
            tag = tokens[1]
            value = trim(substr(line, length(tag) + 1))
            if (tag == "@requires") {
                add_words("requires", value)
                next
            }
            if (tag == "@depends") {
                add_words("depends", value)
                next
            }
            if (tag == "@private") {
                private_flag = 1
                next
            }
            if (tag == "@public") {
                private_flag = 0
                next
            }
            if (tag == "@param") {
                add_entry("param", value)
                next
            }
            if (tag == "@option") {
                add_entry("option", value)
                next
            }
            if (tag == "@flag") {
                add_entry("flag", value)
            }
        }

        END {
            if (substr(NAME, 1, 1) == "_")
                private_flag = 1
            if (MARKDOWN == "true") {
                printf "> Synopsis:\n> `%s", NAME
                for (i = 1; i <= entry_count; i++)
                    printf " %s", signature(i)
                printf "`\n"
                details = ""
                for (i = 1; i <= entry_count; i++) {
                    line = detail(i, 1)
                    if (details != "")
                        details = details "\n"
                    if (line != "")
                        details = details "- " markdown_label(i) ": " line
                    else
                        details = details "- " markdown_label(i) ":"
                }
                if (details != "")
                    printf "%s\n\n", details
                if (requires != "")
                    printf "- ⚠️ Requires: %s\n", word_list(requires, 1)
                if (depends != "")
                    printf "- 🔗 Depends: %s\n", word_list(depends, 1)
                printf "\n"
                exit
            }
            scope = private_flag ? "private" : "public"
            printf "Synopsis: %s (%s)", NAME, scope
            for (i = 1; i <= entry_count; i++)
                printf " %s", signature(i)
            printf "\n"
            for (i = 1; i <= entry_count; i++) {
                line = detail(i, 0)
                if (line != "")
                    printf "    %s: %s\n", plain_label(i), line
                else
                    printf "    %s:\n", plain_label(i)
            }
            if (requires != "")
                printf "    Requires: %s\n", word_list(requires, 0)
            if (depends != "")
                printf "    Depends: %s\n", word_list(depends, 0)
            printf "\n"
        }
    '
}

## Set a variable in a ".env" or ".sh" file
##
## Replaces the value when the variable exists or fails.
## when the variable does not exist, and the FORCE parameter is "true", 
## appends a new assignment at the end of the file.
##
## @namespace src/shell/env
## @requires awk chmod dirname grep mktemp mv rm stat
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The ".env" file to update.
## @param {str} <KEY> (required) The variable name to set.
## @param {str} <VALUE> (required) The value to assign.
## @param {bool} <FORCE> (default:false) Append the variable when missing.
_set_parameter() {
    if [ $# -lt 3 ]; then _echo_error '_set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_set_parameter: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$2" "$3" "${4:-false}"

    if [ ! -f "$1" ]; then
        _echo_error "_set_parameter: \"$1\" file not found\n"

        return 1
    fi

    # A parameter name is an identifier: a letter or "_" followed by
    # letters, digits or "_" (the expansions below only differ when a
    # character falls outside those classes)
    if [ -z "$2" ] \
        || [ "$2" != "${2#[!A-Za-z_]}" ] \
        || [ "$2" != "${2#*[!A-Za-z0-9_]*}" ]; then
        _echo_error "_set_parameter: invalid parameter name \"$2\"\n"

        return 1
    fi

    if [ "$4" != 'true' ] && ! grep -q "^$2=" "$1"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    # Values are handed over through the environment because, unlike "-v",
    # awk does not interpret backslash escapes in ENVIRON values.
    # The template keeps mktemp portable to BusyBox.
    __tmp__=$(mktemp "$(dirname "$1")/.set_parameter.XXXXXX") || return 1
    if ! __KEY__="$2" __VALUE__="$3" __FORCE__="$4" awk '
        BEGIN { key = ENVIRON["__KEY__"]; value = ENVIRON["__VALUE__"]; found = 0 }
        index($0, key "=") == 1 { print key "=" value; found = 1; next }
        { print }
        END { if (!found && ENVIRON["__FORCE__"] == "true") print key "=" value }
    ' "$1" > "$__tmp__"; then
        rm -f "$__tmp__"
        _echo_error "_set_parameter: could not update \"$1\"\n"

        return 1
    fi

    # Replace the target atomically, restoring the original mode. The
    # numeric form is accepted by both GNU and BSD stat.
    if ! __mode__=$(stat -c '%a' "$1" 2>/dev/null); then
        __mode__=$(stat -f '%Lp' "$1" 2>/dev/null)
    fi
    if ! mv "$__tmp__" "$1"; then
        rm -f "$__tmp__"
        _echo_error "_set_parameter: could not replace \"$1\"\n"

        return 1
    fi
    if [ -n "${__mode__}" ]; then
        chmod "$__mode__" "$1"
    fi
}

#--------------------------------------------------
#_ Shoedoc
#--------------------------------------------------

## Get function shedoc annotation by name
##
## @namespace src/shell/shoedoc
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to retrieve.
_get_function_shoedoc() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_function_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_function_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_function_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    awk -v FUNCTION_NAME="$2" '
        /^##/ { annotation=annotation$0"\n" }                   # concatenates annotations
        /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {                   # matches a function (ignoring curly braces)
            function_name=substr($0,1,index($0,"(")-1);         # truncate string at opening round bracket
            sub("^function ","",function_name);                 # remove leading "function " if present
            gsub(" +","",function_name);                        # trim whitespaces
            if (function_name==FUNCTION_NAME) print annotation; # print annotation
        }
        !/^##/ { annotation="" }
    ' "$1"
}

## Get top-level shoedoc annotation of the provided shoe script file
##
## @namespace src/shell/shoedoc
## @requires awk realpath
## @depends src/shell/colors/_echo_error
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
_get_script_shoedoc() {
    if [ -z "$1" ]; then _echo_error '_get_script_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_script_shoedoc: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    awk '
        /^##/ { annotation=annotation$0"\n" }
        !/^##/ {
            if (annotation != "") {
                if ($0 == "") {
                    print annotation
                }
                exit
            }
        }
    ' "$1"
}

## Get shoedoc annotation
##
## Removes every line that does not start with a pound character or contains a tag
## Returns string without leading pound characters
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT
        }
    }'
}

## Get shoedoc description
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc_description() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc_description: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_description: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            count+=1;
            if (count==2 && RESULT=="") next;
            if (count>1) print RESULT
        }
    }'
}

## Return given tag values from shoedoc annotation
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
## @param {str} <TAG_NAME> (required) The name of tag to return.
_get_shoedoc_tag() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_get_shoedoc_tag: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_get_shoedoc_tag: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk -v TAG="$2" '/^## .*/ {
        if ($2=="@"TAG) {
            gsub(" +"," "); sub("^ +",""); sub(" +$",""); # trim input
            RESULT=substr($0,length($1)+length($2)+3);    # remove leading pound character(s)
            print RESULT
        }
    }'
}

## Get shoedoc title
##
## Returns the first line that does not contain a tag
##
## @namespace src/shell/shoedoc
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <TEXT> (required) The input shoedoc annotation bloc.
_get_shoedoc_title() {
    if [ -z "$1" ]; then _echo_error '_get_shoedoc_title: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_shoedoc_title: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | awk '/^## .*/ {
        if (substr($2,1,1) != "@") {
            RESULT=substr($0,length($1)+2); # remove leading pound character(s)
            print RESULT; exit
        }
    }'
}

#--------------------------------------------------
#_ SSH
#--------------------------------------------------

## Set the expected permissions on the ~/.ssh folder
##
## The folder is set to 700, private keys to 600 and public keys to 644.
## Configuration files such as authorized_keys, config and known_hosts are
## set to 644.
##
## @namespace src/shell/ssh
## @requires chmod chown find
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @assumes HOME USER
_config_ssh_file_permissions() {
    if [ "$#" -gt 0 ]; then _echo_error "_config_ssh_file_permissions: too many arguments ($#)\n"; return 1; fi

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_error "_config_ssh_file_permissions: \"${HOME}/.ssh\" folder not found\n"

        return 1
    fi

    # correct ssh permissions
    _echo_info "chown \"${USER}\":\"${USER}\" -R \"${HOME}/.ssh\"\n"
    chown "${USER}:${USER}" -R "${HOME}/.ssh"

    # the .ssh directory should be 700 (drwx------)
    _echo_info "chmod 700 \"${HOME}/.ssh\"\n"
    chmod 700 "${HOME}/.ssh"

    # private keys should be 600 (-rw-------)
    # only apply this to regular files, never to directories or sockets
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f ! -name '*.pub' -exec chmod 600 {} +

    # public keys (.pub) should be 644 (-rw-r--r--)
    _echo_info "find \"${HOME}/.ssh\" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +\n"
    find "${HOME}/.ssh" -maxdepth 1 -type f -name '*.pub' -exec chmod 644 {} +

    # authorized_keys, config and known_hosts should be 644 as well
    set -- authorized_keys config known_hosts
    while [ "$#" -gt 0 ]; do
        if [ -f "${HOME}/.ssh/$1" ]; then
            _echo_info "chmod 644 \"${HOME}/.ssh/$1\"\n"
            chmod 644 "${HOME}/.ssh/$1"
        fi
        shift
    done
}

## Check if the current ssh agent is gcr-ssh-agent
##
## gcr-ssh-agent is usually exposed as ${XDG_RUNTIME_DIR}/gcr/ssh.
##
## @namespace src/shell/ssh
## @assumes SSH_AUTH_SOCK
_is_gcr_ssh_agent() {
    if [ "${SSH_AUTH_SOCK%*/gcr/ssh}" != "${SSH_AUTH_SOCK}" ]; then
        return 0
    fi

    return 1
}

## Check if an ssh agent is running
##
## The socket advertised through SSH_AUTH_SOCK is used by default. ssh-add
## exits 0 when identities are loaded and 1 when the agent is reachable but
## has no identities. Exit status 2 means no agent is reachable.
##
## @namespace src/shell/ssh
## @requires ssh-add
## @depends src/shell/colors/_echo_error
## @assumes SSH_AUTH_SOCK
## @param {str} <SOCKET> (default:"$SSH_AUTH_SOCK") The ssh agent socket path.
_is_ssh_agent_running() {
    if [ "$#" -gt 1 ]; then _echo_error "_is_ssh_agent_running: too many arguments ($#)\n"; return 1; fi

    set -- "${1:-${SSH_AUTH_SOCK}}"

    # `-S`: returns true when the path exists and is a Unix domain socket
    if [ -z "$1" ] || [ ! -S "$1" ]; then

        return 1
    fi

    SSH_AUTH_SOCK="$1" ssh-add -l >/dev/null 2>&1
    set -- "$1" "$?"

    # 0: identities loaded, 1: agent reachable without identities
    if [ "$2" -eq 0 ] || [ "$2" -eq 1 ]; then
        return 0
    fi

    return 1
}

## List the identities loaded in the ssh agent
##
## @namespace src/shell/ssh
## @requires command ssh-add
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
_list_ssh_identities() {
    if [ $# -gt 0 ]; then _echo_error "_list_ssh_identities: too many arguments ($#)\n"; return 1; fi

    if ! command -v ssh-add >/dev/null 2>&1; then
        _echo_error '_list_ssh_identities: ssh-add required\n'

        return 1
    fi

    _echo_info 'ssh-add -l\n'
    ssh-add -l
}

## Add every ssh identity found in ~/.ssh to the ssh agent
##
## Each public key ending with ".pub" must have a matching private key in
## the same folder.
##
## @namespace src/shell/ssh
## @requires command find printf sed ssh-add
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_warning
## @assumes HOME
_ssh_add_all_identities() {
    if [ "$#" -gt 0 ]; then _echo_error "_ssh_add_all_identities: too many arguments ($#)\n"; return 1; fi

    if ! command -v ssh-add >/dev/null 2>&1; then
        _echo_error '_ssh_add_all_identities: ssh-add required\n'

        return 1
    fi

    if [ -z "${HOME}" ]; then
        _echo_error '_ssh_add_all_identities: HOME is not set\n'

        return 1
    fi

    if [ ! -d "${HOME}/.ssh" ]; then
        _echo_error "_ssh_add_all_identities: \"${HOME}/.ssh\" folder not found\n"

        return 1
    fi

    # $1: newline separated list of public keys left to process.
    set -- "$(find "${HOME}/.ssh" -type f -name '*.pub')"
    while [ -n "$1" ]; do
        # $2: public key path, $3: matching private key path.
        set -- "$1" "$(printf '%s\n' "$1" | sed -n '1p')"
        set -- "$1" "$2" "${2%.pub}"

        if [ ! -f "$3" ]; then
            _echo_warning "error: \"$3\" private key not found\n"
        else
            _echo_info "ssh-add \"$3\"\n"
            ssh-add "$3"
        fi

        # drop the processed public key from the list
        set -- "$(printf '%s\n' "$1" | sed -e '1d')"
    done
}

#--------------------------------------------------
#_ Strings
#--------------------------------------------------

## Collapse blank lines with "sed"
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_sed_i
## @param {file} <FILE_PATH> (required) The path to the input file.
_collapse_blank_lines() {
    if [ -z "$1" ]; then _echo_error '_collapse_blank_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_collapse_blank_lines: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_collapse_blank_lines: \"$1\" file not found\n"; return 1; fi
    set -- "$(realpath "$1")"

    # The N command reads the next line into the pattern space.
    # The remaining expression checks if the pattern space now consists of two empty lines (^\n$).
    _echo_info "$(_sed_i) '/^$/{N;s/^\\\n$//;}' \"$1\"\n"
    $(_sed_i) '/^$/{N;s/^\n$//;}' "$1"
}

## Decode a base64 string
##
## @namespace src/shell/strings
## @requires base64 command printf
## @depends src/shell/colors/_echo_error
## @param {str} <STRING> (required) The base64 string to decode.
_decode_base64() {
    if [ -z "$1" ]; then _echo_error '_decode_base64: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_decode_base64: too many arguments ($#)\n"; return 1; fi

    if ! command -v base64 >/dev/null 2>&1; then
        _echo_error '_decode_base64: base64 required\n'

        return 1
    fi

    printf '%s' "$1" | base64 --decode
}

## Remove every line in target file that contains substrings from source file
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_sed_i
## @param {file} <SOURCE_PATH> (required) The path to the file containing the substrings to remove.
## @param {file} <TARGET_PATH> (required) The path to the target file to deduplicate.
_dedupe_lines() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_dedupe_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_dedupe_lines: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_dedupe_lines: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_dedupe_lines: \"$2\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$(realpath "$2")"

    while read -r __substring__; do
        _echo_info "$(_sed_i) \"/${__substring__}/d\" \"$2\"\n"
        $(_sed_i) "/${__substring__}/d" "$2"
    done < "$1"
}

## Encode a string to base64
##
## @namespace src/shell/strings
## @requires base64 command printf
## @depends src/shell/colors/_echo_error
## @param {str} <STRING> (required) The string to encode.
_encode_base64() {
    if [ -z "$1" ]; then _echo_error '_encode_base64: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_encode_base64: too many arguments ($#)\n"; return 1; fi

    if ! command -v base64 >/dev/null 2>&1; then
        _echo_error '_encode_base64: base64 required\n'

        return 1
    fi

    printf '%s' "$1" | base64
}

## Generate random 32 bit string
##
## @namespace src/shell/strings
## @requires openssl
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_generate_key() {
    _check_installed openssl

    _echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
}

## Generate a random alphanumeric string
##
## @namespace src/shell/strings
## @requires cut od printf tr
## @depends src/shell/colors/_echo_error
## @param {int} <LENGTH> (required) The length of the generated string.
_generate_random_string() {
    if [ -z "$1" ]; then _echo_error '_generate_random_string: some mandatory parameter is missing\n'; return 1; fi
    if [ "$#" -gt 1 ]; then _echo_error "_generate_random_string: too many arguments ($#)\n"; return 1; fi

    if [ -n "$(printf '%s' "$1" | LC_ALL=C tr -d '0-9')" ] \
        || [ "${1#0}" != "$1" ]; then
        _echo_error '_generate_random_string: length should be a positive integer\n'

        return 1
    fi

    # Read a bounded number of random bytes and keep the first characters
    # of their hexadecimal representation. This avoids relying on SIGPIPE
    # to terminate an endless "/dev/urandom" pipeline, which hangs when
    # SIGPIPE is ignored, as on some CI runners.
    LC_ALL=C od -v -A n -N "$(( ($1 + 1) / 2 ))" -t x1 /dev/urandom \
      | tr -d ' \n' \
      | cut -c "1-$1"
}

## Sanitize string for safe eval
##
## Sanitizes a string for safe eval by escaping backticks.
##
## @namespace src/shell/strings
## @requires printf sed
## @param {str} <STRING> (required) The string to sanitize.
_sanitize() {
    # escape backticks to prevent command substitution
    # shellcheck disable=SC2016
    printf '%s' "$1" | sed 's/`/\\`/g'
}

## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string
##
## Squeezes repeated whitespaces and trim leading and trailing whitespaces from a string.
##
## @namespace src/shell/strings
## @requires printf sed tr
## @param {str} <STRING> (required) The string to trim.
_trim() {
    # tr -s, --squeeze-repeats    replace each sequence of a repeated character
    printf '%s' "$1" | tr -s ' ' | sed -e 's/^ *//' -e 's/ *$//'
}

## Decode a string from URL format
##
## Replaces every percent-encoded sequence with the matching character.
##
## @namespace src/shell/strings
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @param {str} <STRING> (required) The URL-encoded string to decode.
_url_decode() {
    if [ -z "$1" ]; then _echo_error '_url_decode: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_url_decode: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | LC_ALL=C awk '
        function hex_value(hex,    i, digit, value) {
            value = 0
            hex = tolower(hex)
            for (i = 1; i <= 2; i++) {
                digit = index("0123456789abcdef", substr(hex, i, 1)) - 1
                value = value * 16 + digit
            }
            return value
        }
        {
            result = ""
            for (i = 1; i <= length($0); i++) {
                char = substr($0, i, 1)
                pair = substr($0, i + 1, 2)
                if (char == "%" && pair ~ /^[0-9A-Fa-f][0-9A-Fa-f]$/) {
                    result = result sprintf("%c", hex_value(pair))
                    i += 2
                } else {
                    result = result char
                }
            }
            printf "%s", result
        }'
}

## Encode a string to URL format
##
## @namespace src/shell/strings
## @requires awk od printf
## @depends src/shell/colors/_echo_error
## @param {str} <STRING> (required) The string to URL-encode.
_url_encode() {
    if [ -z "$1" ]; then _echo_error '_url_encode: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_url_encode: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | od -An -v -tx1 | awk '
        function hex_value(hex,    i, digit, value) {
            value = 0
            hex = tolower(hex)
            for (i = 1; i <= 2; i++) {
                digit = index("0123456789abcdef", substr(hex, i, 1)) - 1
                value = value * 16 + digit
            }
            return value
        }
        {
            result = ""
            for (i = 1; i <= NF; i++) {
                hex = tolower($i)
                value = hex_value(hex)
                if ((value >= 48 && value <= 57) \
                    || (value >= 65 && value <= 90) \
                    || (value >= 97 && value <= 122) \
                    || value == 45 || value == 46 \
                    || value == 95 || value == 126) {
                    result = result sprintf("%c", value)
                } else {
                    result = result "%" toupper(hex)
                }
            }
            printf "%s", result
        }'
}

#--------------------------------------------------
#_ Symfony
#--------------------------------------------------

## Install project dependencies with composer
##
## @namespace src/shell/symfony
## @requires composer install
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
## @depends src/shell/system/_pwd
_composer_install() {
    _check_installed composer

    _echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(_pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(_pwd)"
}

## Update project dependencies with composer
##
## @namespace src/shell/symfony
## @requires composer
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_composer_update() {
    _check_installed composer

    _echo_info "composer update --with-dependencies\n"
    composer update --with-dependencies
}

## Get correct Symfony console binary path
##
## @namespace src/shell/symfony
## @requires basename echo symfony
## @depends src/shell/colors/_echo_error
_console() {
    if [ -x "$(command -v symfony)" ]; then
        echo 'symfony console'

        return 0
    fi

    if [ -f ./app/console ]; then
        echo './app/console'

        return 0
    fi

    if [ -f ./bin/console ]; then
        echo './bin/console'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" symfony console not found, try: 'composer install'\n"
    exit 1
}

## Create Symfony database with Doctrine
##
## @namespace src/shell/symfony
## @requires true
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_db_create() {
    if [ -z "$1" ]; then _echo_error '_db_create: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_create: too many arguments ($#)\n"; return 1; fi

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:database:create --env \"$1\" || true\n"
    $(_console) doctrine:database:create --env "$1" || true
}

## Drop database with Doctrine
##
## @namespace src/shell/symfony
## @requires true
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_db_drop() {
    if [ -z "$1" ]; then _echo_error '_db_drop: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_drop: too many arguments ($#)\n"; return 1; fi

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:database:drop --force --env \"$1\" || true\n"
    $(_console) doctrine:database:drop --force --env "$1" || true
}

## Executes arbitrary SQL directly from the command line
##
## @namespace src/shell/symfony
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @param {str} <SQL> /.+/ SQL query.
_db_query() {
    if [ -z "$1" ]; then _echo_error '_db_query: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_query: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) doctrine:query:sql \"$1\"\n"
    $(_console) doctrine:query:sql "$1"
}

## Create schema with Doctrine
##
## @namespace src/shell/symfony
## @requires true
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_db_schema() {
    if [ -z "$1" ]; then _echo_error '_db_create: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_db_create: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) doctrine:schema:create --dump-sql --env \"$1\"\n"
    $(_console) doctrine:schema:create --dump-sql --env "$1"

    # following command will not break script execution on failure even with `-e` option enabled
    _echo_info "$(_console) doctrine:schema:create --env \"$1\" || true\n"
    $(_console) doctrine:schema:create --env "$1" || true
}

## Get correct PHPUnit binary path
##
## @namespace src/shell/symfony
## @requires basename echo
## @depends src/shell/colors/_echo_error
_phpunit() {
    if [ -f ./vendor/bin/phpunit ]; then
        echo ./vendor/bin/phpunit

        return 0
    fi

    if [ -f ./vendor/bin/simple-phpunit ]; then
        echo ./vendor/bin/simple-phpunit

        return 0
    fi

    if [ -f ./vendor/symfony/phpunit-bridge/bin/simple-phpunit ]; then
        echo './vendor/symfony/phpunit-bridge/bin/simple-phpunit'

        return 0
    fi

    if [ -f ./bin/phpunit ]; then
        echo './bin/phpunit'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires phpunit, try: 'composer install'\n"

    return 1
}

## Clear Symfony cache
##
## @namespace src/shell/symfony
## @requires clear
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @param {str} <ENV> /^(dev|prod|test)$/ Environment.
_sf_cache() {
    if [ -z "$1" ]; then _echo_error '_sf_cache: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_sf_cache: too many arguments ($#)\n"; return 1; fi

    _echo_info "$(_console) cache:clear --env \"$1\"\n"
    $(_console) cache:clear --env "$1"

    _echo_info "$(_console) cache:warmup --env \"$1\"\n"
    $(_console) cache:warmup --env "$1"
}

## Run linter (sniff)
##
## @namespace src/shell/symfony
## @requires composer find php
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_console
## @depends src/shell/system/_check_installed
_sf_lint() {
    _check_installed php
    _check_installed composer

    # check composer validity
    _echo_info 'composer validate\n'
    composer validate

    # check php files syntax
    _echo_info "php -l -d memory-limit=-1 -d display_errors=0 \"...\"\n"
    find ./src ./tests -type f -name '*.php' | while read -r __file__; do
        php -l -d memory-limit=-1 -d display_errors=0 "${__file__}"
    done

    _echo_info "$(_console) lint:container\n"
    $(_console) lint:container

    _echo_info "$(_console) lint:twig ./templates --show-deprecations\n"
    $(_console) lint:twig ./templates --show-deprecations

    _echo_info "$(_console) lint:yaml ./compose.yaml ./compose.*.yaml"
    $(_console) lint:yaml ./compose.yaml ./compose.*.yaml
}

## Check security issues in project dependencies (symfony-cli)
##
## @namespace src/shell/symfony
## @requires composer symfony
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_is_installed
_sf_security() {
    if _is_installed symfony; then
        _echo_info 'symfony security:check\n'
        symfony security:check

        return 0
    fi

    if _is_installed composer; then
        _echo_info 'composer audit\n'
        composer audit

        return 0
    fi

    _echo_error "\"$0\" requires symfony or composer.\n"
    return 1
}

## Run a local web server with Symfony CLI
##
## @namespace src/shell/symfony
## @requires symfony
## @depends src/shell/colors/_echo_info
## @depends src/shell/system/_check_installed
_sf_serve() {
    _check_installed symfony

    _echo_info 'symfony local:server:start --no-tls\n'
    symfony local:server:start --no-tls
}

## Run test with PHPUnit
##
## @namespace src/shell/symfony
## @requires php realpath
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/symfony/_phpunit
## @param {file} <FILE_PATH> The path to the input file.
_sf_test() {
    if [ $# -gt 1 ]; then _echo_error "_sf_tests: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure

        return 0
    fi

    if [ ! -f "$1" ]; then _echo_error "_sf_tests: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")"

    _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure --testdox \"$1\"\n"
    php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure --testdox "$1"
}

#--------------------------------------------------
#_ System
#--------------------------------------------------

## Print error message if provided command is missing
##
## @namespace src/shell/system
## @requires basename
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_get_package_name
## @depends src/shell/system/_is_installed
## @terminal
## @param {str} <COMMAND> (required) A string containing the command name to find.
_check_installed() {
    if [ -z "$1" ]; then _echo_error '_check_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_check_installed: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$1" "$(_get_package_name "$1")"

    _echo_error "\"$(basename "${0}")\" requires $1, try: 'sudo apt-get install -y $2'\n"

    exit 1
}

## Find package name for given command
##
## @namespace src/shell/system
## @requires echo snap
## @depends src/shell/colors/_echo_error
## @param {str} <COMMAND> (required) A string containing the command name to find.
_get_package_name() {
    if [ -z "$1" ]; then _echo_error '_get_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_package_name: too many arguments ($#)\n"; return 1; fi

    # debian packages
    if [ "$1" = aapt ];     then echo android-tools-adb;      return 0; fi
    if [ "$1" = adb ];      then echo android-tools-adb;      return 0; fi
    if [ "$1" = fastboot ]; then echo android-tools-fastboot; return 0; fi
    if [ "$1" = snap ];     then echo snapd;                  return 0; fi

    for __package__ in \
        ab \
        check_forensic \
        checkgid \
        fcgistarter \
        htcacheclean \
        htdbm \
        htdigest \
        htpasswd \
        httxt2dbm \
        logresolve \
        rotatelogs \
        split-logfile \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo apache2-utils

            return 0
        fi
    done

    for __package__ in \
        certutil \
        modutil \
        pk12util \
        shlibsign \
        signtool \
        ssltap \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo libnss3-tools

            return 0
        fi
    done

    for __package__ in \
        arp \
        ifconfig \
        ipmaddr \
        iptunnel \
        mii-tool \
        nameif \
        plipconfig \
        rarp \
        route \
        slattach \
    ; do
        if [ "$1" = "${__package__}" ]; then
            echo net-tools

            return 0
        fi
    done

    echo "$1"
}

## Print the user running the web server
##
## Falls back to "www-data" when no common web server process is found.
##
## @namespace src/shell/system
## @requires awk comm command grep head printf ps true
_get_web_user() {
    if command -v ps >/dev/null 2>&1; then
        # https://symfony.com/doc/current/setup/file_permissions.html
        # shellcheck disable=SC2009
        set -- "$(ps axo user,comm 2>/dev/null \
            | grep -e '[a]pache' -e '[h]ttpd' -e '[_]www' \
                -e '[w]ww-data' -e '[n]ginx' \
            | grep -v root \
            | head -n 1 \
            | awk '{print $1}' || true)"
        if [ -n "$1" ]; then
            printf '%s\n' "$1"

            return 0
        fi
    fi

    printf 'www-data\n'

    return 0
}

## Validate a file checksum
##
## @namespace src/shell/system
## @requires awk grep realpath set sha256sum
## @depends src/shell/colors/_echo_error
## @depends src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <SHA256SUM> (required) A string containing file checksum.
_is_checksum_valid() {
    _check_installed sha256sum

    if [ $# -lt 2 ]; then _echo_error '_is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    if [ ! -f "$1" ]; then _echo_error "_is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"

    sha256sum "$1" | awk '{print $1}' | grep -q "$2"
}

## Check provided command is installed
##
## @namespace src/shell/system
## @requires dpkg grep
## @depends src/shell/colors/_echo_error
## @param {str} <COMMAND> (required) A string containing the command name to find.
_is_installed() {
    if [ -z "$1" ]; then _echo_error '_is_installed: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_is_installed: too many arguments ($#)\n"; return 1; fi

    if [ -x "$(command -v "$1")" ]; then

        return 0
    fi

    # maybe it's a debian package
    if dpkg -s "$1" 2>/dev/null | grep -q 'Status: install ok installed'; then

        return 0
    fi

    # or maybe it's a linuxbrew package
    if [ -x "/home/linuxbrew/.linuxbrew/bin/$1" ]; then

        return 0
    fi

    return 1
}

## Check current user is root
##
## @namespace src/shell/system
## @requires awk id
_is_root() {
    if [ "$(id | awk '{print $1}')" = 'uid=0(root)' ];then
        return 0
    fi

    return 1
}

## Change the owner of a file or folder
##
## @namespace src/shell/system
## @requires awk chown printf realpath sudo whoami
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @param {path} <SOURCE> (required) The file or folder to update.
## @option {str} <USER> [-u] (default:"current user") The owner user name.
## @option {str} <GROUP> [-g] (default:"owner user") The owner group name.
## @flag <nobody> [-n] Set the owner to nobody:nogroup.
## @flag <recursive> [-r] Change the owner recursively.
## @flag <root> [-R] Set the owner to root.
## @flag <sudo> [-s] Execute chown with sudo.
_own() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-n' ]; then
            set -- "$@" '--nobody'
            shift
        elif [ "$1" = '-r' ]; then
            set -- "$@" '--recursive'
            shift
        elif [ "$1" = '-R' ]; then
            set -- "$@" '--root'
            shift
        elif [ "$1" = '-s' ]; then
            set -- "$@" '--sudo'
            shift
        elif [ "$1" = '-u' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-u" requires value\n'

                return 1
            fi
            set -- "$@" '--user' "$2"
            shift 2
        elif [ "$1" = '-g' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-g" requires value\n'

                return 1
            fi
            set -- "$@" '--group' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_own\n'
            _echo_success 'description:' 2 14; _echo_primary 'Change the owner of a file or folder\n'
            _echo_success 'usage:' 2 14; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout:
    # $1: recursive flag, $2: sudo flag, $3: group, $4: user,
    # $5..: positional parameters.
    set -- "$(printf '%s\n' "$@" | awk -v fallback="$(whoami)" '
        /^--user$/ { getline; user = $0 }
        /^--root$/ { user = "root" }
        /^--nobody$/ { user = "nobody" }
        END { print (user == "" ? fallback : user) }')" "$@"
    set -- "$(printf '%s\n' "$@" | awk -v fallback="$1" '
        /^--group$/ { getline; group = $0 }
        /^--nobody$/ { group = "nogroup" }
        END { print (group == "" ? fallback : group) }')" "$@"
    if printf '%s\n' "$@" | awk '/^--sudo$/ { found = 1 } END { exit !found }'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi
    if printf '%s\n' "$@" | awk '/^--recursive$/ { found = 1 } END { exit !found }'; then
        set -- 'true' "$@"
    else
        set -- 'false' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--recursive' ] || [ "$1" = '--sudo' ] \
            || [ "$1" = '--root' ] || [ "$1" = '--nobody' ]; then
            shift
        elif [ "$1" = '--user' ] || [ "$1" = '--group' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    if [ -z "$5" ]; then
        _echo_error '_own: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 5 ]; then
        _echo_error "_own: too many arguments ($(( $# - 4 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_own [source] -u (user) -g (group) -n (nobody) -R (root) -r (recursive) -s (sudo) -h (help)\n'

        return 1
    fi

    if [ ! -f "$5" ] && [ ! -d "$5" ]; then
        _echo_error "_own: source: \"$5\" is invalid\n"

        return 1
    fi

    if [ ! -d "$5" ] && [ "$1" = 'true' ]; then
        _echo_error "_own: source: \"$5\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$2" "$3" "$4" "$(realpath "$5")"

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    if [ "$1" = 'true' ]; then
        if [ "$2" = 'true' ]; then
            _echo_info "sudo chown \"$4:$3\" -R \"$5\"\n"
            sudo chown "$4:$3" -R "$5"
        else
            _echo_info "chown \"$4:$3\" -R \"$5\"\n"
            chown "$4:$3" -R "$5"
        fi

        return 0
    fi

    if [ "$2" = 'true' ]; then
        _echo_info "sudo chown \"$4:$3\" \"$5\"\n"
        sudo chown "$4:$3" "$5"
    else
        _echo_info "chown \"$4:$3\" \"$5\"\n"
        chown "$4:$3" "$5"
    fi
}

## Return current project directory realpath, or "pwd" when installed globally
##
## @namespace src/shell/system
## @requires dirname pwd realpath
## @assumes HOME
_pwd() {
    if [ "$(dirname "$(realpath "$0")")" = '/usr/bin' ] || [ "$(dirname "$(realpath "$0")")" = '/usr/local/bin' ] || [ "$(dirname "$(realpath "$0")")" = "${HOME}/.local/bin" ]; then
        pwd

        return 0
    fi

    dirname "$(realpath "$0")"
}

## Remove given package from system
##
## eg: `_remove curl` will remove "curl" with "sudo apt remove --yes curl".
## eg: `_remove adb android-tools-adb` will remove "android-tools-adb" package.
##
## @namespace src/shell/system
## @requires apt apt-get snap sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_package_manager
## @depends src/shell/system/_get_package_name
## @depends src/shell/system/_is_installed
## @param {str} <PACKAGE> (required) The command/package to remove.
## @param {str} <PACKAGE_MANAGER> (default:"apt") The package manager required to remove the package with.
_remove() {
    if [ -z "$1" ]; then _echo_error '_remove: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove: too many arguments ($#)\n"; return 1; fi

    if ! _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_package_manager)}"

    if ! _is_installed "$2"; then
        _echo_error "_remove \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        _echo_info "sudo apk del \"$1\"\n"
        sudo apk del "$1"

    elif [ "$2" = apt ]; then
        _echo_info "sudo apt remove --yes \"$1\"\n"
        sudo apt remove --yes "$1"

    elif [ "$2" = apt-get ]; then
        _echo_info "sudo apt-get remove --assume-yes \"$1\"\n"
        sudo apt-get remove --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        _echo_info "sudo aptitude remove --yes \"$1\"\n"
        sudo aptitude remove --yes "$1"

    elif [ "$2" = dnf ]; then
        _echo_info "sudo dnf remove --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf remove --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        _echo_info "flatpak remove --non-interactive \"$1\"\n"
        flatpak remove --non-interactive "$1"

    elif [ "$2" = nala ]; then
        _echo_info "sudo nala remove --assume-yes \"$1\"\n"
        sudo nala remove --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        _echo_info "sudo pacman -Rns \"$1\"\n"
        sudo pacman -Rns "$1"

    elif [ "$2" = snap ]; then
        _echo_info "sudo snap remove \"$1\"\n"
        sudo snap remove "$1"

    elif [ "$2" = yum ]; then
        _echo_info "sudo yum remove --assumeyes \"$1\"\n"
        sudo yum remove --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        _echo_info "sudo zypper remove --non-interactive \"$1\"\n"
        sudo zypper remove --non-interactive "$1"
    fi
}

## Install required package globally
##
## eg: `_require curl` will install "curl" with "sudo apt install --yes curl".
## eg: `_require adb` will install "android-tools-adb" package.
##
## @namespace src/shell/system
## @requires apt apt-get install snap sudo
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/compatibility/_package_manager
## @depends src/shell/system/_get_package_name
## @depends src/shell/system/_is_installed
## @param {str} <PACKAGE> (required) The command/package to remove.
## @param {str} <PACKAGE_MANAGER> (default:"apt") The package manager required to remove the package with.
_require() {
    if [ -z "$1" ]; then _echo_error '_require: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_require: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_package_manager)}"

    if ! _is_installed "$2"; then
        _echo_error "_require \"$2\" package manager not found!\n"
        exit 1
    fi

    if [ "$2" = apk ]; then
        _echo_info "sudo apk add \"$1\"\n"
        sudo apk add "$1"

    elif [ "$2" = apt ]; then
        _echo_info "sudo apt install --yes \"$1\"\n"
        sudo apt install --yes "$1"

    elif [ "$2" = apt-get ]; then
        _echo_info "sudo apt-get install --assume-yes \"$1\"\n"
        sudo apt-get install --assume-yes "$1"

    elif [ "$2" = aptitude ]; then
        _echo_info "sudo aptitude install --yes \"$1\"\n"
        sudo aptitude install --yes "$1"

    elif [ "$2" = dnf ]; then
        _echo_info "sudo dnf install --assumeyes --nogpgcheck -y \"$1\"\n"
        sudo dnf install --assumeyes --nogpgcheck -y "$1"

    elif [ "$2" = flatpak ]; then
        _echo_info "flatpak install --non-interactive flathub \"$1\"\n"
        flatpak install --non-interactive flathub "$1"

    elif [ "$2" = nala ]; then
        _echo_info "sudo nala install --assume-yes \"$1\"\n"
        sudo nala install --assume-yes "$1"

    elif [ "$2" = pacman ]; then
        _echo_info "sudo pacman -Sy \"$1\"\n"
        sudo pacman -Sy "$1"

    elif [ "$2" = snap ]; then
        _echo_info "sudo snap install \"$1\" --classic\n"
        sudo snap install "$1" --classic

    elif [ "$2" = yum ]; then
        _echo_info "sudo yum install --assumeyes \"$1\"\n"
        sudo yum install --assumeyes "$1"

    elif [ "$2" = zypper ]; then
        _echo_info "sudo zypper install --non-interactive \"$1\"\n"
        sudo zypper install --non-interactive "$1"
    fi
}

## Grant the web server user read and write access to a folder
##
## Uses setfacl so the permissions are inherited by future files and
## folders without changing the owner of the project files.
##
## @namespace src/shell/system
## @requires awk command printf realpath setfacl
## @depends src/shell/colors/_echo_danger
## @depends src/shell/colors/_echo_error
## @depends src/shell/colors/_echo_info
## @depends src/shell/colors/_echo_primary
## @depends src/shell/colors/_echo_success
## @depends src/shell/colors/_echo_warning
## @depends src/shell/system/_get_web_user
## @param {folder} <DIRECTORY> (required) The folder to grant access to.
## @option {str} <HTTPD_USER> [-u] (default:"_get_web_user") The web server user.
_set_web_permissions() {
    # $1..: command line arguments followed by an internal marker.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '-u' ]; then
            if [ "$2" = '__END_OF_OPTIONS__' ]; then
                _echo_danger 'error: "-u" requires value\n'

                return 1
            fi
            set -- "$@" '--user' "$2"
            shift 2
        elif [ "$1" = '-h' ]; then
            _echo_warning '_set_web_permissions\n'
            _echo_success 'description:' 2 14; _echo_primary 'Grant the web server user access to a folder\n'
            _echo_success 'usage:' 2 14; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

            return 0
        elif [ "$1" = '--' ]; then
            shift
            while [ "$1" != '__END_OF_OPTIONS__' ]; do
                set -- "$@" "$1"
                shift
            done
        elif [ "${1#-}" != "$1" ]; then
            _echo_danger "error: invalid option \"${1#-}\"\n"

            return 1
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    # Record layout: $1: httpd user, $2..: positional parameters.
    if printf '%s\n' "$@" | awk '/^--user$/ { found = 1 } END { exit !found }'; then
        set -- "$(printf '%s\n' "$@" \
            | awk '/^--user$/ { getline; value = $0 }
                END { print value }')" "$@"
    else
        set -- '' "$@"
    fi

    # Drop the option markers, keeping the record and positional parameters.
    set -- "$@" '__END_OF_OPTIONS__'
    while [ "$1" != '__END_OF_OPTIONS__' ]; do
        if [ "$1" = '--user' ]; then
            shift 2
        else
            set -- "$@" "$1"
            shift
        fi
    done
    shift

    #--------------------------------------------------
    # Check setfacl installation
    #--------------------------------------------------

    if ! command -v setfacl >/dev/null 2>&1; then
        _echo_error '_set_web_permissions: setfacl required, try "sudo apt-get install -y acl"\n'

        return 1
    fi

    if [ -z "$2" ]; then
        _echo_error '_set_web_permissions: some mandatory parameter is missing\n'
        _echo_success 'usage:' 2 8; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

        return 1
    fi
    if [ "$#" -gt 2 ]; then
        _echo_error "_set_web_permissions: too many arguments ($(( $# - 1 )))\n"
        _echo_success 'usage:' 2 8; _echo_primary '_set_web_permissions [directory] -u (user) -h (help)\n'

        return 1
    fi

    if [ ! -d "$2" ]; then
        _echo_error "_set_web_permissions: \"$2\" is not a valid directory\n"

        return 1
    fi

    set -- "$1" "$(realpath "$2")"

    if [ -z "$1" ]; then
        set -- "$(_get_web_user)" "$2"
    fi

    #--------------------------------------------------
    # Execute command
    #--------------------------------------------------

    # set permissions for future files and folders
    _echo_info "setfacl -dR -m \"u:$1:rwX\" \"$2\"\n"
    setfacl -dR -m "u:$1:rwX" "$2"

    # set permissions on the existing files and folders
    _echo_info "setfacl -R -m \"u:$1:rwX\" \"$2\"\n"
    setfacl -R -m "u:$1:rwX" "$2"
}

## Animate a spinner in the terminal for a given amout of time
##
## @namespace src/shell/system
## @requires awk printf sleep
## @param {int} <DURATION> (default:0) Animation duration in miliseconds.
_spin() {
    set -- "$((${1:-0}/10))" 0 0

    while [ "$1" -gt "$2" ]; do
        printf '\r%s' "$(printf "|/-\\" | awk -v I="$3" '{print substr($0, I, 1)}')"
        set -- "$1" "$(( $2+1 ))" "$(( $3%4+1 ))"
        sleep 0.1
    done
}

## Check provided user exists
##
## @namespace src/shell/system
## @requires id
## @depends src/shell/colors/_echo_error
## @param {str} <USERNAME> (required) The username to check.
_user_exists() {
    if [ -z "$1" ]; then _echo_error '_user_exists: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_user_exists: too many arguments ($#)\n"; return 1; fi

    if [ -n "$(id -u "$1" 2>/dev/null)" ]; then

        return 0
    fi

    return 1
}

#--------------------------------------------------
#_ Validation
#--------------------------------------------------

## Exit with an error when a script defines a function more than once
##
## @namespace src/shell/validation
## @requires grep printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_functions_names
## @param {file} <SCRIPT_PATH> (required) The path to the script to inspect.
_check_duplicate_functions() {
    if [ -z "$1" ]; then _echo_error '_check_duplicate_functions: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_check_duplicate_functions: too many arguments ($#)\n"; return 1; fi

    __functions_names__=$(_get_functions_names "$1" 'true')

    for __function__ in ${__functions_names__}; do
        if [ "$(printf '%s' "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    return 0
}

## Checks if variable is valid given regex constraint
##
## The pattern is applied with POSIX extended regular expressions, as
## data (never as a command-line option), and every line of the value
## must match it in full.
##
## @namespace src/shell/validation
## @requires awk printf sed
## @depends src/shell/colors/_echo_error
## @param {str} <VALUE> (required) The string to be compared to regex pattern.
## @param {str} <PATTERN> (required) The regex parttern to apply.
_is_valid() {
    if [ $# -lt 2 ]; then _echo_error '_is_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_valid: too many arguments ($#)\n"; return 1; fi

    # missing pattern always returns valid status
    if [ -z "$2" ]; then

        return 0
    fi

    # remove leading and ending forward slashes from regular expression,
    # including its optional trailing flags
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/[a-z]*$@@')"

    if ! printf '%s\n' "$1" | awk -v pattern="$2" '
        $0 !~ ("^(" pattern ")$") { invalid = 1 }
        END { exit invalid }
    '; then

        return 1
    fi

    return 0
}

## Find constraints and validates a variable
##
## @namespace src/shell/validation
## @requires cut printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_constraint
## @depends src/shell/validation/_is_valid
## @terminal
## @param {str} <VARIABLE> (required) The variable to validate in the followling format : variable_name=value.
## @param {str} <CONSTRAINT> Optional constraint, read from the script when omitted.
_validate() {
    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2-)" "${2:-$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")}"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

## Validate positional parameters against the function shoedoc
##
## Each positional value is matched with the parameter declared at the
## same position. Parameters without a constraint accept any value.
##
## @namespace src/shell/validation
## @requires awk printf
## @depends src/shell/colors/_echo_error
## @depends src/shell/reflexion/_get_function_parameters
## @depends src/shell/validation/_validate
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The command being executed.
## @param {str} <POSITIONAL> The positional values to validate.
_validate_positionals() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        _echo_error '_validate_positionals: some mandatory parameter is missing\n'

        return 1
    fi

    __script__="$1"
    __function__="$2"
    shift 2

    __index__=0
    for __value__ in "$@"; do
        __index__=$((__index__ + 1))
        __record__=$(
            _get_function_parameters "${__script__}" "${__function__}" \
                | awk -F '\037' -v wanted="${__index__}" '
                    $1 == "param" {
                        count++
                        if (count == wanted) {
                            print $2 "\037" $5
                            exit
                        }
                    }
                '
        )
        if [ -z "${__record__}" ]; then continue; fi

        __name__="${__record__%%"$(printf '\037')"*}"
        __constraint__="${__record__#*"$(printf '\037')"}"
        if [ -z "${__constraint__}" ]; then continue; fi

        _validate "${__name__}=${__value__}" "${__constraint__}"
    done
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

## Shoe Light Kernel
##
## @namespace src/shell/kernel
## @requires printf
## @depends src/shell/help/_help
## @depends src/shell/hooks/_after
## @depends src/shell/hooks/_before
## @depends src/shell/hooks/_default
## @depends src/shell/reflexion/_get_functions_names
## @depends src/shell/validation/_check_duplicate_functions
## @assumes _DANGER _EOL
_light_kernel() {
    _check_duplicate_functions "$0"

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __record_separator__=$(printf '\036')
    __field_separator__=$(printf '\037')
    __execution_stack__=''
    __plan__=''

    for __argument__ in "$@"; do
        # Append resolved commands to the execution stack.
        for __function__ in $(_get_functions_names "$0"); do
            if [ "${__argument__}" = "${__function__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __plan__="${__plan__}${__record_separator__}${__function__}"
                continue 2
            fi
        done

        # Every other argument is a positional parameter of the command
        # resolved last. A positional before any command is an error.
        if [ -z "${__execution_stack__}" ]; then
            printf "${_DANGER}error: \"%s\" is not a valid command${_EOL}" "${__argument__}"
            exit 1
        fi
        __plan__="${__plan__}${__field_separator__}${__argument__}"
    done

    [ -n "$(command -v _before)" ] && _before

    # `help` takes precedence over every command around it.
    __function__=''
    for __argument__ in ${__execution_stack__}; do
        if [ "${__function__}" = 'help' ]; then
            _help "$0" "${__argument__}"
            exit 0
        fi
        __function__="${__argument__}"
    done

    if [ "${__function__}" = 'help' ]; then
        _help "$0" ''
        exit 0
    fi

    # Dispatch each command with its positional parameters. Word
    # splitting is intentional here, so pathname expansion is disabled.
    __old_ifs__="${IFS}"
    case "$-" in *f*) __noglob__='true' ;; *) __noglob__='false' ;; esac
    IFS="${__record_separator__}"
    for __record__ in ${__plan__}; do
        if [ -z "${__record__}" ]; then continue; fi
        IFS="${__field_separator__}"
        set -f
        # shellcheck disable=SC2086  # word splitting is intentional
        set -- ${__record__}
        [ "${__noglob__}" = 'true' ] || set +f
        IFS="${__old_ifs__}"
        __function__="$1"
        shift
        eval "${__function__} \"\$@\""
    done
    IFS="${__old_ifs__}"

    [ -n "$(command -v _after)" ] && _after
}

_light_kernel "$@"

