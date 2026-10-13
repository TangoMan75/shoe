#!/bin/bash

## {
##   "namespace": "src/bash/git",
##   "summary": "Print Jira URL",
##   "description": "Print the Jira URL for a given ticket identifier.",
##   "requires": [
##     "echo"
##   ],
##   "assumes": [
##     "JIRA_SERVER"
##   ],
##   "params": [
##     {
##       "position": 1,
##       "name": "TICKET",
##       "description": "The Jira ticket identifier (e.g., FOO-123).",
##       "type": "str",
##       "required": true
##     }
##   ]
## }
function _print_jira_url() {
    echo -n "https://${JIRA_SERVER}/browse/$1"
}
