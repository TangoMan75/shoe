# TangoMan Shoemaker

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version:  0.1.0
- link:  https://github.com/TangoMan75/shoe

## 📑 Description

A versatile developement tool to split a script file into its components,
build a script from a build.lst file, generate Makefile or Markdown
documentation from a shoe script.

## 🔥 Usage

`sh shoemaker.sh [command] (--private) (--file '') (--destination '') (--type shell)`

## 🚩 Flags

1. **`--private`**
> Document private elements

## ⚙️ Options

1. **`--file`**
> Source file /^~?[a-zA-Z0-9./_-]+$/
  - 🚩 Default: _''_

2. **`--destination`**
> Destination directory /^~?[a-zA-Z0-9/._-]+$/
  - 🚩 Default: _''_

3. **`--type`**
> Script type /(shell|bash)/
  - 🚩 Default: _shell_

## 🤖 Commands

### ⚡ RECIPES/SHOEMAKER

#### ⌨️ 1. `dump` (public)

Dump functions from given script into individual files

> Synopsis:
> `dump`

- ⚠️ Requires: `basename`, `mkdir`, `printf`, `realpath`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/reflexion/_get_function`, `src/shell/reflexion/_get_functions_names`, `src/shell/system/_pwd`

#### ⌨️ 2. `list` (public)

Dump "build.shoe" file

> Synopsis:
> `list`

- ⚠️ Requires: `basename`, `mkdir`, `realpath`, `sed`, `true`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_success`, `src/shell/reflexion/_get_functions_names`, `src/shell/system/_pwd`

#### ⌨️ 3. `build` (public)

Build from given "build.shoe" file

> Synopsis:
> `build`

- ⚠️ Requires: `mkdir`, `realpath`

- 🔗 Depends: `recipes/shoemaker/_build`, `src/shell/colors/_echo_error`, `src/shell/system/_pwd`

#### ⌨️ 4. `build_all` (public)

Build all scripts

> Synopsis:
> `build_all`

- ⚠️ Requires: `find`, `mkdir`

- 🔗 Depends: `recipes/shoemaker/_build`, `src/shell/system/_pwd`

#### ⌨️ 5. `remove_json_annotations` (public)

Remove json annotations from file

> Synopsis:
> `remove_json_annotations`

- 🔗 Depends: `src/shell/colors/_echo_error`, `src/shell/colors/_echo_info`, `src/shell/compatibility/_sed_i`

### ⚡ Documentation

#### ⌨️ 6. `generate_doc` (public)

Generate Markdown documentation for provided shoe script

> Synopsis:
> `generate_doc`

- ⚠️ Requires: `basename`, `realpath`

- 🔗 Depends: `src/shell/documentation/_generate_doc`

#### ⌨️ 7. `generate_doc_all` (public)

Generate Markdown documentation for all scripts

> Synopsis:
> `generate_doc_all`

- ⚠️ Requires: `basename`, `find`, `mkdir`

- 🔗 Depends: `src/shell/documentation/_generate_doc`, `src/shell/system/_pwd`

### ⚡ Make

#### ⌨️ 8. `generate_makefile` (public)

Generate Markdown documentation for provided shoe script

> Synopsis:
> `generate_makefile`

- ⚠️ Requires: `basename`, `realpath`

- 🔗 Depends: `src/shell/make/_generate_makefile`

#### ⌨️ 9. `generate_makefile_all` (public)

Generate Makefile for all scripts

> Synopsis:
> `generate_makefile_all`

- ⚠️ Requires: `basename`, `find`, `mkdir`

- 🔗 Depends: `src/shell/make/_generate_makefile`, `src/shell/system/_pwd`

### ⚡ Help

#### ⌨️ 10. `help` (public)

Print this help

> Synopsis:
> `help`

- 🔗 Depends: `src/shell/help/_help`

### ⚡ Self Install

#### ⌨️ 11. `self_install` (public)

Install script and enable autocompletion

> Synopsis:
> `self_install`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_install`

#### ⌨️ 12. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> `self_uninstall`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/install/_uninstall`

#### ⌨️ 13. `self_update` (public)

Update script from @update

> Synopsis:
> `self_update`

- ⚠️ Requires: `basename`

- 🔗 Depends: `src/shell/colors/_echo_danger`, `src/shell/install/_update`, `src/shell/shoedoc/_get_script_shoedoc`, `src/shell/shoedoc/_get_shoedoc_tag`
