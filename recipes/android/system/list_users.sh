#!/bin/sh

## Print user list
list_users() {
    _echo_info 'adb shell pm list users\n'
    adb shell pm list users
}

