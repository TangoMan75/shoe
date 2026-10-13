#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print secondary alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_SECONDARY",
##     "_EOL"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "required": true
##     }
##   ]
## }
_alert_secondary() {
    # Synopsis: _alert_secondary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SECONDARY}" '' "${_ALERT_SECONDARY}" "$1" "${_ALERT_SECONDARY}" ''
}
