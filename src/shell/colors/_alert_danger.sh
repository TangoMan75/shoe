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
_alert_danger()    {
    # Synopsis: _alert_danger <STRING>
    #   STRING: Text to display.

    printf "${_EOL}%b%64s${_EOL}%b %-63s${_EOL}%b%64s${_EOL}\n" "${_ALERT_DANGER}" '' "${_ALERT_DANGER}" "$1" "${_ALERT_DANGER}" ''
}
