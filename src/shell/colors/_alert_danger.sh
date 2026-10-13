#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print danger alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_DANGER",
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
_alert_danger()    {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}
