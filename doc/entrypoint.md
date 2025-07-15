TangoMan Entrypoint
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

Execute Development and Continuous Integration tasks.

## 🔥 Usage

`sh entrypoint.sh [command] (--lint_folder './build') (--test_folder './tests')`

## ⚙️ Options

1. **`--lint_folder`**
> Lint directory 
  - Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - Default: _'./build'_

2. **`--test_folder`**
> Test directory 
  - Constraint: `/^~?[a-zA-Z0-9/._-]+$/`
  - Default: _'./tests'_

## 🤖 Commands

#### 1. `lint` (public)

Sniff errors with linter

##### Synopsis
> lint (public) 

#### 1. `tests` (public)

Run tests

##### Synopsis
> tests (public) 

#### 1. `git_hooks` (public)

Install git hooks

##### Synopsis
> git_hooks (public) 

#### 1. `bash_unit` (public)

Install bash_unit framework

##### Synopsis
> bash_unit (public) 

#### 1. `test_can_fail` (public)

https://github.com/pgrange/bash_unit

##### Synopsis
> test_can_fail (public) 

#### 1. `alpine` (public)

Run script in Alpine Docker container

##### Synopsis
> alpine (public) 

#### 1. `busybox` (public)

Run script in Busybox Docker container

##### Synopsis
> busybox (public) 

#### 1. `ubuntu` (public)

Run script in Ubuntu Docker container

##### Synopsis
> ubuntu (public) 

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

#### 1. `_git_hooks` (private)

Update .git/hooks folder

##### Synopsis
> _git_hooks (private) &lt;SOURCE&gt;
- `SOURCE`: _(type: "folder")_ The source directory.

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

#### 1. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

##### Synopsis
> _set_parameter (private) &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;
- `FILE_PATH`: _(type: "file")_ The path to the input file.
- `KEY`: _(type: "str")_ The variable name to get from provided file.
- `VALUE`: _(type: "str")_ The value to be set to provided file.

#### 1. `_check_installed` (private)

Print error message if provided command is missing

##### Synopsis
> _check_installed (private) &lt;COMMAND&gt;
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

