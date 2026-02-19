#!/bin/bash

## Hello World!
##
## Greets a specified user a given number of times.
## Accepts an optional recipient name and an optional repetition count.
## Useful as a smoke test for new installations.
##
## @author    "Matthias Morin" <mat@tangoman.io> https://tangoman.io
## @version   1.0.0
## @license   MIT
## @link      https://github.com/TangoMan75/shoe
##
## @shell     bash
## @namespace recipes/shoe
## @requires  getopt echo
## @param     {str} <who>    /^[a-zA-Z-]+$/ (default:"World") The recipient's name.
## @option    {int} <count>  [-c|--count]   (default:1)       The repetition count.
## @flag            <prefix> [-p|--prefix]                    Prefix output with a line number.
hello() {
    local who
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

    who="${1:-World}"

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
