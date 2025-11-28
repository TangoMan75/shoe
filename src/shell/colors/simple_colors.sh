#!/bin/sh

## Print primary alert (bold white text over bright blue background)
_alert_primary() { printf "\033[0m\n\033[1;104;97m%64s\033[0m\n\033[1;104;97m %-63s\033[0m\n\033[1;104;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print secondary alert (bold white text over bright purple background)
_alert_secondary() { printf "\033[0m\n\033[1;45;97m%64s\033[0m\n\033[1;45;97m %-63s\033[0m\n\033[1;45;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print success alert (bold white text over bright green background)
_alert_success() { printf "\033[0m\n\033[1;42;97m%64s\033[0m\n\033[1;42;97m %-63s\033[0m\n\033[1;42;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print danger alert (bold white text over bright red background)
_alert_danger() { printf "\033[0m\n\033[1;41;97m%64s\033[0m\n\033[1;41;97m %-63s\033[0m\n\033[1;41;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print warning alert (bold white text over bright orange background)
_alert_warning() { printf "\033[0m\n\033[1;43;97m%64s\033[0m\n\033[1;43;97m %-63s\033[0m\n\033[1;43;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print info alert (bold white text over blue background)
_alert_info() { printf "\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print light alert (black text over white background)
_alert_light() { printf "\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n" '' "$1" ''; }

## Print dark alert (bold white text over black background)
_alert_dark() { printf "\033[0m\n\033[1;44;97m%64s\033[0m\n\033[1;44;97m %-63s\033[0m\n\033[1;44;97m%64s\033[0m\n\n" '' "$1" ''; }

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

## Print light text (light gray background with dark gray text)
_echo_light() { printf '\033[47;90m%b\033[0m' "$1"; }

## Print dark text (black background with light gray text)
_echo_dark() { printf '\033[40;37m%b\033[0m' "$1"; }

## Print error message to STDERR, prefixed with "error: "
_echo_error() { printf '\033[31merror: %b\033[0m' "$1" >&2; }

