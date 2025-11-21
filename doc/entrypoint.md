TangoMan Entrypoint
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.1.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

Execute Development and Continuous Integration tasks.

## 🔥 Usage

`sh entrypoint.sh [command] (--lint_folder './build') (--test_folder './tests')`

## ⚙️ Options

1. **`--lint_folder`**
> Lint directory 
  - 🧩 Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - 🚩 Default: _'./build'_

2. **`--test_folder`**
> Test directory 
  - 🧩 Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - 🚩 Default: _'./tests'_

## 🤖 Commands

#### ⌨️ 1. `lint` (public)

Sniff errors with linter

> Synopsis:
> lint

- ⚠️ Requires: `shellcheck`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 2. `tests` (public)

Run tests

> Synopsis:
> tests

- ⚠️ Requires: `bash_unit`
- 🔗 Depends: `echo_info`

### ⚡ APP

#### ⌨️ 1. `git_hooks` (public)

Install git hooks

> Synopsis:
> git_hooks

- 🔗 Depends: `_git_hooks`

#### ⌨️ 2. `bash_unit` (public)

Install bash_unit framework

> Synopsis:
> bash_unit

- ⚠️ Requires: `curl`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 3. `test_can_fail` (public)

https://github.com/pgrange/bash_unit

> Synopsis:
> test_can_fail

#### ⌨️ 4. `alpine` (public)

Run script in Alpine Docker container

> Synopsis:
> alpine

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 5. `busybox` (public)

Run script in Busybox Docker container

> Synopsis:
> busybox

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 6. `ubuntu` (public)

Run script in Ubuntu Docker container

> Synopsis:
> ubuntu

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

### ⚡ HELP

#### ⌨️ 1. `help` (public)

Print this help

> Synopsis:
> help

- 🔗 Depends: `_help`

### ⚡ COLORS

#### ⌨️ 1. `echo_primary` (public)

Print primary text with optional indentation and padding

> Synopsis:
> echo_primary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 2. `echo_secondary` (public)

Print secondary text with optional indentation and padding

> Synopsis:
> echo_secondary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 3. `echo_success` (public)

Print success text with optional indentation and padding

> Synopsis:
> echo_success &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 4. `echo_danger` (public)

Print danger text with optional indentation and padding

> Synopsis:
> echo_danger &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 5. `echo_warning` (public)

Print warning text with optional indentation and padding

> Synopsis:
> echo_warning &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 6. `echo_info` (public)

Print info text with optional indentation and padding

> Synopsis:
> echo_info &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 7. `alert_primary` (public)

Print primary alert

> Synopsis:
> alert_primary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 8. `alert_secondary` (public)

Print secondary alert

> Synopsis:
> alert_secondary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 9. `alert_success` (public)

Print success alert

> Synopsis:
> alert_success &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 10. `alert_danger` (public)

Print danger alert

> Synopsis:
> alert_danger &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 11. `alert_warning` (public)

Print warning alert

> Synopsis:
> alert_warning &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 12. `alert_info` (public)

Print info alert

> Synopsis:
> alert_info &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 13. `echo_error` (public)

Print error message to STDERR, prefixed with "error: "

> Synopsis:
> echo_error &lt;MESSAGE&gt;
- `MESSAGE`: _(type: "str")_ Error message to display.

