# TangoMan Shoe Demo

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

Showcase the Shoe framework with a FizzBuzz sequence, a
Fibonacci sequence, a color test and a Hello World command.
Demonstrates global flags, command options, positional
parameters, private helpers and generated help.

## 🔥 Usage

`sh demo.sh [command] (--verbose)`

## 🚩 Flags

1. **`--verbose`**
> Print additional details
>
> This is an example flag
> Any script-level variable set to "false" will convert to a flag at runtime

## 🤖 Commands

### ⚡ App

#### ⌨️ 1. `hello` (public)

Hello World!

> Synopsis:
> `hello [recipient]`
- `recipient`: _(type: "str")_ (optional) The recipient's name. _Constraint: `/^[a-zA-Z-]+$/`._ _Defaults to "World"._

- ⚠️ Requires: `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`

#### ⌨️ 2. `colors` (public)

Color test

> Synopsis:
> `colors`

- ⚠️ Requires: `printf`, `true`

- 🔗 Depends: `src/shell/colors/_alert_danger.sh`, `src/shell/colors/_alert_dark.sh`, `src/shell/colors/_alert_info.sh`, `src/shell/colors/_alert_light.sh`, `src/shell/colors/_alert_muted.sh`, `src/shell/colors/_alert_primary.sh`, `src/shell/colors/_alert_secondary.sh`, `src/shell/colors/_alert_success.sh`, `src/shell/colors/_alert_warning.sh`, `src/shell/colors/_echo_danger.sh`, `src/shell/colors/_echo_dark.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/colors/_echo_light.sh`, `src/shell/colors/_echo_muted.sh`, `src/shell/colors/_echo_primary.sh`, `src/shell/colors/_echo_secondary.sh`, `src/shell/colors/_echo_success.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 3. `fizzbuzz` (public)

Print the FizzBuzz sequence

> Synopsis:
> `fizzbuzz [--limit VALUE] [--prefix]`
- `--limit`: _(type: "int")_ Last number to print. _Constraint: `/^[1-9][0-9]?$/`._ _Defaults to "10"._
- `--prefix`: Prefix output with a line number.

- ⚠️ Requires: `printf`, `true`

- 🔗 Depends: `recipes/demo/app/_fizzbuzz.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_warning.sh`

#### ⌨️ 4. `fibonacci` (public)

Print the Fibonacci sequence

> Synopsis:
> `fibonacci [--count VALUE]`
- `--count`: _(type: "int")_ Number of terms to print. _Constraint: `/^[1-9][0-9]?$/`._ _Defaults to "10"._

- ⚠️ Requires: `printf`, `true`

- 🔗 Depends: `src/shell/colors/_echo_warning.sh`

### ⚡ Documentation

#### ⌨️ 5. `generate_doc` (public)

Generate Markdown documentation for current shoe script

> Synopsis:
> `generate_doc`

- 🔗 Depends: `src/shell/documentation/_generate_doc.sh`

### ⚡ Help

#### ⌨️ 6. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/help/_help.sh`

### ⚡ Self Install

#### ⌨️ 7. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install.sh`

#### ⌨️ 8. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall.sh`

### ⚡ Make

#### ⌨️ 9. `generate_makefile` (public)

Generate Makefile for current shoe script

> Synopsis:
> `generate_makefile`

- 🔗 Depends: `src/shell/make/_generate_makefile.sh`
