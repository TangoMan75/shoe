#!/bin/sh

## Color test
##
## @namespace recipes/demo/app
## @requires printf true
## @depends src/shell/colors/_alert_danger.sh
## @depends src/shell/colors/_alert_dark.sh
## @depends src/shell/colors/_alert_info.sh
## @depends src/shell/colors/_alert_light.sh
## @depends src/shell/colors/_alert_muted.sh
## @depends src/shell/colors/_alert_primary.sh
## @depends src/shell/colors/_alert_secondary.sh
## @depends src/shell/colors/_alert_success.sh
## @depends src/shell/colors/_alert_warning.sh
## @depends src/shell/colors/_echo_danger.sh
## @depends src/shell/colors/_echo_dark.sh
## @depends src/shell/colors/_echo_error.sh
## @depends src/shell/colors/_echo_info.sh
## @depends src/shell/colors/_echo_light.sh
## @depends src/shell/colors/_echo_muted.sh
## @depends src/shell/colors/_echo_primary.sh
## @depends src/shell/colors/_echo_secondary.sh
## @depends src/shell/colors/_echo_success.sh
## @depends src/shell/colors/_echo_warning.sh
## @assumes _EOL verbose
colors() {
    if [ "${verbose}" = true ]; then
        _echo_warning 'verbose mode enabled\n'
    fi

    _alert_primary   '_alert_primary'
    _alert_secondary '_alert_secondary'
    _alert_success   '_alert_success'
    _alert_danger    '_alert_danger'
    _alert_warning   '_alert_warning'
    _alert_info      '_alert_info'
    _alert_muted     '_alert_muted'
    _alert_light     '_alert_light'
    _alert_dark      '_alert_dark'

    _echo_primary   '_echo_primary\n'
    _echo_secondary '_echo_secondary\n'
    _echo_success   '_echo_success\n'
    _echo_danger    '_echo_danger\n'
    _echo_warning   '_echo_warning\n'
    _echo_info      '_echo_info\n'
    _echo_muted     '_echo_muted\n'

    if [ "${verbose}" = true ]; then
        _echo_warning 'NOTE: If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line\n'
    fi

    _echo_light     "_echo_light${_EOL}"
    _echo_dark      "_echo_dark${_EOL}"

    _echo_error     '_echo_error\n'

    printf '\n'

    _alert_info '--- Standard 16 Colors ---'
    if [ "${verbose}" = true ]; then
        _echo_warning 'NOTE: This is the ANSI escape sequence for setting the background color.\n48 specifies background (use 38 for foreground text),\nand 5 indicates we are using the 256-color lookup table.\n'
    fi
    i=0
    while [ "$i" -le 15 ]; do
        printf '\033[48;5;%dm  %3d  \033[0m' "$i" "$i"

        if [ $(( (i + 1) % 8 )) -eq 0 ]; then
            printf '\n'
        fi
        i=$((i + 1))
    done

    printf '\n'

    _alert_info '--- 256 Color Palette ---'
    i=16
    while [ "$i" -le 255 ]; do
        printf '\033[48;5;%dm  %3d  \033[0m' "$i" "$i"

        if [ $(( (i - 15) % 6 )) -eq 0 ]; then
            printf ' '
        fi
        if [ $(( (i - 15) % 12 )) -eq 0 ]; then
            printf '\n'
        fi
        i=$((i + 1))
    done
}

