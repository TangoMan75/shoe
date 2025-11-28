#!/usr/bin/env sh

## TangoMan Reflexion Test Fixture
##
## Example script for testing reflexion functions.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe

## Public constant
PUBLIC_CONSTANT=value1

## Another public constant
ANOTHER_PUBLIC=val2

_PRIVATE_CONSTANT=private_val

# Not a constant, no comment
uncommented_constant=ignored

## Public option /^[a-z]+$/i
public_option=default_value

## Another public option /[0-9]+/
another_option=another_val

_private_option=priv_val

## Public flag
public_flag=false

## Another public flag
another_flag=false

_private_flag=false



## Public function
##
## {
##   "namespace": "test",
##   "summary": "A test function.",
##   "parameters": [
##     {
##       "position": 1,
##       "name": "ARG",
##       "type": "str",
##       "description": "An argument.",
##       "nullable": false
##     }
##   ]
## }
public_function() {
    echo "public $1"
}

## Another public function
another_public() {
    echo "another"
}

_private_function() {
    echo "private"
}

