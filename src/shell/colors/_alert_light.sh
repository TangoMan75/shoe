#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print light alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_LIGHT",
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
_alert_light()      {
    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}
