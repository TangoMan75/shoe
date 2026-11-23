#!/bin/sh

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

## bold white text over dark gray background
_ALERT_MUTED='\033[1;100;97m'

## bold dark gray text over light gray background
_ALERT_LIGHT='\033[1;47;90m'

## bold white text over black background
_ALERT_DARK='\033[1;40;37m'

# Disable the colour constants when stdout is not a terminal, when TERM is
# "dumb", or when NO_COLOR is set. Sourced after the echo and alert constant
# files, so these empty assignments take effect.
if [ ! -t 1 ] || [ "${TERM:-}" = 'dumb' ] || [ -n "${NO_COLOR:-}" ]; then
    _ALERT_PRIMARY=''
    _ALERT_SECONDARY=''
    _ALERT_SUCCESS=''
    _ALERT_DANGER=''
    _ALERT_WARNING=''
    _ALERT_INFO=''
    _ALERT_MUTED=''
    _ALERT_LIGHT=''
    _ALERT_DARK=''
fi

