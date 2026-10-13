#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print success alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_SUCCESS",
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
_alert_success()   {
    # Synopsis: _alert_success <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}
