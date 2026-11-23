# TangoMan Entrypoint

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

Execute Development and Continuous Integration tasks.

## 🔥 Usage

`sh entrypoint.sh [command]`

## 🤖 Commands

### ⚡ RECIPES/ENTRYPOINT/APP

#### ⌨️ 1. `build` (public)

Build all scripts in recipes folder

> Synopsis:
> `build`

- ⚠️ Requires: `chmod`, `cp`, `find`, `mktemp`, `python3`, `rm`, `sh`, `true`

- 🔗 Depends: `src/shell/colors/_alert_info.sh`, `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 2. `lint` (public)

Sniff errors with linter

> Synopsis:
> `lint`

- ⚠️ Requires: `find`, `grep`, `python3`, `shellcheck`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`

#### ⌨️ 3. `tests` (public)

Run tests

> Synopsis:
> `tests`

- ⚠️ Requires: `bash_unit`, `find`, `mktemp`, `rm`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/colors/_echo_info.sh`

#### ⌨️ 4. `alpine` (public)

Run tests in Alpine Docker container

> Synopsis:
> `alpine`

- ⚠️ Requires: `docker`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_pwd.sh`

#### ⌨️ 5. `busybox` (public)

Run tests in Busybox Docker container

> Synopsis:
> `busybox`

- ⚠️ Requires: `docker`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_pwd.sh`

#### ⌨️ 6. `ubuntu` (public)

Run tests in Ubuntu Docker container

> Synopsis:
> `ubuntu`

- ⚠️ Requires: `docker`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info.sh`, `src/shell/system/_check_installed.sh`, `src/shell/system/_pwd.sh`

### ⚡ Help

#### ⌨️ 7. `help` (public)

Print this help

> Synopsis:
> `help [COMMAND_NAME]`
- `COMMAND_NAME`: _(type: "str")_ (optional) The command name to print detailed help for.

- 🔗 Depends: `src/shell/colors/_echo_error.sh`, `src/shell/help/_help.sh`
