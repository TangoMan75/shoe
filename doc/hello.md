# TangoMan Hello World!

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

Greets or says goodbye to a specified user a given number of times.
Accepts a recipient name, repetition count, ending and output flags.
Useful as a smoke test for new installations.

## 🔥 Usage

`sh hello.sh [command] (--prefix) (--verbose) (--who 'World') (--count 1) (--ending '!')`

## 🧱 Constants

1. **ALIAS**
> Script alias
>
> The command alias that will be used for invoking the script after installation
> ALIAS is optional and defaults to script basename
  - Value: _hello_

## 🚩 Flags

1. **`--prefix`**
> Prefix output with a line number
>
> This is an example flag
> Any variable set to "false" will convert to a flag at runtime

2. **`--verbose`**
> Print additional details

## ⚙️ Options

1. **`--who`**
> The recipient's name /^[a-zA-Z -]+$/
  - 🚩 Default: _'World'_

2. **`--count`**
> The repetition count /^[1-9][0-9]?$/
  - 🚩 Default: _1_

3. **`--ending`**
> Sentence ending punctuation /^[.!?]$/
  - 🚩 Default: _'!'_

## 🤖 Commands

### ⚡ App

#### ⌨️ 1. `hello` (public)

Hello World!

> Synopsis:
> `hello`

- 🔗 Depends: `recipes/hello/_say`

#### ⌨️ 2. `goodbye` (public)

Goodbye World!

> Synopsis:
> `goodbye`

- 🔗 Depends: `recipes/hello/_say`

### ⚡ Help

#### ⌨️ 3. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/help/_help`

### ⚡ Self Install

#### ⌨️ 4. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install`

#### ⌨️ 5. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall`
