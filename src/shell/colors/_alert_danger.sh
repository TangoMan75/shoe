#!/bin/sh

## Print danger alert
##
## @namespace src/shell/colors
## @requires printf
## @assumes _ALERT_DANGER _EOL
## @param {str} <STRING> (required) Text to display.
_alert_danger()    {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}

