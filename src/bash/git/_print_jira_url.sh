#!/bin/bash

## Print Jira URL
##
## Print the Jira URL for a given ticket identifier.
##
## @namespace src/bash/git
## @requires echo
## @assumes JIRA_SERVER
## @param {str} <TICKET> (required) The Jira ticket identifier (e.g., FOO-123).
function _print_jira_url() {
    echo -n "https://${JIRA_SERVER}/browse/$1"
}

