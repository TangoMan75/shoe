#!/bin/sh

## Print muted alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_MUTED _EOL
## @param {str} <STRING> (required) Text to display.
_alert_muted()     {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_MUTED}" '' "${_ALERT_MUTED}" "$1" "${_ALERT_MUTED}" ''
}

