#!/bin/sh

## Print light alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_LIGHT _EOL
## @param {str} <STRING> (required) Text to display.
_alert_light()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}

