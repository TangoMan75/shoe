#!/bin/sh

## Default recipient name
##
## The name to greet.
##
## @type str
## @constraint /^[a-zA-Z-]+$/
default_name="World"

## Classic recipient name
##
## @variable {str} /^[a-z]+$/ Recipient name - The name to greet.
legacy_name="World"

## Inline recipient name /^[0-9]+$/
inline_name="123"

## Plain recipient name
plain_name="anything"
