TangoMan Shoemaker
===

## ℹ️ Infos

- author:  "Matthias Morin" <mat@tangoman.io>
- version: 1.0.0
- link:    https://github.com/TangoMan75/shoe


## 📑 Description

A versatile developement tool to split a script file into its components, build a script from a build.lst file, generate Makefile or Markdown documentation from a shoe script.  

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

### ⚡ Makefile

#### 1. `generate_makefile`

Generate Markdown documentation for provided shoe script

#### 2. `generate_makefile_all`

Generate Makefile for all scripts

#### 3. `_build` (private)

Build from given "build.lst" file
> Synopsis: _build \<FILE_PATH\> <DESTINATION> [TYPE]<br>
>   FILE_PATH:    The path to the input file.<br>
>   DESTINATION:  The path to the destination folder.<br>
>   TYPE:         (optional) The script type to build (bash or sh). Will default to "sh".<br>

### ⚡ Self Install

#### 1. `self_install`

Install script and enable completion

#### 2. `self_uninstall`

Uninstall script from system

#### 3. `self_update`

Update script from @update-link

### ⚡ Help

#### 1. `help`

Print this help

### ⚡ Hooks

#### 1. `_default` (private)

Place here commands you need executed by default (optional)

#### 2. `_before` (private)

Place here commands you need executed first every time (optional)

#### 3. `_after` (private)

Place here commands you need executed last every time (optional)

### ⚡ Colors

#### 1. `echo_primary` (private)

Print primary text with optional indentation and padding
> Synopsis: echo_primary \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 2. `echo_secondary` (private)

Print secondary text with optional indentation and padding
> Synopsis: echo_secondary \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 3. `echo_success` (private)

Print success text with optional indentation and padding
> Synopsis: echo_success \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 4. `echo_danger` (private)

Print danger text with optional indentation and padding
> Synopsis: echo_danger \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 5. `echo_warning` (private)

Print warning text with optional indentation and padding
> Synopsis: echo_warning \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 6. `echo_info` (private)

Print info text with optional indentation and padding
> Synopsis: echo_info \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 7. `echo_light` (private)

Print light text with optional indentation and padding
> Synopsis: echo_light \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 8. `echo_dark` (private)

Print dark text with optional indentation and padding
> Synopsis: echo_dark \<STRING\> [INDENTATION] [PADDING]<br>
>  STRING:       Text to display.<br>
>  INDENTATION:  Indentation level (default: 0).<br>
>  PADDING:      Padding length (default: 0).<br>
>  note:         Older versions of printf supports a more limited set of format specifiers (eg: "%-*b"),<br>
>                this is why we're calculating the PADDING length on each execution.<br>

#### 9. `alert_primary` (private)

Print primary alert
> Synopsis: alert_primary \<STRING\><br>
>   STRING: Text to display.<br>

#### 10. `alert_secondary` (private)

Print secondary alert
> Synopsis: alert_secondary \<STRING\><br>
>   STRING: Text to display.<br>

#### 11. `alert_success` (private)

Print success alert
> Synopsis: alert_success \<STRING\><br>
>   STRING: Text to display.<br>

#### 12. `alert_danger` (private)

Print danger alert
> Synopsis: alert_danger \<STRING\><br>
>   STRING: Text to display.<br>

#### 13. `alert_warning` (private)

Print warning alert
> Synopsis: alert_warning \<STRING\><br>
>   STRING: Text to display.<br>

#### 14. `alert_info` (private)

Print info alert
> Synopsis: alert_info \<STRING\><br>
>   STRING: Text to display.<br>

#### 15. `alert_light` (private)

Print light alert
> Synopsis: alert_light \<STRING\><br>
>   STRING: Text to display.<br>

#### 16. `alert_dark` (private)

Print dark alert
> Synopsis: alert_dark \<STRING\><br>
>   STRING: Text to display.<br>

### ⚡ System compatibility

#### 1. `_sed_i` (private)

Return sed -i system flavour
> Synopsis: _sed_i<br>

### ⚡ Docbloc

#### 1. `_get_docbloc` (private)

Parse docbloc at the top the provided shoe script file
> Synopsis: _get_docbloc \<FILE_PATH\> <TAG_NAME><br>
>   FILE_PATH:  The path to the input file.<br>
>   TAG_NAME:   The name of the docbloc parameter to return.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

#### 2. `_get_docbloc_description` (private)

Get docbloc description at the top the provided shoe script file
> Synopsis: _get_docbloc_description \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

#### 3. `_get_docbloc_title` (private)

Get docbloc title at the top the provided shoe script file
> Synopsis: _get_docbloc_title \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>
>   note:       To change displayed items, edit docblock infos at the top of the file.<br>

### ⚡ Documentation

#### 1. `_generate_doc` (private)

Generate Markdown documentation for provided shoe script
> Synopsis: _generate_doc \<INPUT_FILE_PATH\> [DESTINATION] [OUTPUT_FILE_NAME] [GET_PRIVATE]<br>
>   INPUT_FILE_PATH:   The path to the input file.<br>
>   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME:  (optional) The name for the documentation file. Defaults to "\<BASENAME\>.md".<br>
>   GET_PRIVATE:       (Optional) If set to 'true', documents private constants, options, flags, and commands as well. Defaults to "false".<br>

### ⚡ Help

#### 1. `_help` (private)

Print help for provider shoe script
> Synopsis: _help \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 2. `_print_commands` (private)

List commands of the of the current shoe script (used by "help" command)
> Synopsis: _print_commands [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 3. `_print_constants` (private)

List constants of the of the current shoe script (used by "help" command)
> Synopsis: _print_constants [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 4. `_print_description` (private)

Print provided text formatted as a description (used by "help" command)
> Synopsis: _print_description \<DESCRIPTION\><br>
>   DESCRIPTION:  A string containing script description.<br>

#### 5. `_print_flags` (private)

List flags of the of the current shoe script (used by "help" command)
> Synopsis: _print_flags [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 6. `_print_infos` (private)

Print infos of the of the current shoe script (used by "help" command)
> Synopsis: _print_infos<br>

#### 7. `_print_options` (private)

List options of the of the current shoe script (used by "help" command)
> Synopsis: _print_options [PADDING]<br>
>  PADDING:  (optional) Padding length (default: 12)<br>
>  note:     "awk: %*x formats are not supported"<br>

#### 8. `_print_usage` (private)

Print usage of the of the current shoe script (used by "help" command)
> Synopsis: _print_usage<br>

### ⚡ Install

#### 1. `_copy_install` (private)

Install script via copy
> Synopsis: _copy_install \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:       Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 2. `_generate_autocomplete` (private)

Generates an autocomplete script for the provided file
> Synopsis: _generate_autocomplete \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:       This function creates a completion script named "\<ALIAS\>-completion.sh" in the same directory as the script itself.<br>
>               Refer to https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial for details on how to configure shell autocompletions.<br>
>               Or read the official docmentation for "complete" https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins<br>

#### 3. `_generate_global_autocomplete` (private)

Creates a system-wide autocomplete script for the provided file
> Synopsis: _generate_global_autocomplete \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to autocomplete. Defaults to the basename of the provided file<br>
>   note:       This function creates a completion script named "\<ALIAS\>" (where "<ALIAS>" is the basename of the provided file)<br>
>               in the /etc/bash_completion.d/ directory, enabling autocompletion for all users on the system.<br>
>               It uses sudo for file creation in a system directory, requiring root privileges.<br>

#### 4. `_get_comspec` (private)

Generate comspec string for the provided file
> Synopsis: _get_comspec \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 5. `_install` (private)

Install script and enable completion
> Synopsis: _install \<FILE_PATH\> [ALIAS] [GLOBAL]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:     (optional) Install globally. Defaults to "false".<br>

#### 6. `_remove_completion_autoload` (private)

Remove completion script autoload
> Synopsis: _remove_completion_autoload \<SHELL_CONFIG_FILE\> [ALIAS]<br>
> Removes an autoload line for a completion script from a shell configuration file.<br>
>   SHELL_CONFIG_FILE:  The path to the shell configuration file to update (e.g., ~/.bashrc, ~/.zshrc).<br>
>   ALIAS:              (optional) The alias of the script to remove. Defaults to the basename of the provided file<br>

#### 7. `_set_completion_autoload` (private)

Adds an autoload line for completion script to a shell configuration file
> Synopsis: _set_completion_autoload \<SHELL_CONFIG_FILE_PATH\> <SCRIPT_FILE_PATH> [ALIAS]<br>
>   SHELL_CONFIG_FILE_PATH:  The path to the shell configuration file to be modified (e.g., ~/.bashrc, ~/.zshrc).<br>
>   SCRIPT_FILE_PATH:        The path to the input file.<br>
>   ALIAS:                   (optional) The alias of the input script. Defaults to the basename of the provided file<br>

#### 8. `_symlink_install` (private)

Install script via symlink
> Synopsis: _symlink_install \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided file<br>
>   note:       Creates a symbolic link in the /usr/local/bin/ directory.<br>

#### 9. `_uninstall` (private)

Uninstall script from system
> Synopsis: _uninstall \<FILE_PATH\> [ALIAS]<br>
>   FILE_PATH:  The path to the input file.<br>
>   ALIAS:      (optional) The alias of the script to uninstall. Defaults to the basename of the provided script.<br>

#### 10. `_update` (private)

Updates given script from the provided URL
> Synopsis: _update \<FILE_PATH\> <URL> [ALIAS] [GLOBAL]<br>
>   FILE_PATH:  The path to the input file.<br>
>   URL:        The URL of the script to download and install.<br>
>   ALIAS:      (optional) The alias of the script to install. Defaults to the basename of the provided script.<br>
>   GLOBAL:     (optional) Install globally. Defaults to "false".<br>

### ⚡ Makefile

#### 1. `_generate_makefile` (private)

Generate Makefile for provided shoe script
> Synopsis: _generate_makefile \<INPUT_FILE_PATH\> [DESTINATION] [OUTPUT_FILE_NAME]<br>
>   INPUT_FILE_PATH:   The path to the input file.<br>
>   DESTINATION:       (optional) The path to the destination folder. Defaults to file parent.<br>
>   OUTPUT_FILE_NAME:  (optional) The name for the generated Makefile. Defaults to "\<BASENAME\>.makefile".<br>

### ⚡ Reflexion

#### 1. `_get_constants` (private)

List constants from provided shoe script
> Synopsis: _get_constants \<SCRIPT_PATH\> [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private constants as well. (default=false)<br>

#### 2. `_get_constraint` (private)

List constaints from provided shoe script
> Synopsis: _get_constraint \<SCRIPT_PATH\> <VARIABLE_NAME><br>
>   SCRIPT_PATH:   The path to the input script.<br>
>   VARIABLE_NAME: The variable to validate.<br>

#### 3. `_get_flags` (private)

List flags from provided shoe script
> Synopsis: _get_flags \<SCRIPT_PATH\><br>
>   SCRIPT_PATH: The path to the input script.<br>

#### 4. `_get_function` (private)

Get function by name
> Synopsis: _get_function \<SCRIPT_PATH\> <FUNCTION_NAME><br>
>   SCRIPT_PATH:   The path to the input file.<br>
>   FUNCTION_NAME: The name of the function to retrieve.<br>

#### 5. `_get_functions_names` (private)

List functions names from provided shoe script
> Synopsis: _get_functions_names \<SCRIPT_PATH\> [GET_PRIVATE]<br>
>   SCRIPT_PATH: The path to the input script.<br>
>   GET_PRIVATE: (Optional) If set to 'true', retrieves private functions as well. Defaults to "false".<br>

#### 6. `_get_options` (private)

List options from provided shoe script
> Synopsis: _get_options \<SCRIPT_PATH\> [GET_PRIVATE_ONLY]<br>
>   SCRIPT_PATH:      The path to the input script.<br>
>   GET_PRIVATE_ONLY: (Optional) If set to 'true', retrieves private options only. Defaults to "false".<br>

#### 7. `_get_padding` (private)

Guess padding length from longest constant, option, flag or command of the provided shoe script
> Synopsis: _get_padding \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

#### 8. `_collapse_blank_lines` (private)

Collapse blank lines with "sed"
> Synopsis: _collapse_blank_lines \<FILE_PATH\><br>
>   FILE_PATH:  The path to the input file.<br>

### ⚡ Sytem

#### 1. `_check_installed` (private)

Print error message if provided command is missing
> Synopsis: _check_installed \<COMMAND\><br>
>   COMMAND:  A string containing command name.<br>

#### 2. `_is_installed` (private)

Check provided command is installed
> Synopsis: _is_installed \<COMMAND\><br>
>   COMMAND:  A string containing command name.<br>

#### 3. `_pwd` (private)

Return current project directory realpath, or "pwd" when installed globally
> Synopsis: _pwd<br>

### ⚡ Validation

#### 1. `_is_valid` (private)

Checks if variable is valid given regex constraint
> Synopsis: _is_valid \<VALUE\> <PATTERN><br>
>   VALUE:    The string to be compared to regex pattern.<br>
>   PATTERN:  The regex parttern to apply.<br>

#### 2. `_validate` (private)

Find constraints and validates a variable
> Synopsis: _validate \<VARIABLE\><br>
>   VARIABLE: The variable to validate in the followling format : variable_name=value.<br>

### ⚡ kernel

#### 1. `_kernel` (private)

Shoe Kernel

