#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print primary alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_PRIMARY",
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
_alert_primary()   {
    # Synopsis: _alert_primary <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_PRIMARY}" '' "${_ALERT_PRIMARY}" "$1" "${_ALERT_PRIMARY}" ''
}
