#!/bin/sh

## {
##   "namespace": "src/bash/git",
##   "summary": "Format a branch subject",
##   "description": "Formats a branch subject by removing type prefix, removing ticket prefix, converting to lowercase, replacing special characters with underscores, and removing trailing underscores.",
##   "requires": [
##     "printf",
##     "sed",
##     "tr"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "SUBJECT",
##       "type": "str",
##       "description": "The branch subject to format.",
##       "required": true
##     }
##   ]
## }
_format_branch_subject() {
    printf '%s' "$1" | tr -s ' ' | sed 's/^\(build\|chore\|ci\|docs\|feat\|fix\|perf\|refactor\|style\|test\)\///' | sed 's/[A-Z]\+-[0-9]\+///' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9_\/-]/_/g' | sed 's/_*$//'
}
