#!/bin/sh

## Environment /^(dev|prod|test)$/
env=dev

## Default port /^[0-9]+$/
port=8000

## Table name /^[a-z0-9_]+$/
table=''

## Container name /^[a-zA-Z0-9_-]+$/
container=''

## Files owner /^[a-z0-9_-]+$/
owner=''

## File to test /^~?[a-zA-Z0-9.\/_-]+$/
file=''

## Execute migrations instead of creating schema
migrate=false

## Import csv data
import=false

## Force
force=false

