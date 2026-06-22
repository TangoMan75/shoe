## entrypoint

===

## ℹ️ Infos


## 📑 Description



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

### ⚡ APP

#### ⌨️ 1. `build` (public)

Build given script from recipe

> Synopsis:
> `build`

- ⚠️ Requires: `python3`, `chmod`

- 🔗 Depends: `_echo_error`, `_echo_info`

#### ⌨️ 2. `build_all` (public)

Build all scripts in recipes folder

> Synopsis:
> `build_all`

- ⚠️ Requires: `python3`, `chmod`, `find`

- 🔗 Depends: `_echo_info`

#### ⌨️ 3. `replace` (public)

Replace entrypoint and Makefile in root directory

> Synopsis:
> `replace`

- ⚠️ Requires: `cp`

- 🔗 Depends: `_echo_info`

#### ⌨️ 4. `lint` (public)

Sniff errors with linter

> Synopsis:
> `lint`

- ⚠️ Requires: `shellcheck`

- 🔗 Depends: `_check_installed`, `_echo_info`

#### ⌨️ 5. `tests` (public)

Run tests

> Synopsis:
> `tests`

- ⚠️ Requires: `bash_unit`

- 🔗 Depends: `_echo_info`

#### ⌨️ 6. `git_hooks` (public)

Install git hooks

> Synopsis:
> `git_hooks`

- 🔗 Depends: `_git_hooks`

#### ⌨️ 7. `bash_unit` (public)

Install bash_unit framework

> Synopsis:
> `bash_unit`

- ⚠️ Requires: `curl`

- 🔗 Depends: `_check_installed`, `_echo_error`, `_echo_info`

#### ⌨️ 8. `alpine` (public)

Run script in Alpine Docker container

> Synopsis:
> `alpine`

- ⚠️ Requires: `docker`

- 🔗 Depends: `_check_installed`, `_echo_info`

#### ⌨️ 9. `busybox` (public)

Run script in Busybox Docker container

> Synopsis:
> `busybox`

- ⚠️ Requires: `docker`

- 🔗 Depends: `_check_installed`, `_echo_info`

#### ⌨️ 10. `ubuntu` (public)

Run script in Ubuntu Docker container

> Synopsis:
> `ubuntu`

- ⚠️ Requires: `docker`

- 🔗 Depends: `_check_installed`, `_echo_info`

### ⚡ HELP

#### ⌨️ 11. `help` (public)

################################################
# Help
################################################
Print this help

> Synopsis:
> `help`

- 🔗 Depends: `_help`
