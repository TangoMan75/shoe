TangoMan Shoemaker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
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
  - Constraint: `/^~?[a-zA-Z0-9./_-]+$/`
  - Default: _''_

2. **`--destination`**
> Destination directory 
  - Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - Default: _''_

3. **`--type`**
> Script type 
  - Constraint: `/(shell|bash)/`
  - Default: _shell_

## 🤖 Commands

#### 1. `dump` (public)

Dump functions from given script into individual files

##### Synopsis
> dump (public) 

#### 1. `list` (public)

Dump "build.shoe" file

##### Synopsis
> list (public) 

#### 1. `build` (public)

Build from given "build.shoe" file

##### Synopsis
> build (public) 

#### 1. `build_all` (public)

Build all scripts

##### Synopsis
> build_all (public) 

#### 1. `generate_doc` (public)

Generate Markdown documentation for provided shoe script

##### Synopsis
> generate_doc (public) 

#### 1. `generate_doc_all` (public)

Generate Markdown documentation for all scripts

##### Synopsis
> generate_doc_all (public) 

#### 1. `generate_makefile` (public)

Generate Markdown documentation for provided shoe script

##### Synopsis
> generate_makefile (public) 

#### 1. `generate_makefile_all` (public)

Generate Makefile for all scripts

##### Synopsis
> generate_makefile_all (public) 

#### 1. `_build` (private)

Build from given "build.shoe" file

##### Synopsis
> _build (private) &lt;FILE_PATH&gt; &lt;DESTINATION&gt; [TYPE]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `DESTINATION`: _(type: "folder")_ The path to the destination folder.
- `TYPE`: _(type: "str")_ (optional) The script type to build (bash or sh). _Defaults to "sh"._

#### 1. `self_install` (public)

Install script and enable completion

##### Synopsis
> self_install (public) 

#### 1. `self_uninstall` (public)

Uninstall script from system

##### Synopsis
> self_uninstall (public) 

#### 1. `self_update` (public)

Update script from @update

##### Synopsis
> self_update (public) 

#### 1. `help` (public)

Print this help

##### Synopsis
> help (public) 

#### 1. `_default` (private)

Place here commands you need executed by default (optional)

##### Synopsis
> _default (private) 

#### 1. `_before` (private)

Place here commands you need executed first every time (optional)

##### Synopsis
> _before (private) 

#### 1. `_after` (private)

Place here commands you need executed last every time (optional)

##### Synopsis
> _after (private) 

#### 1. `_get_shoedoc_description` (private)

Get shoedoc description

##### Synopsis
> _get_shoedoc_description (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_shoedoc` (private)

Get shoedoc

##### Synopsis
> _get_shoedoc (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

##### Synopsis
> _get_shoedoc_tag (private) &lt;TEXT&gt; &lt;TAG_NAME&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.
- `TAG_NAME`: _(type: "str")_ The name of tag to return.

#### 1. `_get_shoedoc_title` (private)

Get shoedoc title

##### Synopsis
> _get_shoedoc_title (private) &lt;TEXT&gt;
- `TEXT`: _(type: "str")_ The input shoedoc annotation bloc.

#### 1. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

##### Synopsis
> _get_script_shoedoc (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `echo_primary` (public)

Print primary text with optional indentation and padding

##### Synopsis
> echo_primary (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_secondary` (public)

Print secondary text with optional indentation and padding

##### Synopsis
> echo_secondary (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_success` (public)

Print success text with optional indentation and padding

##### Synopsis
> echo_success (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_danger` (public)

Print danger text with optional indentation and padding

##### Synopsis
> echo_danger (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_warning` (public)

Print warning text with optional indentation and padding

##### Synopsis
> echo_warning (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_info` (public)

Print info text with optional indentation and padding

##### Synopsis
> echo_info (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_light` (public)

Print light text with optional indentation and padding

##### Synopsis
> echo_light (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `echo_dark` (public)

Print dark text with optional indentation and padding

##### Synopsis
> echo_dark (public) &lt;STRING&gt; [INDENTATION] [PADDING]
- `STRING`: _(type: "str")_ Text to display.
- `INDENTATION`: _(type: "int")_ (optional) Indentation level. _Defaults to "0"._
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "0"._

#### 1. `alert_primary` (public)

Print primary alert

##### Synopsis
> alert_primary (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_secondary` (public)

Print secondary alert

##### Synopsis
> alert_secondary (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_success` (public)

Print success alert

##### Synopsis
> alert_success (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_danger` (public)

Print danger alert

##### Synopsis
> alert_danger (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_warning` (public)

Print warning alert

##### Synopsis
> alert_warning (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_info` (public)

Print info alert

##### Synopsis
> alert_info (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_light` (public)

Print light alert

##### Synopsis
> alert_light (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `alert_dark` (public)

Print dark alert

##### Synopsis
> alert_dark (public) &lt;STRING&gt;
- `STRING`: _(type: "str")_ Text to display.

#### 1. `_sed_i` (private)

Return sed -i system flavour

##### Synopsis
> _sed_i (private) 

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

##### Synopsis
> _generate_doc (private) &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the documentation file. Defaults to "<BASENAME>.md".
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", documents private constants, options, flags, and commands as well. _Defaults to "false"._

#### 1. `_help` (private)

Print help for provider shoe script

##### Synopsis
> _help (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

##### Synopsis
> _print_commands (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

##### Synopsis
> _print_constants (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

##### Synopsis
> _print_description (private) &lt;DESCRIPTION&gt;
- `DESCRIPTION`: _(type: "str")_ A string containing script description.

#### 1. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

##### Synopsis
> _print_flags (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

##### Synopsis
> _print_infos (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

##### Synopsis
> _print_options (private) &lt;FILE_PATH&gt; [PADDING]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `PADDING`: _(type: "int")_ (optional) Padding length. _Defaults to "12"._

#### 1. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

##### Synopsis
> _print_usage (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_copy_install` (private)

Install script via copy

##### Synopsis
> _copy_install (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

##### Synopsis
> _generate_autocomplete (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

##### Synopsis
> _generate_global_autocomplete (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_get_comspec` (private)

Generate comspec string for the provided file

##### Synopsis
> _get_comspec (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_install` (private)

Install script and enable completion

##### Synopsis
> _install (private) &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

#### 1. `_remove_completion_autoload` (private)

Remove completion script autoload

##### Synopsis
> _remove_completion_autoload (private) &lt;SHELL_CONFIG_FILE&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

##### Synopsis
> _set_completion_autoload (private) &lt;SHELL_CONFIG_FILE&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]
- `SHELL_CONFIG_FILE`: _(type: "file")_ The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).
- `SCRIPT_FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_symlink_install` (private)

Install script via symlink

##### Synopsis
> _symlink_install (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_uninstall` (private)

Uninstall script from system

##### Synopsis
> _uninstall (private) &lt;FILE_PATH&gt; [ALIAS]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.

#### 1. `_update` (private)

Updates given script from the provided URL

##### Synopsis
> _update (private) &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `URL`: _(type: "str")_ The URL of the script to download and install.
- `ALIAS`: _(type: "str")_ (optional) The alias of the script to install. Defaults to the basename of the provided file.
- `GLOBAL`: _(type: "bool")_ (optional) Install globally. _Defaults to "false"._

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

##### Synopsis
> _generate_makefile (private) &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `DESTINATION`: _(type: "folder")_ (optional) The path to the destination folder. Defaults to file parent.
- `OUTPUT_FILE_NAME`: _(type: "str")_ (optional) The name for the generated Makefile. Defaults to "<BASENAME>.makefile".

#### 1. `_get_constants` (private)

List constants from provided shoe script

##### Synopsis
> _get_constants (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private constants as well. _Defaults to "false"._

#### 1. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

##### Synopsis
> _get_constraint (private) &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `VARIABLE_NAME`: _(type: "str")_ The variable to validate.

#### 1. `_get_flags` (private)

List flags from provided shoe script

##### Synopsis
> _get_flags (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `_get_function_annotation` (private)

Get function annotation by name

##### Synopsis
> _get_function_annotation (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_get_function` (private)

Get function by name

##### Synopsis
> _get_function (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_get_functions_names` (private)

List functions names from provided shoe script

##### Synopsis
> _get_functions_names (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE`: _(type: "bool")_ (optional) If set to "true", retrieves private functions as well. _Defaults to "false"._

#### 1. `_get_options` (private)

List options from provided shoe script

##### Synopsis
> _get_options (private) &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `GET_PRIVATE_ONLY`: _(type: "bool")_ (optional) If set to "true", retrieves private options only. _Defaults to "false"._

#### 1. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

##### Synopsis
> _get_padding (private) &lt;SCRIPT_PATH&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.

#### 1. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

##### Synopsis
> _get_parameter (private) &lt;FILE_PATH&gt; &lt;KEY&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.

#### 1. `_parse_annotation` (private)

Return function annotation as json

##### Synopsis
> _parse_annotation (private) &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;
- `SCRIPT_PATH`: _(type: "file")_ The path to the input script.
- `FUNCTION_NAME`: _(type: "str")_ The name of the function to retrieve.

#### 1. `_print_synopsis` (private)

Print function synopsis from a JSON string.

##### Synopsis
> _print_synopsis (private) &lt;JSON&gt; [MARKDOWN_FORMAT]
- `JSON`: _(type: "json")_ The input string containing raw JSON.
- `MARKDOWN_FORMAT`: _(type: "bool")_ (optional) If set to "true", returns result as markdown. _Defaults to "false"._

#### 1. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

##### Synopsis
> _set_parameter (private) &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

#### 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

##### Synopsis
> _collapse_blank_lines (private) &lt;FILE_PATH&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.

#### 1. `_check_installed` (private)

Print error message if provided command is missing

##### Synopsis
> _check_installed (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_get_package_name` (private)

Find package name for given command

##### Synopsis
> _get_package_name (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_is_installed` (private)

Check provided command is installed

##### Synopsis
> _is_installed (private) &lt;COMMAND&gt;
- `COMMAND`: _(type: "str")_ A string containing the command name to find.

#### 1. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

##### Synopsis
> _pwd (private) 

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

##### Synopsis
> _is_valid (private) &lt;VALUE&gt; &lt;PATTERN&gt;
- `VALUE`: _(type: "str")_ The string to be compared to regex pattern.
- `PATTERN`: _(type: "str")_ The regex parttern to apply.

#### 1. `_validate` (private)

Find constraints and validates a variable

##### Synopsis
> _validate (private) &lt;VARIABLE&gt;
- `VARIABLE`: _(type: "str")_ The variable to validate in the followling format : variable_name=value.

#### 1. `_kernel` (private)

Shoe Kernel

##### Synopsis
> _kernel (private) 

