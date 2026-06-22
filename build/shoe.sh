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
## @update  https://raw.githubusercontent.com/TangoMan75/shoe/refs/heads/main/shoe.sh

#--------------------------------------------------
# Place your constants after this line
#--------------------------------------------------

## Script alias (the command alias that will be used for invoking the script after installation)
ALIAS=shoe

#--------------------------------------------------
# Place your options after this line
#--------------------------------------------------

## Greeting recipient name /^[a-zA-Z-]+$/
who="World"

## How many times to say hello /[1-9]/
count=1

#--------------------------------------------------
# Place your flags after this line
#--------------------------------------------------

## Example Flag (any variable set to "false" will convert to a flag at runtime)
flag=false

## Install script globally
global=false

#--------------------------------------------------
# Place your private constants after this line
#--------------------------------------------------

## This constant is private (it will not de displayed in the "help" output)
_PRIVATE="I'm a private constant"

#--------------------------------------------------
# Place your global variables after this line
#--------------------------------------------------

## This variable is private (it will not de displayed in the "help" output)
_global_variable="I'm a global variable"

#--------------------------------------------------
# Place your functions after this line
#--------------------------------------------------

## Hello World!
##
## Greets a specified user a given number of times. (the recipient's name is provided with the "--who" option)
##
## @namespace recipes/shoe
## @requires echo
## @param {str} <who> The recipient's name.
hello() {
    loop=0
    while [ "${loop}" -lt "${count}" ]; do
        echo "Hello, ${who} !"
        loop=$((loop+1))
    done
}

## Prints flag status
##
## @namespace recipes/shoe
## @requires echo true
## @assumes flag
flag_test() {
    if [ "${flag}" = true ]; then
        echo "Flag is on"

        return 0
    fi

    echo "Flag is off"
}

#--------------------------------------------------
# Place your private functions after this line
#--------------------------------------------------

# Private functions are prefixed with underscore, they cannot be called from the command line and will not appear in the help section.
_private() {
    echo "I'm private"
}

###################################################
# TangoMan Shoe Shell Microframework
###################################################

#--------------------------------------------------
# Generated code : Do not edit below this line
#--------------------------------------------------

#--------------------------------------------------
#_ Android
#--------------------------------------------------

## Connect to device with adb via wifi (not recommended when flashing images)
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
_adb_sideload() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_adb_sideload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_adb_sideload: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_adb_sideload: \"$1\" file not found\n"; return 1; fi

    _echo_info "adb sideload \"$1\"\n"
    adb sideload "$1"
}

## Start local adb server
##
## @namespace src/shell/android
## @requires adb
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_adb_start_server() {
    _check_installed adb

    _echo_info 'adb start-server\n'
    adb start-server
}

## Lock bootloader and flashing
##
## @namespace src/shell/android
## @requires fastboot
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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

    set -- "$(realpath "$1")" "$2" "${3:-false}"
    if [ ! -f "$1" ]; then _echo_error "_flash_img: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_label() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_label: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_label: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_apk_label: \"$1\" file not found\n"; return 1; fi

    aapt dump badging "$1" 2>/dev/null | awk -F "'" '/application-label:/{print $2}'
}

## Get APK package_name
##
## @namespace src/shell/android
## @requires aapt awk realpath
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_package_name() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_package_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_package_name: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_apk_package_name: \"$1\" file not found\n"; return 1; fi

    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("name=|'"'"'","");  print $2}'
}

## Get installed APK path on connected device from package name
##
## @namespace src/shell/android
## @requires adb awk
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error
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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_apk_version() {
    _check_installed aapt

    if [ -z "$1" ]; then _echo_error '_get_apk_version: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_apk_version: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_apk_version: \"$1\" file not found\n"; return 1; fi

    # adb shell dumpsys package "${apk_package}" | awk -F '=' '/versionName/{print $2}' | tr ' ' _ | head -n1
    aapt dump badging "$1" 2>/dev/null | awk '/package/{gsub("versionName=|'"'"'","");  print $4}'
}

## Install APK on connected device
##
## @namespace src/shell/android
## @requires adb install realpath true
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {bool} <FORCE> (default:false) Force install.
_install_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_install_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_install_apk: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_install_apk: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error
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
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error
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
## @depends src/shell/android/_get_apk_path src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {str} <PACKAGE_NAME> (required) The apk package name. eg: "org.fdroid.fdroid"
## @param {folder} <DESTINATION> (required) The path to the destination folder.
_pull_apk() {
    if ! _is_device_connected_with_adb; then
        _echo_error 'device not found\n'

        return 1
    fi

    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_pull_apk: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_pull_apk: too many arguments ($#)\n"; return 1; fi

    set -- "$1" "$(_get_apk_path "$1")" "$(realpath "$2")"
    if [ ! -d "$2" ]; then _echo_error "_pull_apk: \"$2\" folder not found\n"; return 1; fi

    _echo_info "adb pull \"$2\" \"$3/$1.apk\"\n"
    adb pull "$2" "$3/$1.apk"
}

## Reboot connected device to bootloader
##
## @namespace src/shell/android
## @requires adb fastboot reboot
## @depends src/shell/android/_is_device_connected_with_adb src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_adb src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_adb src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
_reboot_with_img() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    if [ -z "$1" ]; then _echo_error '_reboot_with_img: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_reboot_with_img: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_reboot_with_img: \"$1\" file not found\n"; return 1; fi

    _echo_info "fastboot --verbose boot \"$1\"\n"
    fastboot --verbose boot "$1"
}

## Remove APK from connected device
##
## @namespace src/shell/android
## @requires adb true
## @depends src/shell/android/_is_device_connected_with_adb src/shell/colors/_echo_error src/shell/colors/_echo_info
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
## @depends src/shell/android/_is_device_connected_with_fastboot src/shell/colors/_echo_error src/shell/colors/_echo_info
_toggle_active_slot() {
    if ! _is_device_connected_with_fastboot; then
        _echo_error 'please reboot to bootloader\n'

        return 1
    fi

    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

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

## shellcheck disable=SC2034

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

## bold dark gray text over light gray background
_ALERT_LIGHT='\033[1;47;90m'

## bold white text over black background
_ALERT_DARK='\033[1;40;37m'

## shellcheck disable=SC2034

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

## Open with default system handler
##
## @namespace src/shell/compatibility
## @requires echo uname
_open() {
    if [ "$(uname)" = 'Darwin' ]; then
        echo 'open'

        return 0
    fi

    echo 'xdg-open'
}

## Return sed -i system flavour
##
## @namespace src/shell/compatibility
## @requires command echo sed uname
_sed_i() {
    if [ "$(uname)" = 'Darwin' ] && [ -n "$(command -v sed)" ] && [ -z "$(sed --version 2>/dev/null)" ]; then
        echo "sed -i ''"

        return 0
    fi

    echo 'sed -i'
}

#--------------------------------------------------
#_ Docker
#--------------------------------------------------

## Build container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/docker/_get_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_build() {
    if [ $# -gt 1 ]; then _echo_error "_docker_compose_build: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_get_docker_compose) build\n"
        $(_get_docker_compose) build

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_docker_compose_build: \"$1\" file not found\n"; return 1; fi

    _echo_info "$(_get_docker_compose) --file \"$1\" build\n"
    $(_get_docker_compose) --file "$1" build
}

## Build and start container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/docker/_get_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
## @param {file} <ENV_FILE> The path to the env file.
_docker_compose_start() {
    if [ $# -gt 2 ]; then _echo_error "_docker_compose_start: too many arguments ($#)\n"; return 1; fi

    if [ $# -eq 2 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        if [ ! -f "$2" ]; then _echo_error "_docker_compose_start: \"$2\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")" "$(realpath "$2")"

        _echo_info "$(_get_docker_compose) --file \"$1\" --env-file \"$2\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" --env-file "$2" up --detach --remove-orphans

        return 0
    fi

    if [ $# -eq 1 ]; then
        if [ ! -f "$1" ]; then _echo_error "_docker_compose_start: \"$1\" file not found\n"; return 1; fi
        set -- "$(realpath "$1")"

        _echo_info "$(_get_docker_compose) --file \"$1\" up --detach --remove-orphans\n"
        $(_get_docker_compose) --file "$1" up --detach --remove-orphans

        return 0
    fi

    _echo_info "$(_get_docker_compose) up --detach --remove-orphans\n"
    $(_get_docker_compose) up --detach --remove-orphans
}

## Stop container stack with docker compose
##
## @namespace src/shell/docker
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/docker/_get_docker_compose
## @param {file} <FILE_PATH> The path to the compose.yaml file.
_docker_compose_stop() {
    if [ $# -gt 1 ]; then _echo_error "_docker_compose_stop: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "$(_get_docker_compose) stop\n"
        $(_get_docker_compose) stop

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_docker_compose_stop: \"$1\" file not found\n"; return 1; fi

    _echo_info "$(_get_docker_compose) --file \"$1\" stop\n"
    $(_get_docker_compose) --file "$1" stop
}

## Execute command in the given docker container
##
## @namespace src/shell/docker
## @requires docker
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then _echo_error "_docker_run: \"$3\" folder not found\n"; return 1; fi

    _echo_info "docker run --detach --rm --interactive --tty --volume=\"$4:/home\" --workdir=\"/home\" --name \"$2\" \"$1\" $3\n"
    # shellcheck disable=SC2086
    docker run --detach --rm --interactive --tty --volume="$4:/home" --workdir="/home" --name "$2" "$1" $3
}

## Run local atmoz_sftp server
##
## @namespace src/shell/docker
## @requires docker realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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

    set -- "$1" "$2" "$3" "$(realpath "$4")"
    if [ ! -d "$4" ]; then _echo_error "_docker_run_atmoz_sftp: \"$4\" folder not found\n"; return 1; fi

    _echo_info "docker run --volume=\"$4:/home/shared\" --network \"${3:-bridge}\" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp \"$1:$2\"\n"
    docker run --volume="$4:/home/shared" --network "${3:-bridge}" --publish 22:22 --detach --rm --name atmoz_sftp atmoz/sftp "$1:$2"
}

## Run local whoami server
##
## @namespace src/shell/docker
## @requires docker whoami
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {str} <CONTAINER_ID> (required) The container id.
_get_container_name() {
    _check_installed docker

    if [ -z "$1" ]; then _echo_error '_get_container_name: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_container_name: too many arguments ($#)\n"; return 1; fi

    docker inspect "$1" --format '{{slice .Name 1}}'
}

## Return docker compose command
##
## @namespace src/shell/docker
## @requires basename command docker docker-compose echo
## @depends src/shell/colors/_echo_error
_get_docker_compose() {
    if [ "$(docker compose >/dev/null 2>&1)" ]; then
        echo 'docker compose'

        return 0
    fi

    if [ -x "$(command -v docker-compose)" ]; then
        echo 'docker-compose'

        return 0
    fi

    _echo_error "\"$(basename "${0}")\" requires docker-compose or docker compose plugin\n"

    exit 1
}

## Checks if given container is running
##
## @namespace src/shell/docker
## @requires docker true
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/system/_check_installed src/shell/system/_spin
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/system/_check_installed src/shell/system/_spin
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
## @requires awk basename dirname grep printf realpath sed
## @depends src/shell/colors/_alert_primary src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/reflexion/_print_synopsis src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_description src/shell/shoedoc/_get_shoedoc_tag src/shell/shoedoc/_get_shoedoc_title
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the documentation file. Defaults to "<BASENAME>.md".
## @param {bool} <GET_PRIVATE> (default:false) If set to "true", documents private constants, options, flags, and commands as well.
_generate_doc() {
    if [ -z "$1" ]; then _echo_error '_generate_doc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_generate_doc: too many arguments ($#)\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).md"}" "${4:-false}"
    if [ ! -f "$1" ]; then _echo_error "_generate_doc: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then _echo_error "_generate_doc: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then _echo_error '_generate_doc: file should be type ".sh"\n'; return 1; fi

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
                sub("^#+ ","",PREV);
                printf "%d. **%s%s**\n> %s\n  - Value: _%s_\n\n",++i,$1,PRIVATE,PREV,$2
            } {PREV = $0}' "$1"
        fi

        if [ "$4" = true ] && [ -n "$(_get_options "$1" true)" ]; then
            printf '## ⚙️ Global Variables\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr($1,1,1) != "_" || $1 == toupper($1)) next;
                printf "%d. **`%s` (private)**\n> %s\n  - 🚩 Default: _%s_\n\n",++i,$1,substr(PREV,4),$2
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_flags "$1")" ]; then
            printf '## 🚩 Flags\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=false$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1)) next;
                printf "%d. **`--%s`**\n> %s\n\n",++i,$1,substr(PREV,4)
            } {PREV = $0}' "$1"
        fi

        if [ -n "$(_get_options "$1")" ]; then
            printf '## ⚙️ Options\n\n'
            awk -F '=' \
            '/^[a-zA-Z0-9_]+=.+$/ {
                if (substr(PREV,1,3) != "## " || substr($1,1,1) == "_" || $1 == toupper($1) || $2 == "false") next;
                if (match(PREV,/ \/.+\//)) { # check option has constraint
                    CONSTRAINT=substr(PREV,RSTART+1,RLENGTH);
                    DESCRIPTION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                    printf "%d. **`--%s`**\n> %s\n  - 🧩 Constraint: `%s`\n  - 🚩 Default: _%s_",++i,$1,DESCRIPTION,CONSTRAINT,$2
                } else {
                    printf "%d. **`%s`**\n> %s\n  - 🚩 Default: _%s_",++i,$1,substr(PREV,4),$2
                }
                printf "\n\n"
            } {PREV = $0}' "$1"
        fi
    ) > "$2/$3"

    printf '## 🤖 Commands\n\n' >> "$2/$3"

    if _is_installed jq; then
        __index__=0
        for __function_name__ in $(_get_functions_names "$1" true); do
            _echo_info "${__function_name__}\n"

            __json__="$(_parse_shoedoc "$1" "${__function_name__}")"
            if [ -z "${__json__}" ]; then
                _echo_error "_generate_doc: no annotation found for function \"${__function_name__}\"\n"
                continue
            fi

            if [ "$4" = false ] && [ "$(printf '%s' "${__json__}" | jq -r '.scope')" = 'private' ]; then
                continue
            fi

            __namespace__="$(printf '%s' "${__json__}" | jq -r '.namespace')"
            if [ "${__namespace__}" != "${__current_namespace__}" ] && [ "${__namespace__}" != null ]; then
                __index__=0
                __current_namespace__="${__namespace__}"
                (
                    printf '### ⚡ %s\n\n' "$(printf '%s' "${__namespace__}" | awk '{print toupper($0)}')"
                ) >> "$2/$3"
            fi

            __index__=$((__index__ + 1))
            (
                # shellcheck disable=SC2016
                printf '#### ⌨️ %d. `%s` %s\n\n' ${__index__} "${__function_name__}" "($(printf '%s\n' "${__json__}" | jq -r '.scope'))"
                printf '%s\n\n' "$(printf '%s\n' "${__json__}" | jq -r '.summary')"
                # shellcheck disable=SC2016
                printf '%s\n\n' "$(_print_synopsis "${__json__}" true)"
            ) >> "$2/$3"
        done

        _echo_success "Documentation generated : \"$2/$3\"\n"

        return 0
    fi

    (
        awk -v GET_PRIVATE="$4" '/^#+/ {
                if (summary=="") {
                    summary=$0
                } else {
                    annotation=substr($0,length($1)+2);
                    if (annotation!="") annotations=annotations"\n"annotation
                }
            }
            /^#(##|_) / { # print section / divider
                if (GET_PRIVATE == "false" && $1 == "#_") next;
                sub("^#(##|_) +","");
                i=0; printf"### ⚡ %s\n\n",$0
            }
            in_function {
                # print comments
                if (sub("^ +# ","&")<1) {
                    print ""; in_function=0; next;
                }
                sub("^ +# ",""); gsub("<","\&lt;"); gsub(">","\&gt;"); printf "> %s<br>\n",$0;
            }
            /^(function +)?[a-zA-Z0-9_]+ *\(\)/ {           # matches a function (ignoring curly braces)
                function_name=substr($0,1,index($0,"(")-1); # truncate string at opening round bracket
                sub("^function ","",function_name);         # remove leading "function " if present
                gsub(" +","",function_name);                # trim whitespaces
                is_private="";
                if (substr(summary,1,3) != "## " || substr(function_name,1,1) == "_") is_private=" (private)";
                if (GET_PRIVATE == "false" && is_private != "") next;
                in_function=1;
                printf "#### %d. `%s`%s\n\n",++i,function_name,is_private
                if (summary!="") {
                    sub("^##? ","",summary);
                    printf "%s\n\n",summary
                }
                if (annotations!="") {
                    sub("^\n","",annotations); # remove all leading "\n";
                    printf "```json\n%s\n```\n\n",annotations
                }
            }
            !/^#+/ { summary=""; annotations="" }' "$1"
    ) >> "$2/$3"

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
#_ Files
#--------------------------------------------------

## Extract file based on its extension
##
## @namespace src/shell/files
## @requires dirname realpath tar unzip zip
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
_extract() {
    if [ -z "$1" ]; then _echo_error '_extract: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_extract: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}"
    if [ ! -f "$1" ]; then _echo_error "_extract: \"$1\" file not found\n"; return 1; fi

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
## @requires grep printf
## @depends src/shell/colors/_echo_error
## @param {file} <FILE_PATH> (required) The path to the input file.
_get_file_extension() {
    if [ -z "$1" ]; then _echo_error '_get_file_extension: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_get_file_extension: too many arguments ($#)\n"; return 1; fi

    printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$'
}

## Move file or folder to destination (creates folder when missing)
##
## @namespace src/shell/files
## @requires cp mkdir mv realpath rm
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
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

    # `cp -r SOURCE/. DESTINATION`
    # will effectively merge folders when destination exists without leaving dotfiles behind
    # (files in destination will overwriten)
    _echo_info "cp -r \"$1/.\" \"$2\"\n"
    cp -r "$1/." "$2"

    _echo_info "rm -rf \"$1\"\n"
    rm -rf "$1"
}

#--------------------------------------------------
#_ Git
#--------------------------------------------------

## Update .git/hooks folder
##
## @namespace src/shell/git
## @requires chmod cp git realpath rm
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {folder} <SOURCE> (required) The source directory.
_git_hooks() {
    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi
    if [ -z "$1" ]; then _echo_error '_git_hooks: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_git_hooks: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "${1:-.githooks}")" '.git/hooks'
    if [ ! -d "$1" ]; then _echo_error "_git_hooks: \"$1\" folder not found\n"; return 1; fi

    _echo_info "rm -rf \"$2\"\n"
    rm -rf "$2"

    _echo_info "cp -r \"$1\" \"$2\"\n"
    cp -r "$1" "$2"

    _echo_info "chmod +x \"$2\"/*\n"
    chmod +x "$2"/*
}

## Initialise git submodules
##
## @namespace src/shell/git
## @requires git
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
_initialise_submodules() {
    _check_installed git

    if [ -z "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then _echo_error 'not a git repository (or any of the parent directories)\n'; return 1; fi

    _echo_info 'git submodule update --init --recursive\n'
    git submodule update --init --recursive
}

#--------------------------------------------------
#_ Github
#--------------------------------------------------

## Deploy source folder to "gh-pages"
##
## @namespace src/shell/github
## @requires HEAD git split
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
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

## Print help for provider shoe script
##
## @namespace src/shell/help
## @requires jq printf realpath
## @depends src/shell/colors/_alert_primary src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_primary src/shell/colors/_echo_secondary src/shell/help/_print_commands src/shell/help/_print_constants src/shell/help/_print_description src/shell/help/_print_flags src/shell/help/_print_infos src/shell/help/_print_options src/shell/help/_print_usage src/shell/reflexion/_get_constants src/shell/reflexion/_get_flags src/shell/reflexion/_get_options src/shell/reflexion/_get_padding src/shell/reflexion/_print_synopsis src/shell/shoedoc/_get_function_shoedoc src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_description src/shell/shoedoc/_get_shoedoc_title src/shell/shoedoc/_parse_shoedoc
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <FUNCTION_NAME> The function name to get help for.
_help() {
    if [ -z "$1" ]; then _echo_error '_help: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_help: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_help: \"$1\" file not found\n"; return 1; fi

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
    if [ -x "$(command -v jq)" ]; then
        __json__="$(_parse_shoedoc "$1" "$2")"
        if [ -n "${__json__}" ]; then
            _echo_primary "$(printf '%s' "${__json__}" | jq -r '.summary')\n\n"
            _echo_secondary "$(_print_synopsis "${__json__}")\n"
            exit 0
        fi
    fi
    _echo_info "$(_get_function_shoedoc "$0" "$2")\n"
}

## Print this help
##
## @namespace src/shell/help
## @depends src/shell/help/_help
help() {
    _help "$0"
}

## List commands of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk printf realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_warning
## @assumes PRIMARY SUCCESS WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_commands() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_commands: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_commands: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then _echo_error "_print_commands: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_warning
## @assumes EOL INFO PRIMARY SUCCESS WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_constants() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_constants: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_constants: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-12}"
    if [ ! -f "$1" ]; then _echo_error "_print_constants: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Constants:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" -v INFO="${_INFO}" -v WARNING="${_WARNING}" -v EOL="${_EOL}" \
    '/^[A-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && substr($0,1,1) != "_")
        printf "%s  %-'"$2"'s %s%s%s (value: %s%s%s)%s",SUCCESS,$1,PRIMARY,substr(PREV,4),INFO,WARNING,$2,INFO,EOL
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print provided text formatted as a description (used by "help" command)
##
## @namespace src/shell/help
## @requires fold printf
## @depends src/shell/colors/_echo_primary src/shell/colors/_echo_warning
## @param {str} <DESCRIPTION> (required) A string containing script description.
_print_description() {
    _echo_warning 'Description:\n'
    _echo_primary "$(printf '%s' "$1" | fold -w 64 -s)\n\n" 2
}

## List flags of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_warning
## @assumes PRIMARY SUCCESS
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_flags() {
    if [ -z "$1" ]; then _echo_error '_print_flags: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_flags: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then _echo_error "_print_flags: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Flags:\n'
    awk -F '=' -v SUCCESS="${_SUCCESS}" -v PRIMARY="${_PRIMARY}" '/^[a-zA-Z0-9_]+=false$/ {
        if (substr(PREV, 1, 3) == "## " && $1 != toupper($1) && substr($0, 1, 1) != "_")
        printf "%s  --%-'"$2"'s %s%s\n",SUCCESS,$1,PRIMARY,substr(PREV,4)
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print infos of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires printf realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_primary src/shell/colors/_echo_success src/shell/colors/_echo_warning src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_tag
## @param {file} <FILE_PATH> (required) The path to the input file.
_print_infos() {
    if [ -z "$1" ]; then _echo_error '_print_infos: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_infos: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_infos: \"$1\" file not found\n"; return 1; fi

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
## @requires awk realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_warning
## @assumes DEFAULT EOL INFO SUCCESS WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {int} <PADDING> (default:12) Padding length.
_print_options() {
    # note: "awk: %*x formats are not supported"

    if [ -z "$1" ]; then _echo_error '_print_options: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_options: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" $((${2:-12}-2))
    if [ ! -f "$1" ]; then _echo_error "_print_options: \"$1\" file not found\n"; return 1; fi

    _echo_warning "Options:\n"
    awk  -F '=' -v WARNING="${_WARNING}" -v SUCCESS="${_SUCCESS}" -v INFO="${_INFO}" -v DEFAULT="${_DEFAULT}" -v EOL="${_EOL}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) == "## " && $1 != toupper($1) && $2 != "false" && substr($0,1,1) != "_") {
            if (match(PREV,/ \/.+\//)) {
                # if option has constaint
                CONSTRAINT=substr(PREV,RSTART,RLENGTH);
                ANNOTATION=substr(PREV,4,length(PREV)-length(CONSTRAINT)-3);
                printf "%s  --%-'"$2"'s %s%s%s %s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,SUCCESS,CONSTRAINT,INFO,WARNING,$2,INFO,EOL
            } else {
                ANNOTATION=substr(PREV,4);
                printf "%s  --%-'"$2"'s %s%s%s (default: %s%s%s)%s",SUCCESS,$1,DEFAULT,ANNOTATION,INFO,WARNING,$2,INFO,EOL
            }
        }
    } { PREV = $0 }' "$1"
    printf '\n'
}

## Print usage of the provided shoe script (used by "help" command)
##
## @namespace src/shell/help
## @requires awk basename realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_success src/shell/colors/_echo_warning
## @assumes DEFAULT INFO SUCCESS WARNING
## @param {file} <FILE_PATH> (required) The path to the input file.
_print_usage() {
    if [ -z "$1" ]; then _echo_error '_print_usage: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_usage: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_print_usage: \"$1\" file not found\n"; return 1; fi

    _echo_warning 'Usage:\n'
    _echo_info "sh $(basename "$1") <" 2; _echo_success 'command'; _echo_info '> '
    # options
    awk -F '=' -v INFO="${_INFO}" -v SUCCESS="${_SUCCESS}" -v WARNING="${_WARNING}" -v DEFAULT="${_DEFAULT}" \
    '/^[a-zA-Z0-9_]+=.+$/ {
        if (substr(PREV,1,3) != "## " || $1 == toupper($1) || substr($1,1,1) == "_") next;
        if ($2 == "false") {printf "%s[%s--%s%s]%s ",INFO,SUCCESS,$1,INFO,DEFAULT;next}
        printf "%s[%s--%s %s%s%s]%s ",INFO,SUCCESS,$1,WARNING,$2,INFO,DEFAULT
    } {PREV = $0} END {print "\n"}' "$1"
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
    help
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_copy_install() {
    if [ -z "$1" ]; then _echo_error '_copy_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_copy_install: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_copy_install: \"$1\" file not found\n"; return 1; fi

    # -a, --archive    same as -dR --preserve=all
    _echo_info "sudo cp --archive \"$1\" \"/usr/local/bin/$2\"\n"
    sudo cp --archive "$1" "/usr/local/bin/$2"
}

## Generates an autocomplete script for the provided file
##
## This function creates a completion script named "<ALIAS>-completion.sh" in the same directory as the script itself.
## Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.
## Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins
##
## @namespace src/shell/install
## @requires basename dirname printf realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/install/_get_comspec
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_autocomplete: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_autocomplete: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/install/_get_comspec
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_generate_global_autocomplete() {
    if [ -z "$1" ]; then _echo_error '_generate_global_autocomplete: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_generate_global_autocomplete: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_global_autocomplete: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_comspec: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/install/_copy_install src/shell/install/_generate_autocomplete src/shell/install/_generate_global_autocomplete src/shell/install/_set_completion_autoload src/shell/install/_symlink_install src/shell/system/_is_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_install() {
    if [ -z "$1" ]; then _echo_error '_install: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_install: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}" "${3:-false}"
    if [ ! -f "$1" ]; then _echo_error "_install: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_remove_completion_autoload() {
    if [ $# -lt 1 ]; then _echo_error '_remove_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove_completion_autoload: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_remove_completion_autoload: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_danger src/shell/install/_update src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_tag
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i src/shell/strings/_collapse_blank_lines
## @param {file} <SHELL_CONFIG_FILE> (required) The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
## @param {file} <SCRIPT_FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_set_completion_autoload() {
    if [ -z "$1" ]  || [ -z "$2" ]; then _echo_error '_set_completion_autoload: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_completion_autoload: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$(realpath "$2")" "${3:-"$(basename "$2" .sh)"}"
    if [ ! -f "$1" ]; then _echo_error "_set_completion_autoload: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_set_completion_autoload: \"$2\" file not found\n"; return 1; fi

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
## @requires basename ln realpath sudo true
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
_symlink_install(){
    if [ -z "$1" ]; then _echo_error '_symlink_install some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_symlink_install too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_symlink_install \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(basename "$1" .sh)"}"

    _echo_info "sudo ln -s \"$1\" \"/usr/local/bin/$2\" || true\n"
    sudo ln -s "$1" "/usr/local/bin/$2" || true
}

## Uninstall script from system
##
## @namespace src/shell/install
## @requires basename dirname realpath rm sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/install/_remove_completion_autoload
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
## @requires basename curl realpath wget
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/install/_install src/shell/install/_uninstall src/shell/system/_is_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <URL> (required) The URL of the script to download and install.
## @param {str} <ALIAS> The alias of the script to install. Defaults to the basename of the provided file.
## @param {bool} <GLOBAL> (default:false) Install globally.
_update() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_update: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 4 ]; then _echo_error "_update: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_update: \"$1\" file not found\n"; return 1; fi

    set -- "$(realpath "$1")" "$2" "${3:-"$(basename "$1" .sh)"}" "${4:-false}"

    if _is_installed curl; then
        _echo_info "curl -sSL \"$2\" > \"$1\"\n"
        curl -sSL "$2" > "$1"

    elif _is_installed  wget; then
        _echo_info "wget -qO - \"$2\" > \"$1\"\n"
        wget -qO - "$2" > "$1"

    else
        _echo_error "\"$0)\" requires curl, try: \"sudo apt-get install -y curl\"\n"
        return 1
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
## @requires awk basename cat dirname grep printf realpath tr
## @depends src/shell/colors/_alert_primary src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/shoedoc/_get_script_shoedoc src/shell/shoedoc/_get_shoedoc_description src/shell/shoedoc/_get_shoedoc_tag src/shell/shoedoc/_get_shoedoc_title
## @assumes _ALERT_DANGER _ALERT_INFO _ALERT_PRIMARY _ALERT_SECONDARY _ALERT_SUCCESS _ALERT_WARNING _DANGER _DEFAULT _EOL _INFO _PRIMARY _SECONDARY _SUCCESS _WARNING
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {folder} <DESTINATION> The path to the destination folder. Defaults to file parent.
## @param {str} <OUTPUT_FILE_NAME> The name for the generated Makefile. Defaults to "<BASENAME>.makefile".
_generate_makefile() {
    if [ -z "$1" ]; then _echo_error '_generate_makefile: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_generate_makefile: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-"$(realpath "$(dirname "$1")")"}" "${3:-"$(basename "$1" .sh).makefile"}"
    if [ ! -f "$1" ]; then _echo_error "_generate_makefile: \"$1\" file not found\n"; return 1; fi
    if [ ! -d "$2" ]; then _echo_error "_generate_makefile: \"$2\" folder not found\n"; return 1; fi

    # check valid input file type
    if [ "$(printf '%s' "$1" | grep -oE '\.[a-zA-Z0-9]+$')" != .sh ]; then _echo_error '_generate_makefile: file should be type ".sh"\n'; return 1; fi

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

    # generate rules
    awk -v SHELL_SCRIPT="$(basename "$1")" \
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

## Downloads file with either curl or wget
##
## @namespace src/shell/network
## @requires curl dirname grep head mkdir wget
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_is_installed
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

## Open in default browser
##
## @namespace src/shell/network
## @requires nohup
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_open
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {folder} <DOCROOT> (required) The path to the root directory.
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
_php_serve() {
    _check_installed php

    if [ -z "$1" ]; then _echo_error '_php_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_php_serve: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then _echo_error "_php_serve: \"$1\" folder not found\n"; return 1; fi

    _echo_info "php -d memory-limit=-1 -S \"$2:$3\" -t \"$1\"\n"
    php -d memory-limit=-1 -S "$2:$3" -t "$1"
}

## Serve given local directory with Python 3
##
## @namespace src/shell/network
## @requires python3 realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_check_installed
## @param {folder} <DOCROOT> (required) The path to the root directory.
## @param {str} <IP> (default:"127.0.0.1") Target IP address or domain.
## @param {int} <PORT> /^[0-9]{1,5}$/ (default:"8080") Destination port.
_py_serve() {
    _check_installed python3

    if [ -z "$1" ]; then _echo_error '_py_serve: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_py_serve: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "${2:-127.0.0.1}" "${3:-8080}"
    if [ ! -d "$1" ]; then _echo_error "_php_serve: \"$1\" folder not found\n"; return 1; fi

    _echo_info "python3 -m http.server --directory \"$1\" --bind \"$2\" \"$3\"\n"
    python3 -m http.server --directory "$1" --bind "$2" "$3"
}

## Remove hostname from /etc/hosts
##
## @namespace src/shell/network
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
## @param {str} <HOSTNAME> (required) The hostame to unset locally.
_remove_host() {
    if [ -z "$1" ]; then _echo_error '_remove_host: some mandatory parameter is missing\n'; return 1; fi

    _echo_info "sudo $(_sed_i) \"/$1/d\" /etc/hosts\n"
    eval "sudo $(_sed_i) \"/$1/d\" /etc/hosts"
}

## Set new host in /etc/hosts
##
## @namespace src/shell/network
## @requires sudo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/network/_remove_host
## @param {str} <HOSTNAME> (required) The hostame to set locally.
_set_host() {
    if [ -z "$1" ]; then _echo_error '_set_host: some mandatory parameter is missing\n'; return 1; fi

    _remove_host "$1"

    _echo_info "sudo /bin/sh -c \"echo \\\"127.0.0.1    $1\\\" >> /etc/hosts\"\n"
    sudo /bin/sh -c "echo \"127.0.0.1    $1\" >> /etc/hosts"
}

#--------------------------------------------------
#_ Prompts
#--------------------------------------------------

## Present user with a list of choices and prompt them to select one
##
## @namespace src/shell/prompts
## @requires cut echo
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_success src/shell/colors/_echo_warning
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
## @depends src/shell/colors/_echo_success src/shell/colors/_echo_warning
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

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_constants: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_constraint: \"$1\" file not found\n"; return 1; fi

    awk -F '=' -v NAME="$2" \
    '/^## /{if (annotation=="") annotation=substr($0,4)}
    /^[a-zA-Z0-9_]+=.+$/ {
        if (annotation!="" && $1 == NAME) {
            match(annotation, /\/.+\//); print substr(annotation, RSTART, RLENGTH)
        }
    } !/^## */{annotation=""}' "$1"
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

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_flags: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_function: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_functions_names: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")" "${2:-false}"
    if [ ! -f "$1" ]; then _echo_error "_get_options: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_padding: \"$1\" file not found\n"; return 1; fi

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

## Print function synopsis from a JSON string.
##
## @namespace src/shell/reflexion
## @requires jq printf
## @depends src/shell/colors/_echo_error
## @param {json} <JSON> (required) The input string containing raw JSON.
## @param {bool} <MARKDOWN_FORMAT> (default:false) If set to "true", returns result as markdown.
_print_synopsis() {
    if [ -z "$1" ]; then _echo_error '_print_synopsis: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_print_synopsis: too many arguments ($#)\n"; return 1; fi
    if ! printf '%s' "$1" | jq empty >/dev/null 2>&1; then _echo_error "_print_synopsis: invalid JSON input\n"; return 1; fi

    if [ "${2:-false}" = "true" ]; then
        printf '> Synopsis:\n> '
    else
        printf 'Synopsis: '
    fi

    printf '%s' "$1" | jq -rj '.name'

    if [ "${2:-false}" = "true" ]; then
        printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then " &lt;\(.name)&gt;" else " [\(.name)]" end] | join("")'
        printf '\n'
        printf '%s' "$1" | jq -r '.parameters // [] | .[] | "`\(.name)`: \(if .type then "_(type: \"\(.type)\")_ " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " _Defaults to \"\(.default|tostring)\"._" else "" end)"' | while read -r line; do
            printf '%s\n' "- ${line}"
        done
        printf '\n'
        printf '%s' "$1" | jq -rj '[.requires // [] | .[] | "`\(.)`"] | if length > 0 then "- ⚠️ Requires: \(.|join(", "))\n" else "" end'
        printf '%s' "$1" | jq -rj '[.depends // [] | .[] | "`\(.)`"] | if length > 0 then "- 🔗 Depends: \(.|join(", "))\n" else "" end'
        printf '\n'
        return 0
    fi

    printf '%s' "$1" | jq -rj 'if .scope then " (\(.scope)) " else "" end'
    printf '%s' "$1" | jq -rj '[.parameters // [] | .[] | if (.nullable|tostring) == "false" then "<\(.name)>" else "[\(.name)]" end] | join(" ")'
    printf '\n'
    printf '%s' "$1" | jq -r '.parameters // [] | .[] | "\(.name): \(if .type then "(\(.type)) " else "" end)\(if (.nullable|tostring) == "false" then "" else "(optional) " end)\(if .description then .description else "" end)\(if has("default") then " Defaults to \"\(.default|tostring)\"." else "" end)"' | while read -r line; do
        printf '    %s\n' "${line}"
    done
    printf '%s' "$1" | jq -rj '[.requires // [] | .[]] | if length > 0 then "    Requires: \(.|join(", "))\n" else "" end'
    printf '%s' "$1" | jq -rj '[.depends // [] | .[]] | if length > 0 then "    Depends: \(.|join(", "))\n" else "" end'
    printf '\n'
}

## Set value for given parameter into provided file ".env" or ".sh" file
##
## @namespace src/shell/reflexion
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/colors/_echo_warning src/shell/compatibility/_sed_i src/shell/reflexion/_get_parameter src/shell/reflexion/_has_parameter
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <KEY> (required) The variable name to get from provided file.
## @param {str} <VALUE> (required) The value to be set to provided file.
_set_parameter() {
    if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then _echo_error '_set_parameter: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 3 ]; then _echo_error "_set_parameter: too many arguments ($#)\n"; return 1; fi
    if [ ! -f "$1" ]; then _echo_error "_set_parameter: \"$1\" file not found\n"; return 1; fi

    # set default values
    set -- "$(realpath "$1")" "$2" "$3"

    if ! _has_parameter "$1" "$2"; then
        _echo_error "_set_parameter: \"$2\" parameter not found\n"

        return 1
    fi

    if [ "$(_get_parameter "$1" "$2")" = "$3" ]; then
        _echo_warning "warning: _set_parameter: \"$2\" parameter unchanged\n"

        return 0
    fi

    _echo_info "$(_sed_i) -E \"s/^$2=.*/$2=$3/\" \"$1\"\n"
    $(_sed_i) -E "s/^$2=.*/$2=$3/" "$1"
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

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_get_function_shoedoc: \"$1\" file not found\n"; return 1; fi

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

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_get_script_shoedoc: \"$1\" file not found\n"; return 1; fi

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
            if (index($0, "{") > 0) exit;
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

## Return function shoedoc as json
##
## @namespace src/shell/shoedoc
## @requires cut head jq printf realpath sed
## @depends src/shell/colors/_echo_error src/shell/shoedoc/_get_function_shoedoc
## @param {file} <SCRIPT_PATH> (required) The path to the input script.
## @param {str} <FUNCTION_NAME> (required) The name of the function to retrieve.
_parse_shoedoc() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_parse_shoedoc: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_parse_shoedoc: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_parse_shoedoc: \"$1\" file not found\n"; return 1; fi

    set -- "$1" "$2" "$(printf '%s' "$(_get_function_shoedoc "$1" "$2" | sed -nE 's/^ *#+ *//p')")"
    set -- "$1" "$2" "$3" "$(printf '%s' "$3" | sed -n '/^{/,$p')" "$(printf '%s' "$3" | head -n 1)"

    if [ "$(printf '%s' "$2" | cut -c1)" = "_" ]; then
        set -- "$1" "$2" "$3" "$4" "$5" 'private'
    else
        set -- "$1" "$2" "$3" "$4" "$5" 'public'
    fi
    # $1: SCRIPT_PATH, $2: FUNCTION_NAME, $3: annotation, $4 json, $5: summary, $6: scope

    if [ -z "$4" ]; then
        jq --null-input \
            --arg name "$2" \
            --arg summary "$5" \
            --arg scope "$6" \
            '$ARGS.named'

        return 0
    fi

    jq --null-input \
    --arg name "$2" \
    --arg summary "$5" \
    --arg scope "$6" \
    '$ARGS.named + '"$4"
}

#--------------------------------------------------
#_ Strings
#--------------------------------------------------

## Collapse blank lines with "sed"
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
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

## Remove every line in target file that contains substrings from source file
##
## @namespace src/shell/strings
## @requires realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/compatibility/_sed_i
## @param {file} <SOURCE_PATH> (required) The path to the file containing the substrings to remove.
## @param {file} <TARGET_PATH> (required) The path to the target file to deduplicate.
_dedupe_lines() {
    if [ -z "$1" ] || [ -z "$2" ]; then _echo_error '_dedupe_lines: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_dedupe_lines: too many arguments ($#)\n"; return 1; fi
    set -- "$(realpath "$1")" "$(realpath "$2")"
    if [ ! -f "$1" ]; then _echo_error "_dedupe_lines: \"$1\" file not found\n"; return 1; fi
    if [ ! -f "$2" ]; then _echo_error "_dedupe_lines: \"$2\" file not found\n"; return 1; fi

    while read -r __substring__; do
        _echo_info "$(_sed_i) \"/${__substring__}/d\" \"$2\"\n"
        $(_sed_i) "/${__substring__}/d" "$2"
    done < "$1"
}

## Generate random 32 bit string
##
## @namespace src/shell/strings
## @requires openssl
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_generate_key() {
    _check_installed openssl

    _echo_info 'openssl rand -hex 16\n'
    openssl rand -hex 16
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
    printf '%s' "$1" | tr -s ' ' | sed 's/^ \+//' | sed 's/ \+$//'
}

#--------------------------------------------------
#_ Symfony
#--------------------------------------------------

## Install project dependencies with composer
##
## @namespace src/shell/symfony
## @requires composer install
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed src/shell/system/_pwd
_composer_install() {
    _check_installed composer

    _echo_info "composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir=\"$(_pwd)\"\n"
    composer install --no-interaction --prefer-dist --optimize-autoloader --working-dir="$(_pwd)"
}

## Update project dependencies with composer
##
## @namespace src/shell/symfony
## @requires composer
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_console
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
## @depends src/shell/colors/_echo_info src/shell/symfony/_console src/shell/system/_check_installed
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_is_installed
_sf_security() {
    if "$(_is_installed symfony)"; then
        _echo_info 'symfony security:check\n'
        symfony security:check

        return 0
    fi

    if "$(_is_installed composer)"; then
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
## @depends src/shell/colors/_echo_info src/shell/system/_check_installed
_sf_serve() {
    _check_installed symfony

    _echo_info 'symfony local:server:start --no-tls\n'
    symfony local:server:start --no-tls
}

## Run test with PHPUnit
##
## @namespace src/shell/symfony
## @requires php realpath
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/symfony/_phpunit
## @param {file} <FILE_PATH> The path to the input file.
_sf_test() {
    if [ $# -gt 1 ]; then _echo_error "_sf_tests: too many arguments ($#)\n"; return 1; fi

    if [ -z "$1" ]; then
        _echo_info "php -d memory-limit=-1 \"$(_phpunit)\" --stop-on-failure\n"
        php -d memory-limit=-1 "$(_phpunit)" --stop-on-failure

        return 0
    fi

    set -- "$(realpath "$1")"
    if [ ! -f "$1" ]; then _echo_error "_sf_tests: \"$1\" file not found\n"; return 1; fi

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
## @depends src/shell/colors/_echo_error src/shell/system/_get_package_name src/shell/system/_is_installed
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

## Print default package manager
##
## @namespace src/shell/system
## @requires apt apt-get echo snap
## @depends src/shell/colors/_echo_error src/shell/system/_is_installed
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

## Validate a file checksum
##
## @namespace src/shell/system
## @requires awk grep realpath set sha256sum
## @depends src/shell/colors/_echo_error src/shell/system/_check_installed
## @param {file} <FILE_PATH> (required) The path to the input file.
## @param {str} <SHA256SUM> (required) A string containing file checksum.
_is_checksum_valid() {
    _check_installed sha256sum

    if [ $# -lt 2 ]; then _echo_error '_is_checksum_valid: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_is_checksum_valid: too many arguments ($#)\n"; return 1; fi

    set -- "$(realpath "$1")" "$2"
    if [ ! -f "$1" ]; then _echo_error "_is_checksum_valid: \"$1\" file not found\n"; return 1; fi

    sha256sum "$1" | awk '{print $1}' | grep -q "$2"
}

## Check current desktop is gnome
##
## @namespace src/shell/system
## @assumes XDG_CURRENT_DESKTOP
_is_gnome() {
    if [ "${XDG_CURRENT_DESKTOP}" != 'ubuntu:GNOME' ]; then

        return 1
    fi

    return 0
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

## Check current environment is Termux
##
## @namespace src/shell/system
_is_termux() {
    if [ ! -d '/data/data/com.termux' ]; then

        return 1
    fi

    return 0
}

## Return current project directory realpath, or "pwd" when installed globally
##
## @namespace src/shell/system
## @requires dirname pwd realpath
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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_get_package_manager src/shell/system/_get_package_name src/shell/system/_is_installed
## @param {str} <PACKAGE> (required) The command/package to remove.
## @param {str} <PACKAGE_MANAGER> (default:"apt") The package manager required to remove the package with.
_remove() {
    if [ -z "$1" ]; then _echo_error '_remove: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_remove: too many arguments ($#)\n"; return 1; fi

    if ! _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_get_package_manager)}"

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
## @depends src/shell/colors/_echo_error src/shell/colors/_echo_info src/shell/system/_get_package_manager src/shell/system/_get_package_name src/shell/system/_is_installed
## @param {str} <PACKAGE> (required) The command/package to remove.
## @param {str} <PACKAGE_MANAGER> (default:"apt") The package manager required to remove the package with.
_require() {
    if [ -z "$1" ]; then _echo_error '_require: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 2 ]; then _echo_error "_require: too many arguments ($#)\n"; return 1; fi

    if _is_installed "$1"; then
        return 0
    fi

    # set default values
    set -- "$(_get_package_name "$1")" "${2:-$(_get_package_manager)}"

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

## Checks if variable is valid given regex constraint
##
## @namespace src/shell/validation
## @requires grep printf sed
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

    # remove leading and ending forward slashes from regular expression
    set -- "$1" "$(printf '%s' "$2" | sed 's@^/@@;s@/$@@')"

    # if [ "$1" != "$(printf '%s' "$1" | awk "$2 {print}")" ]; then
    if [ "$1" != "$(printf '%s' "$1" | grep -E "$2")" ]; then

        return 1
    fi

    return 0
}

## Find constraints and validates a variable
##
## @namespace src/shell/validation
## @requires cut printf
## @depends src/shell/colors/_echo_error src/shell/reflexion/_get_constraint src/shell/validation/_is_valid
## @param {str} <VARIABLE> (required) The variable to validate in the followling format : variable_name=value.
_validate() {
    if [ -z "$1" ]; then _echo_error '_validate: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_validate: too many arguments ($#)\n"; return 1; fi

    set -- "$(printf '%s' "$1" | cut -d= -f1)" "$(printf '%s' "$1" | cut -d= -f2)" "$(_get_constraint "$0" "$(printf '%s' "$1" | cut -d= -f1)")"

    if ! _is_valid "$2" "$3"; then
        _echo_error "invalid \"$1\", expected \"$3\", \"$2\" given\n"
        exit 1
    fi
}

#--------------------------------------------------
#_ Kernel
#--------------------------------------------------

## Shoe Kernel
##
## @namespace src/shell/kernel
## @requires awk false grep printf true
## @depends src/shell/colors/_echo_error src/shell/help/_help src/shell/hooks/_after src/shell/hooks/_before src/shell/hooks/_default src/shell/reflexion/_get_flags src/shell/reflexion/_get_functions_names src/shell/reflexion/_get_options src/shell/validation/_validate
_kernel() {
    # Check for duplicate function definitions
    __functions_names__=$(_get_functions_names "$0" true)
    for __function__ in ${__functions_names__}; do
        if [ "$(printf "%s" "${__functions_names__}" | grep -cx "${__function__}")" -gt 1 ]; then
            _echo_error "function \"${__function__}\" is defined multiple times\n"
            exit 1
        fi
    done

    if [ $# -lt 1 ]; then _default; exit 0; fi

    __execution_stack__=''
    __requires_value__=''

    for __argument__ in "$@"; do
        __is_valid__=false

        # Handle required value for previous option
        if [ -n "${__requires_value__}" ]; then
            _validate "${__requires_value__}=${__argument__}"
            eval "${__requires_value__}=\"${__argument__}\";"
            __requires_value__=''
            continue
        fi

        # Check if argument is a flag or option (starts with - or --)
        if printf '%s' "${__argument__}" | grep -Eq '^--?[a-zA-Z0-9_]+$'; then
            for __type__ in flag option; do
                __parameters__="$(_get_flags "$0")"
                [ "$__type__" = 'option' ] && __parameters__="$(_get_options "$0")"
                for __parameter__ in $__parameters__; do
                    __shorthand__="$(printf '%s' "${__parameter__}" | awk '{print substr($0,1,1)}')"
                    if [ "${__argument__}" = "--${__parameter__}" ] || [ "${__argument__}" = "-${__shorthand__}" ]; then
                        if [ "$__type__" = 'flag' ]; then
                            eval "${__parameter__}=true"
                        else
                            __requires_value__="${__parameter__}"
                        fi
                        __is_valid__=true
                        break 2
                    fi
                done
            done
            if [ "${__is_valid__}" = false ]; then
                _echo_error "\"${__argument__}\" is not a valid parameter\n"
                exit 1
            fi
            continue
        fi

        # Check if argument is a function name or its shorthand
        for __function__ in $(_get_functions_names "$0"); do
            __shorthand__="$(printf '%s' "${__function__}" | awk '{print substr($0,1,1)}')"
            if [ "${__argument__}" = "${__function__}" ] || [ "${__argument__}" = "${__shorthand__}" ]; then
                __execution_stack__="${__execution_stack__} ${__function__}"
                __is_valid__=true
                break
            fi
        done
        if [ "${__is_valid__}" = false ]; then
            _echo_error "\"${__argument__}\" is not a valid command\n"
            exit 1
        fi
    done

    if [ -n "${__requires_value__}" ]; then
        _echo_error "\"--${__requires_value__}\" requires value\n"
        exit 1
    fi

    [ -n "$(command -v _before)" ] && _before

    if printf '%s' "${__execution_stack__}" | grep -qw 'help'; then
       _help "$0" "$(printf '%s' "${__execution_stack__}" | awk '{for(i=1;i<=NF;i++) if($i=="help") print $(i+1); exit}')"
       exit 0
    fi

    if [ -z "${__execution_stack__}" ]; then _default; exit 0; fi

    for __function__ in ${__execution_stack__}; do
        eval "${__function__}"
    done

    [ -n "$(command -v _after)" ] && _after
}

_kernel "$@"

