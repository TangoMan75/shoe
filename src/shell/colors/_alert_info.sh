#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print info alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_INFO",
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
_alert_info()      {
    # Synopsis: _alert_info <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_INFO}" '' "${_ALERT_INFO}" "$1" "${_ALERT_INFO}" ''
}
