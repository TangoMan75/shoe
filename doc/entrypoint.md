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

#### ⌨️ 3. `git_hooks` (public)

Install git hooks

> Synopsis:
> git_hooks

- 🔗 Depends: `_git_hooks`

#### ⌨️ 4. `bash_unit` (public)

Install bash_unit framework

> Synopsis:
> bash_unit

- ⚠️ Requires: `curl`
- 🔗 Depends: `_check_installed`, `echo_danger`, `echo_info`

#### ⌨️ 5. `test_can_fail` (public)

https://github.com/pgrange/bash_unit

> Synopsis:
> test_can_fail

#### ⌨️ 6. `alpine` (public)

Run script in Alpine Docker container

> Synopsis:
> alpine

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 7. `busybox` (public)

Run script in Busybox Docker container

> Synopsis:
> busybox

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 8. `ubuntu` (public)

Run script in Ubuntu Docker container

> Synopsis:
> ubuntu

- ⚠️ Requires: `docker`
- 🔗 Depends: `_check_installed`, `echo_info`

#### ⌨️ 9. `help` (public)

Print this help

> Synopsis:
> help

- 🔗 Depends: `_help`

#### ⌨️ 10. `echo_primary` (public)

Print primary text with optional indentation and padding

> Synopsis:
> echo_primary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 11. `echo_secondary` (public)

Print secondary text with optional indentation and padding

> Synopsis:
> echo_secondary &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 12. `echo_success` (public)

Print success text with optional indentation and padding

> Synopsis:
> echo_success &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 13. `echo_danger` (public)

Print danger text with optional indentation and padding

> Synopsis:
> echo_danger &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 14. `echo_warning` (public)

Print warning text with optional indentation and padding

> Synopsis:
> echo_warning &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 15. `echo_info` (public)

Print info text with optional indentation and padding

> Synopsis:
> echo_info &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 16. `echo_light` (public)

Print light text with optional indentation and padding

> Synopsis:
> echo_light &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 17. `echo_dark` (public)

Print dark text with optional indentation and padding

> Synopsis:
> echo_dark &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### ⌨️ 18. `alert_primary` (public)

Print primary alert

> Synopsis:
> alert_primary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 19. `alert_secondary` (public)

Print secondary alert

> Synopsis:
> alert_secondary &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 20. `alert_success` (public)

Print success alert

> Synopsis:
> alert_success &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 21. `alert_danger` (public)

Print danger alert

> Synopsis:
> alert_danger &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 22. `alert_warning` (public)

Print warning alert

> Synopsis:
> alert_warning &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 23. `alert_info` (public)

Print info alert

> Synopsis:
> alert_info &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 24. `alert_light` (public)

Print light alert

> Synopsis:
> alert_light &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### ⌨️ 25. `alert_dark` (public)

Print dark alert

> Synopsis:
> alert_dark &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

