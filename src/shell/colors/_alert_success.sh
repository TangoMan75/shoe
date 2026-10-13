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
##   "params": [
##     {
##       "position": 1,
##       "name": "STRING",
##       "description": "Text to display.",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
_alert_success()   {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_SUCCESS}" '' "${_ALERT_SUCCESS}" "$1" "${_ALERT_SUCCESS}" ''
}
