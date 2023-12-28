TangoMan Shoe XL
===

## Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.11.1-xl
- link:    https://github.com/TangoMan75/shoe

## Description

Create self documented shell scripts with argument validation  easily. Prefix a comment with two pound signs on the previous  line of any function or variable you want documented with the  "help" command.  Flags are just regular variables with a "false" value assigned.  Warning: Functions and variables names should not contain dashes.  Note: Version xl is standard version with extra optional features : - install / uninstall / update - autocomplete   

## Usage

`sh [command] shoe-xl.sh (--who "World") (--count 1) (--env "dev") (--flag) (--global) `

## Constants

1. **VERSION**
  - Constants are ignored (must be uppercase)
  - Value: 0.11.1-xl

## Flags

1. **--flag**
  - Enable FooBar mode

2. **--global**
  - Install script globally

## Options

1. **--who**
  - Description: Who do you want to say "hello" to ?
  - Constraint:  /^[a-zA-Z-]+$/
  - Default: "World"

2. **--count**
  - Description: How many times to say hello
  - Constraint:  /^[1-9]$/
  - Default: 1

3. **--env**
  - Description: Environment
  - Constraint:  /^(prod|dev|test)$/
  - Default: "dev"

## Commands

1. **hello**
  - Say hello to arbitrary recipient

2. **generate_doc**
  - Generate Markdown documentation

### Installation

1. **self_install**
  - Install script and enable completion

2. **self_uninstall**
  - Uninstall script from system

3. **self_update**
  - Update script from @update-link

### Help

1. **help**
  - Print this help (default)

