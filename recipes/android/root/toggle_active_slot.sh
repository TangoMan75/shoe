#!/bin/sh

## Toggle active slot
toggle_active_slot() {
    _echo_info 'fastboot set_active other\n'
    fastboot set_active other
}

