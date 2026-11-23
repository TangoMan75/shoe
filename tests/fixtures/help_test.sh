#!/bin/sh

## Script alias
##
## The command alias that will be used for invoking the script after installation
##
## @type str
ALIAS=hello

## The recipient's name /^[a-zA-Z -]+$/
##
## The name of the person to greet
who='World'

## The repetition count
##
## How many times the script should greet
##
## @type int
## @constraint /^[1-9][0-9]?$/
count=1

## Prefix output with a line number
##
## This is an example flag
## Any variable set to "false" will convert to a flag at runtime
prefix=false

## Print additional details
##
## @deprecated Use --trace instead
verbose=false
