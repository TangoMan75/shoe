TangoMan Shoemaker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 0.1.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

A versatile developement tool to split a script file into its components,
build a script from a build.lst file, generate Makefile or Markdown
documentation from a shoe script.

## 🔥 Usage

`sh shoemaker.sh [command] (--file '') (--destination '') (--type shell) (--private)`

## 🚩 Flags

1. **`--private`**
> Document private elements

## ⚙️ Options

1. **`--file`**
> Source file 
  - 🧩 Constraint: `/^~?[a-zA-Z0-9./_-]+$/`
  - 🚩 Default: _''_

2. **`--destination`**
> Destination directory 
  - 🧩 Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - 🚩 Default: _''_

3. **`--type`**
> Script type 
  - 🧩 Constraint: `/(shell|bash)/`
  - 🚩 Default: _shell_

## 🤖 Commands

#### ⌨️ 1. `dump` (public)

Dump functions from given script into individual files

> Synopsis:
> dump

- 🔗 Depends: `_get_function`, `_get_functions_names`, `echo_danger`, `echo_success`

#### ⌨️ 2. `list` (public)

Dump "build.shoe" file

> Synopsis:
> list

- 🔗 Depends: `_get_functions_names`, `_pwd`, `echo_danger`, `echo_success`

#### ⌨️ 3. `build` (public)

Build from given "build.shoe" file

> Synopsis:
> build

- 🔗 Depends: `_build`, `_pwd`, `echo_danger`

#### ⌨️ 4. `build_all` (public)

Build all scripts

> Synopsis:
> build_all

- 🔗 Depends: `_build`, `_pwd`

#### ⌨️ 5. `remove_json_annotations` (public)

Remove json annotations from file

> Synopsis:
> remove_json_annotations

- ⚠️ Requires: `sed`
- 🔗 Depends: `echo_danger`, `echo_info`, `sed_i`

#### ⌨️ 6. `generate_doc` (public)

Generate Markdown documentation for provided shoe script

> Synopsis:
> generate_doc

- 🔗 Depends: `_generate_doc`

#### ⌨️ 7. `generate_doc_all` (public)

Generate Markdown documentation for all scripts

> Synopsis:
> generate_doc_all

- 🔗 Depends: `_generate_doc`, `_pwd`

#### ⌨️ 8. `generate_makefile` (public)

Generate Markdown documentation for provided shoe script

> Synopsis:
> generate_makefile

- 🔗 Depends: `_generate_makefile`

#### ⌨️ 9. `generate_makefile_all` (public)

Generate Makefile for all scripts

> Synopsis:
> generate_makefile_all

- 🔗 Depends: `_generate_makefile`, `_pwd`

#### ⌨️ 10. `_build` (private)

Build from given "build.shoe" file

> Synopsis:
> _build &lt;FILE_PATH&gt; &lt;DESTINATION&gt; [TYPE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.
- `TYPE`: _(type: "str")_ (optional) The script type to build (bash or sh). _Defaults to "sh"._

- 🔗 Depends: `_collapse_blank_lines`, `_sed_i`, `alert_primary`, `echo_danger`, `echo_info`

### ⚡ INSTALL

#### ⌨️ 1. `self_install` (public)

Install script and enable completion

> Synopsis:
> self_install

- 🔗 Depends: `_install`

#### ⌨️ 2. `self_uninstall` (public)

Uninstall script from system

> Synopsis:
> self_uninstall

- 🔗 Depends: `_uninstall`

#### ⌨️ 3. `self_update` (public)

Update script from @update

> Synopsis:
> self_update

- 🔗 Depends: `_get_annotation_tags`, `_get_script_shoedoc`, `_update`

### ⚡ HELP

#### ⌨️ 1. `help` (public)

Print this help

> Synopsis:
> help

- 🔗 Depends: `_help`

### ⚡ HOOKS

#### ⌨️ 1. `_default` (private)

Place here commands you need executed by default (optional)

> Synopsis:
> _default

#### ⌨️ 2. `_before` (private)

Place here commands you need executed first every time (optional)

> Synopsis:
> _before

#### ⌨️ 3. `_after` (private)

Place here commands you need executed last every time (optional)

> Synopsis:
> _after

### ⚡ SHOEDOC

#### ⌨️ 1. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis:
> _get_shoedoc_description &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_get_shoedoc` (private)

Get shoedoc

> Synopsis:
> _get_shoedoc &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 3. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

> Synopsis:
> _get_shoedoc_tag &lt;TEXT&gt; &lt;TAG_NAME&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis:
> _get_shoedoc_title &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

> Synopsis:
> _get_script_shoedoc &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

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

### ⚡ COMPATIBILITY

#### ⌨️ 1. `_sed_i` (private)

Return sed -i system flavour

> Synopsis:
> _sed_i

- ⚠️ Requires: `command`, `sed`, `uname`

### ⚡ DOCUMENTATION

#### ⌨️ 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis:
> _generate_doc &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_tag`, `_get_shoedoc_title`, `_print_synopsis`, `alert_primary`, `echo_danger`, `echo_success`

### ⚡ HELP

#### ⌨️ 1. `_help` (private)

Print help for provider shoe script

> Synopsis:
> _help &lt;FILE_PATH&gt; [FUNCTION_NAME]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `FUNCTION_NAME`: _(type: "str")_ (optional) The function name to get help for.

- 🔗 Depends: `_get_constants`, `_get_flags`, `_get_function_annotation`, `_get_options`, `_get_padding`, `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_title`, `_print_commands`, `_print_constants`, `_print_description`, `_print_flags`, `_print_infos`, `_print_options`, `_print_synopsis`, `_print_usage`, `alert_primary`, `echo_danger`

#### ⌨️ 2. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis:
> _print_commands &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 3. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis:
> _print_constants &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis:
> _print_description &lt;DESCRIPTION&gt;
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

- 🔗 Depends: `echo_primary`, `echo_warning`

#### ⌨️ 5. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis:
> _print_flags &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 6. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis:
> _print_infos &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_tag`, `echo_danger`, `echo_primary`, `echo_success`, `echo_warning`

#### ⌨️ 7. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis:
> _print_options &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_warning`

#### ⌨️ 8. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis:
> _print_usage &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`, `echo_info`, `echo_success`, `echo_warning`

### ⚡ INSTALL

#### ⌨️ 1. `_copy_install` (private)

Install script via copy

> Synopsis:
> _copy_install &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis:
> _generate_autocomplete &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_get_comspec`, `echo_danger`, `echo_info`

#### ⌨️ 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis:
> _generate_global_autocomplete &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_get_comspec`, `echo_danger`, `echo_info`

#### ⌨️ 4. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis:
> _get_comspec &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_install` (private)

Install script and enable completion

> Synopsis:
> _install &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- 🔗 Depends: `_copy_install`, `_generate_autocomplete`, `_generate_global_autocomplete`, `_is_installed`, `_set_completion_autoload`, `_symlink_install`, `echo_danger`

#### ⌨️ 6. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis:
> _remove_completion_autoload &lt;SHELL_CONFIG_FILE&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis:
> _set_completion_autoload &lt;SHELL_CONFIG_FILE&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_collapse_blank_lines`, `_sed_i`, `echo_danger`, `echo_info`

#### ⌨️ 8. `_symlink_install` (private)

Install script via symlink

> Synopsis:
> _symlink_install &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 9. `_uninstall` (private)

Uninstall script from system

> Synopsis:
> _uninstall &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

- 🔗 Depends: `_remove_completion_autoload`, `echo_danger`, `echo_info`

#### ⌨️ 10. `_update` (private)

Updates given script from the provided URL

> Synopsis:
> _update &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

- ⚠️ Requires: `curl`, `wget`
- 🔗 Depends: `_copy_install`, `_generate_autocomplete`, `_generate_global_autocomplete`, `_install`, `_is_installed`, `_set_completion_autoload`, `_symlink_install`, `_uninstall`, `echo_danger`

### ⚡ MAKE

#### ⌨️ 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis:
> _generate_makefile &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

- ⚠️ Requires: `awk`
- 🔗 Depends: `_get_script_shoedoc`, `_get_shoedoc_description`, `_get_shoedoc_tag`, `_get_shoedoc_title`, `alert_primary`, `echo_danger`, `echo_success`

### ⚡ REFLEXION

#### ⌨️ 1. `_get_constants` (private)

List constants from provided shoe script

> Synopsis:
> _get_constants &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis:
> _get_constraint &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 3. `_get_flags` (private)

List flags from provided shoe script

> Synopsis:
> _get_flags &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_get_function_annotation` (private)

Get function annotation by name

> Synopsis:
> _get_function_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 5. `_get_function` (private)

Get function by name

> Synopsis:
> _get_function &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 6. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis:
> _get_functions_names &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 7. `_get_options` (private)

List options from provided shoe script

> Synopsis:
> _get_options &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 8. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis:
> _get_padding &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

- ⚠️ Requires: `awk`
- 🔗 Depends: `echo_danger`

#### ⌨️ 9. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsis:
> _get_parameter &lt;FILE_PATH&gt; &lt;KEY&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

- ⚠️ Requires: `sed`
- 🔗 Depends: `echo_danger`, `echo_info`

#### ⌨️ 10. `_parse_annotation` (private)

Return function annotation as json

> Synopsis:
> _parse_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

- ⚠️ Requires: `jq`, `sed`
- 🔗 Depends: `_get_function_annotation`, `echo_danger`

#### ⌨️ 11. `_print_synopsis` (private)

Print function synopsis from a JSON string.

> Synopsis:
> _print_synopsis &lt;JSON&gt; [MARKDOWN_FORMAT]
- `JSON`: _(type: "json")_ The input string containing raw JSON.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

- ⚠️ Requires: `jq`
- 🔗 Depends: `echo_danger`

#### ⌨️ 12. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

> Synopsis:
> _set_parameter &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

- ⚠️ Requires: `sed`
- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`, `echo_warning`

### ⚡ STRINGS

#### ⌨️ 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis:
> _collapse_blank_lines &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

- 🔗 Depends: `_sed_i`, `echo_danger`, `echo_info`

### ⚡ SYSTEM

#### ⌨️ 1. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis:
> _check_installed &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- 🔗 Depends: `_get_package_name`, `_is_installed`, `echo_danger`

#### ⌨️ 2. `_get_package_name` (private)

Find package name for given command

> Synopsis:
> _get_package_name &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- 🔗 Depends: `echo_danger`

#### ⌨️ 3. `_is_installed` (private)

Check provided command is installed

> Synopsis:
> _is_installed &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

- ⚠️ Requires: `dpkg`
- 🔗 Depends: `echo_danger`

#### ⌨️ 4. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis:
> _pwd

### ⚡ VALIDATION

#### ⌨️ 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis:
> _is_valid &lt;VALUE&gt; &lt;PATTERN&gt;
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

- ⚠️ Requires: `grep`, `sed`
- 🔗 Depends: `echo_danger`

#### ⌨️ 2. `_validate` (private)

Find constraints and validates a variable

> Synopsis:
> _validate &lt;VARIABLE&gt;
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.

- ⚠️ Requires: `sed`
- 🔗 Depends: `_get_constraint`, `_is_valid`, `echo_danger`

### ⚡ KERNEL

#### ⌨️ 1. `_kernel` (private)

Shoe Kernel

> Synopsis:
> _kernel

- ⚠️ Requires: `awk`, `grep`
- 🔗 Depends: `_after`, `_before`, `_default`, `_get_flags`, `_get_functions_names`, `_get_options`, `_validate`, `echo_danger`

