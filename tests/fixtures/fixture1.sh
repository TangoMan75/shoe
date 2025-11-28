#!/usr/bin/env sh

set -e

# This script is based on TangoMan Shoe Shell Microframework
#
# This file is distributed under to the MIT license.
#
# Copyright (c) 2026 "Matthias Morin" <mat@tangoman.io>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Source code is available here: https://github.com/TangoMan75/shoe

## TangoMan Fixture
##
## Example script.
##
## @author  "Matthias Morin" <mat@tangoman.io>
## @version 0.1.0
## @license MIT
## @link    https://github.com/TangoMan75/shoe

## Print primary text (bright white text)
_echo_primary() { printf '\033[97m%b\033[0m' "$1"; }

## Print secondary text (bright blue text)
_echo_secondary() { printf '\033[94m%b\033[0m' "$1"; }

## Print success text (bright green text)
_echo_success() { printf '\033[32m%b\033[0m' "$1"; }

## Print danger text (red text)
_echo_danger() { printf '\033[31m%b\033[0m' "$1"; }

## Print warning text (orange text)
_echo_warning() { printf '\033[33m%b\033[0m' "$1"; }

## Print info text (bright purple text)
_echo_info() { printf '\033[95m%b\033[0m' "$1"; }

## Print error message to STDERR, prefixed with "error: "
_echo_error() { printf '\033[31merror: %b\033[0m' "$1" >&2; }

_echo_info "Fixture"
