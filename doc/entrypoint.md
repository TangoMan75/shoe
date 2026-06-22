# TangoMan Entrypoint

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

Execute Development and Continuous Integration tasks.

## 🔥 Usage

`sh entrypoint.sh [command] (--recipe '') (--lint_folder './build') (--test_folder './tests')`

## ⚙️ Options

1. **`--recipe`**
> Recipe name to build /^~?[a-zA-Z0-9.\/_-]+$/
  - 🚩 Default: _''_

2. **`--lint_folder`**
> Lint directory /^~?[a-zA-Z0-9/._-]+$/
  - 🚩 Default: _'./build'_

3. **`--test_folder`**
> Test directory /^~?[a-zA-Z0-9/._-]+$/
  - 🚩 Default: _'./tests'_

## 🤖 Commands

### ⚡ RECIPES/ENTRYPOINT/APP

#### ⌨️ 1. `build` (public)

Build given script from recipe

> Synopsis:
> `build`

- ⚠️ Requires: `chmod`, `python3`, `rm`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 2. `build_all` (public)

Build all scripts in recipes folder

> Synopsis:
> `build_all`

- ⚠️ Requires: `chmod`, `find`, `python3`, `rm`, `sh`, `true`

- 🔗 Depends: `src/shell/colors/_alert_info`, `src/shell/colors/_echo_info`, `src/shell/system/_pwd`

#### ⌨️ 3. `lint` (public)

Sniff errors with linter

> Synopsis:
> `lint`

- ⚠️ Requires: `find`, `shellcheck`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 4. `tests` (public)

Run tests

> Synopsis:
> `tests`

- ⚠️ Requires: `bash_unit`, `find`, `sort`

- 🔗 Depends: `src/shell/colors/_echo_info`

#### ⌨️ 5. `git_hooks` (public)

Install git hooks

> Synopsis:
> `git_hooks`

- 🔗 Depends: `src/shell/git/_git_hooks`

#### ⌨️ 6. `bash_unit` (public)

Install bash_unit framework

> Synopsis:
> `bash_unit`

- ⚠️ Requires: `cat`, `chmod`, `curl`, `mkdir`, `wget`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`

#### ⌨️ 7. `alpine` (public)

Run script in Alpine Docker container

> Synopsis:
> `alpine`

- ⚠️ Requires: `docker`, `pwd`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 8. `busybox` (public)

Run script in Busybox Docker container

> Synopsis:
> `busybox`

- ⚠️ Requires: `docker`, `pwd`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

#### ⌨️ 9. `ubuntu` (public)

Run script in Ubuntu Docker container

> Synopsis:
> `ubuntu`

- ⚠️ Requires: `docker`, `pwd`, `sh`

- 🔗 Depends: `src/shell/colors/_echo_info`, `src/shell/system/_check_installed`

### ⚡ Help

#### ⌨️ 10. `help` (public)

Print this help

> Synopsis:
> `help`

- 🔗 Depends: `src/shell/help/_help`
