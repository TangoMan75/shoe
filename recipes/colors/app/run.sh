#!/bin/sh

## {
##   "namespace": "recipes/colors/app",
##   "summary": "Color test",
##   "requires": [
##     "printf"
##   ],
##   "depends": [
##     "src/shell/colors/_alert_danger",
##     "src/shell/colors/_alert_dark",
##     "src/shell/colors/_alert_info",
##     "src/shell/colors/_alert_light",
##     "src/shell/colors/_alert_primary",
##     "src/shell/colors/_alert_secondary",
##     "src/shell/colors/_alert_success",
##     "src/shell/colors/_alert_warning",
##     "src/shell/colors/_echo_danger",
##     "src/shell/colors/_echo_dark",
##     "src/shell/colors/_echo_error",
##     "src/shell/colors/_echo_info",
##     "src/shell/colors/_echo_light",
##     "src/shell/colors/_echo_primary",
##     "src/shell/colors/_echo_secondary",
##     "src/shell/colors/_echo_success",
##     "src/shell/colors/_echo_warning"
##   ]
## }
run() {
    _alert_primary   '_alert_primary'
    _alert_secondary '_alert_secondary'
    _alert_success   '_alert_success'
    _alert_danger    '_alert_danger'
    _alert_warning   '_alert_warning'
    _alert_info      '_alert_info'
    _alert_light     '_alert_light'
    _alert_dark      '_alert_dark'

    _echo_primary   '_echo_primary\n'
    _echo_secondary '_echo_secondary\n'
    _echo_success   '_echo_success\n'
    _echo_danger    '_echo_danger\n'
    _echo_warning   '_echo_warning\n'
    _echo_info      '_echo_info\n'
    # If you are printing the reset after a newline the terminal will "bleed" the last background color used into the next empty space or line
    _echo_light     "_echo_light${_EOL}"
    _echo_dark      "_echo_dark${_EOL}"
    _echo_error     '_echo_error\n'

    printf '\n--- Standard 16 Colors ---\n'
    i=0
    while [ "$i" -le 15 ]; do
        # This is the ANSI escape sequence for setting the background color.
        # 48 specifies background (use 38 for foreground text),
        # and 5 indicates we are using the 256-color lookup table.
        printf '\033[48;5;%dm  %3d  \033[0m' "$i" "$i"

        if [ $(( (i + 1) % 8 )) -eq 0 ]; then
            printf '\n'
        fi
        i=$((i + 1))
    done

    printf '\n--- 256 Color Palette ---\n'
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

