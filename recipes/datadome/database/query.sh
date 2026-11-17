#!/bin/sh

## Executes arbitrary SQL directly from the command line
##
## @namespace recipes/datadome/database
## @depends src/shell/symfony/_db_query
## @assumes sql
query() {
    _db_query "${sql}"
}

