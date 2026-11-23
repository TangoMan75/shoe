#!/usr/bin/env sh

## Public entry point
##
## @namespace tests/fixtures
public_entry() {
    :
}

## Private helper, declared with the Bash "function" keyword and an
## annotated description: the annotation must never make it public.
function _private_entry() {
    :
}
