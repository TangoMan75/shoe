#!/bin/bash

# Print Jira url
##
## {
##   "namespace": "git",
##   "summary": "Print the Jira URL for a given ticket identifier.",
##   "assumes": [
##     "JIRA_SERVER"
##   ],
##   "parameters": [
##     {
##       "position": 1,
##       "name": "TICKET",
##       "type": "str",
##       "description": "The Jira ticket identifier (e.g., FOO-123).",
##       "default": "",
##       "nullable": false
##     }
##   ]
## }
function _print_jira_url() {
    echo -n "https://${JIRA_SERVER}/browse/$1"
}
