#!/bin/sh

## {
##   "namespace": "src/shell/colors",
##   "summary": "Print warning alert",
##   "requires": [
##     "printf"
##   ],
##   "assumes": [
##     "_ALERT_WARNING",
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
_alert_warning()   {
    # Synopsis: _alert_warning <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_WARNING}" '' "${_ALERT_WARNING}" "$1" "${_ALERT_WARNING}" ''
}
