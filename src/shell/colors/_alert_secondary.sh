#!/bin/sh

## Print secondary alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_SECONDARY _EOL
## @param {str} <STRING> (required) Text to display.
_alert_secondary() {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}

