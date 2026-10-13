#!/bin/sh

## {
##   "namespace": "src/bash/git",
##   "summary": "Format a commit subject",
##   "description": "Formats a commit subject by removing type, scope, ticket, and PR number prefixes, then trimming whitespace.",
##   "requires": [
##     "echo",
##     "sed",
##     "tr"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "SUBJECT",
##       "type": "str",
##       "description": "The commit subject to format.",
##       "required": true
##     }
##   ]
## }
_format_commit_subject() {
    echo -n "$1" | sed -E 's/^[a-z()_]+!?: //' | sed -E 's/\([A-Z]+-[0-9]+\)//g' | sed -E 's/\(#[0-9]+\)//g' | tr -s ' ' | sed -E 's/ +$//'
}
