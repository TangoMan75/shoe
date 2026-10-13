#!/bin/sh

## {
##   "namespace": "src/shell/system",
##   "summary": "Animate a spinner in the terminal for a given amout of time",
##   "requires": [
##     "awk",
##     "printf",
##     "sleep"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "DURATION",
##       "description": "Animation duration in miliseconds.",
##       "type": "int",
##       "default": 0
##     }
##   ]
## }
_spin() {
    set -- "$((${1:-0}/10))" 0 0

    while [ "$1" -gt "$2" ]; do
        printf '\r%s' "$(printf "|/-\\" | awk -v I="$3" '{print substr($0, I, 1)}')"
        set -- "$1" "$(( $2+1 ))" "$(( $3%4+1 ))"
        sleep 0.1
    done
}

