#!/bin/sh

## List bookmarks when no command is provided
##
## @namespace recipes/bookmarks
## @depends src/shell/help/help
## @overrides src/shell/hooks/_default
_default() {
    help
}

