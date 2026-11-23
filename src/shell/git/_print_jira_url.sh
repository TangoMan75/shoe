#!/bin/sh

## Print Jira URL
##
## Print the Jira URL for a given ticket identifier.
##
## @namespace src/shell/git
## @requires printf
## @depends src/shell/colors/_echo_error.sh
## @assumes JIRA_SERVER
## @param {str} <TICKET> (required) The Jira ticket identifier (e.g., FOO-123).
_print_jira_url() {
    if [ -z "$1" ]; then _echo_error '_print_jira_url: some mandatory parameter is missing\n'; return 1; fi
    if [ $# -gt 1 ]; then _echo_error "_print_jira_url: too many arguments ($#)\n"; return 1; fi

    printf 'https://%s/browse/%s' "${JIRA_SERVER}" "$1"
}

