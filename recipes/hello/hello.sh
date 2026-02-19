#!/bin/bash

## {
##   "namespace": "recipes/shoe",
##   "summary": "Hello World!",
##   "description": "Greets a specified user a given number of times.\nAccepts an optional recipient name and an optional repetition count.\nUseful as a smoke test for new installations.",
##   "authors": [
##     {
##       "name": "Matthias Morin",
##       "email": "mat@tangoman.io",
##       "homepage": "https://tangoman.io"
##     }
##   ],
##   "version": "1.0.0",
##   "license": "MIT",
##   "links": [
##     "https://github.com/TangoMan75/shoe"
##   ],
##   "shell": "bash",
##   "requires": [
##     "echo",
##     "getopt",
##     "who"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "who",
##       "description": "The recipient's name.",
##       "type": "str",
##       "constraint": "/^[a-zA-Z-]+$/",
##       "default": "World"
##     }
##   ],
##   "options": [
##     {
##       "name": "count",
##       "description": "The repetition count.",
##       "type": "int",
##       "short": "c",
##       "long": "count",
##       "default": 1
##     }
##   ],
##   "flags": [
##     {
##       "name": "prefix",
##       "description": "Prefix output with a line number.",
##       "short": "p",
##       "long": "prefix"
##     }
##   ]
## }
hello() {
    local who=World
    local count=1
    local prefix=0

    local options
    if ! options=$(getopt -o c:p --long count:,prefix -- "$@"); then
        echo "Usage: hello [who] [-c|--count number] [-p|--prefix]" >&2
        return 1
    fi

    eval set -- "$options"

    while true; do
        case "$1" in
            -c | --count)
                count="$2"
                shift 2
                ;;
            -p | --prefix)
                prefix=1
                shift 1
                ;;
            --)
                shift
                break
                ;;
            *)
                echo "Internal error during option parsing." >&2
                return 1
                ;;
            esac
    done

    local loop=0
    while [ "${loop}" -lt "${count}" ]; do
        if [ "${prefix}" -eq 1 ]; then
            echo "$((loop + 1)): Hello, ${who} !"
        else
            echo "Hello, ${who} !"
        fi
        loop=$((loop+1))
    done
}

