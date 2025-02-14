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
  - Constraint: `/~?[a-zA-Z0-9./_-]+/`
  - Default: _''_

2. **`--destination`**
> Destination directory 
  - Constraint: `/~?[a-zA-Z0-9/._-]+/`
  - Default: _''_

3. **`--type`**
> Script type 
  - Constraint: `/(shell|bash)/`
  - Default: _shell_

## 🤖 Commands

#### 1. `dump`

Dump functions


#### 2. `list`

Dump "build.lst" file


#### 3. `build`

Build from given "build.lst" file


#### 4. `build_all`

Build all scripts


### ⚡ Documentation

#### 1. `generate_doc`

Generate Markdown documentation for provided shoe script


#### 2. `generate_doc_all`

Generate Markdown documentation for all scripts


### ⚡ Make

#### 1. `generate_makefile`

Generate Markdown documentation for provided shoe script


#### 2. `generate_makefile_all`

Generate Makefile for all scripts


#### 3. `_build` (private)

Build from given "build.lst" file

> Synopsis: _build &lt;FILE_PATH&gt; &lt;DESTINATION&gt; [TYPE]<br>
>   FILE_PATH:    The path to the input file.<br>
>   DESTINATION:  The path to the destination folder.<br>
>   TYPE:         (optional) The script type to build (bash or sh). Will default to "sh".<br>

### ⚡ Self Install

#### 1. `self_install`

Install script and enable completion


#### 2. `self_uninstall`

Uninstall script from system


#### 3. `self_update`

Update script from @update


### ⚡ Help

#### 1. `help`

Print this help


### ⚡ Hooks

### ⚡ Hooks

#### 1. `_default` (private)

Place here commands you need executed by default (optional)


#### 2. `_before` (private)

Place here commands you need executed first every time (optional)


#### 3. `_after` (private)

Place here commands you need executed last every time (optional)


### ⚡ Bashdoc

#### 1. `_get_shoedoc_description` (private)

Get shoedoc description

> Synopsis: _get_shoedoc_description &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>

#### 2. `_get_shoedoc` (private)

Get shoedoc

> Synopsis: _get_shoedoc &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>
>   note: Remove every line that does not start with a pound character or contains a tag<br>
>         Returns string without leading pound characters<br>

#### 3. `_get_shoedoc_tag` (private)

Return given tag values from shoedoc bloc

> Synopsis: _get_shoedoc_tag &lt;TEXT&gt; &lt;TAG_NAME&gt;<br>
>   TEXT:     The input shoedoc annotation bloc.<br>
>   TAG_NAME: The name of tag to return.<br>

#### 4. `_get_shoedoc_title` (private)

Get shoedoc title

> Synopsis: _get_shoedoc_title &lt;TEXT&gt;<br>
>   TEXT: The input shoedoc annotation bloc.<br>
>   note: Returns the first line that does not contain a tag<br>

#### 5. `_get_script_shoedoc` (private)

Get shoedoc bloc at the top the provided shoe script file

> Synopsis: _get_script_shoedoc &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   note:        Each shoedoc should strictly start with two pound signs (##)<br>
>                Returns the first valid docbloc found in the provided file<br>

### ⚡ Colors

#### 1. `echo_primary` (private)

Print primary text with optional indentation and padding

> Synopsis: echo_primary &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:      Text to display.<br>
>  INDENTATION: Indentation level (default: 0).<br>
>  PADDING:     Padding length (default: 0).<br>
>  note:        Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>               this is why we're calculating the PADDING length on each execution.<br>

#### 2. `echo_secondary` (private)

Print secondary text with optional indentation and padding

> Synopsis: echo_secondary &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 3. `echo_success` (private)

Print success text with optional indentation and padding

> Synopsis: echo_success &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 4. `echo_danger` (private)

Print danger text with optional indentation and padding

> Synopsis: echo_danger &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 5. `echo_warning` (private)

Print warning text with optional indentation and padding

> Synopsis: echo_warning &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 6. `echo_info` (private)

Print info text with optional indentation and padding

> Synopsis: echo_info &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 7. `echo_light` (private)

Print light text with optional indentation and padding

> Synopsis: echo_light &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 8. `echo_dark` (private)

Print dark text with optional indentation and padding

> Synopsis: echo_dark &lt;STRING&gt; [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>

#### 9. `alert_primary` (private)

Print primary alert

> Synopsis: alert_primary &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 10. `alert_secondary` (private)

Print secondary alert

> Synopsis: alert_secondary &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 11. `alert_success` (private)

Print success alert

> Synopsis: alert_success &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 12. `alert_danger` (private)

Print danger alert

> Synopsis: alert_danger &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 13. `alert_warning` (private)

Print warning alert

> Synopsis: alert_warning &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 14. `alert_info` (private)

Print info alert

> Synopsis: alert_info &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 15. `alert_light` (private)

Print light alert

> Synopsis: alert_light &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

#### 16. `alert_dark` (private)

Print dark alert

> Synopsis: alert_dark &lt;STRING&gt;<br>
>   STRING: Text to display.<br>

### ⚡ Compatibility

#### 1. `_sed_i` (private)

Return sed -i system flavour

> Synopsis: _sed_i<br>

### ⚡ Documentation

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script

> Synopsis: _generate_doc &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]<br>
>   SCRIPT_PATH:      The path to the input file.<br>
>   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME: (optional) The name for the documentation file. Defaults to "&lt;BASENAME&gt;.md".<br>
>   GET_PRIVATE:      (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".<br>

### ⚡ Help

#### 1. `_help` (private)

Print help for provider shoe script

> Synopsis: _help &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 2. `_print_commands` (private)

List commands of the provided shoe script (used by "help" command)

> Synopsis: _print_commands &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 3. `_print_constants` (private)

List constants of the provided shoe script (used by "help" command)

> Synopsis: _print_constants &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)

> Synopsis: _print_description &lt;DESCRIPTION&gt;<br>
>   DESCRIPTION: A string containing script description.<br>

#### 5. `_print_flags` (private)

List flags of the provided shoe script (used by "help" command)

> Synopsis: _print_flags &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 6. `_print_infos` (private)

Print infos of the provided shoe script (used by "help" command)

> Synopsis: _print_infos &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 7. `_print_options` (private)

List options of the provided shoe script (used by "help" command)

> Synopsis: _print_options &lt;FILE_PATH&gt; [PADDING]<br>
>   FILE_PATH: The path to the input file.<br>
>   PADDING:   (optional) Padding length (default: 12)<br>
>   note:      "awk: %*x formats are not supported"<br>

#### 8. `_print_usage` (private)

Print usage of the provided shoe script (used by "help" command)

> Synopsis: _print_usage &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

### ⚡ Install

#### 1. `_copy_install` (private)

Install script via copy

> Synopsis: _copy_install &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:      Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file

> Synopsis: _generate_autocomplete &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:      This function creates a completion script named "&lt;ALIAS&gt;-completion.sh" in the same directory as the script itself.<br>
>              Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.<br>
>              Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins<br>

#### 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file

> Synopsis: _generate_global_autocomplete &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:      This function creates a completion script named "&lt;ALIAS&gt;" (where "&lt;ALIAS&gt;" is the basename of the provided file)<br>
>              in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.<br>
>              It uses sudo for file creation in a system directory, requiring root privileges.<br>

#### 4. `_get_comspec` (private)

Generate comspec string for the provided file

> Synopsis: _get_comspec &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

#### 5. `_install` (private)

Install script and enable completion

> Synopsis: _install &lt;FILE_PATH&gt; [ALIAS] [GLOBAL]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:    (optional) Install globally. Defaults to "false".<br>

#### 6. `_remove_completion_autoload` (private)

Remove completion script autoload

> Synopsis: _remove_completion_autoload &lt;SHELL_CONFIG_FILE&gt; [ALIAS]<br>
> Removes an autoload line for a completion script from a shell configuration file.<br>
>   SHELL_CONFIG_FILE: The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).<br>
>   ALIAS:             (optional) The alias of the script to remove. Defaults to the basename of the provided file<br>

#### 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file

> Synopsis: _set_completion_autoload &lt;SHELL_CONFIG_FILE_PATH&gt; &lt;SCRIPT_FILE_PATH&gt; [ALIAS]<br>
>   SHELL_CONFIG_FILE_PATH: The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).<br>
>   SCRIPT_FILE_PATH:       The path to the input file.<br>
>   ALIAS:                  (optional) The alias of the input script. Defaults to the basename of the provided file<br>

#### 8. `_symlink_install` (private)

Install script via symlink

> Synopsis: _symlink_install &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:      Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 9. `_uninstall` (private)

Uninstall script from system

> Synopsis: _uninstall &lt;FILE_PATH&gt; [ALIAS]<br>
>   FILE_PATH: The path to the input file.<br>
>   ALIAS:     (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.<br>

#### 10. `_update` (private)

Updates given script from the provided URL

> Synopsis: _update &lt;FILE_PATH&gt; &lt;URL&gt; [ALIAS] [GLOBAL]<br>
>   FILE_PATH: The path to the input file.<br>
>   URL:       The URL of the script to download and install.<br>
>   ALIAS:     (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:    (optional) Install globally. Defaults to "false".<br>

### ⚡ Make

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script

> Synopsis: _generate_makefile &lt;SCRIPT_PATH&gt; [DESTINATION] [OUTPUT_FILE_NAME]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   DESTINATION:      (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME: (optional) The name for the generated Makefile. Defaults to "&lt;BASENAME&gt;.makefile".<br>

### ⚡ Reflexion

#### 1. `_get_constants` (private)

List constants from provided shoe script

> Synopsis: _get_constants &lt;SCRIPT_PATH&gt; [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)<br>

#### 2. `_get_constraint` (private)

Get constaint for given variable from provided shoe script

> Synopsis: _get_constraint &lt;SCRIPT_PATH&gt; &lt;VARIABLE_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input script.<br>
>   VARIABLE_NAME: The variable to validate.<br>

#### 3. `_get_flags` (private)

List flags from provided shoe script

> Synopsis: _get_flags &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 4. `_get_function` (private)

Get function by name

> Synopsis: _get_function &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 5. `_get_function_annotation` (private)

Get function annotation by name

> Synopsis: _get_function_annotation &lt;SCRIPT_PATH&gt; &lt;FUNCTION_NAME&gt;<br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 6. `_get_functions_names` (private)

List functions names from provided shoe script

> Synopsis: _get_functions_names &lt;SCRIPT_PATH&gt; [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".<br>

#### 7. `_get_options` (private)

List options from provided shoe script

> Synopsis: _get_options &lt;SCRIPT_PATH&gt; [GET_PRIVATE_ONLY]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".<br>

#### 8. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script

> Synopsis: _get_padding &lt;SCRIPT_PATH&gt;<br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 9. `_get_parameter` (private)

Get value for given parameter from provided ".env" or ".sh" file

> Synopsys : _get_parameter &lt;FILE_PATH&gt; &lt;KEY&gt;<br>
>   FILE_PATH: The path to the input file.<br>
>   KEY:       The variable name to get from provided file.<br>

#### 10. `_parse_annotation` (private)

Return json object from annotation

> Synopsis: _parse_annotation &lt;ANNOTATION&gt;<br>
>   ANNOTATION: The input text containing raw annotation.<br>

#### 11. `_set_parameter` (private)

Set value for given parameter into provided file ".env" or ".sh" file

> Synopsys : _set_parameter &lt;FILE_PATH&gt; &lt;KEY&gt; &lt;VALUE&gt;<br>
>   FILE_PATH: The path to the input script.<br>
>   KEY:       The variable name to set to provided file<br>
>   VALUE:     The value to be set to provided file<br>

### ⚡ Strings

#### 1. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"

> Synopsis: _collapse_blank_lines &lt;FILE_PATH&gt;<br>
>   FILE_PATH: The path to the input file.<br>

### ⚡ System

#### 1. `_check_installed` (private)

Print error message if provided command is missing

> Synopsis: _check_installed &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 2. `_get_package_name` (private)

Find package name for given command

> Synopsis: _get_package_name &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 3. `_is_installed` (private)

Check provided command is installed

> Synopsis: _is_installed &lt;COMMAND&gt;<br>
>   COMMAND: A string containing the command name to find.<br>

#### 4. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally

> Synopsis: _pwd<br>

### ⚡ Validation

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint

> Synopsis: _is_valid &lt;VALUE&gt; &lt;PATTERN&gt;<br>
>   VALUE:   The string to be compared to regex pattern.<br>
>   PATTERN: The regex parttern to apply.<br>

#### 2. `_validate` (private)

Find constraints and validates a variable

> Synopsis: _validate &lt;VARIABLE&gt;<br>
>   VARIABLE: The variable to validate in the followling format : variable_name=value.<br>

### ⚡ Kernel

#### 1. `_kernel` (private)

Shoe Kernel


