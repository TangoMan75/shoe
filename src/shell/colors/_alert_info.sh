#!/bin/sh

## Print info alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_INFO _EOL
## @param {str} <STRING> (required) Text to display.
_alert_info()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}

