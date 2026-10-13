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
_alert_light()      {
    # Synopsis: _alert_light <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_LIGHT}" '' "${_ALERT_LIGHT}" "$1" "${_ALERT_LIGHT}" ''
}
