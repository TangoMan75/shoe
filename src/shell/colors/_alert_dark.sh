#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print dark alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_DARK",
##     "_EOL"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "type": "str",
##       "description": "Text to display.",
##       "nullable": false
##     }
##   ]
## }
_alert_dark()      {
    # Synopsis: _alert_dark <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}
