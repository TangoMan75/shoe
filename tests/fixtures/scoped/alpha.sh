#!/bin/sh

## Alpha command
##
## @namespace tests/fixtures/scoped
## @option {str} <mode> [-m|--mode] (default:"alpha") Execution mode
## @flag <force> [-f|--force] Skip confirmation prompts
## @stdout the alpha result
alpha() {
    printf 'alpha: mode=%s force=%s\n' "${mode}" "${force}"
}

