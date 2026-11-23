#!/bin/sh

## bright white text
_PRIMARY='\033[97m'

## bright blue text
_SECONDARY='\033[94m'

## bright green text
_SUCCESS='\033[32m'

## red text
_DANGER='\033[31m'

## orange text
_WARNING='\033[33m'

## bright purple text
_INFO='\033[95m'

## gray text
_MUTED='\033[90m'

## light gray background with dark gray text
_LIGHT='\033[47;90m'

## black background with light gray text
_DARK='\033[40;37m'

## reset formatting
_DEFAULT='\033[0m'

## reset formatting and carriage return
_EOL='\033[0m\n'

# Disable the colour constants when stdout is not a terminal, when TERM is
# "dumb", or when NO_COLOR is set. Sourced after the echo and alert constant
# files, so these empty assignments take effect.
if [ ! -t 1 ] || [ "${TERM:-}" = 'dumb' ] || [ -n "${NO_COLOR:-}" ]; then
    _PRIMARY=''
    _SECONDARY=''
    _SUCCESS=''
    _DANGER=''
    _WARNING=''
    _INFO=''
    _MUTED=''
    _LIGHT=''
    _DARK=''
    _DEFAULT=''
    _EOL='\n'
fi

