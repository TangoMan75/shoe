#!/bin/sh

# Return json object from annotation
_parse_annotation() {
    # Synopsis: _parse_annotation <ANNOTATION>
    #   ANNOTATION: The input text containing raw annotation.

    # if [ -z "$1" ]; then echo_danger 'error: _parse_annotation: some mandatory parameter is missing\n'; return 1; fi
    # if [ ${#} -gt 1 ]; then echo_danger "error: _parse_annotation: too many arguments (${#})\n"; return 1; fi

    set -- "$(printf '%s' "$1" | sed -E 's/^ *#+ ?//g')"

    result="$(printf '%s' "$1" | awk 'function count_occurrences(str,char) {
        gsub("\\.","",str); # remove escaped characters
        gsub(/"[^"]*"/,""); # remove quoted string
        return gsub(char,char,str);
    }{
        temp=$0;
        open+=count_occurrences($0,"{");
        if (open > closed) print temp;
        closed+=count_occurrences($0,"}");
    }')"

    summary="$(printf '%s' "$1" | head -n 1)"

    if [ -z "${result}" ]; then
        jq --null-input \
            --arg summary "${summary}" \
            '$ARGS.named'

        return 0
    fi

    jq --null-input \
    --arg summary "${summary}" \
    '$ARGS.named + '"${result}"
}

