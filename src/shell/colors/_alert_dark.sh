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
_alert_dark()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DARK}" '' "${_ALERT_DARK}" "$1" "${_ALERT_DARK}" ''
}
