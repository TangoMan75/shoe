#!/bin/sh

## Beta command
##
## @namespace tests/fixtures/scoped
## @option {str} <mode> [-m|--mode] (default:"beta") Execution mode
## @flag <force> [-f|--force] Skip confirmation prompts
## @stdout the beta result
beta() {
    printf 'beta: mode=%s force=%s\n' "${mode}" "${force}"
}

